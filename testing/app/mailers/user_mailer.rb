class UserMailer < ActionMailer::Base
  default from: "no-reply@agendador"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Senha do sistema publico de agendamentos')
  end
end
