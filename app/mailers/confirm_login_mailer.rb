# Mailer to send email confirmations to new users.
class ConfirmLoginMailer < ApplicationMailer
    def registration_confirmation(login)
        @user = login
        @frontend_host = ENV['FRONTEND_HOST']
        mail(to: @user.identification, subject: 'ATLMaps Registration Confirmation')
    end
end
