# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array(described_class.statuses.keys) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_many(:comments) }
  end
end
