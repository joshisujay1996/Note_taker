var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
//multer required for file upload
var multer  = require('multer');
var path = require('path');
//setting multer path
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './public/uploads/')
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname)) //Appending .jpg
    }
});
var upload = multer({ storage: storage });


//import the link to connect to db
var config = require('../controller/database');
var sendSuccessMail = require('../controller/mailer');
var nodemailer = require('nodemailer');

//import the created user models
var Jobs = require("../models/jobs");
var Candidates = require("../models/candidates");

//sending job details to angular server
router.get('/jobs', function(req, res) {
        Jobs.find({},function (err,jobs) {
            if(err) {
                //handling error wrt DB
              res.status(500).json({success : false});
            }
            //sending the response
            res.status(200).send(jobs);

        }).sort({"time":-1});
            
        });
//get jobs by its JobID
router.get('/jobs/:id', function (req,res) {
    Jobs.findById(req.params.id, function (err, job) {
        if (err) return res.status(500).send('db error');
        res.status(200).send(job);
    });

});

//accept candidates to company database
router.post('/candidates',upload.single('resume'),function (req,res) {
    if( !req.body.jobid || !req.body.jobtitle || !req.body.username
        || !req.body.email )
    //checking if all fields are entered
    {
        res.status(400).json({success: false, msg: 'Please enter all required details'});}
    else{
        //if all fields are entered, create a new job
        var newCandidate = new Candidates({
            //creating format for the DB insert
            jobid : req.body.jobid,
            jobtitle: req.body.jobtitle,
            email:req.body.email,
            username:req.body.username,
            resume:("uploads/" + req.file.filename)
        });
        //save the job
        newCandidate.save(function (err) {
            if (err){
                res.status(400).send({error:"PERSON ALREADY APPLIED "});
            }else{
                var transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: sendSuccessMail['user'],
                        pass: sendSuccessMail['pass']
                    }
                });

                var mailOptions = {
                    //creating mailing oprions
                    to: req.body.email,
                    //getting user email id from the request to send mail
                    subject: 'You have succesfully applied to Misco Networks',
                    //sending mail wrt job title
                    text: ('You have succesfully applied to '+ req.body.jobtitle)
                };
                //sending email
                transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        console.log(error);
                        res.send('fail')
                    } else {
                        console.log('Email sent: ' + info.response);
                        res.status(200).send('Mail has been sent to candidate')
                    }
                });

            }



        });
    }


});

//to view applied candidates
router.get('/viewcandidates',function (req,res) {
    Candidates.find({},function (err,candidates) {
       if(err){
           //error with database if something goes wrong
           res.status(400).send(err);
       }
       //rendering candidates page
       res.status(200).send(candidates);
 
       //sorting values in dec order
    }).sort({"time":-1});
 
 });


//export the module
module.exports = router;