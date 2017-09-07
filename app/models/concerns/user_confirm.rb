# /app/models/concerns/user_confirm.rb
# Concern provides code to ensure a user is confirmed.
module UserConfirm
    extend ActiveSupport::Concern

    included do
        before_create :confirmation_token
    end

    def confirmed
        return provider.present? || \
               provider.nil? && confirm_token.nil?
    end

    def confirmation_token
        return if confirm_token.present?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
end
