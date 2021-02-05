require('./models/db')
const express = require('express')
const app = express()
const bodyParser = require('body-parser');
const { options } = require('./app');
const e = require('express');
const userController = require('./controllers/userController')
const authController = require('./controllers/authController')
const port = 3000;


app.use(bodyParser.json());


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})

app.use('/user',userController)
app.use('/auth',authController)
