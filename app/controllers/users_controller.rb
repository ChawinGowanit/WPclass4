class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in, except: %i[ login check invalid ]
  before_action :check_permission, only: %i[edit update destroy] 
  before_action :check_post_permission, only: %i[newpost addpost editpost deletepost] 
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @posts = User.find(@user.id).posts
    if (logged_in)
      @posts = User.find(@user.id).posts
    else
      return
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_fast
      uname = params[:name]
      umail = params[:email]
      upass = params[:pass]
      uaddress = params[:address]
      upost = params[:postal_code]

      @user = User.create(name:uname,email:umail,address:uaddress,postal_code:upost,pass:upass)

  end


  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
  end

  def login
    session[:user_id] = nil
  end

  def check
    @umail = params[:email]
    @upass = params[:pass]
    @u = User.find_by(email:@umail)
    @check = false
    if @u && @u.authenticate(@upass)
          redirect_to user_path(@u.id), notice: "User login."
          session[:user_id] = @u.id
          check = true
    end
    if check == false
      render :_invalid
    end
  end

  def invalid
  end

  def newpost
    @post = Post.new()
    @post.user_id = params[:user_id]
  end
  def addpost
      @post = Post.new(post_params)
      if @post.save
        redirect_to user_url(@post.user_id), notice: "Post was successfully created."
      end
  end
    
  def editpost
      @user = User.find(params[:user_id])
      @post = @user.posts.find(params[:post_id])
  end
    
  def updatepost
      @user = User.find(params[:user_id])
      @post = @user.posts.find(params[:post_id])
      @post.update(post_params)
      redirect_to user_url(@user.id), notice: "Edit post successfully."
  end
    
  def deletepost
      @user = User.find(params[:user_id])
      @post = @user.posts.find(params[:post_id])
      @post.destroy()
      redirect_to user_url(@user.id), notice: "Delete post successfully."
  end

  private
    def logged_in
      if (session[:user_id])
        return true
      else
        redirect_to main_path, notice: "Please login."
      end
    end

    def check_permission
      if (@user.id == session[:user_id])
        return true
      else
        redirect_to "/users", notice: "You cant Edit/Update/Destroy other users."
      end
    end

    def check_post_permission
      @user = User.find(params[:user_id])
      if (@user.id == session[:user_id])
        return true
      else
        redirect_to user_url(@user.id), notice: "You cant Create/Edit/Update/Destroy other users posts."
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :name, :address, :postal_code)
    end
    def post_params
      params.require(:post).permit(:user_id, :msg)
    end
end


