namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    # Create a administrator user
    admin = User.create!( name: "akiya",
                          email: "akiya@aqua-lia.com",
                          password: "fffjjj",
                          password_confirmation: "fffjjj",
                          admin: true )

    # User.create!(name: "Example User",
    #              email: "example@railstutorial.jp",
    #              password: "foobar",
    #              password_confirmation: "foobar")

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
end
