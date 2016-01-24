require 'rails_helper'

RSpec.describe UserMailer do
  let(:voter) do
    instance_double(User, id: '1', name: 'Frank', email: 'frank@test.dev')
  end
  let(:poster) do
    instance_double(User, id: '2', name: 'John', email: 'john@mcfoo.dev')
  end
  let(:movie) do
    instance_double(Movie, user: poster, title:'Point Break')
  end

  describe 'movie_hater' do
    subject { described_class.movie_hater(user: voter, movie: movie) }

    it { is_expected.to be_a(ActionMailer::MessageDelivery) }

    it 'should have hello@movierama.dev as sender' do
      expect(subject.from).to include('hello@movierama.dev')
    end

    it 'should have john@mcfoo.dev as recipient' do
      expect(subject.to).to include(poster.email)
    end

    it 'should have the right subject' do
      expect(subject.subject).to eq('Someone just hated a movie you posted!')
    end

    it 'should have the right body' do
      expect(subject.body).to include("#{voter.name} just hated #{movie.title}")
    end
  end

  describe 'movie_liker' do
    subject { described_class.movie_liker(user: voter, movie: movie) }

    it { is_expected.to be_a(ActionMailer::MessageDelivery) }

    it 'should have hello@movierama.dev as sender' do
      expect(subject.from).to include('hello@movierama.dev')
    end

    it 'should have john@mcfoo.dev as recipient' do
      expect(subject.to).to include(poster.email)
    end

    it 'should have the right subject' do
      expect(subject.subject).to eq('Someone just liked a movie you posted!')
    end

    it 'should have the right body' do
      expect(subject.body).to include("#{voter.name} just liked #{movie.title}")
    end
  end

  describe 'after_action' do
    subject { described_class.movie_liker(user: voter, movie: movie) }

    context 'when the user has no email address' do
      before do
        allow(voter).to receive(:email).and_return(nil)
      end

      it { expect(subject.perform_deliveries).to be_falsey }
    end

    context 'when the poster has no user' do
      before do
        allow(movie).to receive(:user).and_return(nil)
      end

      it { expect(subject.perform_deliveries).to be_falsey }
    end

    context 'when the poster has no email address' do
      before do
        allow(poster).to receive(:email).and_return(nil)
      end

      it { expect(subject.perform_deliveries).to be_falsey }
    end
  end
end
