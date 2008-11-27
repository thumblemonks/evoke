class Callback < ActiveRecord::Base
  validates_presence_of :url, :callback_at

  def called_back!
    update_attributes!(:called_back => true)
  end
end
