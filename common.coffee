app = require('express')()
http = require('http').createServer(app)
io = require('socket.io')(http)
serveStatic = require('serve-static')


# Serve static files from folder 'public'
# Note that the folder 'public' is ommited when referencing the files.
app.use(serveStatic('public'))

app.get '/nfc', (req, res) ->
  arr = req.originalUrl.match(/\?(.*)/) # Get string behing "?" in the URL
  if arr and arr[1]
    id = arr[1]
    console.log 'nfc requests chapter ' + id
    res.send 'you requested chapter ' + id
    io.emit 'change audiovisual', id

app.get '/reset', (req, res) ->
  console.log 'projection reset requested'
  res.send 'you requested a projection reset'
  io.emit 'reset'

io.on 'connection', (socket) ->
  console.log 'yay, a user connected'

  socket.on 'projection connect', ->
    console.log 'projection connect'
  socket.on 'projection disconnect', ->
    console.log 'projection disconnect'

http.listen 5000, ->
  console.log('listening on *:5000')