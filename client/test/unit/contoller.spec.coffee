'use strict'

expect = chai.expect

mocha.setup({globals: ['script*']});

# jasmine specs for controllers go here

# TODO figure out how to test Controllers that use modules
describe "controllers", ->
  
  console.log 'aaaaaaaaaaaa'

  #beforeEach(module(($provide) ->
  #  $provide.service 'profile', -> $get: sinon.spy()
  #))
  beforeEach(module "app.controllers")
  beforeEach(module "app.services")

  describe "AppCtrl", ->

    it "should make scope testable", inject(($q, $rootScope, $controller, profile) ->
      sinon.stub(profile, '$get')
      scope = $rootScope.$new()
      ctrl = $controller "AppCtrl", {
        $scope: scope,
        profile: profile
        $location: {}
      }
      expect(scope.$location).to.eql {}
    )
