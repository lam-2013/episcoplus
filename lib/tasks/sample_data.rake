namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_posts
    make_relationships
    make_private_messages
    make_sermons
  end
end

def make_users
  password = "episcoplus"
  pasquale = User.create!(name: "Pasquale",
                          surname: "Lisena",
                          email: "pasq.lisena@gmail.com",
                          password: password,
                          password_confirmation: password)

  sigalini = User.create!(honorific: "Mons",
                          name: "Domenico",
                          surname: "Sigalini",
                          email: "d.sigalini@episcoplus.com",
                          password: password,
                          password_confirmation: password)

  bagnasco = User.create!(honorific: "Card",
                          name: "Angelo",
                          surname: "Bagnasco",
                          email: "a.bagnasco@episcoplus.com",
                          password: password,
                          password_confirmation: password)

  gallo = User.create!(honorific: "Don",
                       name: "Andrea",
                       surname: "Gallo",
                       email: "a.gallo@episcoplus.com",
                       password: password,
                       password_confirmation: password)

  99.times do |n|
    honorific = "Don"
    name = Faker::Name.first_name
    surname = Faker::Name.last_name
    # take users from the Rails Tutorial book since most of them have a "real" profile pic
    email = "example-#{n+1}@railstutorial.org"
    User.create!(honorific: honorific,
                 name: name,
                 surname: surname,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_posts
  # generate 50 fake posts for the first 10 users
  users = User.all(limit: 10)
  50.times do
    post_content = Faker::Lorem.sentence(8)
    users.each { |user| user.posts.create!(content: post_content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  # first user follows user 3 up to 51
  followed_users.each { |followed| user.follow!(followed) }
  # users 4 up to 41 follow back the first user
  followers.each { |follower| follower.follow!(user) }
end

def make_private_messages
  # generate 10 fake messages for the first user
  first_user = User.first
  users = User.all
  message_from_users = users[3..12]
  message_from_users.each do |user|
    msg_body = Faker::Lorem.sentence(8)
    msg_subject = Faker::Lorem.sentence(3)
    message = Message.new
    message.sender = user
    message.recipient = first_user
    message.subject = msg_subject
    message.body = msg_body
    message.save!
  end
end

def make_sermons
  # generate 50 fake sermons for the first 10 users
  users = User.all(limit: 10)
  50.times do
    sermon_title = Faker::Lorem.sentence(8)
    sermon_content = Faker::Lorem.sentence(80)
    users.each { |user| user.sermons.create!(title: sermon_title, content: sermon_content) }
  end
end

