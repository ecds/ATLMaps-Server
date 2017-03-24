# Preview all emails at http://localhost:3000/rails/mailers/confirm_login_mailer
class ConfirmLoginMailerPreview < ActionMailer::Preview
    def registration_confirmation
        # Login.create(identification: 'matt.ryan@rise-up.com', password: 'bradyIsOverrated')
        ConfirmLoginMailer.registration_confirmation(Login.last)
    end
end
