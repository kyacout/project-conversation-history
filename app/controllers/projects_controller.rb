# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update update_status destroy authorize_user!]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[edit update update_status destroy]
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  # GET /projects
  def index
    @pagy, @projects = pagy(Project.ordered)
    @user_projects = current_user.projects.ordered
  end

  # GET /projects/1
  def show
    @pagy_comments, @comments = pagy(@project.comments.includes(:author).ordered)
    @pagy_project_histories, @project_histories = pagy(@project.project_histories.includes(:user).ordered)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    return unless current_user.id != @project.owner_id

    respond_to do |format|
      format.html do
        redirect_to project_url(@project), status: :unauthorized, alert: 'You are not allowed to edit this project.'
      end
    end
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.status = 'ready' if @project.status.blank?
    @project.owner = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: 'Project was successfully created.' }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity, alert: @project.errors.full_messages.join(', ') }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity, alert: @project.errors.full_messages.join(', ') }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def authorize_user!
    if current_user.id != @project.owner_id
      respond_to do |format|
        format.html do
          redirect_to project_url(@project), status: :unauthorized,
                                             alert: 'You are not authorized to do that.'
        end
      end
      return false
    end

    true
  end

  def record_invalid
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity, alert: @project.errors.full_messages.join(', ') }
    end
  end
end
