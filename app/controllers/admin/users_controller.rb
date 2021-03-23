class Admin::UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
  end

  # ユーザーインスタンスを作成
  def new
    @user = User.new
  end

  # ユーザーを作成
  # return [User] saveされた時作成されたユーザーのshow.html.erbにリダイレクト
  # return [nil] saveされなかった時new.html.erbにレンダリング
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:succcess] = 'ユーザーが作成されました'
      redirect_to admin_user_path(@user)
    else
      flash[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  # 対象ユーザーを取得する
  # return [user]
  def edit
    @user = User.find(params[:id])
  end

  # 対象ユーザーの値を変更する
  # return [User] updateされた時作成されたユーザーのshow.html.erbにリダイレクト
  # return [nil] updateされなかった時edit.html.erbにレンダリング
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:succcess] = 'ユーザーが編集されました'
      redirect_to admin_user_path(@user)
    else
      flash[:danger] = 'ユーザーの編集に失敗しました'
      render :edit
    end
  end

  # 対象ユーザーの削除
  # @return [nil]
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = 'ユーザーが削除されました'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
