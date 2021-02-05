const mongoose = require('mongoose');
var uuid = require('node-uuid');

var userSchema = new mongoose.Schema({
    _id: { type: String, default: uuid.v1 },
    name: {type : String, required : true},
    number: {type : String , unique : true, required : true},
    email: {type : String , unique : true, required : true},
    password: {type : String},
    tokens:[{
      token:{
          type:String,
          required:true
      }
  }],
    // otp: {type : Number},
    // otp_check: {type : Boolean, required : true}
 });

 var otpSchema = new mongoose.Schema({
    email: {type : String , unique : true, required : true},
    otp: {type : Number},
    otp_check: {type : Boolean, required : true},
    createdAt:{type : Number,expires: '600s', default: Date.now},
 });

//  var tokenSchema = new mongoose.Schema({
//     email: {type : String , unique : true, required : true},
//     token: {type : String, required : true},
//     createdAt:{type : Number,expires: '3000s', default: Date.now},
//  });

//  var refreshSchema = new mongoose.Schema({
//     email: {type : String , unique : true, required : true},
//     refresh_token: {type : String, required : true},
//     createdAt:{type : Number,expires: '6000s', default: Date.now},
//  });
mongoose.model("user", userSchema);
mongoose.model("otp", otpSchema);
// mongoose.model("token", tokenSchema);
// mongoose.model("refresh", refreshSchema);
