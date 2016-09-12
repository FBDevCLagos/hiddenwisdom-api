# This file should contain all the record creation needed to seed the database with its default values.
# The data can thenglish be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenglishhagenglish' }])
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
          "urgenglishcy",
          "past",
          "forgive",
          "look to the future",
          "be positive",
          "wish others well",
          "payorubaack",
          "love",
          "name",
          "peace"
        ]

proverbs = [
  {body: "Unity is strength", language: "english", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]},
  {body: "Gidi gidi bụ ugwu eze.",language: "igbo", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},


  {body: "Make hay while the sun shines",language: "english", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Chọọ ewu ojii ka chi dị",language: "igbo", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},


  {body: "Fools rush in where angels fear to tread.",language: "english", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Ihe ehi hụrụ gbalaba oso ka okuku huru na-atụ onu",language: "igbo", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},


  {body: "Be forward-looking; let go of the past",language: "english", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Ibi tí à ńlọ là ńwò, a kìí wo ibi tí a ti ṣubú",language: "yoruba", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},

  {body: "Be positive; live and let live.",language: "english", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Tí ẹyẹ ò bá fín ẹyẹ níràn, ojú ọrun tó ẹyẹ ẹ́ fò láì fara kanra. ",language: "yoruba", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},

  {body: "Keep hope alive; don't give up.",language: "english", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Adániwáyè ò gbàgbé ẹnìkan; àìmàsìkò ló ńdààmú ẹ̀dá.",language: "yoruba", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},

  {body: "One good turn deserves another.",language: "english", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}},
  {body: "Ẹni tó bá da omi síwájú á tẹ'lẹ tútù.",language: "yoruba", status: "approved", user: user, all_tags: all_tags[rand(all_tags.length - 1)]}}
]

proverbs.in_groups_of(2, false) do |grp|
  Proverb.create(grp.last.merge(root: Proverb.create(grp.first)))
end

root = Proverb.create({body: "A dead person shall have all the sleep necessary.", language: "english", status: "approved", user: user})
Proverb.create({body: "Ura ga-eju onye nwuru anwu afo", language: "igbo", user: user, root: root})
Proverb.create({body: "englishi to ku, o ma sun dada", language: "yoruba", user: user, root: root})
