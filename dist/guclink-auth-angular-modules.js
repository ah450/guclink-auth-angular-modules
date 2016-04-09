(function() {
  angular.module('guclinkAuthModules', ['guclinkConstants', 'ngCookies', 'ngResource', 'satellizer', 'angulartics', 'angulartics.google.analytics']);

  angular.module('guclinkAuthModules').config(function($compileProvider) {
    return $compileProvider.debugInfoEnabled(false);
  });

  angular.module('guclinkAuthModules').config(function($cookiesProvider) {
    return $cookiesProvider.defaults = {
      path: '/',
      domain: 'guclink.in',
      secure: true
    };
  });

  angular.module('guclinkAuthModules').config(function($authProvider, AUTH_BASE_URL) {
    $authProvider.httpInterceptor = true;
    $authProvider.loginOnSignup = true;
    $authProvider.baseUrl = AUTH_BASE_URL;
    $authProvider.signupUrl = 'users.json';
    return $authProvider.loginUrl = 'tokens.json';
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('authConfigurations', function(AuthEndpoints, $http) {
    return $http.get(AuthEndpoints.configurations.index, {
      cache: true
    }).then(function(response) {
      return response.data;
    });
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('AuthEndpoints', function(AUTH_BASE_URL) {
    var endpoints;
    return endpoints = {
      configurations: {
        index: [AUTH_BASE_URL, 'configurations.json'].join('/')
      },
      users: {
        resourceUrl: [AUTH_BASE_URL, 'users', ':id.json'].join('/')
      }
    };
  });

}).call(this);

(function() {
  var slice = [].slice;

  angular.module('guclinkAuthModules').factory('User', function(UsersResource, moment) {
    var User;
    return User = (function() {
      function User(data, deletedCallEback) {
        this.deletedCallEback = deletedCallEback != null ? deletedCallEback : angular.noop;
        this.resource = new UsersResource(data);
        _.assign(this, this.resource);
      }

      User.prototype.reload = function() {
        return UsersResource.get({
          id: this.resource.id
        }).$promise.then((function(_this) {
          return function(resource) {
            _this.resource = resource;
            return _this;
          };
        })(this));
      };

      User.prototype.$update = function() {
        var args, ref;
        args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return (ref = this.resource).$update.apply(ref, args);
      };

      User.prototype.$delete = function() {
        var args, ref;
        args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return (ref = this.resource).$delete.apply(ref, args).then((function(_this) {
          return function(response) {
            _this.deletedCallback(_this);
            return response;
          };
        })(this));
      };

      User.property('verified', {
        get: function() {
          return this.resource.verified;
        },
        set: function(value) {
          return this.resource.verified = value;
        }
      });

      User.property('id', {
        get: function() {
          return this.resource.id;
        }
      });

      User.property('student', {
        get: function() {
          return this.resource.student;
        }
      });

      User.property('admin', {
        get: function() {
          return this.resource.super_user;
        },
        set: function(value) {
          return this.resource.super_user = value;
        }
      });

      User.property('teacher', {
        get: function() {
          return !this.resource.student;
        }
      });

      User.property('name', {
        get: function() {
          return this.resource.name;
        },
        set: function(value) {
          return this.resource.name = value;
        }
      });

      User.property('full_name', {
        get: function() {
          return this.resource.full_name;
        }
      });

      User.property('created_at', {
        get: function() {
          return moment(this.resource.created_at).format("MMMM Do YYYY, h:mm:ss a");
        }
      });

      User.property('email', {
        get: function() {
          return this.resource.email;
        }
      });

      User.property('password', {
        get: function() {
          return this.resource.password;
        },
        set: function(value) {
          return this.resource.password = value;
        }
      });

      return User;

    })();
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('redirect', function() {
    var Redirect;
    Redirect = (function() {
      function Redirect(history) {
        this.history = history != null ? history : [];
      }

      Redirect.prototype.push = function(data) {
        return this.history.push(data);
      };

      Redirect.prototype.pop = function() {
        return this.history.pop();
      };

      Redirect.property('empty', {
        get: function() {
          return this.history.length === 0;
        }
      });

      return Redirect;

    })();
    return new Redirect;
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('UserAuth', function($auth, $q, authConfigurations, $cookies, User) {
    var UserService;
    UserService = (function() {
      function UserService() {}

      UserService.property('signedIn', {
        get: function() {
          return $auth.isAuthenticated();
        }
      });

      UserService.prototype.login = function(info, expiration) {
        var deferred;
        deferred = $q.defer();
        authConfigurations.then((function(_this) {
          return function(config) {
            expiration || (expiration = config.default_token_exp);
            info.expiration = expiration;
            return $auth.login({
              token: info
            }).then(function(response) {
              _this.currentUserData = response.data.user;
              $cookies.putObject('currentUser', _this.currentUserData);
              _this.currentUser = new User(_this.currentUserData);
              return deferred.resolve(response);
            })["catch"](function(response) {
              return deferred.reject(response);
            });
          };
        })(this))["catch"](function(response) {
          return deferred.reject(response);
        });
        return deferred.promise;
      };

      UserService.prototype.signup = function(data) {
        return $auth.signup(data).then((function(_this) {
          return function(response) {
            _this.currentUserData = response.data.user;
            $cookies.putObject('currentUser', _this.currentUserData);
            _this.currentUser = new User(_this.currentUserData);
            return response;
          };
        })(this));
      };

      UserService.prototype.logout = function() {
        this.currentUser = void 0;
        this.currentUserData = void 0;
        $cookies.remove('currentUser');
        if (this.signedIn) {
          return $auth.logout();
        }
      };

      UserService.prototype.getUser = function() {
        if (!this.signedIn) {
          return void 0;
        } else if (!angular.isUndefined(this.currentUser)) {
          return this.currentUser;
        } else {
          return this.currentUser = new User($cookies.getObject('currentUser'));
        }
      };

      UserService.property('user', {
        get: function() {
          return this.getUser();
        }
      });

      return UserService;

    })();
    return new UserService;
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('UsersResource', function($resource, AuthEndpoints) {
    var usersResourceActions, usersResourceDefaultParams;
    usersResourceDefaultParams = {
      id: '@id'
    };
    usersResourceActions = {
      query: {
        method: 'GET',
        isArray: false,
        cache: true
      },
      update: {
        method: 'PUT',
        isArray: false,
        cache: false
      },
      create: {
        method: 'POST',
        isArray: false,
        cache: false
      },
      "delete": {
        method: 'DELETE',
        isArray: false,
        cache: false
      }
    };
    return $resource(AuthEndpoints.users.resourceUrl, usersResourceDefaultParams, usersResourceActions);
  });

}).call(this);

(function() {
  angular.module('guclinkAuthModules').factory('moment', function() {
    return moment;
  });

}).call(this);
