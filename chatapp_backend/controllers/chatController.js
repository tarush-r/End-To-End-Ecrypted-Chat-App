const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const moment = require('moment-timezone');
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const Chat = require('../models/chat');
const Call = require('../models/call');
const Schedule = require('../models/schedule')
const login_required = require('../middleware/login_required')
const { ggmail, ppassword } = require('../config/key');
var ObjectId = require('mongodb').ObjectID;

router.get('/getAllChats', login_required, async (req, res) => {
  console.log("reqqqq=", req.user._id)
  Chat.find({ $or: [{ from: req.user._id }, { to: req.user._id }] })
    .populate("from", "_id name email publicKey profile_pic", User)
    .populate("to", "_id name email publicKey profile_pic", User)
    // .sort('-sentAt')
    .then((chats) => {
      console.log(chats)
      res.send({ chats })
    }).catch(err => {
      console.log(err)
    })
})

router.get('/getAllCalls', login_required, async (req, res) => {
  console.log("reqqqq=", req.user._id)
  Call.find({ $or: [{ sender: req.user._id }, { receiver: req.user._id }] })
    .populate("sender", "_id name email profile_pic number", User)
    .populate("receiver", "_id name email profile_pic number", User)
    .sort('-sentAt')
    .then((calls) => {
      console.log(calls)
      res.send({ calls })
    }).catch(err => {
      console.log(err)
    })
})


router.get('/getNewChats', login_required, async (req, res) => {
  console.log("reqqqq=", req.user._id)
  Chat.find({ $and: [{ to: req.user._id }, { isStored: false }] })
    .populate("from", "_id name email publicKey profile_pic number", User)
    .populate("to", "_id name email publicKey profile_pic number", User)
    // .sort('-sentAt')
    .then((chats) => {
      console.log(chats)
      const n = chats.length;
      var i;
      for (i = 0; i < n; i++) {

        chats[i].isStored = true
      }
      Chat.updateMany({ $and: [{ to: req.user._id }, { isStored: false }] },
        { isStored: true }, function (err, doc) {
          if (err) {
            console.log(err)
            res.send(err)
          }
          else {
            console.log(doc)
            res.send({ chats })
            // res.send(doc)
          }
        });
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

router.post('/getSelectedUserProfile', login_required, async (req, res) => {
  console.log(req.user._id)
   User.find({_id:req.body._id})
    .then((user) => {
      console.log(user[0])
      user=user[0];
      res.send({ user })
    }).catch(err => {
      console.log(err)
    })
})


router.post('/deleteSelectedUserChat', login_required, async (req, res) => {
  console.log(req.user._id)
  console.log("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
  Chat.deleteMany({ $or: [{ $and: [{ from: req.user._id }, { to: req.body._id }] }, { $and: [{ to: req.user._id }, { from: req.body._id }] }] }).then(function () {
    res.status(200).send({ data: "Chats deleted successfully" });
    console.log("Data deleted"); // Success
  }).catch(function (error) {
    res.status(500).send({ data: "Server error" }); // Failure
  });

})






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
  var toSendAt = req.body.toSendAt
  var dateTime = moment(toSendAt)
  console.log(typeof (dateTime))
  console.log(toSendAt)
  var date = toSendAt.split(" ")[0]
  var time = dateTime.format("HH:mm")
  console.log(date)
  const newChat = new Schedule({
    from: from,
    to: to,
    message: message,
    toSendAtDate: date,
    toSendAtTime: time,
  })
  try {
    await newChat.save()
    res.send({ newChat })
  } catch (error) {

    res.send({ error })
  }
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

module.exports = router;