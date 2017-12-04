class EpicenterController < ApplicationController
  def feed
    following_user_ids = current_user.following + [current_user.id]
    @following_tweets = Tweet.where(user_id: following_user_ids)
	end

  def show_user
  	@user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    redirect_to :root
  end

  def all_users
    @users = User.all
  end

  def now_following
  # We are adding the user.id of the user you want to 
  # follow to your following array.
  # and we want to make sure it's saved in there as an integer
  current_user.following.push(params[:id].to_i)
  current_user.save
  current_user.update(following: current_user.following.push(params[:id].to_i))

  redirect_to show_user_path(id: params[:id])
  end

  def following
    @user = User.find(params[:id])
    @users = []

    User.all.each do |user|
      if @user.following.include?(user.id)
        @users.push(user)
      end
    end
  end

  def followers
    @user =  User.find(params[:id])
    @users = []

    User.all.each do |user|
      if user.following.include?(@user.id)
        @users.push(user)
      end
    end
  end

  def unfollow
    current_user.following.delete(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end

  def tag_tweets
    @tag = Tag.find(params[:id])
  end
end
