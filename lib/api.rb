class API < Grape::API
  prefix "api"
  version 'v1', :using => :path
  format :json

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
      Task.create(name: params[:name], status: 'todo')
    end

    desc 'update a task'
    params do
      requires :id, type: Integer
    end
    put ":id" do
      Task.find(params[:id]).update(name: params[:name], status: params[:status])
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