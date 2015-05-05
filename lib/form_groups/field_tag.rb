module FormGroups
  class FieldTag < ActionView::Helpers::Tags::Base
    def initialize object_name, method, object, template, form, options
      super object_name, method, template, options.merge(object: object)

      @builder = FieldBuilder.new object_name, method, object, form, options
    end

    def render &block
      html_options = @options.delete(:html) || {}

      classes = (html_options[:class] || '').split(' ')
      classes << FormGroups.field_class
      classes << FormGroups.field_error_class if object.errors.has_key?(@method_name.to_sym)

      html_options[:class] = classes

      output =  @template_object.tag(:div, html_options, true)
      output << @template_object.capture(@builder, &block)
      output.safe_concat '</div>'
    end
  end
end
