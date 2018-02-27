require "action_controller/railtie"
module MyApp
  class Application < Rails::Application
    config.session_store :cookie_store, :key=>"_my_app_session"
    config.secret_token = "Stay hungry. Stay foolish. -- Steve Jobs"
    config.active_support.deprecation = :stderr

    config.middleware.use Rack::OAuth2::Server::Admin.mount
    config.after_initialize do
      # TODO : Use the below to later if we want to support Mongo ruby driver
      #        version 1 AND 2
      # gem_name, *gem_ver_reqs = 'mongo', '~> 1'
      # gdep = Gem::Dependency.new(gem_name, *gem_ver_reqs)
      # # find latest that satisifies
      # found_gspec = gdep.matching_specs.max_by(&:version)
      # one_point_oh = Gem::Version.new("1.0.0")
      # two_point_oh = Gem::Version.new("2.0.0")
      # puts "found_gspec.version > one_point_oh = #{(found_gspec.version > one_point_oh).inspect}"
      # puts "found_gspec.version < two_point_oh = #{(found_gspec.version < two_point_oh).inspect}"

      # NOTE : need to set the ::DATABASE below in order to satifsy some
      #        tests in test/oauth/server_methods_test.rb
      ::MONGO_CLIENT = Mongo::MongoClient.new("localhost", 27017, logger: Rails.logger)
      ::DATABASE = ::MONGO_CLIENT.db(ENV["DB"])

      config.oauth.database = ::DATABASE
      config.oauth.host = "example.org"
      config.oauth.collection_prefix = "oauth2_prefix"
      config.oauth.authenticator = lambda do |username, password|
        "Batman" if username == "cowbell" && password == "more"
      end
    end

    config.eager_load = false
  end
end
Rails.application.config.root = File.dirname(__FILE__) + "/.."
require Rails.root + "config/routes"
