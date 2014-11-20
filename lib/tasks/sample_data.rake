namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
    # Create a administrator user
    admin = User.create!( name: "akiya",
                          email: "akiya@aqua-lia.com",
                          password: "fffjjj",
                          password_confirmation: "fffjjj",
                          admin: true )

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
end

def make_microposts
    # users = User.all( limit: 6 )
    users = User.limit( 6 )
    50.times do
      content = Faker::Lorem.sentence( 5 )
      users.each { |user| user.microposts.create!( content: content ) }
    end
end

def make_relationships
  user = User.all
  user = users.first
  followed_user = user[2..50]
  followed_users.each { |followed| user.follow!( followed ) }
  followers.each { |follower| follower.follow!( user ) }
end
