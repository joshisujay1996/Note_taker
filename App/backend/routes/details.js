var express = require('express');
//importing router for api calls
var router = express.Router();
var mongoose = require('mongoose');

//import the link to connect to db
var config = require('../controller/database');
var Candidates = require("../models/candidates");


//import the created user models
var Jobs = require("../models/jobs");

//route to get all jobs posted in the page.
router.get('/jobs', function(req, res) {
    Jobs.find({},function (err,jobs) {
        if(err) {
            //handling the error
            res.render('error',{whatKind:"Cannot find Jobs, Error with database"})
        }
        //rendering the page
        res.render('jobs',{list1 : jobs});

    }).sort({"time":-1});

});

//to view applied candidates
router.get('/viewcandidates',function (req,res) {
   Candidates.find({},function (err,candidates) {
      if(err){
          //error with database if something goes wrong
          res.render('error',{whatKind:"Cannot find candidates, Error with database"});
      }
      //rendering candidates page
      res.render('candidates',{list2:candidates});

      //sorting values in dec order
   }).sort({"time":-1});

});



//export the module
module.exports = router;