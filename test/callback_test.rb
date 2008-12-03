require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_require_attributes :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back

  context "called back!" do
    setup do
      @callback = Factory(:callback)
      @callback.called_back!
    end
    should("return true for called back?") { assert @callback.called_back? }
  end

  context "after create" do
    setup do
      @callback = Factory(:callback)
    end
    
    should_change 'Delayed::Job.count', :by => 1
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
      assert_nil Callback.by_guid('wit-_my-naked-eye-i-saw')
    end
  end

end
