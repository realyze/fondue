'use strict'

# jasmine specs for services go here

describe "service", ->

  beforeEach(angular.module "app.services")

  describe "version", ->
    it "should return current version", angular.mock.inject((version) ->
      expect(version).toEqual "0.1"
    )
