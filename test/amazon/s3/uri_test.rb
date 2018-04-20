require "test_helper"

class Amazon::S3::UriTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Amazon::S3::Uri::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
