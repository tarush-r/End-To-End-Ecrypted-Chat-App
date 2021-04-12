const mongoose = require('mongoose');
var uuid = require('node-uuid');
// const Chat = mongoose.model("Chat");

var userSchema = new mongoose.Schema({
    name: {type : String, required : true},
    number: {type : String , unique : true, required : true},
    email: {type : String , unique : true, required : true},
    profile_pic:{
      type:String,
      default:"https://drgsearch.com/wp-content/uploads/2020/01/no-photo.png" 
    },
    status:{
      type:String,
      default:"Hey there! I am using Cypher." 
  },
    password: {type : String},
    publicKey: {type : String},
    privateKey: {type: String},
    hashedPass: {type : String},
    resetPasswordOTP:{type:Number},
    resetPasswordReq:{type:Boolean, default:false},
    tokens:[{
      token:{
          type:String,
          required:true
      }
  }],
 });

//  var otpSchema = new mongoose.Schema({
//     email: {type : String , unique : true, required : true},
//     otp: {type : Number},
//     otp_check: {type : Boolean, required : true},
//     createdAt:{type : Number,expires: '600s', default: Date.now},
//  });

// mongoose.model("user", userSchema);
// mongoose.model("otp", otpSchema);

const User = mongoose.model('User', userSchema)
module.exports = User

// const OTP = mongoose.model('OTP', otpSchema)
// module.exports = OTP

