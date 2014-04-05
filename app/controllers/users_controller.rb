class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    if !session[:user_logged_in].nil? and User.find_by_id(session[:user_logged_in]).usertype == 1
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path}
      end
    end
  end

  def reports
    posts = Post.all
    @displayarray = Hash.new
    posts.each do |curpost|
        votes = Vote.find_all_by_post_id(curpost.id)
        count = votes.size.to_s

        @displayarray[curpost.title] = [count,User.find_by_id(curpost.user_id).fname]
    end

    users = User.all
    @userarray = Hash.new
    users.each do |curuser|
        votesreceived = Vote.find_all_by_user_id(curuser.id).size
        commentsmade = Comment.find_all_by_user_id(curuser.id).size
        postsposted = Post.find_all_by_user_id(curuser.id).size
        @userarray[curuser.id] = [curuser.fname+" "+curuser.lname,postsposted,votesreceived,commentsmade]
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    if (!session[:user_logged_in].nil? and (@user.id == session[:user_logged_in] or User.find_by_id(session[:user_logged_in]).usertype == 1))
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      respond_to do |format|
        format.html #show.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user.usertype = params[:usertype]
    if (!session[:user_logged_in].nil? and (@user.id == session[:user_logged_in] or User.find_by_id(session[:user_logged_in]).usertype == 1))
      respond_to do |format|
        format.html #show.html.erb
        format.json { render json: @user }
      end
    else
      respond_to do |format|
        format.html { redirect_to posts_path}# show.html.erb
        format.json { render json: @user }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    if session[:user_logged_in] != nil and User.find_by_id(session[:user_logged_in]).usertype == 1
      @user.usertype= 1
    else
      @user.usertype= 0
    end
    respond_to do |format|
      if @user.save
        #format.html { redirect_to @user, notice: 'User was successfully created. Please Login' }
        #flash[:message]= "User was successfully created. Please Login"
        #format.html { redirect_to root_url }
        #redirect_to root_url
        format.html { redirect_to root_url, notice: 'User was successfully created. Please Login' }
        format.json { head :ok }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  def login
    if request.post?
      if (user = User.sign_in(params[:email],params[:password]))
        session[:user_logged_in] = user.id
        flash[:notice] = "Welcome back #{user.fname} #{user.lname}!"
        redirect_to :controller => 'users', :action => 'myhome'
      else
        flash[:error] = "Wrong username or password"
        redirect_to root_url
      end
    end
  end

  def myhome

  end

  def logout
    session[:user_logged_in] = nil
    redirect_to new_user_path
  end
end
