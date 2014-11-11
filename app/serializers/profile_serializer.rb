class ProfileSerializer < UserSerializer
  attributes :friends, :cover_photo_url

  has_many :friends, serializer: UserSerializer
end
