##项目介绍
**本项目是基于nodemcu芯片实现的一个智能动物服化工厂系统。**
**主要功能**：实时读取温湿度以及气压，远程调色，远程控制RGB灯，温度预警。
**主要语言**：nodejs，lua
**应用软件**：esplorer（往nodemcu上上传代码），nodemcu-flash（刷nodemcu固件），vscode
**主要技术**：[pwm](https://baike.baidu.com/item/%E8%84%89%E5%86%B2%E5%AE%BD%E5%BA%A6%E8%B0%83%E5%88%B6/10813756?fr=aladdin&fromid=3034961&fromtitle=PWM),[mqtt](https://baike.baidu.com/item/MQTT),[koa](https://koa.bootcss.com/)
**主要框架**：koa（后端）,layui（前端）
**硬件选用**：nodemcu，bme280，3个rgb灯。
**参考文章**：[NodeMCU Documentation](http://nodemcu.readthedocs.io/en/master/),[MQTT.js](https://github.com/mqttjs/MQTT.js),[koa教程](https://chenshenhai.github.io/koa2-note/note/start/quick.html),[mosca](https://github.com/mcollina/mosca),[layui开发文档](http://www.layui.com/doc/),[MQTT over Websockets](https://github.com/mcollina/mosca/wiki/MQTT-over-Websockets)
****
##环境搭建
1. [安装nodejs](http://www.runoob.com/nodejs/nodejs-install-setup.html)
2. 下载github上的代码 [code](https://github.com/songzh96/nodemcu-led-bme280)
3. 打开命令行窗口（在刚刚下载的文件夹下），下载依赖包（依次输入以下命令）
```
npm install mosca --save
npm install mqtt --save
npm install koa --save
npm install koa-static --save
npm install koa-route --save
npm install koa-bodyparser --save
```
4. 根据init.lua上的代码然后进行连线,然后对其通电
5. 还是在刚刚下载的文件夹下打开cmd 输入 ``node index.js``
6. 打开网页，输入``127.0.0.1:3000``
7. 基本上已经可以实现功能了，如不能实现有可能是哪一步做错了，大家可自己进行研究，其实很简单的；下面会有详细教程。
****
##案例展示
![web端界面展示.png](https://upload-images.jianshu.io/upload_images/3246153-670be37491da3bb7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![硬件端.jpg](https://upload-images.jianshu.io/upload_images/3246153-309fac79f7fbf18b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![服务器.png](https://upload-images.jianshu.io/upload_images/3246153-d914fc9978c2cdc7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
****
##详细教程
* [NodeMcu官方Api](http://nodemcu.readthedocs.io/en/dev/) 
* [NodeMcu各模块简单介绍](http://www.jianshu.com/nb/7000517)
* [Lua基本语法](http://www.runoob.com/lua/lua-basic-syntax.html)
* [NodeJs基本语法（选看）](http://www.runoob.com/nodejs/nodejs-tutorial.html)
* [如何为NodeMcu烧写固件](http://www.cnblogs.com/wangzexi/p/5696925.html)
* [Mqtt服务器简单介绍](http://blog.csdn.net/jiesa/article/details/50635222)
* [利用nodejs快速搭建mqtt服务器](https://www.jianshu.com/p/9e74287e3b07)
* [在web前端使用mqtt](https://www.jianshu.com/p/5c95245e9edf)
* [nodejs安装教程](http://www.runoob.com/nodejs/nodejs-install-setup.html)
* [layui文档](http://www.layui.com/doc/)
