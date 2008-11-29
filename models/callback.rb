class Callback < ActiveRecord::Base
  validates_presence_of :url, :callback_at

  def called_back!
    update_attributes!(:called_back => true)
  end

  def after_create
    Delayed::Job.enqueue(self, 0, self.callback_at)
  end

  def perform
    $stdout.puts "Who's your daddy?!"
  end
end
