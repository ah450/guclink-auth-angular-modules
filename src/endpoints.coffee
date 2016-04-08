angular.module 'guclinkAuthModules'
  .factory 'AuthEndpoints', (AUTH_BASE_URL) ->
    endpoints =
      configurations:
        index: [AUTH_BASE_URL, 'configurations.json'].join '/'
      users:
        resourceUrl: [AUTH_BASE_URL, 'users', ':id.json'].join '/'
