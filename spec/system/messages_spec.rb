require 'rails_helper'

RSpec.describe "メッセージ投稿機能", type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
    # room_users.rbに定義したFactoryBotのassociationメソッドによるもの。
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗すること' do
      # サインインする
      # （@room_userに紐づくuserが生成されているため、@room_user.userというアソシエーションの記述で取得できる）
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      # （最終的にnameカラムの値を取得しclick_onメソッドの引数にして、チャットルームの名前のリンクをクリックしている）
      click_on(@room_user.room.name)

      # DBに保存されていないことを確認する
      expect{
        find('input[name="commit"]').click
      }.not_to change { Message.count }

      # 元のページに戻ってくることを確認する
      expect(current_path).to eq  room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

    end
    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する（Rails.rootとすると、このRailsアプリケーションのトップ階層のディレクトリまでの絶対パスを取得できる。パスの情報に対してjoinメソッドを利用することで、引数として渡した文字列でのパス情報を、Rails.rootのパスの情報にくっつけることができる。）
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)
      # タイプがfileのinput要素、つまり画像などのアップロード用のinput要素に、画像投稿のテスト用の画像を仕込む(アタッチする)ことができるメソッド
      # 第一引数に画像をアップロードするinput要素のname属性の値、第二引数にアップロードする画像のパス、第三引数以降にはオプション
      # make_visible: trueを付けることで非表示になっている要素も一時的に hidden でない状態になる。
      # ちなみにfixture_file_uploadメソッドはインスタンスに画像ファイルをセットするメソッド
      
      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)
      
      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)
      
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
      
    end
    it 'テキストと画像の投稿に成功すること' do
      # サインインする
      sign_in(@room_user.user)
      
      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)
      
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      
      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)     

      # 値をテキストフォームに入力する
      post = "テスト"
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Message.count }.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
      # have_selectorで確認することで、一覧表示画面に遷移出来ているかどうかが確認できるため,current_pathは入れていない

    end
  end
end
