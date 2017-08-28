class BlogsController < ApplicationController
  
  before_action :set_blog, only: [:edit, :update, :destroy
  ]
  before_action :authenticate_user!
  
  def index
    @blogs = Blog.all
    raise
  end
  
  def new
    if params[:back]
    @blog = Blog.new(blogs_params)
  else
    @blog = Blog.new
    end
  end
  
  def create
    @blog = Blog.new(blogs_params)
    @blog.user_id = current_user.id
    @blog.user_name = current_user.name
    if @blog.save
    redirect_to blogs_path, notice: "ブログを作成しました！"
    NoticeMailer.sendmail_blog(@blog).deliver
  else
    render 'new'
    end
  end
  
  def edit
    # redirect_to blogs_path, notice: "ブログを編集しました"
  end
  
  def update
    
    if @blog.update(blogs_params)
    redirect_to blogs_path, notice: "ブログを更新しました！"
  else
    render 'edit'
    end
  end
  
  def destroy
  
    @blog.destroy
    redirect_to blogs_path, notice: "ブログを削除しました"
    
  end
  
  def confirm
    @blog = Blog.new(blogs_params)
    render :new if @blog.invalid?
  end
  
  
  private
  def blogs_params
    params.require(:blog).permit(:title, :content)
  end
  
  def set_blog
    @blog = Blog.find(params[:id])
  end
  
end
