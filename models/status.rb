require 'drb'
require 'god'

class Status
  def recent_callbacks; Callback.recent; end
  def total_callback_count; Callback.count; end
  def jobs_in_queue_count; Delayed::Job.count; end
  def pending_callback_count; Callback.pending.count; end

  def consumer_running?
    DRb.start_service("druby://127.0.0.1:0")
    server = DRbObject.new(nil, God::Socket.socket(17165))

    server.status["evoke_consumer"][:state]
  rescue DRb::DRbConnError
    false
  ensure
    DRb.stop_service
  end
end
