class ConversationsController < ApplicationController

	before_action :authenticate_user!

  def index
   @users = User.all  
   @conversations = Conversation.all
  end

  def create
  	#該当のユーザ間での会話が過去に存在しているかを確認する式です
   if Conversation.between(params[:sender_id], params[:recipient_id]).present?
    #その会話を取得
    #betweenメソッドについては、後でモデルに定義します。
    @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
    	#過去に一件も存在しなかった場合、
    	#強制的にメッセージを生成
    	#そのためにストロングパラメータconversasion_paramsを使います。
     @conversation = Conversation.create!(conversation_params)
   end
   #いずれの状態であってもその後その会話に紐づくメッセージの一覧画面へ遷移させる式です。
    redirect_to conversation_messages_path(@conversation)
  end


  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
