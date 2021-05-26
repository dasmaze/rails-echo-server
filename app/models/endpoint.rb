class Endpoint < ApplicationRecord
    METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'PATCH']

    has_many :headers, dependent: :destroy

    validates_presence_of :verb, :path, :response_code

    validates :verb, inclusion: { in: METHODS,
        message: "'%{value}' is not a supported HTTP method" }
    
    validates :path, format: { with: /\A\/(?:[\w-]+\/?)+\z/,
        message: "Paths are restricted to be alphanumerical" }
end
