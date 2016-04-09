describe 'UserAuth service', ->
  beforeEach module 'guclinkAuthModules'
  instance = null
  $httpBackend = null
  $rootScope = null
  beforeEach inject (_UserAuth_, _$httpBackend_, _$rootScope_) ->
    instance = _UserAuth_
    $httpBackend = _$httpBackend_
    $rootScope = _$rootScope_

  it 'is not signed in by default', ->
    expect(instance.signedIn).to.be.false

  it 'has an undefined user if not signed in', ->
    expect(instance.user).to.be.undefined

  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30
      })

  it 'sends a proper login request', (done)->
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
    promise = instance.login {email: 'haha@guc.edu.eg', password: 'password'}, 24
    $httpBackend.flush()
    promise.then (response) ->
      expect(instance.signedIn).to.be.true
    .catch (e) ->
      expect(true).to.be.false
    .finally ->
      done()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sends proper signup request', ->
    $httpBackend.expect('POST', 'http://localhost:3000/api/users.json')
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
        })
    instance.signup {email: 'ss'}
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
