describe 'UserAuth service', ->
  beforeEach module 'guclinkAuthModules'
  instance = null
  beforeEach inject (_UserAuth_) ->
    instance = _UserAuth_

  it 'is not signed in by default', ->
    expect(instance.signedIn).to.be.false

  it 'has an undefined user if not signed in', ->
    expect(instance.user).to.be.undefined
