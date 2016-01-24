class ApplicationMailer < ActionMailer::Base
  default from: "hello@movierama.dev"
  layout 'mailer'
end
