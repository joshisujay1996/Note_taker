//imports
var mongoose = require('mongoose');

//mongoose schema
var Schema = mongoose.Schema;

var CandidateSchema = new Schema({
    jobid: {
        type: String,
        required : true
    },
    jobtitle:{
        type: String,
        required : true

    },
    email:{
        type : String,
        unique : true,
        required : true
    },
    username:{
      type:String,
      required :true
    },
    resume:{
        type:String,
        required :true

    },
    //current format is epoch
    time : { type: String, default: (new Date()) },

    company : { type: String, default:"Misco Networks" }


});
//can also add time stamp for created and updated at time and data
// JobSchema.set('timestamps', true);

module.exports = mongoose.model('candidates', CandidateSchema);