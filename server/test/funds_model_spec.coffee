chai = require 'chai'
should = chai.Should()

chai.use require 'sinon-chai'
chai.use require 'chai-as-promised'
require('mocha-as-promised')()

nock = require 'nock'

mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/test'
Q = require 'q'

require '../src/models/fund'
Fund = mongoose.model 'Fund'


CONSEQ_ROOT_URL = 'https://www.conseq.cz'


describe "funds model", ->

  env = {}

  beforeEach ->
    env = {}

  afterEach (done) ->
    Fund.remove {}, done

  it "should be a function", ->
    Fund.should.be.a 'function'

  describe "getConseqId", ->

    beforeEach ->
      env.scope = nock(CONSEQ_ROOT_URL)
        .defaultReplyHeaders('content-type': 'text/html')

    it "should be a static method", ->
      should.exist Fund.getConseqId
      Fund.getConseqId.should.be.a 'function'

    describe "invalid fond_id", ->

      beforeEach ->
        env.scope = env.scope
          .get('/search.asp')
          .reply(200, require './fixtures/conseq_empty_search')

      afterEach ->
        env.scope.done()

      it "should return a rejected promise if an invalid fund id is passed in", ->
        Fund.getConseqId('invalid_id_3rfb2v78rt111aaa111')
          .should.be.rejected

    describe "with valid fund id'", ->

      beforeEach ->
        env.scope = env.scope
          .get('/search.asp')
          .reply(200, require './fixtures/conseq_valid_search')

      it "should return the fund conseq id when a valid fund id is passed in", ->
          Fund.getConseqId('my_valid_fund_id')
            .should.eventually.be.a('string')
            .and.should.eventually.equal('my_valid_fund_id')

      it "should GET 'https://www.conseq.cz/search.asp?q=my_valid_fund_id'", ->
        Fund.getConseqId('valid_id')
        env.scope.done()


  describe "updateFund", ->

    beforeEach (done) ->
      env.fund = new Fund id: 42
      env.fund.save done

    beforeEach ->
      env.scope = nock(CONSEQ_ROOT_URL)
        .defaultReplyHeaders('content-type': 'text/html')
        .get("/fund_detail.asp")
        .reply(200, require './fixtures/conseq_valid_fund')
    
    it "should be a method", ->
      should.exist env.fund.updateFund
      env.fund.updateFund.should.be.a 'function'

    it "should update the cummulative performance of the fund", ->
      env.fund.updateFund('my_valid_fund_id')
        .should.be.fulfilled
        .then ->
          Q.ninvoke Fund, 'findOne', id:42
        .should.eventually.have.deep.property('cummulative.week1', 1.15)
        .and.deep.property('cummulative.month1', -12.52)
        .and.deep.property('cummulative.month3', -15.28)
