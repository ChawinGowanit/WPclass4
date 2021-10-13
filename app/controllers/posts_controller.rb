class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :logged_in, only: %i[index]
  before_action :check_permission, only: %i[edit update destroy] 
  before_action :check_new_post, only: %i[create] 


  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    if(session[:user_id]!= nil)
      @post.user_id = Integer(session[:user_id])
      @user = User.find(Integer(session[:user_id]))
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @user = User.find(Integer(session[:user_id]))

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
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
      if (@post.user.id == session[:user_id])
        return true
      else
        redirect_to "/posts", notice: "You can't Edit/Destroy other users posts."
      end
    end

    def check_new_post
      if (Integer(post_params["user_id"])!= session[:user_id])
        redirect_to "/posts", notice: "You can't Create other users posts."
      else
        return true
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:msg, :user_id)
    end
end
