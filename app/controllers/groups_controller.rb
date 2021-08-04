class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @group_user = GroupUser.new
    @group_owner = User.find(@group.owner_id)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end
  
  def join
  @group = Group.find_by(id: params[:id])
     if !@group.users.include?(current_user)
      @group.users << current_user
      redirect_to group_path(@group)
     end
  end
  
  def leave
  @group = Group.find_by(id: params[:id])
    if @group.users.include?(current_user)
    @group.users.delete(current_user)
    redirect_to group_path(@group)
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    if @group.users.count != 0
      ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
    else
      redirect_to users_path
    end
  end
  
  

  private
  
  
  

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
