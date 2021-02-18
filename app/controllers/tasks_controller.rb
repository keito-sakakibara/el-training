# frozen_string_literal: true

class TasksController < ApplicationController
  # 全てのタスクを取得する
  # @return [Array<Task>]
  def index
    @deadline_sort = params[:deadline_date_sort]
    @tasks = Task.deadline_sort(@deadline_sort)
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
    @task = Task.new(task_params)

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
    params.require(:task).permit(:name, :detail, :deadline_date)
  end
end
