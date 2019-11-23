var express = require('express');
//importing router for api calls
var router = express.Router();
var mongoose = require('mongoose');

//import the link to connect to db
var config = require('../controller/database');


//import the created user models
var Events = require("../models/events");

//route to get all events posted in the page.
router.get('/events', function(req, res) {
    Events.find({},function (err,events) {
        if(err) {
            //handling the error
            res.render('error',{whatKind:"Cannot find events, Error with database"})
        }
        //rendering the page
        res.render('events',{list1 : events});

    }).sort({"time":-1});

});




//export the module
module.exports = router;