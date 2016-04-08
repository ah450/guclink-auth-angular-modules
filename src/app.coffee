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
