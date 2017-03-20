{View} = require 'space-pen'
git = require '../git'

module.exports =
class TestView extends View
    @content: ->
        @div =>
            @div class: 'block panel', =>
                @div =>
                  @div class: 'text-subtle', outlet: 'gitVersion'
                @div class: 'btn-group btn-group-sm', =>
                  @button class: 'btn selected', 'Console'
                  @button class: 'btn', disabled: 'true', 'History'
                @div =>
                  @button class: 'btn btn-sm icon icon-x', outlet: 'clearConsole', click: 'clearConsoleClick'

    initialize: () ->
      atom.tooltips.add(@clearConsole, {title: 'Clear console'})
      git.version().then (version) =>
        [firstLine] = version
        @gitVersion.text(firstLine)
      return

    clearConsoleClick: ->
      @parentView.clearLog()
      return
