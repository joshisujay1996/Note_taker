var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');

//import the link to connect to db
var config = require('../controller/database');

//import the created user models
var Events = require("../models/events");


router.get('/add',function(req,res,next){
    res.render('post-events.hbs');
});

//to add a event
router.post('/add',function(req,res,next){
    if( !req.body.eventid || !req.body.eventtitle || !req.body.eventdescription
        || !req.body.eventtype )
    //checking if all fields are entered
    {
        res.json({success: false, msg: 'Please enter all required details'});}
        else{
            //if all fields are entered, create a new job
            var newEvent = new Events({
                eventid : req.body.eventid,
                eventtype: req.body.eventtype,
                eventtitle: req.body.eventtitle,
                eventdescription: req.body.eventdescription
            });
            //save the job
            newEvent.save(function (err) {
                if (err){
                    //handling the error
                    res.render('error', {whatKind: "The event already exists with the given Event ID"});


                }else   {
                    //redirecting to events page after success
                    res.redirect('events');

                }


            });
        }


});







//export the module
module.exports = router;
