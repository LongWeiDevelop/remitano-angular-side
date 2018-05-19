'use strict'

angular.module 'remitano'
.config ($stateProvider, AccessLevels) ->
  $stateProvider.state 'root.apps_download',
    url: '/mobile_apps'
    templateUrl: 'apps_download/apps_download.tmpl.html'
    controller: "AppsDownloadController"
    controllerAs: "vm"
    data:
      title: 'cano_title_root_apps_download'
