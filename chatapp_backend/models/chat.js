const mongoose = require('mongoose')
const { ObjectId } = mongoose.Schema.Types
const chatSchema = new mongoose.Schema({
   from: {
      type: ObjectId,
      required: true,
      ref: 'User',
   },
   to: {
      type: ObjectId,
      required: true,
      ref: 'User',
   },
   message: {
      type: String,
      required: true,
   },
   sentAt: {
      type: Number,
      default: Date.now
   }
})

const Chat = mongoose.model('Chat', chatSchema)
module.exports = Chat