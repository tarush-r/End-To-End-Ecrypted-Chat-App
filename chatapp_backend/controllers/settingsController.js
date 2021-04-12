const express = require("express");
var router = express.Router();
const mongoose = require("mongoose");
var nodemailer = require("nodemailer");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const login_required = require('../middleware/login_required')
const { ggmail, ppassword } = require('../config/key')

router.post('/resetPassword', async (req, res) => {
   console.log(req.body)
   if (!req.body.oldPassword || !req.body.newPassword || !req.body.email || !req.body.privateKey) {
      return res.status(422).json({ error: "Please add all fields" })
   }
   else {
      try {
         const emailId = req.body.email
         console.log(emailId)
         const user = await User.findOne({ email: emailId });
         if (user.password === req.body.oldPassword) {
         console.log(user.password+ " "+req.body.oldPassword)

            await User.updateOne(
               { email: req.body.email },
               {
                  $set: { password: req.body.newPassword , privateKey:req.body.privateKey},
               }
            );
            console.log('SUCCESS')
            res.json({ user })
         }

      }
      catch (error) {
         console.log(error)
         res.status(404).send()
      }
   }
})

router.post('/statusUpdate', login_required,async (req, res) => {
   console.log(req.body)
   if (!req.body.status) {
      return res.status(422).json({ error: "Please add all fields" })
   }
   else {
      try {
            await User.updateOne(
               { email: req.user.email },
               {
                  $set: { status: req.body.status },
               }
            );
            const user = await User.findOne({ email: req.user.email });
            console.log('SUCCESS')
            res.json({
               user
            })
      }
      catch (error) {
         console.log(error)
         res.status(404).send()
      }
   }
})

router.post('/profileUpdate', login_required,async (req, res) => {
   console.log(req.body)
   if (!req.body.profile_pic) {
      return res.status(422).json({ error: "Please add all fields" })
   }
   else {
      try {
            await User.updateOne(
               { email: req.user.email },
               {
                  $set: { profile_pic: req.body.profile_pic },
               }
            );
            const user = await User.findOne({ email: req.user.email });
            console.log('SUCCESS')
            res.json({
               user
            })
      }
      catch (error) {
         console.log(error)
         res.status(404).send()
      }
   }
})

router.post('/sendotpForgetPassword', async (req, res) => {

   var otp = await generateOTP(req.body.email)
   var val=true
   try {
      console.log(otp)
      await User.updateOne(
         { email: req.body.email },
         {
            $set: { resetPasswordOTP: otp, resetPasswordReq:val },
         }
      );
      res.send({
         'data': 'otp sent'
      })
   }
   catch(e){
      console.log(e)
      res.send({
         'data': e
      })
   }
})

router.post('/forgetPassword', async (req, res) => {

   const emailId = req.body.email;
   console.log(req.body)
   try {
      const user = await User.findOne({ email: emailId });
      console.log(user)

      if (req.body.otp === user.resetPasswordOTP && user.resetPasswordReq === true) {
         await User.updateOne(
            { email: req.body.email },
            {
               $set: { resetPasswordReq:false, password:req.body.newPassword , privateKey:req.body.privateKey},
            }
         );
      }
      res.send({
         'data':'success'
      })
   }
   catch (error) {
      res.status(404).send()
   }
})


router.post('/deleteAccount', async (req, res) => {
   console.log(req.body)
   try {
      emailId = req.body.email
      const user = await User.findOne({ email: emailId });
      await user.remove()
      res.send(user)
   } catch (e) {
      console.log(e)
      return res.status(500).send()
   }
})

router.post('/logout', login_required, async (req, res) => {
   try{
      console.log("logout")
      req.user.tokens=req.user.tokens.filter((token)=>{
          return token.token !== req.token
      })
      await req.user.save()
      res.send()
  }catch(e){
      res.status(500).send()
  }
})

router.post('/logoutAll', login_required, async (req, res) => {
   try{
      console.log("logoutall")
      req.user.tokens=[]
      await req.user.save()
      res.send()
  }catch(e){
      res.status(500).send()
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