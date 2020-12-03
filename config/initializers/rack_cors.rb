# frozen_string_literal: true

Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  allow do
    origins 'https://atlmaps.com',
            'http://atlmaps-dev.org',
            'http://atlmaps-dev.com',
            'http://atlmaps.com',
            'http://localhost:4200',
            'https://localhost:4200',
            'http://2c801b74.ngrok.io',
            'http://atlmaps.ecdsweb.org',
            'https://lvh.me:4200',
            'http://localhost:3000'
    resource '*',
             headers: :any,
             methods: %i[
               get
               post
               put
               delete
               options
               patch
               head
             ],
             credentials: true
  end
end
