class MainController < ApplicationController

	def main
		umail = params[:email]
		upass = params[:pass]
      	@user = User.find_by email: umail , pass:upass
      	respond_to do |format|
      		if @user
        		format.html { redirect_to "/main/show?email=#{umail}&pass=#{upass}", notice: "User Log In." }
        		format.json { render :show, status: :created, location: @user }
      		else
        		format.html { render :main, status: :unprocessable_entity}
        		format.json { render json: main.errors, status: :unprocessable_entity }
      		end
		end
	end

	def show
		umail = params[:email]
		upass = params[:pass]
		@suser = User.find_by email: umail , pass:upass
		@up = @suser.posts
	end

end
