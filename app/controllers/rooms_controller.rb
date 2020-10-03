class RoomsController < ApplicationController
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

  private

  def room_params
    params.require(:room).permit(:name, user_ids: [])
  end
end
