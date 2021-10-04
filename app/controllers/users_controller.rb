class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @posts = User.find(@user.id).posts

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

  end

  def check
    @umail = params[:email]
    @upass = params[:pass]
    @allusers = User.all
    @found = false
    puts @upass
    @allusers.each do |u|
      if @umail == u.email && @upass == u.pass
          redirect_to user_path(u.id), notice: "User login."
          @found = true
      end
    end
    if @found == false
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
      @post.user_id = params[:user_id]
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
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :pass, :name, :address, :postal_code)
    end
    def post_params
      params.require(:post).permit(:user_id, :msg)
    end
end


