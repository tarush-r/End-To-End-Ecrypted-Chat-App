const jwt=require('jsonwebtoken')
const mongoose = require("mongoose");
const User = require("../models/user");
const {JWT_SECRET} = require('../config/key')

const auth =async(req,res,next)=>{
    try{
        const token=req.header('Authorization').replace('Bearer ','')
        const decoded=jwt.verify(token.toString(),JWT_SECRET)
        const user=await User.findOne({_id:decoded.data,'tokens.token':token}) 
        if(!user){
            throw new Error()
        }
        req.token=token
        req.user=user
        next()
    }catch(e){
        res.status(401).send(e)
    }
}

module.exports=auth