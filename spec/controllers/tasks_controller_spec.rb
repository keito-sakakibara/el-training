require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#index" do
    it "正常なレスポンスか" do
      get :index
      expect(response).to be_success
    end
    # 200レスポンスが返ってきているか？
    it "200レスポンスが返ってきているか" do
      get :index
      expect(response).to have_http_status "200"
    end
    it "taskのカウント数があっているか" do
      task1 = create(:task1)
      task2 = create(:task2)
      expect(Task.count).to eq(2)
    end
  end
end
