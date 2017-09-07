# spec/support/request_spec_helper
module RequestSpecHelper
    # Parse JSON response to ruby hash
    def json
        JSON.parse(response.body)['data']
    end

    def response_id
        data['id']
    end

    def attributes
        json['attributes']
    end

    def hash_to_json_api(model, attributes)
        {
            data: {
                type: model,
                attributes: attributes
            }
        }
    end

    def factory_to_json_api(model)
        {
            data: {
                type: ActiveModel::Naming.plural(model),
                attributes: model.attributes
            }.tap do |hash|
                hash[:id] = model.id if model.persisted?
            end
        }
    end
end
