# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update update_status destroy authorize_user!]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[edit update update_status destroy]
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
    @comments = @project.comments.includes(:author).order(created_at: :desc)
    @project_histories = @project.project_histories.includes(:user).order(created_at: :desc)
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

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.status = 'ready' if @project.status.blank?
    @project.owner = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: 'Project was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity, alert: @project.errors.full_messages.join(', ') }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity, alert: @project.errors.full_messages.join(', ') }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
    end
  end

  # PUT /projects/1/update_status
  def update_status
    ActiveRecord::Base.transaction do
      @project.project_histories.create!(user: current_user, history_type: :status_update,
                                         description: "from #{@project.status} to #{project_params[:status]}")
      @project.update!(status: project_params[:status])
    end

    respond_to do |format|
      format.html { redirect_to request.referer || root_path, notice: 'Project state successfully updated.' }
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
