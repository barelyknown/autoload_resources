module AutoloadResources
  module Able
    extend ActiveSupport::Concern

    def autoload_resources(action_name=params[:action])
      return unless self.class.autoload_procs[action_name]
      value = instance_eval(&(self.class.autoload_procs[action_name]))
      self.class.autoload_instance_variable_names(action_name).each do |instance_variable_name|
        instance_variable_set(
          "@#{instance_variable_name}",
          value
        )
      end
    end

    module ClassMethods
      
      def autoload_resources
        set_default_autoload_procs
        yield if block_given?
        before_action :autoload_resources
      end

      def autoload_procs
        @autoload_procs ||= HashWithIndifferentAccess.new
      end

      def autoload_instance_variable_name(klass, action_name)
        case String(action_name)
        when "index" then klass.model_name.plural
        else klass.model_name.element
        end
      end

      def autoload_instance_variable_names(action_name)
        resource_class.ancestors.grep(Class).select do |klass|
          klass != ActiveRecord::Base && klass.ancestors.include?(ActiveRecord::Base)
        end.collect do |klass|
          autoload_instance_variable_name(klass, action_name)
        end
      end

      def set_default_autoload_procs
        return unless resource_class
        default_autoload_procs.each do |actions, closure|
          for_actions(actions, closure)
        end
      end

      def default_autoload_procs
        {
          index: Proc.new { resource_class.all },
          new: Proc.new { resource_class.new },
          create: default_create_proc,
          [:show, :edit, :update, :destroy] => Proc.new { resource_class.find(params[:id]) }
        }
      end

      def default_create_proc
        Proc.new do
          create_params_method and resource_class.new(send(create_params_method))
        end
      end

      def for_actions(actions, proc=nil, &block)
        Array(actions).each do |action|
          autoload_procs[action] = block || proc
        end
      end
      alias_method :for_action, :for_actions

    end

  private
    def create_params_method
      self.class.autoload_instance_variable_names(:create).collect do |element|
        element + "_params"
      end.find do |params_method_name|
        self.respond_to? params_method_name
      end
    end

  end
end