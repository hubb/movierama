# Cast or withdraw a vote on a movie
class VotingBooth
  CASTING = {
    like: { set: :likers, email: :movie_liker },
    hate: { set: :haters, email: :movie_hater },
  }

  def initialize(user, movie, notifier = UserMailer)
    @user     = user
    @movie    = movie
    @notifier = notifier
  end

  def vote(like_or_hate)
    cast = CASTING.fetch(like_or_hate)
    unvote # to guarantee consistency
    _set = cast[:set].to_proc
    _set.call(@movie).add(@user)
    _update_counts
    _notify_poster(cast[:email])
    self
  end

  def unvote
    @movie.likers.delete(@user)
    @movie.haters.delete(@user)
    _update_counts
    self
  end

  private

  def _update_counts
    @movie.update(
      liker_count: @movie.likers.size,
      hater_count: @movie.haters.size)
  end

  def _notify_poster(email)
    _user = @user.is_a?(UserDecorator) ? @user.object : @user
    @notifier.public_send(email, user: _user, movie: @movie).deliver_later
  end
end
