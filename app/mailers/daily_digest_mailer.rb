class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    @questions = Question.to_daily_digest
    mail(to: user.email, subject: 'Daily digest')
  end
end
