require "rspec"
require "lyricli"

describe Lyricli::Util do
  before :each do
    class TestClass
      include Lyricli::Util
    end

    module Lyricli
      module Sources
        class ParsedClass
        end
      end
    end

    @c = TestClass.new
  end

  describe "#camelize" do
    it "should convert snake_case to CamelCase" do
      expect(@c.camelize("test_string")).to eq("TestString")
    end
  end

  describe "#parse_class" do
    it "should parse classes under the Source namespace" do
      expect(@c.parse_class("ParsedClass")).to eq(Lyricli::Sources::ParsedClass)
    end

    it "should return nil for nonexistent classes" do
      expect(@c.parse_class("non_existent_class")).to eq(nil)
    end
  end

  describe "#sanitize_param" do
    it "should escape weird characters, but conserve the +" do
      str = "one two+three /?&"
      expect(@c.sanitize_param(str)).to eq("one+two+three+%2F%3F%26")
    end
  end
end
