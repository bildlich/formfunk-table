app = require('express')()
http = require('http').createServer(app)
io = require('socket.io')(http)
serveStatic = require('serve-static')


# Serve static files from folder 'public'
# Note that the folder 'public' is ommited when referencing the files.
app.use(serveStatic('public'))

app.get '/nfc', (req, res) ->
  arr = req.originalUrl.match(/\?(.*)/)
  if arr and arr[1]
    id = arr[1]
    console.log 'nfc requests card ' + req.originalUrl.match(/\?(.*)/)[1]

http.listen 5000, ->
  console.log('listening on *:5000')

io.on 'connection', (socket) ->
  console.log 'yay, a user connected'

  socket.on 'nfc connect', ->
    console.log 'nfc connect'
  socket.on 'nfc disconnect', ->
    console.log 'nfc disconnect'
  socket.on 'projection connect', ->
    console.log 'projection connect'
  socket.on 'projection disconnect', ->
    console.log 'projection disconnect'

  socket.on 'nfc requests card', (data) ->
    console.log 'nfc requests card ' + data.id
    socket.broadcast.emit 'change audiovisual', data


