angular.module 'guclinkAuthModules'
  .factory 'UsersResource', ($resource, AuthEndpoints) ->
    usersResourceDefaultParams =
      id: '@id'
    usersResourceActions =
      query:
        method: 'GET'
        isArray: false
        cache: true
      update:
        method: 'PUT'
        isArray: false
        cache: false
      create:
        method: 'POST'
        isArray: false
        cache: false
      delete:
        method: 'DELETE'
        isArray: false
        cache: false

    $resource AuthEndpoints.users.resourceUrl, usersResourceDefaultParams,
      usersResourceActions
