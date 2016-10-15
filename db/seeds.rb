# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

User.destroy_all
Proverb.destroy_all
Tag.destroy_all
Tagging.destroy_all

user = User.create({
  email: Faker::Internet.email,
  fb_id: Faker::Number.number(11),
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name
  })


  tags = [
          "caution",
          "unity",
          "togetherness",
          "teamwork",
          "procrastination",
          "urgency",
          "past",
          "forgive",
          "look to the future",
          "be positive",
          "wish others well",
          "payback",
          "love",
          "name",
          "peace"
        ]

proverbs = [
  {body: "Unity is strength", locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Gidi gidi bụ ugwu eze.",locale: "ib", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},


  {body: "Make hay while the sun shines",locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Chọọ ewu ojii ka chi dị",locale: "ib", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},


  {body: "Fools rush in where angels fear to tread.",locale: "en", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Ihe ehi hụrụ gbalaba oso ka okuku huru na-atụ onu",locale: "ib", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},


  {body: "Be forward-looking; let go of the past",locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Ibi tí à ńlọ là ńwò, a kìí wo ibi tí a ti ṣubú",locale: "yb", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},

  {body: "Be positive; live and let live.",locale: "en", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Tí ẹyẹ ò bá fín ẹyẹ níràn, ojú ọrun tó ẹyẹ ẹ́ fò láì fara kanra. ",locale: "yb", user: user, all_tags: tags[1..rand(tags.length)]},

  {body: "Keep hope alive; don't give up.",locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Adániwáyè ò gbàgbé ẹnìkan; àìmàsìkò ló ńdààmú ẹ̀dá.",locale: "yb", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},

  {body: "One good turn deserves another.",locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]},
  {body: "Ẹni tó bá da omi síwájú á tẹ'lẹ tútù.",locale: "yb", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]}
]

proverbs.in_groups_of(2, false) do |grp|
  Proverb.create(grp.last.merge(root: Proverb.create(grp.first)))
end

root = Proverb.create({body: "A dead person shall have all the sleep necessary.", locale: "en", status: "approved", user: user, all_tags: tags[1..rand(tags.length)]})
Proverb.create({body: "Ura ga-eju onye nwuru anwu afo", locale: "ib", user: user, root: root, all_tags: tags[1..rand(tags.length)]})
Proverb.create({body: "eni to ku, o ma sun dada", locale: "yb", user: user, root: root, all_tags: tags[1..rand(tags.length)]})

puts "#{Proverb.count} proverbs created"
puts "#{Tag.count} tags created"
