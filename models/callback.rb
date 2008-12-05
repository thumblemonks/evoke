class Callback < ActiveRecord::Base
  belongs_to :delayed_job, :class_name => 'Delayed::Job'

  validates_presence_of :url, :callback_at
  validates_uniqueness_of :guid, :allow_nil => true

  before_save :data_cannot_be_nil
  before_save :guid_cannot_be_blank

  def self.by_guid(guid)
    first(:conditions => {:guid => guid})
  end

  def called_back!
    update_attributes!(:called_back => true)
  end

  def perform
    http_method = (method || 'get').to_s
    request_args = [url]
    request_args << data if requires_payload?
    RestClient.send(http_method, *request_args)
    called_back!
  rescue RestClient::Exception => e
    update_attributes!(:error_message => e.message)
  end

private
  def data_cannot_be_nil
    write_attribute(:data, '') if data.nil?
  end

  def guid_cannot_be_blank
    write_attribute(:guid, nil) if guid && guid.strip == ''
  end

  def requires_payload?
    %w[post put].include?(method)
  end

end
