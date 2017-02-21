Dialog = require './dialog'

module.exports =
class CommitDialog extends Dialog
  @content: ->
    @div class: 'dialog', =>
      @div class: 'heading', =>
        @i class: 'icon x clickable', click: 'cancel'
        @strong 'Commit'
      @div class: 'body', =>
        @label 'Commit Message'
        @textarea class: 'native-key-bindings', outlet: 'msg', keyUp: 'commitMessageUpdate'
        @select class: 'native-key-bindings', outlet: 'messageSelection', change: 'messageSelectionUpdate'
      @div class: 'buttons', =>
        @button class: 'active', outlet: 'commitButton', click: 'commit', =>
          @i class: 'icon commit'
          @span 'Commit'
        @button click: 'cancel', =>
          @i class: 'icon x'
          @span 'Cancel'

  activate: (lastCommitMessages) ->
    @msg.val('')
    @checkForEmptyMessage()
    @initMessageSelection(lastCommitMessages)
    return super()

  initMessageSelection: (lastCommitMessages) ->
    @messageSelection.html('')
    @messageSelection.append('<option disabled selected hidden>&lt;Choose a previously entered commit message&gt;</option>')

    if (lastCommitMessages?)
      @messageSelection.prop('disabled', false)
    else
      @messageSelection.prop('disabled', true)
      return

    for currentMessage in lastCommitMessages when currentMessage.length
      option = document.createElement("option")
      option.text = currentMessage
      @messageSelection.append(option)
    return

  colorLength: ->
    too_long = false
    for line, i in @msg.val().split("\n")
      if (i == 0 && line.length > 50) || (i > 0 && line.length > 80)
        too_long = true
        break

    if too_long
      @msg.addClass('over-fifty')
    else
      @msg.removeClass('over-fifty')
    return

  checkForEmptyMessage: ->
    if atom.config.get("git-control.allowEmptyMessage")
      return

    if !@msg.val() or @msg.val().replace(/^\s+/g, '').length == 0
      @commitButton.prop('disabled', true)
    else
      @commitButton.prop('disabled', false)
    return

  commitMessageUpdate: ->
    @colorLength()
    @checkForEmptyMessage()
    return

  messageSelectionUpdate: ->
    @msg.val(@messageSelection.find('option:selected').text())
    @commitMessageUpdate()
    return

  commit: ->
    @deactivate()
    @parentView.commit()
    return

  getMessage: ->
    return "#{@msg.val()} "
