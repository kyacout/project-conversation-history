# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    return unless current_user.id != @project.owner_id

    respond_to do |format|
      format.html do
        redirect_to project_url(@project), status: :unauthorized, notice: 'You are not allowed to edit this project.'
      end
      format.json { render :show, status: :unauthorized, location: @project }
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
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if current_user.id != @project.owner_id
      respond_to do |format|
        format.html do
          redirect_to project_url(@project), status: :unauthorized,
                                             notice: 'You are not allowed to update this project.'
        end
        format.json { render :show, status: :unauthorized, location: @project }
      end
      return
    end

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if current_user.id != @project.owner_id
      respond_to do |format|
        format.html do
          redirect_to project_url(@project), status: :unauthorized,
                                             notice: 'You are not allowed to delete this project.'
        end
        format.json { render :show, status: :unauthorized, location: @project }
      end
      return
    end

    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { render :index, status: :ok }
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
end
