Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins 'https://atlmaps.com',
                'http://atlmaps-dev.org',
                'http://atlmaps-dev.com',
                'http://atlmaps.com',
                'http://localhost:4200',
                'http://2c801b74.ngrok.io'
        resource '*', headers: :any,
                      methods: [
                          :get,
                          :post,
                          :put,
                          :delete,
                          :options,
                          :patch
                      ],
                      max_age: 0
    end
end
