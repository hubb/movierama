require 'rails_helper'

RSpec.describe MoviesController, :type => :controller do
  let(:user) { User.new }

  before { controller.authenticate!(user) }

  describe "GET index" do
    it { expect(get :index).to have_http_status(:success) }
    it { expect(get :index).to render_template(:index) }

    specify 'should assign @movies (Enumerable)' do
      get :index
      expect(assigns(:movies)).to be_a(Enumerable)
    end
  end

  describe "GET new" do
    it { expect(get :new).to have_http_status(:success) }
    it { expect(get :new).to render_template(:new) }

    specify 'should assign @movie (Movie)' do
      get :new
      expect(assigns(:movie)).to be_a(Movie)
    end

    specify 'should assign @validator (NullValidator)' do
      get :new
      expect(assigns(:validator)).to be_a(NullValidator)
    end
  end

  describe "POST create" do
    it do
      expect(
        post :create,
          date: '1991-07-12',
          title: 'Point Break',
          description: 'Fear causes hesitation, and hesitation will cause ' + \
                       'your worst fears to come true - Bohdi'
      ).to redirect_to(root_path)
    end
  end
end
