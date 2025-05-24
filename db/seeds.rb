# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Clearing existing data..."
Message.destroy_all
Chatroom.destroy_all
User.destroy_all

puts "Creating users..."
user1 = User.create!(username: 'testuserone', password: '123', password_confirmation: '123')
user2 = User.create!(username: 'testusertwo', password: '123', password_confirmation: '123')
user3 = User.create!(username: 'testuserthree', password: '123', password_confirmation: '123')

puts "Creating chatrooms..."
general_chatroom = Chatroom.create!(name: 'General Chatroom')
dev_talk = Chatroom.create!(name: 'Dev Talk')

puts "Creating messages..."
Message.create!(chatroom: general_chatroom,content: 'Hello everyone in general chat!', user: user1)
sleep(1)
Message.create!(chatroom: general_chatroom, content: 'Hi number 1', user: user2)
sleep(1)
Message.create!(chatroom: general_chatroom, content: 'yo yo', user: user3)
sleep(1)

Message.create!(chatroom: dev_talk, content: 'Hello everyone in dev talk!', user: user1)
sleep(1)
Message.create!(chatroom: dev_talk, content: 'Rails is so cool!', user: user2)
sleep(1)
Message.create!(chatroom: dev_talk, content: 'Laravel better', user: user3)

puts "Seeding Done!"