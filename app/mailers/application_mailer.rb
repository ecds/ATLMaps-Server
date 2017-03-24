# Base class for mailers.
class ApplicationMailer < ActionMailer::Base
    default from: 'info@atlmaps.com'
    layout 'mailer'
end
