class CallbackRunner

  def self.make_job_from_callback!(callback)
    runner = CallbackRunner.new(callback)
    job = Delayed::Job.enqueue(runner, 0, callback.callback_at)
    callback.update_attributes!(:delayed_job => job)
  end

  def self.replace_job_for_callback!(callback)
    callback.delayed_job.destroy if callback.delayed_job
    make_job_from_callback!(callback)
  end

  def initialize(callback)
    raise(ArgumentError, "Callback cannot be nil") unless callback
    @callback = callback
  end

  def perform
    @callback.reload
    http_method = (@callback.method || 'get').to_s
    request_args = [@callback.url]
    request_args << @callback.data if requires_payload?(http_method)
    RestClient.send(http_method, *request_args)
    @callback.update_attributes!(:called_back => true)
  rescue RestClient::Exception => e
    @callback.update_attributes!(:error_message => e.message)
  end

private

  def requires_payload?(method)
    %w[post put].include?(method)
  end

end
