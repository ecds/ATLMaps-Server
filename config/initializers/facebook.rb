class Facebook
    def initialize(auth_code)
        @auth_code = auth_code
        @user_data = user_data
    end

    def user_data
        facebook = URI.parse("https://graph.facebook.com/v2.5/me?access_token=#{@auth_code}&fields=id,name,email,first_name,last_name,gender")
        response = Net::HTTP.get_response(facebook)
        JSON.parse(response.body)
    end

    def user_data_req
        "https://graph.facebook.com/v2.5/me?access_token=#{@auth_code}&fields=id,name,email,first_name,last_name,gender"
    end

    def image
        img = URI.parse("https://graph.facebook.com/v2.5/me/picture?access_token=#{@auth_code}&width=180&height=180&redirect=false")
        response = Net::HTTP.get_response(img)
        JSON.parse(response.body)
    end

    def get_user!
        if user_data.present?
            # below you should implement the logic to find/create a user in your app basing on @user_data
            # It should return a user object
            puts '&&&&&&&&&&&&&&&'
            puts @user_data
            puts '&&&&&&&&&&&&&&&'
            User.authorize_from_external(@user_data)
        end
    end
end
