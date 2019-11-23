var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');


//import the link to connect to db
var config = require('../controller/database');


//import the created user models
var Events = require("../models/events");


//get user update
router.get('/update', function (req,res) {
    res.render('edit');

});

//update the events posted
router.post('/update', function (req,res) {
    Events.find({ eventid:req.body.eventid},function (err,events) {
        //throws error if the specified event id is not present
        if (events[0] === undefined){
            res.render('error',{whatKind:"The requested EventID does not exist, cannot update!!"})
        }

        else{
            //update the event if the id is present
            var upd = events[0]['_id'];
            Events.findById(upd,function (err,doc) {
                if(err){
                    res.redirect('error');
                }
                doc.eventid = req.body.eventid;
                doc.eventtitle =req.body.eventtitle;
                doc.eventtype =req.body.eventtype;
                doc.eventdescription = req.body.eventdescription;
                doc.save();

            });
            //redirect to the event listings page after update
            res.redirect('events');

        }

    });


});



//must export to fetch at the backend
module.exports = router;