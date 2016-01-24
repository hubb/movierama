class UserMailer < ApplicationMailer
  after_action :assert_notifiable, :_mail

  def movie_hater(user:, movie:)
    @user  = user
    @movie = MovieDecorator.new(movie)
  end

  def movie_liker(user:, movie:)
    @user  = user
    @movie = MovieDecorator.new(movie)
  end

  private

  def assert_notifiable
    unless @user.email && @movie&.user&.email
      mail.perform_deliveries = false
    end
  end

  def _mail
    mail(to: @movie&.user&.email, subject: default_i18n_subject)
  end
end
