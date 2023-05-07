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

  describe 'scopes' do
    describe '.ordered' do
      let!(:project) { create(:project) }
      let!(:project_history1) { create(:project_history, :comment, project:) }
      let!(:project_history2) { create(:project_history, :comment, project:) }
      let!(:project_history3) { create(:project_history, :comment, project:) }

      it 'returns the project histories ordered by created_at' do
        expect(project.project_histories.ordered).to eq([project_history3, project_history2, project_history1])
      end
    end
  end
end
