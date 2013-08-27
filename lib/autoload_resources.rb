require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash/indifferent_access"

require "autoload_resources/version"
require "autoload_resources/able"
require "autoload_resources/railtie" if defined?(Rails)

module AutoloadResources
end
