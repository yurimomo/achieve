class BlogsController < ApplicationController
  
  before_action :set_blog, only: [:show, :edit, :update, :destroy
  ]
  before_action :authenticate_user!
  
  def index
    @blogs = Blog.all
    respond_to do |format|
    format.html
    format.js
  end

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

  # showアククションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
  def show
    @comment = @blog.comments.build
    @comments = @blog.comments
    # ヘッダーの通知がリアルタイム
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]

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
