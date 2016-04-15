describe 'logout directive', ->
  beforeEach module 'guclinkAuthModules'
  userAuth = null
  $httpBackend = null
  $rootScope = null
  $compile = null
  beforeEach inject (_UserAuth_, _$httpBackend_, _$rootScope_, _$compile_) ->
    userAuth = _UserAuth_
    $httpBackend = _$httpBackend_
    $rootScope = _$rootScope_
    $compile = _$compile_

  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30
      })
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond(201, {
        user:
          id: 24
          name: 'test user'
          email: 'test.user@guc.edu.eg'
          verified: true
          student: false
          super_user: false
          full_name: 'Test User'
          created_at: '2016-04-08T20:06:45.391Z'
          updated_at: '2016-04-08T20:06:45.391Z'
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE0NjAyMDAyMzAsImV4cCI6MTQ5MTczNjIzMCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSIsIkdpdmVuTmFtZSI6IkpvaG5ueSIsIlN1cm5hbWUiOiJSb2NrZXQiLCJFbWFpbCI6Impyb2NrZXRAZXhhbXBsZS5jb20iLCJSb2xlIjpbIk1hbmFnZXIiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.Q82UHJ8ep8EUYLKBdwpiTa9S4j5lSxHFrTP3uePnln8'
        })
  beforeEach ->
    promise = userAuth.login({email: 'haha@guc.edu.eg', password: 'password'},
      24)
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'logs out on click', ->
    expect(userAuth.signedIn).to.be.true
    element = angular.element("<button data-logout></button>")
    compiled = $compile(element)($rootScope)
    compiled.click()
    expect(userAuth.signedIn).to.be.false
