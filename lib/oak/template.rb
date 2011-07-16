# TILT Template
if defined?(Tilt)
  class OakTemplate < Tilt::Template
    def initialize_engine
      return if defined?(::Oak)
      require_template_library 'oak'
    end

    def prepare
      options = @options.merge(:format => @options[:format])
      @engine = ::Oak::Builder.new(data, options)
    end

    def evaluate(scope, locals, &block)
      @engine.render(scope, locals, &block)
    end
  end

  Tilt.register 'oak', OakTemplate
end

# Rails 2.X Template
if defined?(Rails) && Rails.version =~ /^2/
  require 'action_view/base'
  require 'action_view/template'

  module ActionView
    module TemplateHandlers
      class OakHandler < TemplateHandler
        include Compilable

        def compile(template) %{
          ::Oak::Builder.new(#{template.source.inspect}, { :format => #{template.format.inspect} }).
            render(self, assigns.merge(local_assigns)).to_json
        } end
      end
    end
  end

  ActionView::Template.register_template_handler :oak, ActionView::TemplateHandlers::OakHandler
end

# Rails 3.X Template
if defined?(Rails) && Rails.version =~ /^3/
  module ActionView
    module Template::Handlers
      class Oak

        class_attribute :default_format
        self.default_format = Mime::JSON

        def self.call(template)
          source = if template.source.empty?
            File.read(template.identifier)
          else # use source
            template.source
          end

          %{ ::Oak::Builder.new(#{source.inspect}).
              render(self, assigns.merge(local_assigns)).to_json }
        end
      end
    end
  end

  ActionView::Template.register_template_handler :oak, ActionView::Template::Handlers::Oak
end
