'use strict'

angular.module('remitano').factory "ngWatchCounter", ->

  # I return the count of watchers on the current page.
  getWatchCount = ->
    total = 0

    # AngularJS denotes new scopes in the HTML markup by appending the
    # class "ng-scope" to appropriate elements. As such, rather than
    # attempting to navigate the hierarchical Scope tree, we can simply
    # query the DOM for the individual scopes. Then, we can pluck the
    # watcher-count from each scope.
    # --
    # NOTE: Ordinarily, it would be a HUGE SIN for an AngularJS service
    # to access the DOM (Document Object Model). But, in this case,
    # we're not really building a true AngularJS service, so we can
    # break the rules a bit.
    # angular.element(".ng-scope")
    angular.elements = {}
    for element in document.querySelectorAll(".ng-scope")
      # Get the scope associated with this element node.
      scope = angular.element(element).scope()
      # The $$watchers value starts out as NULL.
      if scope.$$watchers
        total += scope.$$watchers.length
        key = "#{element.tagName}.#{element.className.replace(" ", ".")}"
        key = "#{key}-#{element.attributes["ng-repeat"].value}" if element.attributes["ng-repeat"]
        angular.elements[key] = {count: 0, elements: []} unless angular.elements[key]
        angular.elements[key].count += scope.$$watchers.length
        angular.elements[key].elements.push element
    total

  getWatchCount

