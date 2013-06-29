'use strict'

### Sevices ###

angular.module('app.services', [])

.factory('version', -> "0.1")

.service('profile', ($http) ->
  $get: -> $http.get('/api/users/me').then (res) ->
    res.data
)
