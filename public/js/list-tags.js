var chapterString, socket;

socket = io();

socket.on('change audiovisual', function(chapterID) {
  console.log('change audiovisual');
  chapterString += "hello\nlo";
  return $('textarea').val(chapterString);
});

chapterString = "";

//# sourceMappingURL=maps/list-tags.js.map
