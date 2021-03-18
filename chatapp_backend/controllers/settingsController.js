const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = mongoose.model("user");
const login_required = require('../middleware/login_required')

router.post('/resetPassword', login_required, async (req, res) => {
   if (!req.body.oldPassword || !req.body.newPassword || !req.body.email) {
      return res.status(422).json({ error: "Please add all fields" })
   }
   else {
      try {
         const emailId = req.body.email
         const user = await User.findOne({ emailId });
         if (user.password === req.body.oldPassword) {
            await User.updateOne(
               { email: req.body.email },
               {
                  $set: { password: newPassword },
               }
            );
            res.json({ user, token })
         }

      }
      catch (error) {
         res.status(404).send()
      }
   }
})

router.post('/sendotpForgetPassword', login_required, async (req, res) => {

   var otp = await generateOTP(req.user.email)
   var val=true
   await User.updateOne(
      { email: req.user.email },
      {
         $set: { resetPasswordOTP: otp, resetPasswordReq:val },
      }
   );
})

router.post('/forgetPassword', login_required, async (req, res) => {

   const emailId = req.user.email;
   try {
      const user = await User.findOne({ emailId });
      if (req.body.otp === user.resetPasswordOTP && user.resetPasswordReq === true) {
         await User.updateOne(
            { email: req.user.email },
            {
               $set: { resetPasswordReq:false, password:req.body.newPassword },
            }
         );
      }
   }
   catch (error) {
      res.status(404).send()
   }
})


router.post('/deleteAccount', login_required, async (req, res) => {
   try {
      await req.user.remove()
      res.send(req.user)
   } catch (e) {
      return res.status(500).send()
   }
})

async function generateOTP(email) {
   let OTP = 0;
   var d = 1
   for (let i = 0; i < 4; i++) {
      OTP = OTP * 10 + Math.floor(Math.random() * 10);
   }

   var transporter = await nodemailer.createTransport({
      service: 'gmail',
      auth: {
         user: ggmail,
         pass: ppassword
      }
   });

   var mailOptions = {
      from: ggmail,
      to: email,
      subject: 'OTP for ChatApp',
      text: ('Your OTP is ' + OTP)
   };

   transporter.sendMail(mailOptions, function (error, info) {
      if (error) {
         console.log(error);
      } else {
         console.log('Email sent: ' + info.response);
      }
   });
   return OTP;
}


module.exports = router;