class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    before_create :confirmation_token

    def confirmed
        return provider.present? || \
               provider.nil? && confirm_token.nil?
    end

    def confirmation_token
        return unless confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
end
