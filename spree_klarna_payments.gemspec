# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'klarna_gateway/version'

Gem::Specification.new do |spec|
  spec.name          = "spree_klarna_payments"
  spec.version       = KlarnaGateway::VERSION
  spec.authors       = ["Jose Antonio Pio Gil", "Pascal Jungblut"]
  spec.email         = ["jose.pio@bitspire.de", "pascal.jungblut@bitspire.de"]

  spec.summary       = %q{Klarna Payments ActiveMerchant gateway and Spree payment method}
  spec.description   = %q{Klarna Payments ActiveMerchant gateway and Spree payment method}
  spec.homepage      = ""
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails", "~> 3.5.0"
  spec.add_development_dependency "sass-rails"
  spec.add_development_dependency "coffee-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "poltergeist", "~> 1.15.0"
  spec.add_development_dependency "site_prism"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "factory_girl", "~> 4"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency "chromedriver-helper"
  spec.add_development_dependency "listen"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "devise"

  spec.add_dependency "spree_core", ">= 2.3.0"
  spec.add_dependency "spree_api", ">= 2.3.0"
  spec.add_dependency "spree_frontend", ">= 2.3.0"
  spec.add_dependency "spree_backend", ">= 2.3.0"

  spec.add_dependency "klarna_client", ">= 0.9.1"
  spec.add_dependency "activemerchant"
end
