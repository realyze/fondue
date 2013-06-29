mongoose = require("mongoose")
Schema = mongoose.Schema

userSchema = new Schema(
  googleId:
    type: String
    unique: true

  displayName:
    type: String
    unique: true
    required: true

  name:
    givenName: String
    familyName: String

  email:
    type: String
    required: true

  funds: [String]
)

userSchema.statics.findOrCreate = (profile, done) ->
  @findOne googleId: profile.id, (err, user) ->
    if err or user then return done err, user
    user =
      googleId: profile.id
      displayName: profile.displayName
      name:
        givenName: profile.name.givenName
        familyName: profile.name.familyName

      email: profile.emails[0].value
      ptApiToken: null

    User.create user, done

exports.User = User = mongoose.model 'User', userSchema
