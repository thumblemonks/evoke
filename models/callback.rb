class Callback < ActiveRecord::Base
  validates_presence_of :url, :callback_at
  validates_uniqueness_of :guid, :allow_nil => true

  def self.by_guid(guid)
    first(:conditions => {:guid => guid})
  end

  def called_back!
    update_attributes!(:called_back => true)
  end

  def after_create
    Delayed::Job.enqueue(self, 0, self.callback_at)
  end

  def perform
    http_method = (method || 'get')
    request_args = [url, data].compact
    RestClient.send(http_method, *request_args)
    called_back!
  rescue RestClient::Exception => e
    update_attributes!(:error_message => e.message)
  end

end
