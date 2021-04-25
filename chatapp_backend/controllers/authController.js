const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
// const {JWT_SECRET} = require('../config/key')
const {JWT_SECRET} = require('../config/key')
// const Token = mongoose.model('token');
// const Refresh = mongoose.model('refresh');

router.post("/login", async (req, res) => {
  console.log("login===",req.body);
  if (/\S+@\S+\.\S+/.test(req.body.email)) {
    console.log(req.body.email);
    console.log(req.body.hashedPassword); 
    doc = await login(req.body.email, req.body.hashedPassword);
    if (doc["status"]) {
      // tokenPair = generateTokens(req.body.email,doc['id'])
      // console.log("TOKENNNN--",tokenPair)
      user = await generateTokens(req.body.email, doc["id"]);
      console.log("USER HERE")
      console.log(user)
      console.log("USER.USER")
      console.log((user.user))
      console.log("USER.TOKEN")
      console.log((user.token))
      res.status(200).send(user);
      //res.json({'status': "success", 'token_uuid': tokenPair['token_uuid'], 'refresh_uuid':tokenPair['refresh_uuid']});
    } else res.status(403).json({ message: "Email id or password doesn't match", type: "error" });
    // dbc=="m"?insertUserMongod(req.body.email,req.body.phone_num,otp):insertUserCass(req.body.email,req.body.phone_num,otp);
  } else {
    res.status(400).json({ error: "Incorrect details" });
  }
});

async function login(email_id, pass) {
  var result = true;
  var id = await User.findOne({ email: email_id }, function (err, response) {
    if (!err) {
      console.log("Retrieve Response check : " + response);
      console.log(pass)
      if (response != null && response["password"] == pass) {
        console.log("vsfegegrferferfe");
        result = true;
      }
      else{
          result = false
      }
    } else {
      console.log("Error" + err);
      result = false;
    }
  }).exec();
  console.log("result : "+result)
  console.log("SSSSSSSSSSSSSS=",id)
  if (result) return { status: result, id: id._id };
  else return { status: false };
}

async function generateTokens(email_id, uuid) {
  try {
    const token = jwt.sign(
      {
        data: uuid,
      },
      JWT_SECRET,
      { expiresIn: "7d" }
    );
    refresh_uuid = jwt.sign(
      {
        data: uuid,
      },
      JWT_SECRET,
      { expiresIn: "7d" }
    );
    const user = await User.findOne({ email: email_id });
    user.tokens = user.tokens.concat({ token });
    user.save();
    return { user ,token};
  } catch (error) {
    return { error };
  }
}

module.exports = router;
