const mongoose = require('mongoose')
const { ObjectId } = mongoose.Schema.Types
const moment = require('moment-timezone');
const dateIndia = moment.tz(Date.now(), "Asia/Calcutta");

const chatSchema = new mongoose.Schema({
   from: {
      type: ObjectId,
      required: true,
      ref: 'user',
   },
   to: {
      type: ObjectId,
      required: true,
      ref: 'user',
   },
   message: {
      type: String,
      required: true,
   },
   sentAt: {
      type: Date,
      default: Date.now
   },
   seen:{
      type:Boolean,
      default:false,
   },
   isStored:{
      type:Boolean,
      default:false,
   },
})

const Chat = mongoose.model('Chat', chatSchema)
module.exports = Chat