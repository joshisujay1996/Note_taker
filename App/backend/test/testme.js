// const app = require("../app");
// const chai = require("chai");
// const chaiHttp = require("chai-http");

// const { expect } = chai;
// chai.use(chaiHttp);
// describe("Server!", () => {
//   it("welcomes user to the api", done => {
//     chai
//       .request(app)
//       .get("/")
//       .end((err, res) => {
//         expect(res).to.have.status(200);
//         done();
//       });
//   });
// });


var expect  = require('chai').expect;
var request = require('request');

it('Main page content', function(done) {
    request('http://localhost:5500' , function(error, response, body) {
        // expect(body).to.equal('Smart');
        // expect(res).to.have.status(200);
        done();
    });
});