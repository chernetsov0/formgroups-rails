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
      define_method selector do |options = {}|
        @template.send selector, @method, validated_options(options)
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

    def label text, options = {}
      @template.label @method, text, unvalidated_options(options)
    end

    def text_area placeholder = nil, **options
      options[:placeholder    ] = placeholder
      options['aria-multiline'] = true

      @template.text_area @method, validated_options(options)
    end

    private

    def unvalidated_options options
      @default_options.merge(options).merge(object: @object)
    end

    def validated_options options
      options = unvalidated_options(options).merge(validations)
      options = options.merge('aria-invalid' => 'true') if errors.any?

      options
    end

    def validations
      validations = validators.map do |validator|
        result = {}

        case validator
        when ActiveModel::Validations::LengthValidator
          result['data-min'] = validator.options[:minimum] if validator.options[:minimum]
          result['data-max'] = validator.options[:maximum] if validator.options[:maximum]
        when ActiveRecord::Validations::PresenceValidator
          result['data-required'] = 'true'
          result['aria-required'] = 'true'
        when EmailValidator
          pattern = EmailValidator::PATTERN.source
          pattern = pattern.sub('\\A','^')
                           .sub('\\Z','$')
                           .sub('\\z','$')
                           .sub(/^\//,'')
                           .sub(/\/[a-z]*$/,'')
                           .gsub(/\(\?#.+\)/, '')
                           .gsub(/\(\?-\w+:/,'(')

          result['data-pattern'] = pattern
        end

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
