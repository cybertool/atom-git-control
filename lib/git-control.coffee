GitControlView = require './git-control-view'
{CompositeDisposable} = require 'atom'
git = require './git'

CMD_TOGGLE = 'git-control:toggle'
EVT_SWITCH = 'pane-container:active-pane-item-changed'

views = []
view = undefined
pane = undefined
item = undefined

module.exports = GitControl =

  activate: (state) ->
    console.log 'GitControl: activate'

    atom.commands.add 'atom-workspace', CMD_TOGGLE, => @toggleView()
    atom.commands.add '.diff', 'git-control:copy': (event) ->
      if (window.getSelection)
        atom.clipboard.write(window.getSelection().toString())

    atom.workspace.onDidChangeActivePaneItem (item) => @updateViews()
    atom.project.onDidChangePaths => @updatePaths()
    return

  deactivate: ->
    console.log 'GitControl: deactivate'
    return

  toggleView: ->
    console.log 'GitControl: toggle'

    unless view and view.active
      view = new GitControlView()
      views.push view

      pane = atom.workspace.getActivePane()
      item = pane.addItem view, {index: 0}

      pane.activateItem item
      view.compareMenuClick()
    else
      pane.destroyItem item

    return

  updateViews: ->
    activeView = atom.workspace.getActivePane().getActiveItem()
    for v in views when v is activeView
      v.update()
    return

  updatePaths: ->
    # when projects paths changed restart within 0
    git.setProjectIndex(0);
    return

  serialize: ->

  config:
    showGitFlowButton:
      title: 'Show GitFlow button'
      description: 'Show the GitFlow button in the Git Control toolbar'
      type: 'boolean'
      default: true
    noFastForward:
      title: 'Disable Fast Forward'
      description: 'Disable Fast Forward for default at Git Merge'
      type: 'boolean'
      default: false
    allowEmptyMessage:
      title: 'Allow Empty Message'
      description: 'Allows you to create a commit with an empty commit message'
      type: 'boolean'
      default: true
    gitCustomPath:
      title: 'Git path'
      description: 'Git executable location for custom installation'
      type: 'string'
      default: ''
