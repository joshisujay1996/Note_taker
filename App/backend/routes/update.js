var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');


//import the link to connect to db
var config = require('../controller/database');


//import the created user models
var Jobs = require("../models/jobs");


//get user update
router.get('/update', function (req,res) {
    res.render('edit');

});

//update the jobs posted
router.post('/update', function (req,res) {
    Jobs.find({ jobid:req.body.jobid},function (err,jobs) {
        //throws error if the specified job id is not present
        if (jobs[0] === undefined){
            res.render('error',{whatKind:"The requested Job ID does not exist, cannot update!!"})
        }

        else{
            // console.log(jobs);
            //update the job if the id is present
            var upd = jobs[0]['_id'];
            Jobs.findById(upd,function (err,doc) {
                if(err){
                    res.redirect('error');
                }
                doc.jobid = req.body.jobid;
                doc.jobtitle =req.body.jobtitle;
                doc.jobtype =req.body.jobtype;
                doc.jobdescription = req.body.jobdescription;
                doc.save();

            });
            //redirect to the job listings page after update
            res.redirect('jobs');

        }

    });


});



//must export to fetch at the backend
module.exports = router;