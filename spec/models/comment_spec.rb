# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:author) }
  end

  describe 'scopes' do
    describe '.ordered' do
      let!(:project) { create(:project) }
      let!(:comment1) { create(:comment, project: project) }
      let!(:comment2) { create(:comment, project: project) }
      let!(:comment3) { create(:comment, project: project) }

      it 'returns the comments ordered by created_at' do
        expect(project.comments.ordered).to eq([comment3, comment2, comment1])
      end
    end
  end
end
