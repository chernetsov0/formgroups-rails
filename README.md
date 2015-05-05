### FormGroups for Rails

**Warning:** This gem is still in the active development phase.
Please read the code before deciding that it is suitable for production.

This gem for Ruby on Rails **4.0+** allows to create blocks for each field of the form.
This allows to simplify syntax, show errors, add errors classes and validation attributes.

For example consider this part of the template:

```erb
<div class='field <%= 'field-errors' if @report.errors[:name].any? %>'>
  <%= f.label :name, 'Name' %>
  <%= f.text_field :name, placeholder: 'Name' %>

  <% if @report.errors[:name].any? %>
    <p><%= @report.errors[:name].first %></p>
  <% end %>
</div>
```
With this gem you can write following code instead:
```erb
<%= f.field :name do |name| %>
  <%= name.label 'Name' %>
  <%= name.text 'Name' %>
  <% if name.errors.any? %>
    <p><%= name.errors.first %></p>
  <% end %>
<% end %>
```

If model assosiated with the form has validations, helpers will try to convert them to attributes.
By default only `presence` and `length` will be converted to [jQuery Validation](http://jqueryvalidation.org/)-compatible attributes, but you can define your own or turn off this feature altogether.

You can configure default field and error classes as well as mapping from validators to attributes
in the initializer like this:

```ruby
# config/initializers/form_groups.rb
FormGroups.configure do |config|
  config.field_class = 'field'
  config.field_error_class = 'field-errors'

  config.validator_mapping['ActiveModel::Validations::LengthValidator'] = Proc.new do |validator, html|
    html['data-min'] = validator.options[:minimum] if validator.options[:minimum]
    html['data-max'] = validator.options[:maximum] if validator.options[:maximum]
  end

  config.map_validators = false # Add this to turn off validators mapping
end
```
