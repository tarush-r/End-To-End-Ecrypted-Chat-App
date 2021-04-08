const mongoose = require('mongoose')
const { ObjectId } = mongoose.Schema.Types
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
   isImage:{
      type:Boolean,
      default:false,
   },
   isLocation:{
      type:Boolean,
      default:false,
   },
   sentAt: {
      type: Date,
      default: Date.now
   },
   seen:{
      type:Boolean,
      default:false,
   }
})

const Chat = mongoose.model('Chat', chatSchema)
module.exports = Chat