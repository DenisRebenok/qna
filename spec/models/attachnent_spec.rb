require 'rails_helper'

RSpec.describe Attachnent, type: :model do
  it { should belong_to :question }
end
