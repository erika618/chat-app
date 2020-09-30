class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # このメソッドによるログインしていないユーザーをログインページの画面に促すことができる。（deviseのメソッド）authenticate_user!自体がログインしていなければ、そのユーザーをログイン画面に遷移させるため、ビフォーアクションで定義することによって下記に記載するアクションを実行する前に行うことができる。
  before_action :configure_permitted_parameters, if: :devise_controller?
  # deviseのコントローラーから呼び出された場合は、configure_permitted_parametersメソッドが呼ばれる。他のカラム情報をDBに保存する場合は、ストロングパラメーターの設定が別途必要なため。

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # ユーザー登録をする場合に使用できる。「特定のカラムを許容するメソッド」。「name」キーの内容の保存をpermitメソッドで許可している。
  end
end
