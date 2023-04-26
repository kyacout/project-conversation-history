# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:comments) }
  end
end
