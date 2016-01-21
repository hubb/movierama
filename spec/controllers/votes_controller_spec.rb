require 'rails_helper'

RSpec.describe VotesController, :type => :controller do
  let(:user) { User.new }

  let(:movie) do
    Movie.create(title: 'Foo', description: 'Bar', date: '2016-01-21')
  end

  before { controller.authenticate!(user) }

  describe "GET create" do
    it do
      expect(get :create, movie_id: movie.id, t: 'like')
        .to redirect_to(root_path)
    end
  end

  describe "GET destroy" do
    it do
      expect(get :destroy, movie_id: movie.id, t: 'hate')
        .to redirect_to(root_path)
    end
  end
end
