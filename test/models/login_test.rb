# frozen_string_literal: true

require('test_helper')

# Test for the `User` model.
class LoginTest < ActiveSupport::TestCase
  test 'user confirmed' do
    # If social auth is used we do not worry
    # about a confirmation.
    user1 = Login.find(1)
    assert user1.confirmed

    # If social auth was not used, `login.provider`
    # will be `nil`. When a hosted account is
    # confirmed, the `login.confirm_token` is removded
    # from the database. User2's `login.confirm_token` is
    # not `nil`.
    user3 = Login.find(3)
    assert_not user3.confirmed

    # User3's `login.provider` and `login.confirm_token`
    # are `nil`.
    user2 = Login.find(2)
    assert user2.confirmed

    user4 = Login.create(identification: 'julio.jones@rise-up.com', password: 'iAmAmazing')
    assert user4.confirm_token
  end
end
