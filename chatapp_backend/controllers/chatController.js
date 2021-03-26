const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = mongoose.model("user");
const Chat=require('../models/chat')
const login_required = require('../middleware/login_required')
const { ggmail, ppassword } = require('../config/key');
var ObjectId = require('mongodb').ObjectID;

router.get('/getAllChats', login_required,async (req, res) => {
   console.log(req.user._id)
   Chat.find({$or:[{from:req.user._id},{to:req.user._id}]})
   .populate("_id","_id name email publicKey")
   .sort('-sentAt')
   .then((chats)=>{
       res.send({chats})  
   }).catch(err=>{
       console.log(err)
   })
})

router.post('/addChat', async (req, res) => {

console.log("HEY=",(typeof( ObjectId(req.body.from))))
   // var from=mongoose.Types.ObjectId("9888b3c0-898a-11eb-b6ae-cd2857033253")
   // var to=mongoose.Types.ObjectId("2c9aea50-8e50-11eb-b912-c309867e102e")
   var message=req.body.message
   var from=req.body.from
   var to=req.body.to
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