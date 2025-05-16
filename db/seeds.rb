Category.create!([
  { name: "Music" },
  { name: "Sports" },
  { name: "Tech" },
  { name: "Health" },
  { name: "Education" },
  { name: "Art" },
  { name: "Business" }
])
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?