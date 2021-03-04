const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = mongoose.model("user");
// const Token = mongoose.model('token');
// const Refresh = mongoose.model('refresh');

router.post("/login", async (req, res) => {
  console.log(req.body);
  if (/\S+@\S+\.\S+/.test(req.body.email)) {
    console.log(req.body.email);
    console.log(req.body.hashedPassword);
    doc = await login(req.body.email, req.body.hashedPassword);
    if (doc["status"]) {
      // tokenPair = generateTokens(req.body.email,doc['id'])
      // console.log("TOKENNNN--",tokenPair)
      user = await generateTokens(req.body.email, doc["id"]);
      res.status(200).send(user);
      //res.json({'status': "success", 'token_uuid': tokenPair['token_uuid'], 'refresh_uuid':tokenPair['refresh_uuid']});
    } else res.json({ message: "Technical Error", type: "error" });
    // dbc=="m"?insertUserMongod(req.body.email,req.body.phone_num,otp):insertUserCass(req.body.email,req.body.phone_num,otp);
  } else {
    res.json({ error: "Incorrect details" });
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
  if (result) return { status: result, id: id._id };
  else return { status: false };
}

async function generateTokens(email_id, uuid) {
  const token = jwt.sign(
    {
      data: uuid,
    },
    "secret",
    { expiresIn: "1h" }
  );
  refresh_uuid = jwt.sign(
    {
      data: uuid,
    },
    "secret",
    { expiresIn: "7d" }
  );

  // var utoken = new Token()
  // utoken.token = token_uuid
  // utoken.email = email_id
  // var rtoken = new Refresh()
  // rtoken.refresh_token = refresh_uuid
  // rtoken.email = email_id

  try {
    const user = await User.findOne({ email: email_id });
    console.log("USERRRR-", user);
    user.tokens = user.tokens.concat({ token });
    user.save();
    // return {"token_uuid":token_uuid,"refresh_uuid":refresh_uuid}
    return { user };
  } catch (error) {
    return { error };
  }

  // var result;
  // utoken.save(function(err, Token){
  //     if(err){
  //         result = false
  //         console.log(err)
  //     }
  //     else
  //         result = true
  //     });
  // if(result){
  //     rtoken.save(function(err, Refresh){
  //         if(err){
  //             result = false
  //             console.log(err)
  //         }
  //         else
  //             result = true
  //         });
  // }
}

module.exports = router;
