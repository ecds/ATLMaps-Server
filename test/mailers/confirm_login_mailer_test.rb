# frozen_string_literal: true

require('test_helper')
# Test confirm mailer.
class ConfirmLoginMailerTest < ActionMailer::TestCase
  test 'send confirm code' do
    @login = Login.create(identification: 'chunkylover53@aol.com', password: 'duh')
    @login.save!
    email = ConfirmLoginMailer.registration_confirmation(Login.last)
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['info@atlmaps.com'], email.from
    assert_nil email.body.to_s[-24..-3].match(/\s/)
  end
end
