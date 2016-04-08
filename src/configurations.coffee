angular.module 'guclinkAuthModules'
  .factory 'authConfigurations', (AuthEndpoints, $http) ->
    $http.get AuthEndpoints.configurations.index, {cache: true}
      .then (response) ->
        return response.data
