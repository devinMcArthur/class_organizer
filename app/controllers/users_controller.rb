class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @courses = @user.courses.paginate(page: params[:page])
    @my_courses = Course.where(admin_id: @user.id)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account (email may take a few minutes to arrive, or may be sorted into your junk folder)"
      if @user.is_professor?
        flash[:success] = "You have been recognized as a Professor, if you are a student it can be changed in Profile Settings"
        @user.update_attribute(:professor, true)
      end
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      #Handle the successful update
      flash[:success] = "Profile successfully updated!"
      redirect_to @user
    else
      # Refresh edit page on unsuccessful update
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Deleted"
    redirect_to users_url
  end
  
  private
    
    # This is used to prevent users from passing raw paramaters in a web request, but will always require the :user attribute
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :moodle_username, :moodle_password)
    end
    
    # Confirms a logged in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in to continue"
        redirect_to login_url
      end
    end
    
    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
