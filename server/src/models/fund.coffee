request = require 'superagent'
Q = require 'q'
cheerio = require 'cheerio'
fs = require 'fs'

mongoose = require 'mongoose'
Schema = mongoose.Schema


CONSEQ_ROOT_URL = 'https://www.conseq.cz'
CONSEQ_SEARCH_URL = "#{CONSEQ_ROOT_URL}/search.asp"
CONSEQ_FUND_URL = "#{CONSEQ_ROOT_URL}/fund_detail.asp"


jquery = fs.readFileSync('../client/vendor/jquery/jquery.js').toString()


FundSchema = new Schema
  id: String
  cummulative: {}


FundSchema.statics.getConseqId = (fundId) ->
  deferred = Q.defer()

  request
    .get(CONSEQ_SEARCH_URL)
    .query(q: fundId)
    .on('error', deferred.reject)
    .end (res) ->
      if res.error or res.status != 200
        return deferred.reject res.error or new Error('Failed to get fund.')
  
      conseqId = _parseConseqFundId res.text
      if not conseqId
        return deferred.reject new Error('Could not find the fund')

      deferred.resolve conseqId

  deferred.promise


FundSchema.methods.updateFund = (id) ->
  conseqId = this.get 'conseqId'

  deferred = Q.defer()

  request
    .get(CONSEQ_FUND_URL)
    .query(fund: conseqId)
    .on('error', deferred.reject)
    .end (res) ->
      if res.error or res.status != 200
        return deferred.reject res.error or new Error('Failed to get fund.')
      deferred.resolve res.text

  deferred.promise
    .then (html) ->
      $ = cheerio.load html
      cummulative = {}
      for key, i in ['week1', 'month1', 'month3']
        val = $('body #tableDetailFund tr').eq(i).find('td').text()
        val = val.replace(',', '.').replace('%', '')
        cummulative[key] = parseFloat val
      cummulative

    .then (cummulativeObj) =>
      @cummulative = cummulativeObj
      Q.ninvoke @, 'save'


Fund = mongoose.model 'Fund', FundSchema


# Returns the Conseq fund id from the Conseq search page.
_parseConseqFundId = (html) ->
  $ = cheerio.load html
  results = $('body').find('.searchResults a')

  return null unless results.length == 1

  results.attr('href').split('=')[1]
