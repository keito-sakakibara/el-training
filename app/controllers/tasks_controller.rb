# frozen_string_literal: true

class TasksController < ApplicationController
  # 全てのタスクを取得する
  # @return [Array<Task>]
  def index
    @statuses = Status.all
    tasks_name = params[:name]
    status_id = params[:status_id]
    if tasks_name.present? && status_id.present? 
      @tasks = Task.search_status_id(status_id).search_task_name(tasks_name)
    elsif status_id.present?
      @tasks = Task.search_status_id(status_id)
    elsif params[:deadline_date_sort_type].present?
      @tasks = Task.all.order(deadline_date: params[:deadline_date_sort_type])
    else
      @tasks = Task.all.order(created_at: :desc)
    end
    
  end

  # 対象タスクを取得する
  # @return [Task]
  def show
    @task = Task.find(params[:id])
  end

  # タスクインスタンスを作成
  def new
    @task = Task.new
    @statuses = Status.all
    @task.build_status
  end

  # タスクを作成
  # return [Task] saveされた時作成されたタスクのshow.html.erbにリダイレクト
  # return [nil] saveされなかった時new.html.erbにレンダリング
  def create
    @task = Task.new(task_params)
    @task.status_id = params[:task][:status_id].to_i
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
    params.require(:task).permit(:name, :detail, :deadline_date, :status_id )
  end
end
