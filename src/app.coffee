angular.module 'guclinkAuthModules', ['guclinkConstants']
angular.module 'guclinkAuthModules'
  .config ($compileProvider) ->
    $compileProvider.debugInfoEnabled false
