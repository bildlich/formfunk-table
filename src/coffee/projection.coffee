socket = io()


socket.on 'connect', ->
  console.log 'projection connect'
  socket.emit 'projection connect'

socket.on 'disconnect', ->
  console.log 'projection disconnect'
  socket.emit 'projection disconnect'

socket.on 'change audiovisual', (data) ->
  console.log('changing audiovisual to ' + data.id)
