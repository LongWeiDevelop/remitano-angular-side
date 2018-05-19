"use strict"

angular.module "remitano"
.config (AccessLevels, $stateProvider) ->
  $stateProvider
  .state "root.article",
    url: "/articles/{id:[a-zA-Z0-9-]+}"
    templateUrl: "articles/show.tmpl.html"
    controller: "ArticleShowController"
    controllerAs: "vm"
