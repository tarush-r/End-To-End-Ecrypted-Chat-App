require('./models/db')
const express = require('express')
const app = express()
const bodyParser = require('body-parser');
const { options } = require('./app');
const path = require('path')

const userController = require('./controllers/userController')
const authController = require('./controllers/authController')
const settingsController = require('./controllers/settingsController')
const chatController = require('./controllers/chatController')
const Chat = require("./models/chat");
const port = 3000;


app.use(bodyParser.json());


// app.listen(port, () => {
//   console.log(`Example app listening at http://localhost:${port}`)
// })

app.use('/user',userController)
app.use('/auth',authController)
app.use('/settings',settingsController)
app.use('/chat',chatController)

//sockets
// const socketio=require('socket.io')

var server = require("http").createServer(app);
var io = require("socket.io")(server);
const http = require('http')
let ON_CONNECTION = "connection";
let ON_DISCONNECT = "disconnect";

// Main Events
let EVENT_IS_USER_ONLINE = "check_online";
let EVENT_SINGLE_CHAT_MESSAGE = "single_chat_message";

// Sub Events
let SUB_EVENT_RECEIVE_MESSAGE = "receive_message";
let SUB_EVENT_IS_USER_CONNECTED = "is_user_connected";
const publicDirectoryPath = path.join(__dirname, './public')
// app.use(express.static(publicDirectoryPath))
let listen_port = 3000;

let STATUS_MESSAGE_NOT_SENT = 10001;
let STATUS_MESSAGE_SENT = 10001;

const userMap = new Map();

// io.sockets.on(ON_CONNECTION, (socket) => {
//   console.log("HEEEEEEEY")
//   onEachUserConnection(socket);
// });

io.on('connection', (userSocket) => {
  console.log('New WebSocket connection')
  userSocket.on("send_message", (data) => {
    console.log(data)
    userSocket.broadcast.emit("receive_message", data)
})
})

function onEachUserConnection(socket) {
  var query = stringifyJson(socket.handshake.query);
  print("-----");
  print("Connected => Socket ID: " + socket.id + ", Users: " + query);

  var from_user_id = socket.handshake.query.from;
  var userMapVal = { socket_id: socket.id };
  addUserToMap(from_user_id, userMapVal);
  printOnlineUser();

  onMessage(socket);
  checkOnline(socket);
  onDisconnect(socket);
}

function checkOnline(socket) {
  socket.on(EVENT_IS_USER_ONLINE, function (chat_message) {
    onlineCheckHandler(socket, chat_message);
  });
}

function onlineCheckHandler(socket, chat_user_details) {
  let to_user_id = chat_user_details.to;
  print("Checking Online User => " + to_user_id);
  let to_user_socket_id = getSocketIDFromMapForThisUser(to_user_id);
  let isOnline = undefined != to_user_socket_id;
  chat_user_details.to_user_online_status = isOnline;
  sendBackToClient(
    socket,
    to_user_socket_id,
    SUB_EVENT_IS_USER_CONNECTED,
    chat_user_details
  );
}

function sendBackToClient(socket, to_user_socket_id, event, chat_message) {
  socket.emit(event, stringifyJson(chat_message));
}

function onMessage(socket) {
  socket.on(EVENT_SINGLE_CHAT_MESSAGE, function (chat_message) {
    singleChatHandler(socket, chat_message);
  });
}

function singleChatHandler(socket, chat_message) {
  print("onMessage: " + stringifyJson(chat_message));
  let to_user_id = chat_message.to;
  let from_user_id = chat_message.from;
  print(from_user_id + "=>" + to_user_id);
  // to_user_id
  var to_user_socket_id = getSocketIDFromMapForThisUser(to_user_id);
  if (to_user_socket_id == undefined) {
    print("User not online");
    chat_message.to_user_online_status = false;
    return;
  }
  chat_message.to_user_online_status = true;
  sentToConnectedSocket(
    socket,
    to_user_socket_id,
    SUB_EVENT_RECEIVE_MESSAGE,
    chat_message
  );
}

function sentToConnectedSocket(socket, to_user_socket_id, event, chat_message) {
  socket.to(to_user_socket_id).emit(event, stringifyJson(chat_message));
  // socket.emit(event, stringifyJson(chat_message));

  //for saving the chat in database

  // const message = new Chat(parameters??)
  // try {
  //    await message.save()
  //    res.send({ message })
  // } catch (error) {
  //    res.status(400)
  //    res.send(error)
  // }

}

function getSocketIDFromMapForThisUser(to_user_id) {
  let userMapVal = userMap.get(to_user_id.toString());
  if (undefined == userMapVal) {
    return undefined;
  }
  return userMapVal.socket_id;
}

function onDisconnect(socket) {
  socket.on(ON_DISCONNECT, function () {
    removeUserWithSocketIDFromMap(socket.id);
    socket.removeAllListeners(SUB_EVENT_RECEIVE_MESSAGE);
    socket.removeAllListeners(SUB_EVENT_IS_USER_CONNECTED);
    socket.removeAllListeners(ON_DISCONNECT);
  });
}

function removeUserWithSocketIDFromMap(socket_id) {
  print("Deleting User : " + socket_id);
  let toDeleteUser;
  for (let key of userMap) {
    let userMapVal = key[1];
    if (userMapVal.socket_id == socket_id) {
      toDeleteUser = key[0];
    }
  }
  print("Deleting User : " + toDeleteUser);
  if (undefined != toDeleteUser) {
    userMap.delete(toDeleteUser);
  }
  print(userMap);
  printOnlineUser();
}

function addUserToMap(key_user_id, socket_id) {
  userMap.set(key_user_id, socket_id);
}

function printOnlineUser() {
  print("Online Users : " + userMap.size);
}

function print(txt) {
  console.log(txt);
}

function stringifyJson(data) {
  return JSON.stringify(data);
}
app.get("/", (req, res) => {
  res.send("Hello");
});

// server.listen(listen_port, () => print("Listening"));

server.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
// const path = require('path')
// const http = require('http')
// const express = require('express')
// const socketio = require('socket.io')

// const app = express()
// const server = http.createServer(app)
// const io = socketio(server)

// const port = process.env.PORT || 3000
// const publicDirectoryPath = path.join(__dirname, './public')

// app.use(express.static(publicDirectoryPath))

// io.on('connection', () => {
//     console.log('New WebSocket connection')
// })

// server.listen(port, () => {
//     console.log(`Server is up on port ${port}!`)
// })