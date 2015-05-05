class HomeController < ApplicationController
  def index
    @person = Person.new name: 'Default', age: 18
  end
end
