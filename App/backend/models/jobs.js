//imports
var mongoose = require('mongoose');

//mongoose schema
var Schema = mongoose.Schema;

var JobSchema = new Schema({
    jobid: {
        type: Number,
        unique : true,
        required : true
    },
    jobtitle:{
        type: String,
        required : true

    },
    jobtype:{
        type : String,
        required : true
    },
    jobdescription:{
        type:String,
        required :true

    },
    //current format is epoch
    time : { type: String, default: (new Date()) },
    company:{type:String,default: "Misco Networks"}


});
//can also add time stamp for created and updated at time and data
// JobSchema.set('timestamps', true);

module.exports = mongoose.model('jobs', JobSchema);