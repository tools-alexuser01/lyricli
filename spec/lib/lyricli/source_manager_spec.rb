require "rspec"
require "lyricli"

describe Lyricli::SourceManager do
  before :each do
    # Stub the configuration
    @example_configuration = {"enabled_sources" => "test_class"}
    Configuration.stub(:'[]').and_return(@example_configuration)
    Configuration.stub(:delete)

    # Stub the test class.
    module Lyricli
      module Sources
        module TestClass
        end
      end
    end

    @example_artist = {:artist => "The Shins", :song => "Know Your Onion"}

    Lyricli::Sources::TestClass.stub(:enable)
    Lyricli::Sources::TestClass.stub(:reset)
    Lyricli::Sources::TestClass.stub(:current_track).and_return(@example_artist)
  end
end
