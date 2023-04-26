# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Project', type: :request do
  context 'when the user is logged in' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe 'GET /projects' do
      it 'returns http success' do
        get '/projects'
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /projects/:id' do
      subject { create(:project) }

      it 'returns http success' do
        get "/projects/#{subject.id}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /projects/new' do
      it 'returns http success' do
        get '/projects/new'
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /projects/:id/edit' do
      context 'when the user is the owner of the project' do
        before { @project = create(:project, owner: user) }

        it 'returns http success' do
          get "/projects/#{@project.id}/edit"
          expect(response).to have_http_status(:success)
        end
      end

      context 'when the user is not the owner of the project' do
        before { @project = create(:project) }

        it 'returns unauthorized' do
          get "/projects/#{@project.id}/edit"
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'POST /projects' do
      let(:project_params) { attributes_for(:project).merge(owner_id: user.id) }

      it 'creates a new project' do
        post "/projects", params: { project: project_params }
        expect(Project.count).to eq(1)
      end
    end

    describe 'PUT /projects/:id' do
      context 'when the user is the owner of the project' do
        before { @project = create(:project, owner: user) }
        let(:project_params) { attributes_for(:project) }

        it 'updates the project' do
          put "/projects/#{@project.id}", params: { project: project_params }
          @project.reload
          expect(@project.title).to eq(project_params[:title])
        end
      end

      context 'when the user is not the owner of the project' do
        before { @project = create(:project) }
        let(:project_params) { attributes_for(:project) }

        it 'returns unauthorized' do
          put "/projects/#{@project.id}", params: { project: project_params }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'DELETE /projects/:id' do
      context 'when the user is the owner of the project' do
        before { @project = create(:project, owner: user) }

        it 'deletes the project' do
          delete "/projects/#{@project.id}"
          expect(Project.count).to eq(0)
        end
      end

      context 'when the user is not the owner of the project' do
        before { @project = create(:project) }

        it 'returns unauthorized' do
          delete "/projects/#{@project.id}"
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  context 'when the user is not logged in' do
    describe 'GET /projects' do
      it 'redirects to the login page' do
        get '/projects'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /projects/:id' do
      subject { create(:project) }

      it 'redirects to the login page' do
        get "/projects/#{subject.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /projects/new' do
      it 'redirects to the login page' do
        get '/projects/new'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /projects/:id/edit' do
      subject { create(:project) }

      it 'redirects to the login page' do
        get "/projects/#{subject.id}/edit"
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST /projects' do
      let(:project_params) { attributes_for(:project) }

      it 'redirects to the login page' do
        post "/projects", params: { project: project_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT /projects/:id' do
      subject { create(:project) }
      let(:project_params) { attributes_for(:project) }

      it 'redirects to the login page' do
        put "/projects/#{subject.id}", params: { project: project_params }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE /projects/:id' do
      subject { create(:project) }

      it 'redirects to the login page' do
        delete "/projects/#{subject.id}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
