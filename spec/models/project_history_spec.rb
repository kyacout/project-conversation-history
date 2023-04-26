# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectHistory, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:history_type) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_inclusion_of(:history_type).in_array(described_class.history_types.keys) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end
end
