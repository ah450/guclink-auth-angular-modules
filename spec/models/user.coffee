
describe 'User Model', ->
  beforeEach module 'guclinkAuthModules'
  @userClass = null
  beforeEach inject (_User_) =>
    @userClass = _User_
  @sampleData =
    id: 24
    name: 'test user'
    email: 'test.user@guc.edu.eg'
    verified: true
    student: false
    super_user: false
    full_name: 'Test User'
    created_at: '2016-04-08T20:06:45.391Z'
    updated_at: '2016-04-08T20:06:45.391Z'

  beforeEach =>
    @sampleUser = new @userClass @sampleData

  it 'is verified', =>
    expect(@sampleUser.verified).to.be.true

  it 'is not a student', =>
    expect(@sampleUser.student).to.be.false

  it 'is a teacher', =>
    expect(@sampleUser.teacher).to.be.true

  it 'is not an admin', =>
    expect(@sampleUser.admin).to.be.false
