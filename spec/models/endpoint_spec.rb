require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  it { should have_many(:headers).dependent(:destroy) }

  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:verb) }
  it { should validate_presence_of(:path) }
  it { should validate_presence_of(:response_code) }

  it { should validate_inclusion_of(:verb).
    in_array(['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'PATCH']).
    with_message(/is not a supported HTTP method/) }
end
