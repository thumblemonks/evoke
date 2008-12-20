require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_require_attributes :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back
  should_have_db_column :method
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

    should_require_unique_attributes :guid

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

end
