class Conversation < ActiveRecord::Base
	#会話の受け手がユーザモデルから参照できるようにアソシエーションを設定
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  #会話は複数のメッセージを保有し、会話が削除されたらメッセージも削除する
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  #送り手は受け手と重複しないことを制御しチェックする
  has_many :messages, dependent: :destroy
  #validates_uniqueness_of は、属性の値が一意であることを検証するメソッドです
 #チェックする仕組みとして送り手と受け手の「組み合わせ」で判定する

  validates_uniqueness_of :sender_id, scope: :recipient_id
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end

end
