# BEGIN HELPERS

# Log to the dom instead of console (to work on phone)
baseLogFunction = console.log
createLogNode = (message) ->
  node = document.createElement('div')
  textNode = document.createTextNode(message)
  node.appendChild textNode
  node
console.log = ->
  baseLogFunction.apply console, arguments
  args = Array::slice.call(arguments)
  i = 0
  while i < args.length
    node = createLogNode(args[i])
    document.querySelector('#mylog').appendChild node
    i++
  return
window.onerror = (message, url, linenumber) ->
  console.log 'JavaScript error: ' + message + ' on line ' + linenumber + ' for ' + url
  return


 # END HELPERS

socket = io()

socket.on 'connect', ->
  console.log 'nfc connect'
  socket.emit 'nfc connect'

socket.on 'disconnect', ->
  console.log 'nfc disconnect'
  socket.emit 'nfc disconnect'

# String after '?' in the URL
uid = window.location.search.slice(1)
if uid.length > 0
  socket.emit 'nfc requests card', {id: uid}
  console.log 'requesting card ' + uid

