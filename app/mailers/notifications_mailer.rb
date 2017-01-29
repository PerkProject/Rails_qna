class NotificationsMailer < ApplicationMailer
  def new_answer(answer, email)
    @answer = answer
    mail(to: email, sunject: 'You have a new answer')
  end
end
