var express = require('express');
//router required for api calls
var router = express.Router();
//mongoose orm for connectin to DB
var mongoose = require('mongoose');


//import the link to connect to db
var config = require('../controller/database');


//import the created user models
var Events = require("../models/events");



//deleting EVENT data
router.post('/delete',function(req,res) {
    //to get the recode with the respective eventid, so then we can delete it.
   Events.find({ eventid:req.body.eventid},function (err,events) {
       if(events[0] === undefined){
           // return next(err);

            //error if there is no such event
           res.render('error',{whatKind: "The requested event to be deleted does not exist"}) ;
       }else {
           var rem = events[0]['_id'];
           Events.findByIdAndRemove(rem).exec();
           res.redirect('events');
       }
        

   });



});
//route to delete page
router.get('/delete',function (req,res,next) {
    res.render('delete');

});



//export the module
module.exports = router;