class Callback < ActiveRecord::Base
  belongs_to :delayed_job, :class_name => 'Delayed::Job'

  validates_presence_of :url, :callback_at
  validates_uniqueness_of :guid, :allow_nil => true

  before_save :data_cannot_be_nil
  before_save :guid_cannot_be_blank

  def self.by_guid(guid)
    first(:conditions => {:guid => guid})
  end

private
  def data_cannot_be_nil
    write_attribute(:data, '') if data.nil?
  end

  def guid_cannot_be_blank
    write_attribute(:guid, nil) if guid && guid.strip == ''
  end

end
