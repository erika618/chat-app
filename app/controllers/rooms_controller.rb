class RoomsController < ApplicationController
  
  def index
  end
  
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to root_path
    else
      render :new
    end
  end
  # 成功した場合はredirect_toメソッドでルートパスにリダイレクトし、失敗した場合はrenderメソッドでrooms/new.html.erbのページを表示

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to root_path
    # destroyアクションは、削除するだけなのでビューの表示は必要ない。そのため、インスタンス変数ではなく変数としてroomを定義し、destroyメソッドを使用。
  end 

  private

  def room_params
    params.require(:room).permit(:name, user_ids: [])
  end
end
