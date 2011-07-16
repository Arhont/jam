# TILT Template
if defined?(Tilt)
  class JamTemplate < Tilt::Template
    def initialize_engine
      return if defined?(::Jam)
      require_template_library 'jam'
    end

    def prepare
      options = @options.merge(:format => @options[:format])
      @engine = ::Jam::Builder.new(data, options)
    end

    def evaluate(scope, locals, &block)
      @engine.render(scope, locals, &block)
    end
  end

  Tilt.register 'jam', JamTemplate
end

# Rails 2.X Template
if defined?(Rails) && Rails.version =~ /^2/
  require 'action_view/base'
  require 'action_view/template'

  module ActionView
    module TemplateHandlers
      class JamHandler < TemplateHandler
        include Compilable

        def compile(template) %{
          ::Jam::Builder.new(#{template.source.inspect}, { :format => #{template.format.inspect} }).
            render(self, assigns.merge(local_assigns)).to_json
        } end
      end
    end
  end

  ActionView::Template.register_template_handler :jam, ActionView::TemplateHandlers::JamHandler
end

# Rails 3.X Template
if defined?(Rails) && Rails.version =~ /^3/
  module ActionView
    module Template::Handlers
      class Jam

        class_attribute :default_format
        self.default_format = Mime::JSON

        def self.call(template)
          source = if template.source.empty?
            File.read(template.identifier)
          else # use source
            template.source
          end

          %{ ::Jam::Builder.new(#{source.inspect}).
              render(self, assigns.merge(local_assigns)).to_json }
        end
      end
    end
  end

  ActionView::Template.register_template_handler :jam, ActionView::Template::Handlers::Jam
end
