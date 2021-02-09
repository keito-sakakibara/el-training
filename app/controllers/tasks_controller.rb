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

  # タスクを作成
  def new 
    @task = Task.new
  end

  # タスクを作成
  # param [Object<name,detail>] nameとdetailのみ
  # return [Object<Task>] saveされた時作成されたタスクのshow.html.erbにリダイレクト
  # return [nill] saveされなかった時new.html.erbにレンダリング
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

  # 対象タスクを取得する
  # param [Integer] 対象タスクのID
  # return [Object<Task>]
  def edit
    @task = Task.find(params[:id])
  end

  # 対象タスクの値を変更する
  # param [Integer] 対象タスクのID
  # param [Object<name,detail>] nameとdetailのみ
  # return [Object<Task>] updateされた時作成されたタスクのshow.html.erbにリダイレクト
  # return [nill] updateされなかった時edit.html.erbにレンダリング
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

  # 対象タスクを削除
  # param [Integer] 対象タスクのID
  # return [nill] 削除されたため
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:succcess] = "タスクが削除されました"
    redirect_to tasks_path
  end

  private
  # paramにname,detailのみ渡す
  # param [Object<name,detail>] nameとdetailのみ
  def task_params
    params.require(:task).permit(:name,:detail)
  end
end
