module SessionsHelper
  # 現在ログイン中のユーザーを返す（いる場合）
  # @return [User] ログインしているユーザーとidが一致するユーザー
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
