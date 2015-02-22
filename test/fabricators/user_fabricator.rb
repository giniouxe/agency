Fabricator(:user) do
  name { 'Charlie' }
  email { 'charlie@example.com' }
  password_digest { User.digest('croquettes') }
end
