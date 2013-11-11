class API < Grape::API
  prefix "api"
  version 'v1', :using => :path
  format :json

  helpers do
    def task_params
      ActionController::Parameters.new(params).permit(:name, :memo, :status)
    end
  end

  resource :tasks do
    desc "returns all tasks"
    get do
      Task.all.order(:id)
    end

    desc "return a task"
    params do
      requires :id, type: Integer
    end
    get ':id' do
      Task.find(params[:id])
    end

    # TODO use strong parameter
    desc 'create a task'
    params do
      requires :name, type: String
    end
    post do
      Task.create(task_params.merge(status: 'todo'))
    end

    desc 'update a task'
    params do
      requires :id, type: Integer
    end
    put ":id" do
      Task.find(params[:id]).update(task_params)
    end

    desc 'delete a task'
    params do
      requires :id, type: Integer
    end
    delete ':id' do
      Task.find(params[:id]).destroy
    end
  end
end