#encoding: utf-8

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
  #pasquale = User.create!(name: "Pasquale",
  #                        surname: "Lisena",
  #                        email: "pasq.lisena@gmail.com",
  #                        diocese: "Molfetta",
  #                        study: "Politecnico di Torino",
  #                        role: "Developer",
  #                        place_for_role: "episco+",
  #                        password: password,
  #                        password_confirmation: password)

  #mariella = User.create!(name: "Mariella",
  #                        surname: "Sabatino",
  #                        email: "mll.sabatino@gmail.com",
  #                        diocese: "Novara",
  #                        study: "Politecnico di Torino",
  #                        role: "Developer",
  #                        place_for_role: "episco+",
  #                        password: password,
  #                        password_confirmation: password)

  bergoglio = User.create!(honorific: "Papa",
                           name: "Francesco",
                           surname: "Bergoglio",
                           diocese: "Roma",
                           study: "Seminario di Villa Devoto",
                           role: "Sommo Pontefice",
                           placeForRole: "Chiesa Cattolica",
                           email: "mll.sabatino@gmail.com",
                           password: password,
                           password_confirmation: password)

  sigalini = User.create!(honorific: "Mons",
                          name: "Domenico",
                          surname: "Sigalini",
                          diocese: "Palestrina",
                          study: "Seminario di Brescia",
                          role: "Assistente Generale",
                          placeForRole: "Azione Cattolica",
                          email: "pasq.lisena@gmail.com",
                          password: password,
                          password_confirmation: password)

  bagnasco = User.create!(honorific: "Card",
                          name: "Angelo",
                          surname: "Bagnasco",
                          diocese: "Genova",
                          study: "Seminario Arcivescovile di Genova",
                          role: "Presidente",
                          placeForRole: "Chiesa Cattolica",
                          email: "pasqlisena@gmail.com",
                          password: password,
                          password_confirmation: password)

  gallo = User.create!(honorific: "Don",
                       name: "Andrea",
                       surname: "Gallo",
                       diocese: "Genova",
                       study: "Seminario Arcivescovile di Genova",
                       role: "Animatore",
                       placeForRole: "Comunità di San Benedetto ",
                       email: "pasquale.lisena@studenti.polito.it",
                       password: password,
                       password_confirmation: password)

  piccinonna = User.create!(honorific: "Don",
                            name: "Vito",
                            surname: "Piccinonna",
                            email: "pasqlisena@gmail.com",
                            birth: "1977-06-01",
                            diocese: "Bari",
                            study: "Seminario Regionale Pugliese",
                            role: "Animatore",
                            placeForRole: "Azione Cattolica",
                            email: "s193624@studenti.polito.it",
                            password: password,
                            password_confirmation: password)

  tempesta = User.create!(honorific: "Don",
                          name: "Nico",
                          surname: "Tempesta",
                          diocese: "Molfetta",
                          study: "Seminario Regionale Pugliese",
                          role: "Direttore",
                          placeForRole: "Ufficio Pastorale Giovanile ",
                          email: "s164400@studenti.polito.it",
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
                 diocese: "Genova",
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
    users.each { |user|
      post = user.posts.create!(content: post_content)
      post.create_feed_item(user_id: user.id)
      users.each { |like_user|
        like = post.like!(like_user)
        like.create_feed_item(user_id: like_user.id)
      }
    }
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

  sermon1 = users.first.sermons.create!(title: 'Video omelia', content: 'Descrizione del video', tag_list: 'video',
                                        multimedia: 'v', multimedia_url: 'https://dl.dropboxusercontent.com/u/61675014/omelie_video.mp4')
  sermon2 =users.first.sermons.create!(title: 'Audio omelia', content: 'Descrizione del audio', tag_list: 'audio',
                                       multimedia: 'a', multimedia_url: 'https://dl.dropboxusercontent.com/u/61675014/omelia_audio_mp3.mp3')

  sermon1.create_feed_item(user_id: users.first.id)
  sermon2.create_feed_item(user_id: users.first.id)

  50.times do
    sermon_title = Faker::Lorem.sentence(8)
    sermon_content = Faker::Lorem.sentence(80)
    tags = "parola, dio, amore, famiglia, carità"
    users.each { |user|
      sermon = user.sermons.create!(title: sermon_title, content: sermon_content, tag_list: tags)
      sermon.create_feed_item(user_id: user.id)
      users.each { |like_user|
        like = sermon.like!(like_user)
        like.create_feed_item(user_id: like_user.id)
      }
    }
  end
end

