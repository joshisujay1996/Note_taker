var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');

//import the link to connect to db
var config = require('../controller/database');

//import the created user models
var Jobs = require("../models/jobs");


router.get('/add',function(req,res,next){
    res.render('post-jobs.hbs');
});

//to add a job
router.post('/add',function(req,res,next){
    if( !req.body.jobid || !req.body.jobtitle || !req.body.jobdescription
        || !req.body.jobtype )
    //checking if all fields are entered
    {
        res.json({success: false, msg: 'Please enter all required details'});}
        else{
            //if all fields are entered, create a new job
            var newJob = new Jobs({
                jobid : req.body.jobid,
                jobtype: req.body.jobtype,
                jobtitle: req.body.jobtitle,
                jobdescription: req.body.jobdescription
            });
            //save the job
            newJob.save(function (err) {
                if (err){
                    //handling the error
                    res.render('error', {whatKind: "The job already exists with the given Job ID"});


                }else   {
                    //redirecting to jobs page after success
                    res.redirect('jobs');

                }


            });
        }


});







//export the module
module.exports = router;
