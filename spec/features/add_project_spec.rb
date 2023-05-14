# frozen_string_literal: true

require 'rails_helper'

describe 'User adds a project', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  context 'when user is signed in' do
    before do
      sign_in user
      visit projects_path
      click_link 'New project'
    end

    let (:project_title) { Faker::Lorem.word }
    let (:project_description) { Faker::Lorem.paragraph }

    it 'with valid title and description' do
      fill_in 'Title', with: project_title
      fill_in 'Description', with: project_description
      click_button 'Create Project'

      visit projects_path
      expect(page).to have_text(project_title)
    end

    it 'with empty title' do
      fill_in 'Title', with: ''

      click_button 'Create Project'

      expect(page).to have_text("Title can't be blank")
    end
  end
end
