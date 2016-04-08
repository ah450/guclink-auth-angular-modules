angular.module 'guclinkAuthModules'
  .factory 'configurations', (AuthEndpoints, $http) ->
    $http.get AuthEndpoints.configurations.index, {cache: true}
      .then (response) ->
        return response.data
