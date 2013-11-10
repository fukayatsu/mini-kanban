# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.TodoCtrl = ($scope, $http) ->
  $scope.sort = null
  $scope.statusFilter = null
  $scope.tasks = []
  $scope.editingTask = null
  $scope.originalTask = null

  # load tasks
  $http({method: 'GET', url: '/api/v1/tasks'})
    .success (tasks, status, headers, config) ->
      $scope.tasks = tasks
    .error (data, status, headers, config) ->
      console.log 'cannot load tasks'

  # ng {'class' => "{{activeIf('filter', 'todo')}}"} # with space
  # ok {'class' => "{{activeIf('filter','todo')}}"}  # no space
  $scope.activeIf = (key,value) ->
    if value == $scope[key] then 'active' else ''

  $scope.setSort = (sort) ->
    $scope.sort = if $scope.sort == sort then '' else sort

  $scope.sortOrder = (task) ->
    if $scope.sort == 'status'
      ['todo', 'doing', 'done'].indexOf(task.status)
    else
      0

  $scope.setStatusFilter = (status) ->
    $scope.statusFilter = if $scope.statusFilter == status then  '' else status


  $scope.countStatus = (status) ->
    counts = _.countBy($scope.tasks, 'status')
    counts[status] || 0

  $scope.addTask = () ->
    $http({method: 'POST', url: '/api/v1/tasks', data: { name: $scope.taskName } })
      .success (task, status, headers, config) ->
        $scope.tasks.push task
        $scope.taskName = ''
      .error (data, status, headers, config) ->
        console.log 'cannot create task'

  $scope.removeTask = (task) ->
    $http({method: 'DELETE', url: "/api/v1/tasks/#{task.id}"})
      .success (tasks, status, headers, config) ->
        $scope.tasks.splice($scope.tasks.indexOf(task), 1)
      .error (data, status, headers, config) ->
        console.log 'cannot delete task'

  $scope.editTask = (task) ->
    $scope.editingTask  = task
    $scope.originalTask = angular.extend({}, task);

  $scope.doneEditingTask = (task) ->
    $http({method: 'PUT', url: "/api/v1/tasks/#{task.id}", data: {name: task.name, status: task.status}})
      .success ->
        $scope.editingTask = null
      .error ->
        console.log 'cannot update task'


  $scope.nextStatus = (task) ->
    status = task.status
    task.status = {
      todo: 'doing',
      doing: 'done',
      done: 'todo'
    }[status]

    $http({method: 'PUT', url: "/api/v1/tasks/#{task.id}", data: {name: task.name, status: task.status}})
      .error ->
        console.log 'cannot update task'
        task.status = status
