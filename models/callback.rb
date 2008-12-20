class Callback < ActiveRecord::Base
  belongs_to :delayed_job, :class_name => 'Delayed::Job'

  validates_presence_of :url, :callback_at
  validates_uniqueness_of :guid, :allow_nil => true

  before_save :data_cannot_be_nil
  before_save :guid_cannot_be_blank

  named_scope :recent, :order => 'created_at desc', :limit => 10
  named_scope :pending, :conditions => {:called_back => false}

  def self.by_guid(guid)
    first(:conditions => {:guid => guid})
  end

  def should_have_been_called_back?
    callback_at < Time.now
  end

private
  def data_cannot_be_nil
    write_attribute(:data, '') if data.nil?
  end

  def guid_cannot_be_blank
    write_attribute(:guid, nil) if guid && guid.strip == ''
  end
end
