require 'rails_helper'

RSpec.describe Header, type: :model do
  it { should belong_to(:endpoint) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
end
