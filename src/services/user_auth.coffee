angular.module 'guclinkAuthModules'
  .factory 'UserAuth', ($auth, $q, authConfigurations,
  $cookies, User) ->
    class UserService
      constructor: ->

      @property 'signedIn',
        get: ->
          $auth.isAuthenticated()

      login: (info, expiration) ->
        deferred = $q.defer()
        authConfigurations.then (config) =>
          expiration ||= config.default_token_exp
          info.expiration = expiration
          $auth.login({token: info})
            .then (response) =>
              @currentUserData = response.data.user
              $cookies.putObject 'currentUser', @currentUserData
              @currentUser = new User @currentUserData
              deferred.resolve response
            .catch (response) ->
              deferred.reject response
        .catch (response) ->
          deferred.reject response
        return deferred.promise

      signup: (data) ->
        $auth.signup data
          .then (response) =>
            @currentUserData = response.data.user
            $cookies.putObject 'currentUser', @currentUserData
            @currentUser = new User @currentUserData
            return response


      logout: ->
        @currentUser = undefined
        @currentUserData = undefined
        $cookies.remove 'currentUser'
        if @signedIn
          $auth.logout()

      getUser: ->
        if not @signedIn
          return undefined
        else if not angular.isUndefined @currentUser
          return @currentUser
        else
          @currentUser = new User $cookies.getObject 'currentUser'

      @property 'user',
        get: ->
          @getUser()

    return new UserService
