class Endpoint < ApplicationRecord
    has_many :headers, dependent: :destroy

    validates_presence_of :id, :verb, :path, :response_code

    validates :verb, inclusion: { in: %w(GET HEAD POST PUT DELETE PATCH),
        message: "%{value} is not a supported HTTP method" }
end
