# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comment', type: :request do
  context 'when the user is logged in' do
    let(:user) { create(:user) }

    before { sign_in user }

    describe 'POST /project/:id/comments' do
      let(:project) { create(:project, owner: user) }
      let(:comment_params) { attributes_for(:comment).merge(project_id: project.id) }

      it 'creates a new comment' do
        post "/projects/#{project.id}/comments", params: { comment: comment_params }
        expect(Comment.count).to eq(1)
      end

      it 'creates a new project history' do
        post "/projects/#{project.id}/comments", params: { comment: comment_params }
        expect(ProjectHistory.count).to eq(1)
        expect(ProjectHistory.first.history_type).to eq(ProjectHistory.history_types[:comment])
        expect(ProjectHistory.first.description).to eq(comment_params[:content])
      end
    end
  end

  context 'when the user is not logged in' do
    describe 'POST /project/:id/comments' do
      let(:project) { create(:project) }
      let(:comment_params) { attributes_for(:comment).merge(project_id: project.id) }

      it 'does not create a new comment' do
        post "/projects/#{project.id}/comments", params: { comment: comment_params }
        expect(Comment.count).to eq(0)
      end

      it 'does not create a new project history' do
        post "/projects/#{project.id}/comments", params: { comment: comment_params }
        expect(ProjectHistory.count).to eq(0)
      end

      it 'redirects to the login page' do
        post "/projects/#{project.id}/comments", params: { comment: comment_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
