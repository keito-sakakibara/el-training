# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :logged_in_user
  # 全てのタスクを取得する
  # @return [Array<Task>]
  def index
    @tasks = Task.all.order(created_at: :desc)
    if params[:for_order_column].present?
      @tasks = Task.all.order([params[:for_order_column],
                               params[:asc_or_desc]].join(' '))
    end
    @tasks = @tasks.where(status_id: params[:status_id]) if params[:status_id].present?
    @tasks = @tasks.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    @tasks = @tasks.page(params[:page]).per(5)
  end

  # 対象タスクを取得する
  # @return [Task]
  def show
    @task = Task.find(params[:id])
  end

  # タスクインスタンスを作成
  def new
    @task = Task.new
  end

  # タスクを作成
  # return [Task] saveされた時作成されたタスクのshow.html.erbにリダイレクト
  # return [nil] saveされなかった時new.html.erbにレンダリング
  def create
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    @task = Task.new(task_params)
    @task = Task.find_by(user_id: @current_user.id)
    if @task.save
      flash[:succcess] = 'タスクが作成されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクの作成に失敗しました'
      render :new
    end
  end

  # 対象タスクを取得する
  # return [Task]
  def edit
    @task = Task.find(params[:id])
  end

  # 対象タスクの値を変更する
  # return [Task] updateされた時作成されたタスクのshow.html.erbにリダイレクト
  # return [nil] updateされなかった時edit.html.erbにレンダリング
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:succcess] = 'タスクが編集されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクの編集に失敗しました'
      render :edit
    end
  end

  # 対象タスクの削除
  # @return [nil]
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :detail, :deadline_date, :status_id, :priority_id, :user_id)
  end

  def logged_in_user
    redirect_to login_url unless current_user.present?
  end
end
