module FormGroups
  mattr_accessor(:field_class) { 'field' }
  mattr_accessor(:field_error_class) { 'field-error' }
  mattr_accessor(:map_validators) { true }

  mattr_reader :validator_mapping do
    mappings = {}

    mappings['ActiveModel::Validations::LengthValidator'] = Proc.new do |validator, result|
      result['minlength'] = validator.options[:minimum] if validator.options[:minimum]
      result['maxlength'] = validator.options[:maximum] if validator.options[:maximum]
    end

    mappings['ActiveModel::Validations::PresenceValidator'] = Proc.new do |validator, result|
      result['required'] = 'true'
      result['aria-required'] = 'true'
    end

    mappings
  end

  def self.configure &block
    yield self
  end
end
