# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
kanbanApp = angular.module('kanbanApp', ['ngRoute'])
  .config ($routeProvider, $locationProvider) ->
    # $routeProvider
    #   .when('/tasks',     { controller: 'TasksCtrl', templateUrl: '/template/tasks/index'})
    #   .when('/tasks/:id', { controller: 'TasksCtrl', templateUrl: '/template/tasks/show'})

    # $locationProvider.html5Mode(true).hashPrefix('!');


kanbanApp.controller('TasksCtrl', ['$scope', '$http', '$location', '$route', '$routeParams', ($scope, $http, $location, $route, $routeParams) ->
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

  $scope.setSort = (sort) ->
    $scope.sort = if $scope.sort == sort then '' else sort

  $scope.sortOrder = (task) ->
    if $scope.sort == 'status'
      ['todo', 'doing', 'done'].indexOf(task.status)
    else
      task.id

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
    $http({method: 'PUT', url: "/api/v1/tasks/#{task.id}", data: task})
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

    $http({method: 'PUT', url: "/api/v1/tasks/#{task.id}", data: task})
      .error ->
        console.log 'cannot update task'
        task.status = status
])