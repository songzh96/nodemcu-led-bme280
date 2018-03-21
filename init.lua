-- *******************初始化段************************
-- wifi配置信息
SSID = "@110wifi"
PWD = "110110110"
--LED1配置信息 调色led
pwm.setup(1, 500, 255) -- G
pwm.setup(2, 500, 255) -- B
pwm.setup(3, 500, 255) -- R
-- PWM starts 将引脚设置为脉冲形式
pwm.start(1) 
pwm.start(2)
pwm.start(3)
--bme280配置信息
alt=38 -- 海拔（合肥）
sda, scl = 5, 6 
i2c.setup(0, sda, scl, i2c.SLOW) -- call i2c.setup() only once
bme280.setup()
-- MQTT服务器
IP = "192.168.2.235"
PORT = 1883
-- LED2配置 根据温度亮色
led2_r = 7
led2_g = 8
led2_b = 9
gpio.mode(led2_r, gpio.OUTPUT)
gpio.mode(led2_g, gpio.OUTPUT)
gpio.mode(led2_b, gpio.OUTPUT)
gpio.write(led2_r,gpio.LOW)
gpio.write(led2_g,gpio.LOW)
gpio.write(led2_b,gpio.LOW)
-- led3配置 模拟开关
led3_r = 10
led3_g = 4
led3_b = 0
gpio.mode(led3_r, gpio.OUTPUT)
gpio.mode(led3_g, gpio.OUTPUT)
gpio.mode(led3_b, gpio.OUTPUT)
gpio.write(led3_r,gpio.LOW)
gpio.write(led3_g,gpio.LOW)
gpio.write(led3_b,gpio.LOW)

-- *******************函数段************************
-- 链接wifi的函数
function connectWifi(SSID,PWD)
  -- 设置wifi模式
  wifi.setmode(wifi.STATION)

  -- 设置主机名
  wifi.sta.sethostname("Node-MCU")

  --设置接入路由的信息 (不将此保存至flash)
  station_cfg={}
  station_cfg.ssid=SSID
  station_cfg.pwd=PWD
  wifi.sta.config(station_cfg)

  --注册wifi事件监听器
  wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
  print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID)
  end)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
  print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
  T.netmask.."\n\tGateway IP: "..T.gateway)
  end)
  
end

-- 处理字符串的函数
--[[function split(szFullString, szSeparator)  
  local nFindStartIndex = 1  
  local nSplitIndex = 1  
  local nSplitArray = {}  
  while true do  
     local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
     if not nFindLastIndex then  
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
      break  
     end  
     nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
     nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
     nSplitIndex = nSplitIndex + 1  
  end  
  return nSplitArray  
  end --]]

-- 调色函数
function led(r, g, b)
  pwm.setduty(3, r)
  pwm.setduty(2, g)
  pwm.setduty(1, b)
end

-- 读取温度，湿度，气压
function thp()
table_bme280 = {} --初始化表格
T, P, H, QNH = bme280.read(alt) --Reads the sensor and returns the temperature, the air pressure, the air relative humidity
local Tsgn = (T < 0 and -1 or 1); T = Tsgn*T -- 处理零下的情况

temp = T/100
if temp<10 then  -- 根据温度大小显示led的颜色
  gpio.write(led2_b,gpio.HIGH)
  gpio.write(led2_r,gpio.LOW)
  gpio.write(led2_g,gpio.LOW)
elseif (temp<30 and temp>=10) then
  gpio.write(led2_g,gpio.HIGH)
  gpio.write(led2_b,gpio.LOW)
  gpio.write(led2_r,gpio.LOW)
else
  gpio.write(led2_r,gpio.HIGH)
  gpio.write(led2_b,gpio.LOW)
  gpio.write(led2_g,gpio.LOW)
end

T = string.format("%s%d.%02d", Tsgn<0 and "-" or "", T/100, T%100)
P = string.format("%d.%03d", P/1000, P%1000)
H = string.format("%d.%03d%%", H/1000, H%1000)

table_bme280["temperature"] = T
table_bme280["pressure"] = P
table_bme280["humidity"] = H

json_bme280 = sjson.encode(table_bme280,{key="value"}) -- table转json
return json_bme280
-- m:publish("bme280", json_bme280, 0, 0, function(client) print("published") end)
-- print(string.format("QNH=%d.%03d", QNH/1000, QNH%1000))
-- print(string.format("T=%s%d.%02d", Tsgn<0 and "-" or "", T/100, T%100))
-- print(string.format("humidity=%d.%03d%%", H/1000, H%1000))
end

-- *******************主程序段************************
-- 初始化led
led(0,0,0) --灭灯

-- 链接wifi 
connectWifi(SSID,PWD)

-- 定时发送bme280读取的数据
function main() 
  json_bme280 = thp() -- 读取bme280数据 
  m = mqtt.Client("nodeMCU",120)-- Creates a MQTT client.
  m:connect(IP,PORT, 
          function(client)
              print("connected")
              -- 发布数据
              client:subscribe("led_button",0)
              client:subscribe("led",0, function(conn) print("subscribe success") end)
              client:publish("bme280", json_bme280, 0, 0)
              print("published")
          end, 
          function(client, reason)
              print("fail reason: " .. reason)
          end
      )
    -- 接收订阅的消息函数
  m:on("message", function(client, topic, data)
    if (topic == "led" and data ~= nil) then -- 如果订阅的主题是关于调色的 且消息不为空
      led_table = sjson.decode(data)
      r = led_table.r
      g = led_table.g
      b = led_table.b
      led(g,r,b) --调色
    end
 
    if(topic == "led_button" and data ~= nil) then 
      local switch = {
        ["red_on"] = function()
          gpio.write(led3_r,gpio.HIGH)
        end,
        ["red_off"] = function()
          gpio.write(led3_r,gpio.LOW)
        end,
        ["green_on"] = function()
          gpio.write(led3_g,gpio.HIGH)
        end,
        ["green_off"] = function()
          gpio.write(led3_g,gpio.LOW)
        end,
        ["blue_on"] = function()
          gpio.write(led3_b,gpio.HIGH)
        end,
        ["blue_off"] = function()
          gpio.write(led3_b,gpio.LOW)
        end,
      }
      local fSwitch = switch[data]
      if fSwitch then --key exists  
        fSwitch() --do func  
        else --key not found 
        print ("wrong data") 
      end  
    end
  end)    
  m:close()
end

-- 定时函数
tmr.alarm(0, 2000, tmr.ALARM_AUTO, main)





