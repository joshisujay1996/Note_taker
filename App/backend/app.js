var express = require('express');
var path = require('path');
// var path  = require('engines')
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var sassMiddleware = require('node-sass-middleware');
var createError = require('http-errors');
var mongoose = require('mongoose');
var config = require('./controller/database');
//required for sending and getting data from the client
var cors = require('cors');
var hbs = require('express-handlebars');
var multer  = require('multer');
var upload = multer({ dest: 'uploads/' });


//routes go here !!
var indexRouter = require('./routes/index');
var addRouter = require('./routes/add');
var detailsRouter = require('./routes/details');
var deleteRouter = require('./routes/delete');
var updateRouter = require('./routes/update');
var jobsRouter = require('./routes/jobs');
var app = express();



//enabling CORS
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});


//connect to Database
mongoose.connect(config.database, { useCreateIndex: true, useNewUrlParser: true });



app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(sassMiddleware({
  src: path.join(__dirname, 'public'),
  dest: path.join(__dirname, 'public'),
  indentedSyntax: false, // true = .sass and false = .scss
  sourceMap: true
}));

//set engine to html
app.engine('hbs',hbs({extname: 'hbs', defaultLayout:'layout',layoutsDir: __dirname+'/public/layouts'}) );
app.set('view engine', 'hbs');

//set path of view to directory public
app.set('views', __dirname + '/public');

app.use(express.static(path.join(__dirname, 'public')));
//
// app.engine('html', engines.mustache);
// app.set('view engine', 'html');


app.use('/', indexRouter);
app.use('/',addRouter);
app.use('/',detailsRouter);
app.use('/', deleteRouter);
app.use('/',updateRouter);
app.use('/api',jobsRouter);



module.exports = app;
