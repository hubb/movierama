require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_new'
require 'support/pages/home'
require 'support/with_user'

RSpec.describe 'submit movie', type: :feature do

  let(:page) { Pages::MovieNew.new }
  let(:home) { Pages::Home.new }

  context 'when logged out' do
    it 'fails' do
      expect { page.open }
        .to raise_error(
          CanCan::AccessDenied,
          'You are not authorized to access this page.')
    end
  end

  context 'when logged in' do
    with_logged_in_user
    before { page.open }

    it 'succeeds' do
      page.submit(
        title:       'Bridge over river Kwai',
        description: 'Boom!',
        date:        '1957-10-02')
      expect(page).to have_movie_creation_message
    end

    it 'makes the movie visible on the home page' do
      page.submit(
        title: 'Point Break',
        date: '1991-07-12',
        description: 'Fear causes hesitation, and hesitation will cause ' + \
                     'your worst fears to come true - Bohdi')

      expect(home).to have_movie('Point Break')
    end

    it 'fails without a date' do
      page.submit(
        title:       'Bridge over river Kwai',
        description: 'Boom!',
        date:        nil)
      expect(page).to have_error_message
    end
  end

end


