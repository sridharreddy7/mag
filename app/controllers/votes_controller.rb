class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  def index
    puts "Entered votes index"
    type = params[:type]
    id = params[:id]
    postid = params[:postid]
    if(type == "0") #id is that of a post
      @votes = Vote.find_all_by_post_id(id)
    elsif type == "1" #id is that of a comment
      @votes = Vote.find_all_by_comment_id(id)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])
    @vote.user_id = session[:user_logged_in]
    type = params[:type]

    if type == '0'
      @vote.post_id = params[:id]
    end
    if type == '1'
      @vote.comment_id = params[:id]
    end

    @posts = Post.find_all_by_id(params[:postid])
    if type == '0'
      votes = Vote.find_all_by_post_id(params[:id])
    elsif type == '1'
      votes = Vote.find_all_by_comment_id(params[:id])
    end
    userid = session[:user_logged_in]
    userpresent = false
    votes.each do |vote|
      if vote.user_id == userid
        userpresent = true
        break
      end
    end
    voteforself = false
    if type == '0'
      voteforself = session[:user_logged_in] == User.find_by_id(Post.find_by_id(params[:id]).user_id).id
    elsif type == '1'
      voteforself =  session[:user_logged_in] ==  User.find_by_id(Comment.find_by_id(params[:id]).user_id).id
    end
    if voteforself == true
      displaystring = "You cannot vote for your own post/comment"
    end
    if userpresent == true
         #Don't vote
         displaystring = "You have already voted!"
    elsif userpresent == false and voteforself == false
      @vote.save
      displaystring = "Vote was successfully created."
    end

      respond_to do |format|
          format.html { redirect_to @posts, notice: displaystring }
          format.json { render json: @vote, status: :created, location: @vote }
      end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end
end
