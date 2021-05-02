const mongoose = require('mongoose')
const { ObjectId } = mongoose.Schema.Types

const callSchema = new mongoose.Schema({
   sender: {
      type: ObjectId,
      required: true,
      ref: 'user',
   },
   receiver: {
      type: ObjectId,
      required: true,
      ref: 'user',
   },
   sentAt: {
      type: Date,
      default: Date.now
   },
})

const Call = mongoose.model('Call', callSchema)
module.exports = Call