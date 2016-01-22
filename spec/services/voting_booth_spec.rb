require 'rails_helper'

RSpec.describe VotingBooth, type: :service do
  let(:user) { User.new(id: 'dev|1') }
  let(:movie) { Movie.new(id: '1') }
  subject(:voter) { described_class.new(user, movie) }

  describe 'vote' do
    let(:cast_vote) { voter.vote(like_or_hate) }

    describe 'like' do
      let(:like_or_hate) { :like }

      it 'should include the user in likers' do
        expect { cast_vote }.to change { movie.likers }.to([user])
      end

      it 'should change hater_count to 0' do
        expect { cast_vote }.to change { movie.hater_count }.to(0)
      end

      it 'should change liker_count to 1' do
        expect { cast_vote }.to change { movie.liker_count }.to(1)
      end

      context 'user has already voted' do
        before { cast_vote }

        it 'should not change hater_count' do
          expect { cast_vote }.to_not change { movie.hater_count }
        end

        it 'should not change liker_count' do
          expect { cast_vote }.to_not change { movie.liker_count }
        end
      end
    end

    describe 'hate' do
      let(:like_or_hate) { :hate }

      it 'should include the user in haters' do
        expect { cast_vote }.to change { movie.haters }.to([user])
      end

      it 'should change hater_count to 1' do
        expect { cast_vote }.to change { movie.hater_count }.to(1)
      end

      it 'should change liker_count to 0' do
        expect { cast_vote }.to change { movie.liker_count }.to(0)
      end
    end

    describe 'unknown like_or_hate' do
      let(:like_or_hate) { :foo }

      it { expect { cast_vote }.to raise_error }
    end
  end

  describe 'unvote' do
    let(:cast_vote) { voter.unvote }

    shared_examples 'deletes the user from likers and haters' do
      it 'should delete user from likers' do
        expect { cast_vote }.to change { movie.likers }.from(anything).to([])
      end

      it 'should delete user from haters' do
        expect { cast_vote }.to change { movie.haters }.from(anything).to([])
      end
    end

    context 'when the user has liked the movie' do
      before { voter.vote(:like) }

      include_examples 'deletes the user from likers and haters'

      it 'should change liker_count to 0' do
        expect { cast_vote }.to change { movie.liker_count }.to(0)
      end

      it 'should not change hater_count' do
        expect { cast_vote }.to_not change { movie.hater_count }
      end
    end

    context 'when the user has hated the movie' do
      before { voter.vote(:hate) }

      include_examples 'deletes the user from likers and haters'

      it 'should change hater_count to 0' do
        expect { cast_vote }.to change { movie.hater_count }.to(0)
      end

      it 'should not change liker_count' do
        expect { cast_vote }.to_not change { movie.liker_count }
      end
    end
  end
end
