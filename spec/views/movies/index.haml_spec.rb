require 'rails_helper'

RSpec.describe "movies/index", :type => :view do
  let(:johnny) { User.create(name: 'Johnny Utah') }
  let(:movie) do
    Movie.create(
      title: 'Point Break',
      description: 'Bohdi ♥︎',
      date: '1991-07-12',
      user: johnny
    )
  end

  def add_current_user(object)
    object.instance_eval do
      def current_user
        user = User.new(id: 'test|1', name: 'Johnny Utah')
        UserDecorator.new(user)
      end
    end
  end

  before(:each) do
    [view, view.controller].each { |obj| add_current_user(obj) }
    assign(:movies, [movie])
  end

  it "should display the movies" do
    render

    expect(rendered).to match /Point Break/
    expect(rendered).to match /Bohdi ♥︎/
    expect(rendered).to match /July 12, 1991/
  end
end
