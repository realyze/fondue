'use strict'

# jasmine specs for filters go here
describe "filter", ->
  beforeEach(angular.module "app.filters")

  describe "interpolate", ->

    beforeEach(module(($provide) ->
      $provide.value "version", "TEST_VER"
      return
    ))

    it "should replace VERSION", angular.mock.inject((interpolateFilter) ->
      expect(interpolateFilter("before %VERSION% after")).toEqual "before TEST_VER after"
    )
