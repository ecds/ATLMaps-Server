class Template < ActiveRecord::Base
    has_many :projects

    def slug
      return self.name.parameterize
    end
    
end
