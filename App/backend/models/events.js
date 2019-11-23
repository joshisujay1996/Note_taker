//imports
var mongoose = require('mongoose');

//mongoose schema
var Schema = mongoose.Schema;

var EventsSchema = new Schema({
    eventid: {
        type: Number,
        unique : true,
        required : true
    },
    eventtitle:{
        type: String,
        required : true

    },
    eventtype:{
        type : String,
        required : true
    },
    eventdescription:{
        type:String,
        required :true

    },
    //current format is epoch
    time : { type: String, default: (new Date()) },
    company:{type:String,default: "Misco Networks"}


});
//can also add time stamp for created and updated at time and data
// JobSchema.set('timestamps', true);

module.exports = mongoose.model('events', EventsSchema);