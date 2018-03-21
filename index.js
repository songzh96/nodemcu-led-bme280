const Koa = require('koa')
const path = require('path')
const static = require('koa-static')
const Router = require('koa-router')
const bodyParser = require('koa-bodyparser')
const mqtt = require('mqtt')
const client = mqtt.connect('mqtt://127.0.0.1')
var mosca = require('mosca');

//*****************mqtt服务器 */

var ascoltatore = {  //数据库
  //using ascoltatore
  //type: 'mongo',
 //url: 'mongodb://localhost:27017/mqtt',
  //pubsubCollection: 'ascoltatori',
  //mongo: {}
};

var settings = {
  port: 1883,
  backend: ascoltatore,
   http: {
    port: 7410,
    bundle: true,
    static: './'
  }
};
var server = new mosca.Server(settings);

server.on('clientConnected', function(client) {
    console.log('client connected', client.id);
});

server.on('ready', setup);
// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running');
}


//****************网站服务器 */
const app = new Koa()
app.use(bodyParser())
// 静态资源目录对于相对入口文件index.js的路径
const staticPath = './static'

// 主页
app.use(static(
    path.join( __dirname,  staticPath)
    ))

//mqtt client
client.on('message', function (topic, message) {
    // message is Buffer
    console.log(message.toString())
})

app.listen(3000, () => {
  console.log('[demo] static-use-middleware is starting at port 3000')
})
