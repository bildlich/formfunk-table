socket = io()

socket.on 'change audiovisual', (chapterID) ->
  console.log 'change audiovisual'
  chapterString += """hello
  lo
  """
  $('textarea').val(chapterString)

chapterString = ""
