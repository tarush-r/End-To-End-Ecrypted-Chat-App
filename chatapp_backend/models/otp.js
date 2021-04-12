

const mongoose = require('mongoose');
var uuid = require('node-uuid');
// const Chat = mongoose.model("Chat");


 var otpSchema = new mongoose.Schema({
   email: {type : String , unique : true, required : true},
   otp: {type : Number},
   otp_check: {type : Boolean, required : true},
   createdAt:{type : Number,expires: '600s', default: Date.now},
});

const OTP = mongoose.model('OTP', otpSchema)
module.exports = OTP


