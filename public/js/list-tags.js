var chapterString, socket;

socket = io();

socket.on('change audiovisual', function(chapterID) {
  console.log('change audiovisual');
  chapterString += "'" + chapterID + "':\n  'soundID': ''\n  'start': ''\n";
  return $('textarea').val(chapterString);
});

chapterString = "";

//# sourceMappingURL=maps/list-tags.js.map
