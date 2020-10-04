class MessagesController < ApplicationController
  
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
# @roomには、Room.find(params[:room_id])と記述することで、paramsに含まれているroom_idを代入します。
# 紐解いて説明すると、直前の問題にあった通りルーティングをネストしているため/rooms/:room_id/messagesといったパスになります。
# パスにroom_idが含まれているため、paramsというハッシュオブジェクトの中に、room_idという値が存在しています。そのため、params[:room_id]と記述することでroom_idを取得できます。
    @messages = @room.messages.includes(:user)
    # メッセージに紐付くユーザー情報の取得に、メッセージの数と同じ回数のアクセスが必要になり、N+1問題が発生するため防ぐ
  end
  
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    @message.save
    # @room.messages.newでチャットルームに紐づいたメッセージのインスタンスを生成し、message_paramsを引数にして、privateメソッドを呼び出す。その値を@messageに代入し、saveメソッドでメッセージの内容をmessagesテーブルに保存
    if @message.save
      redirect_to room_messages_path(@room)
      # （参加しているチャットルームに投稿したメッセージの一覧画面）にリダイレクト
    else
      @messages = @room.messages.includes(:user)
      render :index
      # 投稿に失敗したときの処理にも、同様に@messagesを定義。renderを用いることで、投稿に失敗した@messageの情報を保持しつつindex.html.erbを参照できる（この時、indexアクションは経由しない）。しかし、そのときに@messagesが定義されていないとエラーになる。そこで、indexアクションと同様に@messagesを定義する必要あり。
    end
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(user_id: current_user.id)
    # メッセージの内容(content)をmessagesテーブルへ保存できるようにする。パラメーターの中に、ログインしているユーザーのidと紐付いている、メッセージの内容(content)を受け取れるように許可。
  end

end
