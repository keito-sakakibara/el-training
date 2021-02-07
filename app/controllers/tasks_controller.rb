class TasksController < ApplicationController
  
　# @tasksに全てのタスクを
  def index
    @tasks = Task.all
  end

  #railsから送られてきたidをもとに一つのタスクを検索し@taskに
  def show
    @task = Task.find(params[:id])　#　idを引数で受け取る
  end
end
