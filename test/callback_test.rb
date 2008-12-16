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

end
