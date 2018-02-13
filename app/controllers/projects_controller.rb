class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, except: [:index, :company_projects]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.order_by_company_and_project.paginate(page: params[:page] || 1, per_page: helpers.pager_per_page)
    respond_to do |format|
      message = @projects.present? ? "" : "There are no projects available at this time"
      format.json do
        status = @projects.present? ? :ok : :not_found
        render json: { response: @projects, status: status, message: message }
      end
      format.html do
        # Only authorize html format, json is okay because we use it as
        # an api.
        authorize(:project)
        flash[:alert] = message unless message.blank?
        @projects
      end
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @companies = Company.none
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: projects_path }
      else
        @companies = Company.none
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: projects_path }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def company_projects
    company = Company.find_by(id: params[:id])
    @projects = company.nil? ? Project.none : company.projects
    @projects = @projects.order_by_company_and_project
    respond_to do |format|
      message = @projects.present? ? "" : "There are no projects available for this company at this time"
      format.json do
        status = @projects.present? ? :ok : :not_found
        render json: { response: @projects, status: status, message: message }
      end
      format.html do
        # Only authorize html format, json is okay because we use it as
        # an api.
        authorize(:project)
        flash[:alert] = message unless message.blank?
        @projects
      end
    end
  end

  private
  
    def authorize_user
      authorize(:project)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :company_id)
    end
end
