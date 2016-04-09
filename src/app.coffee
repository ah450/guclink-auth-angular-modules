angular.module 'guclinkAuthModules', ['guclinkConstants', 'ngCookies',
  'ngResource', 'satellizer', 'angulartics', 'angulartics.google.analytics']
angular.module 'guclinkAuthModules'
  .config ($compileProvider) ->
    $compileProvider.debugInfoEnabled false
angular.module 'guclinkAuthModules'
  .config ($cookiesProvider) ->
    $cookiesProvider.defaults =
      path: '/'
      domain: 'guclink.in'
      secure: true
angular.module 'guclinkAuthModules'
  .config ($authProvider, AUTH_BASE_URL) ->
    $authProvider.httpInterceptor = true
    $authProvider.loginOnSignup = true
    $authProvider.baseUrl = AUTH_BASE_URL
    $authProvider.signupUrl = 'users.json'
    $authProvider.loginUrl = 'tokens.json'
