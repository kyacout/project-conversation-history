# frozen_string_literal: true

require 'rails_helper'

describe 'User signs in', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it 'with valid email and password' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Log in'

    expect(page).to have_text('Signed in successfully.')
  end

  it 'with invalid email' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@email.com'
    fill_in 'Password', with: 'wrong_password'

    click_button 'Log in'

    expect(page).to have_text('Invalid Email or password.')
  end
end
