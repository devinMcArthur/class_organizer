class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action do
    if @assignment.nil?
      if !params[:assignment].nil?
        @course = Course.find(params[:assignment][:course_id])
      else
        @course = Course.find(params[:course_id])
      end
    else
      @course = Course.find(@assignment.course_id)
    end
  end
  
  def new
    @assignment = Assignment.new
    @assignment.assignment_attachments.build
  end
  
  def index
    @assignments = Assignment.all
  end

  def show
  end
  
  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(assignment_params)
      flash[:success] = "The assignment has successfully been updated"
      redirect_to @course
    else
      render 'edit'
    end
  end

  def edit
    @assignment = Assignment.find(params[:id])
    @attachments = @assignment.assignment_attachments
    @attachment = @assignment.assignment_attachments.build
  end

  def create
    @assignment = @course.assignments.build(assignment_params)
    if @assignment.save
      @assignments = @course.assignments
      logger.info(@assignment.errors.full_messages)
      flash[:success] = "The assignment has been successfully added"
      redirect_to @course
    else
      @assignments = @course.assignments
      logger.info(@assignment.errors.full_messages)
      flash[:danger] = "Assignment upload was unsuccessful"
      redirect_to @course
    end
  end

  def destroy
    @assignment.destroy
    flash[:success] = "Assignment has been destroyed"
    redirect_to request.referrer || courses_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:title, :description, :due_date, :course_id, :importance, assignment_attachments_attributes: [:attachment, :assignment_id])
    end
    
    def attachment_params
      params.require(:assignment_attachment).permit(:assignment_id, :attachment)
    end
    

end
