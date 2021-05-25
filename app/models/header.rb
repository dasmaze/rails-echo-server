class Header < ApplicationRecord
    belongs_to :endpoint

    validates_presence_of :name, :value
end
