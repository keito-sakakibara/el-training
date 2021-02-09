class TasksController < ApplicationController

  # 全てのタスクを取得する
  # @return [Array<Task>]
  def index
    @tasks = Task.all
  end

  # 対象タスクを取得する
  # param [Integer] 対象タスクのID
  # return [Object<Task>]
  def show
    @task = Task.find(params[:id])
  end

  def new 
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:succcess] = "タスクが作成されました"
      redirect_to @task
    else
      flash[:danger] = "タスクの作成に失敗しました"
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:succcess] = "タスクが編集されました"
      redirect_to @task
    else
      flash[:danger] = "タスクの編集に失敗しました"
      render :edit
    end
  end

  # 対象タスクの削除
  # param [Integer] 対象タスクのID
  # return [nill]
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  
    flash[:success] = 'タスクが削除されました'
    redirect_to tasks_path
  end
  private

  def task_params
    params.require(:task).permit(:name,:detail)
  end
end
