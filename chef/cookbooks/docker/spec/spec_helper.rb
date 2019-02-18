require 'chefspec'
require 'chefspec/berkshelf'

class RSpecHelper
  class<<self
    attr_accessor :current_example
  end
  def self.reset!
    @current_example = nil
  end
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before :each do
    RSpecHelper.reset!
    RSpecHelper.current_example = self
  end
end
