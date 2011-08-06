class << ActionController::Base
  def add_template_helper_with_jam(helper_module, *args, &block)
    Jam::Builder.instance_eval { include helper_module }
    add_template_helper_without_jam(helper_module, *args, &block)
  end

  alias_method_chain :add_template_helper, :jam
end
