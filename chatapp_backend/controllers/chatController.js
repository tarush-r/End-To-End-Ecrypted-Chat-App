const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const Chat = require('../models/chat');
const Schedule = require('../models/schedule')
const login_required = require('../middleware/login_required')
const { ggmail, ppassword } = require('../config/key');
var ObjectId = require('mongodb').ObjectID;

router.get('/getAllChats', login_required, async (req, res) => {
  console.log("reqqqq=",req.user._id)
  Chat.find({ $or: [{ from: req.user._id }, { to: req.user._id }] })
    .populate("from", "_id name email publicKey profile_pic",User)
    .populate("to", "_id name email publicKey profile_pic",User)
    // .sort('-sentAt')
    .then((chats) => {
      console.log(chats)
      res.send({ chats })
    }).catch(err => {
      console.log(err)
    })
})

router.post('/setSeen', login_required, async (req, res) => {
  console.log(req.user._id)
  Chat.updateMany({ $and: [{ to: req.user._id }, { from: req.body._id }] },
    { seen: true }, function (err, doc) {
      if (err) {
        console.log(err)
        res.send(err)
      }
      else {
        console.log(doc)
        res.send(doc)
      }
    });

})

router.get('/getSelectedUserChat', login_required, async (req, res) => {
  console.log(req.user._id)
  Chat.find({ $or: [{ $and: [{ from: req.user._id }, { to: req.body._id }] }, { $and: [{ to: req.user._id }, { from: req.body._id }] }] })
    .populate("from", "_id name email publicKey profile_pic")
    .populate("to", "_id name email publicKey profile_pic")
    .sort('-sentAt')
    .then((chats) => {
      res.send({ chats })
    }).catch(err => {
      console.log(err)
    })
})

router.post('/readSelectedUserChat', login_required, async (req, res) => {
  console.log(req.user._id)

  Chat.updateMany({ $or: [{ $and: [{ from: req.user._id }, { to: req.body._id }] }, { $and: [{ to: req.user._id }, { from: req.body._id }] }] },
    { seen: true }, function (err, chats) {
      if (err) {
        console.log(err)
        res, send({ err })
      }
      else {
        console.log("Updated chats : ", chats);
        res.send({ chats })
      }
    });

})

exports.chatpost = async (parameters) => {
  const options = {
    headers: {
      Accept: "*/*",
      "Content-type": "application/json",
    },
  };
  const result = await axios.post(
    parameters.url,
    options
  );
  console.log("HEY")
  console.log("CHECK", result.data.length);
  return result;
};

router.post('/addChat', async (req, res) => {
  console.log("HEY=", (typeof (ObjectId(req.body.from))))
  var from = mongoose.Types.ObjectId(req.body.from)
  var to = mongoose.Types.ObjectId(req.body.to)
  var message = req.body.message
  // var from=req.body.from
  // var to=req.body.to
  const newChat = new Chat({
    from: from,
    to: to,
    message: message,
  })
  try {
    await newChat.save()
    res.send({ newChat })
  } catch (error) {

    res.send({ error })
  }
})


router.post('/schedule', login_required, async (req, res) => {
  console.log("HEY=", (typeof (ObjectId(req.body.to))))
  var from = mongoose.Types.ObjectId(req.user._id)
  var to = mongoose.Types.ObjectId(req.body.to)
  var message = req.body.message
  var toSendAt=req.body.toSendAt
  const newChat = new Schedule({
    from: from,
    to: to,
    message: message,
    toSendAt:toSendAt
  })
  try {
    await newChat.save()
    res.send({ newChat })
  } catch (error) {

    res.send({ error })
  }
})

module.exports = router;