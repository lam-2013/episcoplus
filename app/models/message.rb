class Message < ActiveRecord::Base


  is_private_message


  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  #attr_accessor :to

  # get user's posts plus all the posts written by her followed users
  # def self.allMailbox(user)
  #  all_messages_id = 'SELECT id FROM messages WHERE (recipient_id = :user_id OR sender_id = :user_id)'
  # where("id IN (#{all_messages_id})", user_id: user.id)
  #end

end