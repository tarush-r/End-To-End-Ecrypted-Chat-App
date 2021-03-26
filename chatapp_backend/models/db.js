//local
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/chatApp', {useNewUrlParser: true, useUnifiedTopology: true},
err =>{
    if(!err){
        console.log("Connected successfully to Mongod server")
    }else{
        console.log("Error : "+err)
    }
})

require('./user.model.js');
require('./chat.js')