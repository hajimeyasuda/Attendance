module SessionsHelper
  
   # 引数に渡されるユーザーオブジェクトでログインする。
  def log_in(user)
    session[:user_id] = user.id
  end
  # この定義でログインをしてcreateアクション、そしてリダイレクトする準備完了
  
  # 永続的セッションを記憶する（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する。
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # session @current_userを破棄する
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
    
  # 一時的セッション、それ以外の場合はcookiesに対応するユーザーを返す。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_tokem])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返す。
  def current_user?(user)
    user == current_user
  end
  
  # ログイン中のユーザーがいればtrue、そうでないならfalesを返す。
  def logged_in?
    !current_user.nil?
  end
  
end
