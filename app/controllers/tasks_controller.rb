class TasksController < ApplicationController

  # 全てのタスクを取得する
  # @return [Array<Task>]
  def index
    @tasks = Task.all
  end

  # 選択したタスクを取得する
  # @param [id] 選択したタスクのid
  # @return [Task] 選択したidのタスク
  def show
    @task = Task.find(params[:id])
  end
end
