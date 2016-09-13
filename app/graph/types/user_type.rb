UserTypeEnum = GraphQL::EnumType.define do
  name "UserType"
  description "User types"

  value "regular", "default user type"
  value "moderator", "can approved proverbs"
  value "admin", "super user"
end

UserType = GraphQL::ObjectType.define do
  name "User"
  description "A user"

  field :id, types.ID, "User Id"
  field :email, types.String, "User email"
  field :first_name, types.String, "User first name"
  field :last_name, types.String, "User last name"
  field :fb_id, types.String, "User Facebook id"
  field :created_at, types.String, "Date user was created"
  field :updated_at, types.String, "Date user information was last updated"
  field :user_type, UserTypeEnum
  field :proverbs do
    type types[ProverbType]
    resolve -> (obj, args, ctx){
      obj.proverbs
    }
  end
end
