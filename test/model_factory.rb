require 'factory_girl'

Factory.define(:delayed_job, :class => Delayed::Job) do |job|
  job.payload_object {{:foo => 'bar'}.to_yaml}
  job.priority 0
  job.run_at Time.now + 3600
end

Factory.sequence :guid do |n|
  "foo-#{n}-bar-#{n}"
end

Factory.define :callback do |callback|
  callback.url 'http://foo.bar/person/1/events/2'
  callback.data 'key=12345'
  callback.callback_at Time.now + 86400
  callback.called_back false
end

Factory.define :callback_with_job, :class => Callback do |callback|
  callback.url 'http://foo.bar/person/3/events/5'
  callback.data 'key=lulu'
  callback.callback_at Time.now + 3600
  callback.called_back false
  callback.association :delayed_job
end
