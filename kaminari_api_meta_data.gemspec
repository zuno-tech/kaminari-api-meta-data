# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kaminari_api_meta_data/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.3"
  spec.name = "kaminari-api-meta-data"
  spec.version = KaminariApiMetaData::VERSION
  spec.authors = ["BOXT Developers"]
  spec.email = ["developers@boxt.co.uk"]
  spec.homepage = "https://github.com/boxt/kaminari-api-meta-data"
  spec.summary = "A gem for adding Kaminari collection meta data to your API responses"
  spec.description = "A gem for adding Kaminari collection meta data to your API responses that matches the format " \
                     "that works with Kaminari paginate method."
  spec.license = "MIT"
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }
  spec.files = Dir[
    "lib/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
    "VERSION"
  ]

  spec.add_dependency "kaminari", "~> 1.1"
end
