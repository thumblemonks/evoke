require 'factory_girl'

# Model stuff

# Factory.sequence :name do |n|
#   "Foo-#{n} Bar-#{n}"
# end

# Factory.sequence :email do |n|
#   "foo#{n}@bar.baz"
# end

# Factory.define :person do |person|
#   person.name { Factory.next(:name) }
#   person.email { Factory.next(:email) }
# end

Factory.define :callback do |callback|
  callback.url 'http://foo.bar/person/1/events/2'
  callback.data 'key=12345'
  callback.callback_at Time.now + 86400
  callback.called_back false
end
