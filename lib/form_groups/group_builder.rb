module FormGroups
  module GroupBuilder
    extend ActiveSupport::Concern

    included do
      def field method, options = {}, &block
        raise ArgumentError, "Missing block" unless block_given?

        FieldTag.new(object_name, method, object, @template, self, options).render(&block)
      end

      private

        def objectify options
          options.merge(object: object)
        end
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, FormGroups::GroupBuilder
