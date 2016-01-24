class Movie < BaseModel
  include Ohm::Timestamps
  include GlobalID::Identification
  extend GlobalIdFriendlyFinder

  attribute :title
  attribute :date
  attribute :description

  reference :user, :User

  attribute :liker_count
  attribute :hater_count

  set :likers, :User
  set :haters, :User
end

