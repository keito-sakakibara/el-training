# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :request do
  let!(:user) { create(:user) }
  before do
    post login_path,
         params: { session: FactoryBot.attributes_for(:user, email: user.email, password: user.password) }
  end
  describe '#index' do
    subject { get tasks_path }

    let!(:task1) do
      create(:task, id: 1, name: 'task1', created_at: Time.current, deadline_date: Date.current + 3.days,
                    status: create(:status, id: 1), priority: create(:priority, id: 1), user_id: user.id)
    end
    let!(:task2) do
      create(:task, name: 'task2', created_at: Time.current + 1.hour, deadline_date: Date.current + 10.days,
                    status: create(:status, id: 2), priority: create(:priority, id: 2), user_id: user.id)
    end
    let!(:task3) do
      create(:task, name: 'task3', created_at: Time.current + 2.hours, deadline_date: Date.current + 7.days,
                    status: create(:status, id: 3), priority: create(:priority, id: 3), user_id: user.id)
    end

    let!(:label) { create(:label) }
    let!(:task_label_relationship) { create(:task_label_relationship, task: task1, label: label) }

    it 'リクエストが成功すること' do
      subject
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it '並び順が正しいこと' do
      subject
      expect(controller.instance_variable_get('@tasks')).to eq([task3, task2, task1])
    end

    it '締め切り日に近い順にソートが行われていること' do
      get tasks_path, params: { for_order_column: 'deadline_date', asc_or_desc: 'asc' }
      expect(controller.instance_variable_get('@tasks')).to eq([task1, task3, task2])
    end

    it '締め切り日に遠い順にソートが行われていること' do
      get tasks_path, params: { for_order_column: 'deadline_date', asc_or_desc: 'desc' }
      expect(controller.instance_variable_get('@tasks')).to eq([task2, task3, task1])
    end

    it '名前の検索が正しく行われていること' do
      get tasks_path, params: { name: 'task1' }
      expect(controller.instance_variable_get('@tasks')).to eq([task1])
    end

    it 'ステータスの検索が正しく行われていること' do
      get tasks_path, params: { status_id: 1 }
      expect(controller.instance_variable_get('@tasks')).to eq([task1])
    end

    it 'ラベルの検索が正しく行われていること' do
      get tasks_path, params: { label_ids: [1] }
      expect(controller.instance_variable_get('@tasks')).to eq([task1])
    end

    it '優先順位が高い順にソートが行われていること' do
      get tasks_path, params: { for_order_column: 'priority_id', asc_or_desc: 'asc' }
      expect(controller.instance_variable_get('@tasks')).to eq([task1, task2, task3])
    end

    it '優先順位が低い順にソートが行われていること' do
      get tasks_path, params: { for_order_column: 'priority_id', asc_or_desc: 'desc' }
      expect(controller.instance_variable_get('@tasks')).to eq([task3, task2, task1])
    end
  end

  describe '#show' do
    context 'タスクが存在する時' do
      let!(:task) { create(:task, user: user) }
      subject { get task_path task.id }

      it 'リクエストが成功すること' do
        subject
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'タスク名が表示されていること' do
        subject
        expect(response.body).to include 'task'
      end

      it '終了期限が表示されていること' do
        subject
        expect(response.body).to include '2021-02-18'
      end

      it 'ステータスが表示されていること' do
        subject
        expect(response.body).to include '着手'
      end

      it '優先順位が表示されていること' do
        subject
        expect(response.body).to include '高'
      end
    end

    context 'タスクが存在しない時' do
      subject { get task_path 5 }

      it '404エラーが発生すること' do
        subject
        expect(response.status).to eq 404
      end
    end
  end

  describe '#new' do
    subject { get new_task_path }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    let!(:task) { create(:task, user: user) }
    subject { get edit_task_path task }

    it 'リクエストが成功すること' do
      subject
      expect(response.status).to eq 200
    end

    it 'タスク名が表示されていること' do
      subject
      expect(response.body).to include 'name'
    end

    it '詳細が表示されていること' do
      subject
      expect(response.body).to include 'detail'
    end

    it '終了期限が表示されていること' do
      subject
      expect(response.body).to include '2021'
    end

    it 'ステータスが表示されていること' do
      subject
      expect(response.body).to include '着手'
    end

    it '優先順位が表示されていること' do
      subject
      expect(response.body).to include '高'
    end
  end

  describe '#create' do
    context 'パラメータが妥当な場合' do
      let(:status) { create(:status) }
      let(:priority) { create(:priority) }
      subject do
        post tasks_path,
             params: { task: FactoryBot.attributes_for(:task, status_id: status.id, priority_id: priority.id) }
      end

      it 'タスクが登録される' do
        expect do
          subject
        end.to change(Task, :count).by(1)
      end

      it 'リダイレクトされること' do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to Task.last
      end
    end

    context 'パラメータが不正な場合' do
      subject { post tasks_path, params: { task: FactoryBot.attributes_for(:task, name: nil) } }

      it 'タスクが登録されないこと' do
        expect do
          subject
        end.to_not change(Task, :count)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include 'タスクの作成に失敗しました'
      end
    end
  end

  describe '#update' do
    let!(:task) { create(:task, status: create(:status, :todo), priority: create(:priority), user_id: user.id) }

    context 'パラメータが妥当な場合' do
      let(:status) { create(:status) }
      let(:priority) { create(:priority, :medium) }
      subject do
        put task_path task,
                      params: { task: FactoryBot.attributes_for(:task, name: 'sample', detail: 'sample_detail', deadline_date: '2021-03-18',
                                                                       status_id: status.id, priority_id: priority.id) }
      end

      it 'タスク名が更新されること' do
        expect do
          subject
        end.to change { Task.find(task.id).name }.from('name').to('sample')
      end

      it '詳細が更新されること' do
        expect do
          subject
        end.to change { Task.find(task.id).detail }.from('detail').to('sample_detail')
      end

      it '終了期限が更新されること' do
        expect do
          subject
        end.to change { Task.find(task.id).deadline_date }.from(task.deadline_date).to('Thu, 18 Mar 2021'.to_date)
      end

      it 'ステータスが更新されること' do
        expect do
          subject
        end.to change { Task.find(task.id).status_id }.from(1).to(2)
      end

      it '優先順位が更新されること' do
        expect do
          subject
        end.to change { Task.find(task.id).priority_id }.from(1).to(2)
      end

      it 'リダイレクトすること' do
        subject
        expect(response.status).to eq 302
        expect(response).to redirect_to Task.last
      end
    end

    context 'パラメータが不正な場合' do
      subject do
        put task_path task,
                      params: { id: task.id,
                                task: FactoryBot.attributes_for(:task, name: nil, detail: nil, deadline_date: nil,
                                                                       status_id: nil, priority_id: nil) }
      end

      it 'タスク名が変更されないこと' do
        expect do
          subject
        end.to_not change(Task.find(task.id), :name)
      end

      it '詳細が変更されないこと' do
        expect do
          subject
        end.to_not change(Task.find(task.id), :detail)
      end

      it '締め切り日時が変更されないこと' do
        expect do
          subject
        end.to_not change(Task.find(task.id), :deadline_date)
      end

      it 'ステータスが変更されないこと' do
        expect do
          subject
        end.to_not change(Task.find(task.id), :status_id)
      end

      it '優先順位が変更されないこと' do
        expect do
          subject
        end.to_not change(Task.find(task.id), :priority_id)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include 'タスクの編集に失敗しました'
      end
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task, user: user) }
    subject { delete task_path task }

    it 'タスクが削除されること' do
      expect do
        subject
      end.to change(Task, :count).by(-1)
    end

    it 'タスク一覧にリダイレクトされること' do
      subject
      expect(response.status).to eq 302
      expect(response).to redirect_to(tasks_path)
    end
  end
end
