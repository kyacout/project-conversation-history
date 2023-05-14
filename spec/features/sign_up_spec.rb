# frozen_string_literal: true

require 'rails_helper'

describe 'User signs up', type: :feature do
  it 'with valid email and password' do
    visit new_user_registration_path

    fill_in 'Email', with: Faker::Internet.safe_email
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'

    click_button 'Sign up'

    expect(page).to have_text('Welcome! You have signed up successfully.')
  end
end
