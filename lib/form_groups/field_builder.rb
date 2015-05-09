module FormGroups
  class FieldBuilder
    FIELD_HELPERS = [:text, :password, :hidden, :file, :color, :search, :telephone, :phone,
                     :date, :time, :datetime, :datetime_local, :month, :week, :url, :email,
                     :number, :range]

    OTHER_HELPERS = [:check_box, :radio_button]

    FIELD_HELPERS.each do |selector|
      define_method selector do |placeholder = nil, options = {}|
        options[:placeholder] = placeholder

        @template.send "#{selector}_field".freeze, @method, validated_options(options)
      end
    end

    OTHER_HELPERS.each do |selector|
      define_method selector do |value, options = {}|
        @template.send selector, @method, value, validated_options(options)
      end
    end

    def initialize object_name, method, object, template, options
      @method  , @object_name, @object = method  , object_name, object
      @template, @options              = template, options

      @default_options = @options ? @options.slice(:index, :namespace) : {}
    end

    def errors
      @object.errors[@method]
    end

    def label text, sub_id = '', **options
      full_id  = @method.to_s
      full_id += "_#{sub_id}" unless sub_id.nil? or sub_id.to_s.empty?

      @template.label full_id.to_sym, text, object_options.merge(options)
    end

    def text_area placeholder = nil, **options
      options['placeholder'   ] = placeholder
      options['aria-multiline'] = true

      @template.text_area @method, validated_options(options)
    end

    def select placeholder = nil, **options, &block
      options['data-placeholder'] = placeholder

      @template.select @method, nil, object_options, html_options(options), &block
    end

    private

      def object_options
        @default_options.merge(object: @object)
      end

      def html_options options = {}
        options = options.merge(validations) if FormGroups.map_validators
        options = options.merge('aria-invalid' => 'true') if errors.any?

        options
      end

      def validated_options options
        object_options.merge html_options(options)
      end

      def validations
        validations = validators.map do |validator|
          result  = {}

          mapping = FormGroups.validator_mapping.select { |v| validator.is_a? v }
          mapping.each_value { |m| m.call validator, result }

          result
        end

        Hash[*validations.collect{ |h| h.to_a }.flatten]
      end

      def validators
        @object.class.validators.select do |validator|
          validator.attributes.include? @method
        end
      end
  end
end
