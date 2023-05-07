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
    it { is_expected.to have_many(:project_histories) }
  end

  describe 'scopes' do
    describe '.ordered' do
      let!(:project1) { create(:project, created_at: 1.day.ago) }
      let!(:project2) { create(:project, created_at: 2.days.ago) }
      let!(:project3) { create(:project, created_at: 3.days.ago) }

      it 'returns projects ordered by created_at desc' do
        expect(described_class.ordered).to eq([project1, project2, project3])
      end
    end
  end
end
