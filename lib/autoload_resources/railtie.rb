module AutoloadResources
  class Railtie < Rails::Railtie
    initializer "autoload_resources.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include Able
      end
    end
  end
end