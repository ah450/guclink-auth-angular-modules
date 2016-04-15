angular.module 'guclinkAuthModules'
  .directive 'logout', (UserAuth) ->
    directive =
      restrict: 'A'
      link: ($scope, element) ->
        element.click ->
          UserAuth.logout()
          $scope.$apply()
