require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_validate_presence_of :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back
  should_have_db_column :http_method
  should_have_db_column :error_message
  should_belong_to :delayed_job
  should_allow_values_for :guid, nil

  context "before save" do
    setup do
      @callback = Factory(:callback, :data => nil, :guid => '  ')
    end
    
    should "set nil data to empty string" do
      assert_equal '', @callback.data
    end

    should "turn blank guid into nil" do
      assert_nil @callback.guid
    end
  end

  context "by guid" do
    setup do
      @callback = Factory(:callback, :guid => 'luscious-jackson')
    end

    should_validate_uniqueness_of :guid

    should "return a single callback if guid is exists" do
      assert_equal @callback, Callback.by_guid('luscious-jackson')
    end

    should "return nil if guid does not exist" do
      assert_nil Callback.by_guid('with-my-naked-eye-i-saw')
    end
  end

  context "should have been called back" do
    should "return true if callback at is in the past" do
      @callback = Factory(:callback, :callback_at => Time.now - 1.day)
      assert @callback.should_have_been_called_back?
    end

    should "return false if callback at is in the future" do
      @callback = Factory(:callback, :callback_at => Time.now + 1.day)
      deny @callback.should_have_been_called_back?
    end
  end

  context "recent callbacks" do
    setup do
      @callbacks = (0...20).map {|i| Factory(:callback, :callback_at => i.days.ago)}
    end
    
    should "return most recent 10 callbacks" do
      assert_equal @callbacks[0...10], Callback.recent
    end
  end

  context "pending callbacks" do
    setup do
      @callbacks = (0...20).map do |i|
        Factory(:callback, :callback_at => i.days.ago, :called_back => (i % 2 == 0))
      end
    end
    
    should "return those not called back" do
      assert_equal 10, Callback.pending.count
    end
  end

  context "http_method" do
    should "return get if nil" do
      assert_equal 'get', Factory(:callback).http_method
    end

    should "return whatever it was provided if not nil" do
      assert_equal 'bologna', Factory(:callback, :http_method => 'bologna').http_method
    end
  end

  context "destroying a callback" do
    setup do
      callback = Factory(:callback)
      CallbackRunner.make_job_from_callback!(callback)
      callback.reload
      @job = callback.delayed_job
      callback.destroy
    end

    should "delete the job tied to the callback" do
      assert_nil Delayed::Job.find_by_id(@job.id)
    end
  end
end
