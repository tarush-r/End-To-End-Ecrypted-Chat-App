const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
// const User = mongoose.model("user");
const User=require('../models/user.model')
const Chat=require('../models/chat')
const login_required = require('../middleware/login_required')
const { ggmail, ppassword } = require('../config/key');
var ObjectId = require('mongodb').ObjectID;

router.get('/getAllChats', login_required,async (req, res) => {
   console.log(req.user._id)
   Chat.find({$or:[{from:req.user._id},{to:req.user._id}]})
   .populate("from","_id name email publicKey profile_pic")
   .populate("to","_id name email publicKey profile_pic")
   .sort('-sentAt')
   .then((chats)=>{
      console.log(chats)
       res.send({chats})  
   }).catch(err=>{
       console.log(err)
   })
})

router.post('/addChat', async (req, res) => {

console.log("HEY=",(typeof( ObjectId(req.body.from))))
   var from=mongoose.Types.ObjectId(req.body.from)
   var to=mongoose.Types.ObjectId(req.body.to)
   var message=req.body.message
   // var from=req.body.from
   // var to=req.body.to
   const newChat = new Chat({
     from:from,
     to:to,
     message:message,
   })
   try {
     await newChat.save()
     res.send({newChat}) 
   } catch (error) {

      res.send({error}) 
   }
})

module.exports = router;