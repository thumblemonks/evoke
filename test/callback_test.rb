require File.join(File.dirname(__FILE__), 'test_helper')

class CallbackTest < Test::Unit::TestCase
  should_require_attributes :url, :callback_at
  should_have_db_column :data
  should_have_db_column :called_back

  def setup; @callback = Factory(:callback); end

  context "called back!" do
    setup { @callback.called_back! }
    should("return true for called back?") { assert @callback.called_back? }
  end
end
