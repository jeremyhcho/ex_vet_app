require 'rails_helper'

describe CompaniesUser, type: :model do
  context 'associations' do
    it { should belong_to :company }
    it { should belong_to :user }
  end
end
