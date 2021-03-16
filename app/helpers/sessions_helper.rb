module SessionsHelper
  # 渡されたユーザーでログインする
  # @param [User] Objact フォームに送られたメールアドレスと一致するユーザー
  # @return [hash] session[:user_id]
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  # @return [User] ログインしているユーザーとidが一致するユーザー
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # @return [Boolean] True @current_userの値がnilではない
  # @return [Boolean] False @current_userの値がnil

  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  #  @return [nil]
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
