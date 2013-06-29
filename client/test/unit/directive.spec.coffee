'use strict'

# jasmine specs for directives go here
describe "directives", ->

  beforeEach(angular.module "app.directives")

  describe "app-version", ->

    it "should print current version", ->
      angular.module ($provide) ->
        $provide.value "version", "TEST_VER"
        return

      angular.mock.inject ($compile, $rootScope) ->
        element = $compile("<span app-version></span>")($rootScope)
        expect(element.text()).toEqual "TEST_VER"


