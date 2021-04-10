const mongoose = require('mongoose')
const { ObjectId } = mongoose.Schema.Types
const scheduleSchema = new mongoose.Schema({
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
   toSendAt: {
      type: Date,
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

const Schedule = mongoose.model('Schedule', scheduleSchema)
module.exports = Schedule