### FormGroups for Rails

**Warning:** This gem is still in the active development phase.
Please read the code before deciding that it is suitable for production.

This gem for Ruby on Rails **4.0+** allows to create blocks for each field of the form.
This allows to simplify syntax, show errors, add errors classes and so on.

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

Hope it looks simpler to you! ;-)
