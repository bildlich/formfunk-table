socket = io()

socket.on 'change audiovisual', (chapterID) ->
  console.log 'change audiovisual'
  chapterString += """
  '#{chapterID}':
    'soundID': ''
    'start': ''

  """
  $('textarea').val(chapterString)

chapterString = ""
