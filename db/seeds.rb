User.create!(name: 'Admin User', email: 'admin@example.com',
             password: 'foobar', password_confirmation: 'foobar', admin: true,
             activated: true, activated_at: Time.zone.now)

User.create!(name: 'Simple User', email: 'user@example.com',
             password: 'foobar', password_confirmation: 'foobar',
             activated: true, activated_at: Time.zone.now)

3.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@example.com"
  password = 'password'
  User.create!(name: name, email: email, password: password,
               password_confirmation: password, activated: true,
               activated_at: Time.zone.now)
end

users = User.all

20.times do
  title = Faker::Lorem.sentence
  excerpt = Faker::Lorem.paragraph
  content = Faker::Lorem.paragraphs(5).join(' ')
  tag_list = %w(Foo Bar Fizz Buzz).sample(2).join(', ')
  picture = File.open(Rails.root + "public/uploads/article/picture/#{%w(light coffee wire working writing).sample}.jpg")
  created_at = rand(2.years).seconds.ago
  users.each do |user|
    user.articles.create!(title: title, excerpt: excerpt, content: content,
                          picture: picture, tag_list: tag_list,
                          created_at: created_at)
  end
end

articles = Article.all

5.times do
  author = Faker::Name.name
  body = Faker::Lorem.paragraph
  articles.each do |article|
    article.comments.create!(author: author, body: body)
  end
end
