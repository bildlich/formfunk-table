socket = io()

socket.on 'connect', ->
  console.log 'projection connect'
  socket.emit 'projection connect'

socket.on 'disconnect', ->
  console.log 'projection disconnect'
  socket.emit 'projection disconnect'

socket.on 'change audiovisual', (chapterID) ->
  console.log('changing audiovisual to ' + chapterID)
  changeAudioVisual(chapterID)

socket.on 'reset', ->
  console.log('resetting…')
  resetEverything()

episodeData =
  'erik-spiekermann-onl':
    color: '#0024ff'
  'anna-haifisch-onl':
    color: '#FFEE00'
  'frank-berzbach-onl':
    color: '#ff6300'
  'andreas-muxel-onl':
    color: '#1EFF01'
  'andrea-nienhaus-onl':
    color: '#F1CEC9'
  'oliver-reichenstein-onl':
    color: '#dddddd'
  'julia-kahl-onl':
    color: '#00ffff'
  'i-like-birds-onl':
    color: '#ccff00'
  'birgit-bauer-daniela-burger-onl':
    color: '#FF1493'
  'lars-mueller-onl':
    color: '#ff0000'

chapterData =
  # 1 Spiekermann (11 Tags)
  '804AACE2C56A04':
    'soundID': 'erik-spiekermann-onl'
    'start': '0:29.532'
  '804AACE2C56004':
    'soundID': 'erik-spiekermann-onl'
    'start': '4:28.398'
  '804AACE2C58C04':
    'soundID': 'erik-spiekermann-onl'
    'start': '12:47.447'
  '804AACE2C55F04':
    'soundID': 'erik-spiekermann-onl'
    'start': '24:19.085'
  '804AACE2C56904':
    'soundID': 'erik-spiekermann-onl'
    'start': '30:00.661'
  '804AACE2C58B04':
    'soundID': 'erik-spiekermann-onl'
    'start': '36:01.156'
  '804AACE2C51D04':
    'soundID': 'erik-spiekermann-onl'
    'start': '37:53.865'
  '804AACE2C52704':
    'soundID': 'erik-spiekermann-onl'
    'start': '42:41.191'
  '804AACE2C54904':
    'soundID': 'erik-spiekermann-onl'
    'start': '46:02.238'
  '804AACE2C51C04':
    'soundID': 'erik-spiekermann-onl'
    'start': '52:54.138'
  '814AACE2C75D04':
    'soundID': 'erik-spiekermann-onl'
    'start': '55:46.320'

  # 2 Haifisch (8 Tags)
  '814AACE2C74704':
    'soundID': 'anna-haifisch-onl'
    'start': '0:31.665'
  '814AACE2C71A04':
    'soundID': 'anna-haifisch-onl'
    'start': '7:10.564'
  '814AACE2C76804':
    'soundID': 'anna-haifisch-onl'
    'start': '10:17.406'
  '814AACE2C67A04':
    'soundID': 'anna-haifisch-onl'
    'start': '20:20.466'
  '804009FA3CCD04':
    'soundID': 'anna-haifisch-onl'
    'start': '26:26.867'
  '804AACE2FB8F04':
    'soundID': 'anna-haifisch-onl'
    'start': '32:29.299'
  '804009FA3CEC04':
    'soundID': 'anna-haifisch-onl'
    'start': '40:54.548'
  '814AACE2C76704':
    'soundID': 'anna-haifisch-onl'
    'start': '44:07.560'

  # 3 Berzbach (13 Tags)
  '814AACE2C67B04':
    'soundID': 'frank-berzbach-onl'
    'start': '0:29.610'
  '814AACE2C71B04':
    'soundID': 'frank-berzbach-onl'
    'start': '1:17.021'
  '814AACE2C72504':
    'soundID': 'frank-berzbach-onl'
    'start': '7:21.292'
  '814AACE2C66404':
    'soundID': 'frank-berzbach-onl'
    'start': '12:11.138'
  '804AACE2C6F504':
    'soundID': 'frank-berzbach-onl'
    'start': '14:41.116'
  '814AACE2C61904':
    'soundID': 'frank-berzbach-onl'
    'start': '18:555.151'
  '814AACE2C62304':
    'soundID': 'frank-berzbach-onl'
    'start': '22:31.183'
  '804AACE2C6F404':
    'soundID': 'frank-berzbach-onl'
    'start': '30:14.651'
  '814AACE2C65A04':
    'soundID': 'frank-berzbach-onl'
    'start': '37:58.497'
  '814AACE2C63804':
    'soundID': 'frank-berzbach-onl'
    'start': '42:20.639'
  '814AACE2C66504':
    'soundID': 'frank-berzbach-onl'
    'start': '44:10.328'
  '814AACE2C65B04':
    'soundID': 'frank-berzbach-onl'
    'start': '51:57.090'
  '814AACE2C63904':
    'soundID': 'frank-berzbach-onl'
    'start': '53:59.098'

  # 4 Muxel (9 Tags)
  '81492A92261104':
    'soundID': 'andreas-muxel-onl'
    'start': '0:30.360'
  '804AACE2C62904':
    'soundID': 'andreas-muxel-onl'
    'start': '3:48.622'
  '804AACE2C9F804':
    'soundID': 'andreas-muxel-onl'
    'start': '15:39.660'
  '804AACE2C69804':
    'soundID': 'andreas-muxel-onl'
    'start': '24:28.213'
  '804AACE2C9B004':
    'soundID': 'andreas-muxel-onl'
    'start': '27:56.050'
  '814AACE2C92604':
    'soundID': 'andreas-muxel-onl'
    'start': '35:55.153'
  '814AACE2C90304':
    'soundID': 'andreas-muxel-onl'
    'start': '39:57.756'
  '804AACE2C7D304':
    'soundID': 'andreas-muxel-onl'
    'start': '45:58.092'
  '804AACE2C9BB04':
    'soundID': 'andreas-muxel-onl'
    'start': '48:10.276'

  # 5 Nienhaus (12 Tags)
  '804AACE2C7DD04':
    'soundID': 'andrea-nienhaus-onl'
    'start': '0:30.640'
  '814AACE2C70004':
    'soundID': 'andrea-nienhaus-onl'
    'start': '2:51.382'
  '804AACE2C79A04':
    'soundID': 'andrea-nienhaus-onl'
    'start': '6:29.198'
  '804AACE2C79004':
    'soundID': 'andrea-nienhaus-onl'
    'start': '11:57.009'
  '814AACE2C96A04':
    'soundID': 'andrea-nienhaus-onl'
    'start': '16:26.660'
  '814AACE2C94804':
    'soundID': 'andrea-nienhaus-onl'
    'start': '25:31.488'
  '814AACE2C90104':
    'soundID': 'andrea-nienhaus-onl'
    'start': '30:03.586'
  '804AACE2C9F704':
    'soundID': 'andrea-nienhaus-onl'
    'start': '34:31.906'
  '814AACE2C72404':
    'soundID': 'andrea-nienhaus-onl'
    'start': '39:27.508'
  '814AACE2C92504':
    'soundID': 'andrea-nienhaus-onl'
    'start': '44:18.182'
  '814AACE2C74604':
    'soundID': 'andrea-nienhaus-onl'
    'start': '53:18.912'
  '804AACE2C7D404':
    'soundID': 'andrea-nienhaus-onl'
    'start': '55:28.091'

  # 6 Reichenstein (12 Tags)
  '804AACE2C7DE04':
    'soundID': 'oliver-reichenstein-onl'
    'start': '0:38.065'
  '814AACE2C70104':
    'soundID': 'oliver-reichenstein-onl'
    'start': '3:06.284'
  '814AACE2C87504':
    'soundID': 'oliver-reichenstein-onl'
    'start': '18:33.934'
  '8040A3AAA3C904':
    'soundID': 'oliver-reichenstein-onl'
    'start': '22:33.586'
  '804AACE2C8E604':
    'soundID': 'oliver-reichenstein-onl'
    'start': '30:43.928'
  '804AACE2C8F004':
    'soundID': 'oliver-reichenstein-onl'
    'start': '33:39.656'
  '804AACE2C8A304':
    'soundID': 'oliver-reichenstein-onl'
    'start': '39:26.815'
  '804AACE2C88104':
    'soundID': 'oliver-reichenstein-onl'
    'start': '42:24.778'
  '804AACE2C75804':
    'soundID': 'oliver-reichenstein-onl'
    'start': '45:21.222'
  '804AACE2C8AD04':
    'soundID': 'oliver-reichenstein-onl'
    'start': '49:20.109'
  '804AACE2C77A04':
    'soundID': 'oliver-reichenstein-onl'
    'start': '54:20.775'
  '804AACE2C74D04':
    'soundID': 'oliver-reichenstein-onl'
    'start': '58:03.668'

  # 7 Kahl (12 Tags)
  '804AACE2C68D04':
    'soundID': 'julia-kahl-onl'
    'start': '0:30.993'
  '804AACE2C77904':
    'soundID': 'julia-kahl-onl'
    'start': '4:54.417'
  '804AACE2C75704':
    'soundID': 'julia-kahl-onl'
    'start': '7:26.005'
  '804AACE2C66B04':
    'soundID': 'julia-kahl-onl'
    'start': '9:53.389'
  '804AACE2C69904':
    'soundID': 'julia-kahl-onl'
    'start': '12:39.026'
  '804AACE2C68F04':
    'soundID': 'julia-kahl-onl'
    'start': '13:58.876'
  '804AACE2C66C04':
    'soundID': 'julia-kahl-onl'
    'start': '24:39.427'
  '804AACE2C79904':
    'soundID': 'julia-kahl-onl'
    'start': '26:24.216'
  '804AACE2C78F04':
    'soundID': 'julia-kahl-onl'
    'start': '32:23.032'
  '804AACE2C7BE04':
    'soundID': 'julia-kahl-onl'
    'start': '38:51.441'
  '804AACE2C7BD04':
    'soundID': 'julia-kahl-onl'
    'start': '41:17.519'
  '804AACE2C74E04':
    'soundID': 'julia-kahl-onl'
    'start': '45:52.898'

  # 8 Birds (10 Tags)
  '814AACE2C96904':
    'soundID': 'i-like-birds-onl'
    'start': '0:26.987'
  '814AACE2C93D04':
    'soundID': 'i-like-birds-onl'
    'start': '1:54.304'
  '814AACE2C93C04':
    'soundID': 'i-like-birds-onl'
    'start': '5:09.755'
  '814AACE2C94704':
    'soundID': 'i-like-birds-onl'
    'start': '10:59.273'
  '804AACE2C88004':
    'soundID': 'i-like-birds-onl'
    'start': '20:17.799'
  '814AACE2C84F04':
    'soundID': 'i-like-birds-onl'
    'start': '28:30.387'
  '804AACE2C8AC04':
    'soundID': 'i-like-birds-onl'
    'start': '38:52.760'
  '804AACE2C8A204':
    'soundID': 'i-like-birds-onl'
    'start': '44:49.803'
  '804AACE2C83F04':
    'soundID': 'i-like-birds-onl'
    'start': '48:51.444'
  '804AACE2C86104':
    'soundID': 'i-like-birds-onl'
    'start': '51:30.218'

  # 11 Burger/Bauer (12 Tags)
  '804AACE2C8EF04':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '0:29.604'
  '804AACE2C8C304':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '5:05.506'
  '804AACE2C8E504':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '9:14.525'
  '804AACE2C62804':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '10:07.566'
  '814AACE2C83A04':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '18:07.035'
  '804AACE2C64C04':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '25:23.351'
  '804AACE2C65604':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '31:03.037'
  '814AACE2C80B04':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '37:06.243'
  '814AACE2C83004':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '44:40.985'
  '814AACE2C83904':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '47:33.826'
  '814AACE2C82F04':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '54:41.846'
  '814AACE2C80904':
    'soundID': 'birgit-bauer-daniela-burger-onl'
    'start': '55:29.866'

  # 10 Müller (14 Tags)
  '804AACE2C82804':
    'soundID': 'lars-mueller-onl'
    'start': '0:29.414'
  '804AACE2C81E04':
    'soundID': 'lars-mueller-onl'
    'start': '3:21.267'
  '804AACE2C73704':
    'soundID': 'lars-mueller-onl'
    'start': '10:14.137'
  '804AACE2C81F04':
    'soundID': 'lars-mueller-onl'
    'start': '16:27.497'
  '804AACE2C73604':
    'soundID': 'lars-mueller-onl'
    'start': '18:35.408'
  '804AACE2C82904':
    'soundID': 'lars-mueller-onl'
    'start': '21:57.413'
  '804AACE2C86004':
    'soundID': 'lars-mueller-onl'
    'start': '29:49.448'
  '804AACE2C86A04':
    'soundID': 'lars-mueller-onl'
    'start': '34:02.056'
  '804AACE2C86B04':
    'soundID': 'lars-mueller-onl'
    'start': '36:03.491'
  '804AACE2C83E04':
    'soundID': 'lars-mueller-onl'
    'start': '41:30.260'
  '814AACE2C87F04':
    'soundID': 'lars-mueller-onl'
    'start': '45:24.993'
  '814AACE2C87404':
    'soundID': 'lars-mueller-onl'
    'start': '47:55.803'
  '814AACE2C85004':
    'soundID': 'lars-mueller-onl'
    'start': '53:36.391'
  '814009FA3C0A04':
    'soundID': 'lars-mueller-onl'
    'start': '56:51.322'


setupSoundObjects = ->
  soundManager.setup
    debugMode: true
    onready: ->
      console.log 'ready!'
      # Setup the soundManager objects
      for soundID of episodeData
        color = episodeData[soundID].color
        soundObject = soundManager.createSound
          id: soundID
          url: '/local-mp3/'+soundID+'.mp3'#'http://formfunk.betelgeuse.uberspace.de/formfunk-sandbox/assets/local-mp3/'+soundID+'.mp3'#'http://cdn.podseed.org/formfunk/'+soundID+'.mp3'#'http://cdn.podseed.org/formfunk/thilo-kasper-onl.mp3'#'/assets/local-mp3/'+soundID+'.mp3'
          autoLoad: false
          autoPlay: false
          volume: 100
          onfinish: (e) =>
            f.state.playing = false
          onplay: (e) =>
            f.state.playing = true
          onresume: (e) =>
            f.state.playing = true
          onpause: =>
            f.state.playing = false
          onstop: =>
            f.state.playing = false

setupSoundObjects()

resetEverything = ->
  soundManager.stopAll()
  f.changePathColor('#ff0000')

changeAudioVisual = (chapterID) ->
  if !chapterData[chapterID]
    console.log "The chapterID "+chapterID+" doesn't exist."
    return
  soundObject = soundManager.getSoundById chapterData[chapterID].soundID
  soundManager.stopAll()
  # Change the color
  if episodeData[chapterData[chapterID].soundID]
    f.changePathColor(episodeData[chapterData[chapterID].soundID].color)
  soundObject.play
    from: hoursToMs(chapterData[chapterID].start)

hoursToMs = (string) ->
  # Timecode format: HH:MM:SS.FFF where HH (hours) and FFF (milliseconds) are optional.
  console.log string
  string = string + ''
  console.log 'millis', string
  [string, millis] = string.split(".") # Strip milliseconds if available. We'll add them later.
  a = string.split(':')
  s = 0
  m = 1
  while a.length > 0
    s += m * parseInt(a.pop(), 10)
    m *= 60
  result = s*1000
  if millis? then result += parseInt(millis, 10) # Add milliseconds if they were given.
  return result

speedFactor = 1.5
movementDiminisher = 0.1
$body = $('body')

tableSettings =
  logoMarginLeft: 20
  logoMarginTop: 18
  logoScale: 0.9
  strokeWidth: 7
  strokeWidthLogo: 5
  colorChangeSpeed: 50 # Not ms. Higher is slower
  fadePageSpeed: 1000 # ms
# Begin helpers
randomInt = (min, max) ->
  randomnumber = Math.floor(Math.random()*(max-min+1)) + min
# Change the starting point of a path
setStartPoint = (path, index) ->
  for i in [0..index-1]
    buffer = path.segments.shift()
    path.segments.push(buffer)
# End helpers

# Only run our code once the DOM is ready.
class F
  constructor: ->
    @state = {}
    @state.currentPage = $body.attr 'data-current-page'
    @getUserAgentData()
    history.replaceState @state, null, null

    @popped = false
    @oldPageYOffset = window.pageYOffset
    # Set up paper.js
    paper.install window
    # We have one scope (paper) and create two projects inside
    @mainP = new paper.Project('paper-canvas')
    @logoP = new paper.Project('logo-canvas')
    @mainP.activate() # To do work on the logo canvas, activate it with @logoP.activate()
    @windowInnerHeight = window.innerHeight
    @noOfPoints = 4
    @smooth = false
    @path = new Path()
    @mousePos = view.center.divide new Point(2,2)
    @pathHeight = @mousePos.x
    @path.style =
      fillColor: @getCurrentColor()
      strokeWidth: tableSettings.strokeWidth
      strokeColor: 'black'
    @framesWhenPlayStateChanged = 0
    @center = view.center
    @width = view.size.width / 2
    @height = view.size.height / 2
    @path.segments = []
    for i in [1..@noOfPoints + 4]
      @path.add(new Point(0,0))
    for i in [2..@noOfPoints+1]
      @path.segments[i].data = {movable: true}
    @path.position = view.center
    @roleModelPath = @path.clone()
    @roleModelPath.visible = false
    @initLogo()
    view.onFrame = (event) =>
      if event.count % 2 is 0
        unless @state.menuOpen
          if @state.currentPage is 'home'
            @animateWaves(event.count, 'horizontal')
            @animateColor()
          else if @state.currentPage is 'episode' or 'table'
            @animateWaves(event.count, 'vertical')
            @animateColor()
          @movePoints event, @path
      if event.count % 4 is 0
        @animateLogo(event)
        true
    @setupPage '', @state.currentPage
    @bindUserEvents()
    @scrollLoop()

  # If the item has children, it returns an array with all segments of
  # all children. If the item has no children, it just returns an array
  # with all segments
  getAllSegments: (item) ->
    if !item.children
      return item.segments
    else
      g = item.children
      allSegments = []
      for path in g
        for segment in path.segments
          allSegments.push segment
      return allSegments

  # Returns the currently set main color
  getCurrentColor: ->
    if !@state.currentColor then @state.currentColor = $('.ajax').attr('data-color')
    return @state.currentColor

  animateWaves: (count, orientation) ->
    allSegments = @getAllSegments @path
    for segment, index in allSegments when segment.data and segment.data.movable is true
      sinSeed = (count + 200 * index)
      sinHeight = Math.sin(sinSeed / 200)
      if orientation is 'horizontal'
        segment.data.offsetX = ((Math.sin(sinSeed / 100) * sinHeight * @pathHeight) / 3)
      else if orientation is 'vertical'
        # @heightDiminisher: Higher number means lower waves
        # @speedDiminisher: Higher number means slower waves
        if !@heightDiminisher then @heightDiminisher = 4
        if !@speedDiminisher then @speedDiminisher = 120
        # Has play state been changed since this function was last called?
        if @state.playing isnt @state.oldPlaying
          @state.oldPlaying = @state.playing
          @framesWhenPlayStateChanged = count
        if !@state.playing
          #@heightDiminisher = @changeVarOverTime(@heightDiminisher, 6, +0.1, 2, 'heightDiminisher', count)
          @heightDiminisher = @changeVarOverTime(@heightDiminisher, 2, 1000, @framesWhenPlayStateChanged, count)
        else # When sound is playing, waves are higher. Change is gradually
          #@heightDiminisher = @changeVarOverTime(@heightDiminisher, 4, -0.1, 2, 'heightDiminisher', count)
          @heightDiminisher = @changeVarOverTime(@heightDiminisher, 4, 1000, @framesWhenPlayStateChanged, count)
        segment.data.offsetY = ((Math.sin(sinSeed / @speedDiminisher) * sinHeight) * (@pathHeight / @heightDiminisher))

  animateLogo: (event) ->
    maxWobble = @wavable.bounds.width/30
    for segment, index in @wavable.segments
      # Does point have no targetPoint or has it reached its targetPoint? Then create one.
      if (segment.data.targetPoint is undefined) or segment.data.targetVector.length < 1
        # Alternate between random location and original location
        if segment.data.goBackHome is undefined then segment.data.goBackHome = true
        segment.data.goBackHome = !segment.data.goBackHome
        # Random location nearby
        if !segment.data.goBackHome
          if index is 5 # Rightmost point
            segment.data.targetVector = @getRandomVector(maxWobble, 0) # 0 means 0 degrees -> only vertical
            segment.data.targetPoint = segment.point.add segment.data.targetVector
          else if index is 11 # Leftmost point
            segment.data.targetVector = @getRandomVector(maxWobble, 0) # 0 means 0 degrees -> only vertical
            segment.data.targetPoint = segment.point.add segment.data.targetVector
          else # All the other points
            segment.data.targetVector = @getRandomVector(maxWobble)
            segment.data.targetPoint = segment.point.add segment.data.targetVector
        # Back to original position
        else
          segment.data.targetPoint = segment.data.originalPosition.clone()
          segment.data.targetVector = segment.data.targetPoint.subtract segment.point
        segment.data.speed = 30#randomInt(10,30)
      moveVector = segment.data.targetVector.clone()
      moveVector.length *= segment.data.speed / 1000 * speedFactor
      segment.point = segment.point.add moveVector
      segment.data.targetVector.length -= moveVector.length
    @logoP.view.update()

  initLogo: ->
    if @logo then @logo.remove()
    @logoP.activate()
    @logo = @svgToPath 'wavable'
    @logo.visible = true
    @logo.style =
      fillColor: 'black'
    @wavable = @logo.children['wavable-o']
    @wavable.style =
      fillColor: 'red'
      strokeColor: 'black'
    # scale so that the logo is as high as the small type
    @logo.scale(tableSettings.logoScale)
    # This retrieves the leftmost gutter without 'px' at the end
    @logo.pivot = @logo.bounds.topLeft
    @logo.position = new Point(0,0)
    @wavable.strokeWidth = tableSettings.strokeWidthLogo
    for segment in @wavable.segments
      segment.data =
        originalPosition: segment.point.clone()
    # Make paper path 'clickable'
    homeLink = $('.home-link')
      .clone().empty().removeClass('home-link').addClass('v-home-link')
      .css
        left: @logo.position.x+'px'
        top: @logo.position.y+'px'
        width: @logo.bounds.width
        height: @logo.bounds.height
    $('body').append homeLink
    view.update()
    @mainP.activate()

  # Changes a variable over time (linear growth).
  # startValue: the value to be modified
  # endValue: value we want to reach
  # durationInFrames:
  # startFrame (integer): absolute number of frames drawn when easing started
  # currentFrame (integer): absolute number of frames drawn since page load
  # easing:
  changeVarOverTime: (startValue, endValue, durationInFrames, startFrame, currentFrame) ->
    # value between 0 and 1
    t = (currentFrame - startFrame) / durationInFrames
    if t > 1 then return endValue
    val = startValue + t * (endValue - startValue)

  svgToPath: (svgID) ->
    imported = project.importSVG(document.getElementById(svgID))
    newPath = imported.reduce()
    relativeWidth = newPath.bounds.width / view.bounds.width
    relativeHeight = newPath.bounds.height / newPath.bounds.height
    if relativeWidth > relativeHeight
      newPath.scale(1/relativeWidth)
    else
      newPath.scale(1/relativeHeight)
    newPath.applyMatrix = true # important, otherwise positioning is weird with some svgs
    newPath.translate(view.bounds.center.subtract(newPath.bounds.center))
    newPath.visible = false
    newPath.closed = true
    newPaths = if newPath.hasChildren() then newPath.children else [newPath]
    view.update()
    return newPath

  morphPath: (roleModelPath, callback = undefined, instantly = false, speed = undefined, easing = undefined, animateHandles = false) ->
    # Some dancing around to make sure morphing works for normal paths
    # as well as compoundPaths and groups, even when the number of sub-paths
    # differs.
    paths = if @path.hasChildren() then @path.children else [@path]
    allPathPoints = []
    if animateHandles
      allPathHandleIns = []
      allPathHandleOuts = []
    for childPath in paths
      for segment in childPath.segments
        allPathPoints.push segment.point.clone()
        if animateHandles
          allPathHandleIns.push segment.handleIn.clone()
          allPathHandleOuts.push segment.handleOut.clone()
    roleModelPaths = if roleModelPath.hasChildren() then roleModelPath.children else [roleModelPath]
    allRoleModelPathPoints = []
    if animateHandles
      allRoleModelPathHandleIns = []
      allRoleModelPathHandleOuts = []
    allRoleModelPathData = []
    for roleModelPathChild in roleModelPaths
      for segment in roleModelPathChild.segments
        if !segment.data then segment.data = {}
        allRoleModelPathPoints.push segment.point.clone()
        allRoleModelPathData.push segment.data
        if animateHandles
          allRoleModelPathHandleIns.push segment.handleIn.clone()
          allRoleModelPathHandleOuts.push segment.handleOut.clone()
    clone = roleModelPath.clone()
    clonePaths = if clone.hasChildren() then clone.children else [clone]
    index = 0
    for clonePath, pathCounter in clonePaths
      for segment in clonePath.segments
        unless instantly or @state.dontAnimateNextMorphPath
          if allPathPoints[index]
            segment.point = allPathPoints[index]
          # When roleModelPath has more segments than the current path
          # we can specify in the roleModelPath's data attribute where we
          # want the added points to appear (default: top left)
          # Note: won't work with subpaths
          else
            if roleModelPath.data and roleModelPath.data.createNewPointsAtIndex?
              segment.point = clonePath.segments[roleModelPath.data.createNewPointsAtIndex].point
          if animateHandles
            segment.handleIn = allPathHandleIns[index]
            segment.handleOut = allPathHandleOuts[index]
        segment.data = allRoleModelPathData[index]
        segment.data.explicitTarget = allRoleModelPathPoints[index]
        segment.data.originalPosition = allRoleModelPathPoints[index].clone()
        if speed then segment.data.speed = speed
        if easing then segment.data.easing = easing
        if animateHandles
          segment.data.animateHandles = true
          segment.data.handleInTarget = allRoleModelPathHandleIns[index]
          segment.data.handleOutTarget = allRoleModelPathHandleOuts[index]
        index++
    clonePaths[0].firstSegment.data.callback = callback
    clone.visible = true
    clone.selected = @path.selected
    clone.style = @path.style
    clone.data = @path.data
    clone.insertBelow @path
    @path.remove()
    @path = clone
    @state.isMorphing = true
    if @state.dontAnimateNextMorphPath then @state.dontAnimateNextMorphPath = false
    view.update()

  movePoints: (event, path) ->
    paths = if path.hasChildren() then path.children else [path]
    for path, pathIndex in paths
      for segment, segmentIndex in path.segments
        if !segment.data then segment.data = {}
        # Move the main point
        if segment.data.explicitTarget?
          finishedAnimation = true
          segment.data.targetPoint = segment.data.explicitTarget
          segment.data.targetVector = segment.data.explicitTarget.subtract segment.point
          if !segment.data.speed then segment.data.speed = 5
          if segment.data.easing is 'linear'
            segment.data.projectedDuration = 1000/segment.data.speed * speedFactor
            segment.data.movePerStep = segment.data.targetVector.length / segment.data.projectedDuration
          segment.data.explicitTarget = null
          segment.data.pointWithoutOffset = segment.point.clone()
        if segment.data.targetVector and segment.data.targetVector.length > 1
          finishedAnimation = false
          moveVector = segment.data.targetVector.clone()
          if segment.data.easing is 'linear'
            moveVector.length = Math.min(segment.data.movePerStep, segment.data.targetVector.length)
          else
            moveVector.length *= segment.data.speed / 50 * speedFactor
          segment.data.pointWithoutOffset = segment.data.pointWithoutOffset.add moveVector
          segment.data.targetVector.length -= moveVector.length
        if segment.data.offsetX
          segment.point.x = segment.data.pointWithoutOffset.x + segment.data.offsetX
          segment.data.offsetX = undefined
        else segment.point.x = segment.data.pointWithoutOffset.x
        if segment.data.offsetY
          segment.point.y = segment.data.pointWithoutOffset.y + segment.data.offsetY
          segment.data.offsetY = undefined
        else segment.point.y = segment.data.pointWithoutOffset.y
      if finishedAnimation is true
        if @state.isMorphing
          @state.isMorphing = false
        if path.segments[0].data.callback
          path.segments[0].data.callback.call(this)
        finishedAnimation = false

  animateColor: ->
    if @path.data.targetColor isnt undefined
      redDifference = @path.data.targetColor.red - @path.fillColor.red
      greenDifference = @path.data.targetColor.green - @path.fillColor.green
      blueDifference = @path.data.targetColor.blue - @path.fillColor.blue
      # Stop the color animation when we are really close to the target color.
      if Math.max(Math.abs(redDifference), Math.abs(greenDifference), Math.abs(blueDifference)) > 0.001
        @path.fillColor.red += redDifference/tableSettings.colorChangeSpeed
        @path.fillColor.green += greenDifference/tableSettings.colorChangeSpeed
        @path.fillColor.blue += blueDifference/tableSettings.colorChangeSpeed
        @wavable.fillColor.red += redDifference/tableSettings.colorChangeSpeed
        @wavable.fillColor.green += greenDifference/tableSettings.colorChangeSpeed
        @wavable.fillColor.blue += blueDifference/tableSettings.colorChangeSpeed
      else
        @path.data.targetColor = undefined

  # Change color of the logo path and the big path. Set instantly to true to skip the fading animation.
  changePathColor: (color, instantly = false) ->
    if !instantly
      @path.data.targetColor = new Color(color)
    else
      @path.fillColor = color
      @wavable.fillColor = color
      @mainP.view.update()
      @logoP.view.update()

  # Second argument 'direction' is optional. It is the direction in degrees.
  getRandomVector: (maxLength, direction = 'random') ->
    if direction isnt 'random'
      randomVector = new Point(0, 1-randomInt(0,1)*2) # Can be -1 or 1
      randomVector = randomVector.rotate(direction)
    else
      randomVector = Point.random()
      randomVector = randomVector.rotate(randomInt(0,360))
    randomVector.length = randomInt(0, maxLength)
    return randomVector

  validateEmail: (email) ->
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    re.test(email)

  selectFocusedArticle: ->
    minimumSoFar = 10000
    for article in @articles
      $article = $(article)
      $article.data 'positionOnScreen', $article.offset().top - @oldPageYOffset
      if !$article.data 'height' then $article.data 'height', $article.height()
      distanceFromScreenMiddle = Math.abs($article.data('positionOnScreen') - @windowInnerHeight/2 + $article.data('height')/2)
      if distanceFromScreenMiddle < minimumSoFar
        $articleToFocus = $article
        minimumSoFar = distanceFromScreenMiddle
    unless $articleToFocus.is @lastFocusedArticle
      if @lastFocusedArticle
        @lastFocusedArticle.trigger 'focus:unfocus'
      $articleToFocus.trigger 'focus:focus'

  # Makes the element as wide as the viewport. Vertical position and height stay the same.
  makeElementAsWideAsViewport: ($element) ->
    if $element.length > 0
      $element.css
        'position': 'relative'
        'left': -$element.offset().left
        'width': $body.width()

  setupPage: (fromPage, toPage) ->
    # Hack: When uri contains "episodes/", set up episode page
    if location.href.indexOf('interviews/') > -1
      toPage = "episode"
    console.log 'setup from '+ fromPage+ ' to '+ toPage
    @state.currentPage = toPage
    history.replaceState @state, null, null
    $body.attr 'data-current-page', toPage
    $body.removeClass('page-'+fromPage).addClass('page-'+toPage)
    if @state.menuOpen then @closeMenu()
    if fromPage is 'home'
      @articles.off 'focus:focus'
      @lastFocusedArticle = ''
    if fromPage is 'episode'
      if @sound
        @sound.destruct()
      @changeCssColor 'white'
    if toPage is 'home'
      @setupRoleModelPath 'home'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
      @articles = $('article')
      @articles.on 'focus:focus', (e) =>
        $this = $(e.currentTarget)
        @lastFocusedArticle = $this
        # Change path colors
        if $this.data 'color'
          @state.currentColor = $this.data('color')
          @changePathColor @getCurrentColor()
      @selectFocusedArticle()
      @changePathColor @getCurrentColor(), true
    if toPage is 'abo'
      @setupRoleModelPath 'abo'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
    if toPage is 'ueber'
      @setupRoleModelPath 'ueber'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
    if toPage is 'frage'
      @setupRoleModelPath 'frage'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
    if toPage is 'error'
      @setupRoleModelPath 'error'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
    if toPage is 'episode'
      $('body, html').scrollTop(0)
      @setupRoleModelPath 'episode'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
      @changePathColor @getCurrentColor(), (!fromPage? or fromPage is '')
      if $('.audio-player').length > 0
        @prepareAudioPlayer($('.audio-player'))
      @prepareSmallEpisodeList()
      @changeCssColor @getCurrentColor()
      # On big screens, make image gallery as wide as browser window.
      if @state.currentBreakPoint is 'xl'
        @makeElementAsWideAsViewport($('.guest-images'))
        @makeElementAsWideAsViewport($('.more-header'))
        @makeElementAsWideAsViewport($('.episode-list'))
    if toPage is 'table'
      $('body, html').scrollTop(0)
      @setupRoleModelPath 'table'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
      @changePathColor @getCurrentColor(), (!fromPage? or fromPage is '')
    if toPage is 'fragment'
      @setupRoleModelPath 'fragment'
      @morphPath @roleModelPath, null, (!fromPage? or fromPage is '')
      @changePathColor @getCurrentColor(), (!fromPage? or fromPage is '')
      if $('.small-player').length > 0
        @setupSmallPlayers()
      @changeCssColor @getCurrentColor()
    # Analytics
    if fromPage? and fromPage isnt ''
      ga('send', 'pageview', window.location.pathname)

  # Prepares the background path. Is re-run on resize.
  setupRoleModelPath: (pageSlug) ->
    if @roleModelPath then @roleModelPath.remove()
    if pageSlug is 'home'
      @roleModelPath = new Path
        segments: [view.bounds.topCenter, view.bounds.topRight, view.bounds.bottomRight, view.bounds.bottomCenter]
        selected: false
        closed: true
        visible: false
        strokeColor: 'black'
        strokeWidth: strokeWidths[@state.currentBreakPoint]
      pieceLength = @roleModelPath.curves[3].length / (@noOfPoints+1)
      offset = @roleModelPath.getOffsetOf @roleModelPath.curves[3].point1
      for i in [1..@noOfPoints]
        @roleModelPath.insert 3+i, @roleModelPath.getPointAt offset + i*pieceLength
        @roleModelPath.lastSegment.data =
          movable: true
        @roleModelPath.lastSegment.handleIn = new Point(0, pieceLength/2)
        @roleModelPath.lastSegment.handleOut = new Point(0, -pieceLength/2)
      @roleModelPath.scale(1.1, view.center)
      @roleModelPath.data.createNewPointsAtIndex = 0
    else if pageSlug is 'episode'
      @roleModelPath = new Path
        segments: [view.bounds.rightCenter, view.bounds.bottomRight, view.bounds.bottomLeft, view.bounds.leftCenter]
        selected: false
        closed: true
        fillColor: 'red'
        visible: false
        strokeColor: 'black'
        strokeWidth: strokeWidths[@state.currentBreakPoint]
      # Some hacky trick to hopefully align the waves between guest name and title on all breakpoints
      factor = 0.8
      if @state.currentBreakPoint in ['s', 'm'] then factor += 0.3
      yPos = $('.guest-name').offset().top + $('.guest-name').height() * factor
      @roleModelPath.segments[0].point.y = @roleModelPath.segments[3].point.y = yPos
      pieceLength = @roleModelPath.curves[3].length / (@noOfPoints+1)
      offset = @roleModelPath.getOffsetOf @roleModelPath.curves[3].point1
      for i in [1..@noOfPoints]
        @roleModelPath.insert 3+i, @roleModelPath.getPointAt offset + i*pieceLength
        @roleModelPath.lastSegment.data = {movable: true}
        @roleModelPath.lastSegment.handleIn = new Point(-pieceLength/2, 0)
        @roleModelPath.lastSegment.handleOut = new Point(pieceLength/2, 0)
      @roleModelPath.scale(1.1, view.center)
    else if pageSlug is 'table'
      @roleModelPath = new Path
        segments: [view.bounds.rightCenter, view.bounds.bottomRight, view.bounds.bottomLeft, view.bounds.leftCenter]
        selected: false
        closed: true
        fillColor: 'red'
        visible: false
        strokeColor: 'black'
        strokeWidth: tableSettings.strokeWidth
      if @state.currentBreakPoint in ['s', 'm'] then factor += 0.3
      yPos = view.bounds.height/2
      @roleModelPath.segments[0].point.y = @roleModelPath.segments[3].point.y = yPos
      pieceLength = @roleModelPath.curves[3].length / (@noOfPoints+1)
      offset = @roleModelPath.getOffsetOf @roleModelPath.curves[3].point1
      for i in [1..@noOfPoints]
        @roleModelPath.insert 3+i, @roleModelPath.getPointAt offset + i*pieceLength
        @roleModelPath.lastSegment.data = {movable: true}
        @roleModelPath.lastSegment.handleIn = new Point(-pieceLength/2, 0)
        @roleModelPath.lastSegment.handleOut = new Point(pieceLength/2, 0)
      @roleModelPath.scale(1.1, view.center)
    else if pageSlug is 'ueber' or pageSlug is 'abo' or pageSlug is 'frage' or pageSlug is 'error' or pageSlug is 'fragment'
      @roleModelPath = new Path
        segments: [view.bounds.topRight, view.bounds.topRight, view.bounds.bottomRight,  view.bounds.bottomRight]
        selected: false
        closed: true
        visible: false
        strokeColor: 'black'
        strokeWidth: strokeWidths[@state.currentBreakPoint]
      @roleModelPath.position = @roleModelPath.position.add(new Point(20,0))

  # Sends a GA event every minute with the current track minute as eventLabel.
  # Use to analyze how many minutes have been listened to as well as what sections of the audio
  # are listened to how often.
  playerAnalytics: =>
    # Clear existing timeouts so we don't run two timeouts simultaneously
    if @playerAnalyticsTimeout?
      window.clearTimeout @playerAnalyticsTimeout
    # Stop logging when player isn't running
    if @sound.playState isnt 1 or @sound.paused is true
      return
    else
      ga('send',
        hitType: 'event'
        eventCategory: 'AudioHeatMap'
        eventAction: window.location.pathname # The 'page' variable inside GA doesn't work reliably, possibly when people open multiple tabs at once.
        eventLabel: ''+Math.ceil(@sound.position/1000/60) # Minute from ms
      )
      # Log again in 1 minute
      @playerAnalyticsTimeout = window.setTimeout @playerAnalytics, 1000*60 # After 1 minute, log again

  prepareAudioPlayer: ($node) ->
    $node.addClass 'is-loading'
    audioFilename = $node.attr 'data-audio-filename'
    soundManager.setup
      debugMode: false
    @sound = soundManager.createSound
      id: audioFilename
      url: 'http://cdn.podseed.org/formfunk/'+audioFilename+'.mp3'
      autoLoad: true
      autoPlay: false
      onbufferchange: =>
        $('.audio-player').toggleClass 'is-buffering', @sound.isBuffering
        if @sound.isBuffering
          $('.duration').html('Lade…')
        else
          @state.barHover = false
      onfinish: (e) =>
        @state.playing = false
        $('.audio-player').toggleClass 'is-playing', @sound.playState
        @updateSoundBar(0, $('.audio-player'))
      onplay: (e) =>
        @state.playing = true
        $('.audio-player').toggleClass 'is-playing', @sound.playState
        @playerAnalyticsTimeout = window.setTimeout @playerAnalytics, 1000*60 # After 1 minute, start logging
        setTimeout @showSubscribeOptions, 60000 # After playing 1 minute, show subscribe links
      onresume: (e) =>
        @state.playing = true
        $('.audio-player').toggleClass 'is-playing', @sound.playState
        @playerAnalyticsTimeout = window.setTimeout @playerAnalytics, 1000*60 # After 1 minute, start logging
      onpause: =>
        @state.playing = false
        $('.audio-player').toggleClass 'is-playing', @sound.playState
      onstop: =>
        @state.playing = false
        $('.audio-player').toggleClass 'is-playing', @sound.playState
      onload: (success) =>
        if !success
          $('.duration').html('Fehler :-(')
          alert('Fehler: Die Folge konnte nicht geladen werden. Wenn das Problem weiter auftritt, schreibe bitte an hey@formfunk-podcast.de');
      whileplaying: (e) =>
        unless window.timeDrag
          $bar = $('.audio-player').find('.bar')
          positionPercent = @sound.position/@sound.durationEstimate
          @updateSoundBar(positionPercent*$bar.width(), $('.audio-player'))
        unless @state.barHover or @sound.isBuffering
          @updatePositionIndicator @sound
      # TODO: When file is done playing: show social
      volume: 100
    $audioPlayer = $('.audio-player')
    $audioPlayer.removeClass 'is-loading'
    # Place markers
    @placeAudioMarkers(@sound)
    # Show duration
    $audioPlayer.find('.duration').html(@msToHours @sound.myDuration)
    # Bind play button click event
    $playButton = $audioPlayer.find('.play-button')
    $playButton.click (event) =>
      if @sound.playState is 0 then @sound.play()
      else @sound.togglePause()
      false
    # Bind scrub point drag event
    $audioPlayer.find('.bar')
      .mousedown (e) =>
        window.timeDrag = true
        $bar = $('.audio-player').find('.bar')
        @updateSoundBar(e.pageX - $bar.offset().left, $('.audio-player'))
        @updateAudioPosition(@sound)
      .mousemove (e) =>
        @state.barHover = true
        $bar = $('.audio-player').find('.bar')
        positionPercent = (e.clientX - $bar.offset().left) / $bar.width()
        positionMs = positionPercent*@sound.myDuration
        unless @sound.isBuffering
          @updatePositionIndicator @sound, positionMs
      .mouseleave () =>
        @state.barHover = false
        unless @sound.isBuffering
          @updatePositionIndicator @sound
    # If time is given in the URL, go to this section and autoplay
    # Example: http://formfunk-podcast.de/interviews/anna-haifisch?t=8m5s
    re = /[?&]?t=(\d*)m(\d*)s/g
    tokens = re.exec(location.search)
    if tokens
      minutes = tokens[1]
      seconds = tokens[2]
      ms = 1000*seconds + 1000*60*minutes
      @sound.setPosition(ms)
      if @sound.playState is 0 then @sound.play()

  placeAudioMarkers: (soundObject) ->
    $audioPlayer = $('.audio-player')
    audioData = JSON.parse($("#audio-data-"+soundObject.id).html())
    markerData = audioData.markers
    soundObject.myDuration = @hoursToMs audioData.duration
    $bar = $('.audio-player').find('.bar')
    $list = $('.marker-list')
    pointString = ""
    listString = ""
    for marker, index in markerData
      # Marker position can be in mm:ss or hh:mm:ss. If so, convert to ms.
      if ((''+marker.position).indexOf ':') > -1
        marker.position = @hoursToMs marker.position
      positionPercent = marker.position / soundObject.myDuration * 100
      pointString += '<span class="audio-marker" data-nr="'+index+'" style="left:'+positionPercent+'%"></span>'
      listString += '<li data-nr="'+index+'"><span class="bullet" data-audio-position="'+marker.position+'"></span>'+marker.html+'</li>'
    $bar.append pointString
    $list.append listString
    $list.find('a').attr 'target', '_blank'
    $('.audio-marker, .marker-list li').hover (e) =>
      @highlightMarker $(e.currentTarget).attr('data-nr'), true
    , (e) =>
      @highlightMarker $(e.currentTarget).attr('data-nr'), false
    $('span.bullet').click (e) =>
      @sound.setPosition($(e.currentTarget).attr('data-audio-position'))
      if @sound.playState is 0 then @sound.play()

  setupSmallPlayers: () ->
    @buildFragmentsObj()
    @buildTagObj()
    @buildTagList()
    @prepareSVG()
    soundManager.setup
      debugMode: false
    that = this
    for player, index in $('div.small-player')
      $playerNodeHtml = $(player)
      soundID = $playerNodeHtml.attr 'data-soundID'
      color = $playerNodeHtml.attr 'data-color'
      playerGroup = @svgEle.smallPlayersGroup.append("g")
        .attr("class", "small-player")
        .attr("data-soundID", soundID)
      playerGroup.append("rect")
        .attr("class", "bar")
        .attr("fill", "white")
        .attr("x", $playerNodeHtml.parent().position().left + $playerNodeHtml.position().left)
        .attr("y", $playerNodeHtml.position().top + 20)
        .attr("width", $playerNodeHtml.width())
        .attr("height", @visConfig.fragmentHeight)
      soundObject = soundManager.createSound
        id: soundID
        url: 'http://formfunk.betelgeuse.uberspace.de/formfunk-sandbox/assets/local-mp3/'+soundID+'.mp3' #'/assets/local-mp3/'+soundID+'.mp3'#'http://formfunk.betelgeuse.uberspace.de/formfunk-sandbox/assets/local-mp3/'+soundID+'.mp3'#'http://cdn.podseed.org/formfunk/'+soundID+'.mp3'#'http://cdn.podseed.org/formfunk/thilo-kasper-onl.mp3'#'/assets/local-mp3/'+soundID+'.mp3'
        autoLoad: false
        autoPlay: false
        onbufferchange: ->
          this.$playerNodeHtml.toggleClass 'is-buffering', this.isBuffering
          if this.isBuffering
            this.$playerNodeHtml.find('.duration').html('Lade…')
        onfinish: (e) ->
          this.$playerNodeHtml.toggleClass 'is-playing', this.playState
          that.updateSoundBar(0, this.$playerNodeHtml)
        onplay: (e) ->
          this.$playerNodeHtml.toggleClass 'is-playing', this.playState
        onresume: (e) ->
          this.$playerNodeHtml.toggleClass 'is-playing', this.playState
        onpause: ->
          this.$playerNodeHtml.toggleClass 'is-playing', this.playState
        onstop: ->
          this.$playerNodeHtml.toggleClass 'is-playing', this.playState
        onload: (success) ->
          if !success
            this.$playerNodeHtml.find('.duration').html('Fehler :-(')
            alert('Fehler: Die Folge konnte nicht geladen werden. Wenn das Problem weiter auftritt, schreibe bitte an hey@formfunk-podcast.de');
        whileplaying: ->
          unless window.timeDrag
            $bar = this.$playerNodeHtml.find('.bar')
            positionPercent = this.position/this.durationEstimate
            true#that.updateSoundBar(positionPercent*$bar.width(), this.$playerNodeHtml) # 'that' is the global application object
          unless this.isBuffering
            true#that.updatePositionIndicator this
        volume: 100
      soundObject.$playerNodeHtml = $playerNodeHtml
      $playerNodeHtml.removeClass 'is-loading'
      $playButton = $playerNodeHtml.find('.play-button')
      # Get the duration as written in the episode file
      soundObject.myDuration = @hoursToMs JSON.parse($("#audio-data-"+soundID).html()).duration
      # Place fragments
      @placeAudioFragments(playerGroup)
      # Show duration
      $playerNodeHtml.find('.duration').html(@msToHours soundObject.myDuration)
      # Color the bar
      $playerNodeHtml.find('.bar').css('background-color', $playerNodeHtml.parent().attr('data-color'))
      # Bind play button click event
      $playButton.click (event) ->
        soundId = $(this).parent().attr 'data-audio-filename'
        soundObject = soundManager.getSoundById soundId
        if soundObject.playState is 0 then soundObject.play()
        else soundObject.togglePause()
        false
    # Bind timeline click event for small players
    $playerNodeHtml.find('.bar')
      .mousedown (e) =>
        $bar = $(e.currentTarget)
        @updateSoundBar(e.pageX - $bar.offset().left, $bar.parent())
        soundId = $bar.parent().attr 'data-audio-filename'
        soundObject = soundManager.getSoundById soundId
        @updateAudioPosition(soundObject)
    # Bind timeline click event for big player
    $('.fragments-player').find('.bar')
      .click (e) =>
        $bar = $(e.currentTarget)
        positionPercent = (e.pageX - $bar.offset().left) / $bar.width()
        @skipPlaylist(positionPercent)
    # Bind play button click event for big player
    $('.fragments-player').find('.play-button')
      .click (e) =>
        if @fragmentsPlaylist.isPlaying
          @fragmentsPlaylist.currentSoundObject.pause()
        else
          @playFragmentPlaylist()
    @makePlaylist @getFragments [{key:'tagID', value:'frage-weitergeben'}]

  # Query for fragments. To get all fragments of 1 episode, do
  # @getFragments [{key:'soundID', value:'lars-mueller-onl'}]
  # Or, to get all fragments of one tag, do
  # @getFragments [{key:'tagID', value:'geld'}]
  getFragments: (keyValueArray) ->
    return @fragmentsObj
      .filter (x) ->
        for condition in keyValueArray
          if x[condition.key] isnt condition.value then return false
        return true

  buildFragmentsObj: ->
    @fragmentsObj = []
    scriptElement = $("script[id^=audio-fragments]")
    fragmentData = JSON.parse($(scriptElement).html())
    if !fragmentData.fragments then return
    else @fragmentsObj = fragmentData.fragments
    soundIDlist = []
    for fragment, index in @fragmentsObj
      # Convert timecodes to ms
      fragment.start = @hoursToMs fragment.start
      fragment.end = @hoursToMs fragment.end
      # Get the corresponding color
      playerNode = $('.small-player[data-soundID='+fragment.soundID+']')
      fragment.color = playerNode.attr 'data-color'
      # Identifier
      fragment.id = index
      # Get distinct soundIDs (to later order fragments in this order)
      if !(fragment.soundID in soundIDlist)
        soundIDlist.push fragment.soundID
    # Sort by soundID, then by index
    @fragmentsObj.sort (a,b) ->
      soundIDComparison = soundIDlist.indexOf(a.soundID) - soundIDlist.indexOf(b.soundID)
      if soundIDComparison is 0
        return indexComparison = parseInt(a.index, 10) - parseInt(b.index, 10)
      else return soundIDComparison

  # Make a list of unique tag IDs
  buildTagObj: ->
    @tagObj = []
    lookup = {} # only needed temporarily
    for fragment in @fragmentsObj
      if !(fragment.tagID of lookup)
        @tagObj.push
          tagID: fragment.tagID
          frequency: 1
        lookup[fragment.tagID] = 1
      else
        tag.frequency++ for tag in @tagObj when tag.tagID is fragment.tagID

  buildTagList: ->
    tagString = ""
    # Sort by frequency (descending)
    @tagObj.sort (a,b) ->
      return b.frequency - a.frequency
    for tag in @tagObj
      tagString += '<li><a href="#" data-tag-id="'+tag.tagID+'">'+tag.tagID+'</a><span class="frequency">'+tag.frequency+'</span></li> '
    $('.tag-list').append tagString
    # Bind mouse events
    $('.tag-list')
      .mouseenter (e) =>
        $('.fragments-player').addClass 'is-hovering-tag-list'
      .mouseleave (e) =>
        $('.fragments-player').removeClass 'is-hovering-tag-list'

    $('.tag-list a')
      .mouseenter (e) =>
        # Get all fragment divs in the small players that belong to this tag
        that = this
        $('.small-player .small-player-fragment[data-tag-id='+$(e.currentTarget).attr('data-tag-id')+']').each(->
          this.classList.add('is-highlighted')
          fragmentID = $(this).attr('id').match(/([^-]*)$/)[0] # Get only the number from a fragment id string
          color = that.getFragments([{key: 'id', value: parseInt(fragmentID)}])[0].color
          d3.select(this).style("fill", color)
        )
      .mouseleave (e) =>
        $('.small-player .small-player-fragment[data-tag-id='+$(e.currentTarget).attr('data-tag-id')+']').each(->
          this.classList.remove('is-highlighted')
          d3.select(this).style("fill", "")
        )
      .mouseup (e) =>
        fragmentsArray = @getFragments [{key: 'tagID', value: $(e.currentTarget).attr('data-tag-id')}]
        @makePlaylist fragmentsArray
        @playFragmentPlaylist()
        $('.fragments-player').removeClass 'is-hovering-tag-list'
      .click (e) ->
        e.preventDefault()

  prepareSVG: ->
    @visConfig =
      width: '100%' # Width and height of .fragments-player
      height: '100%'
      fragmentHeight: 10
      smallPlayerWidth: (100/$('.small-player').length) + '%'
      smallPlayerHeight: 100
    @svgEle = {} # Object containing references to all important svg elements
    d3.select(".fragments-player")
      .append("svg")
      .attr("width", $(".fragments-player").width())
      .attr("height", $(".fragments-player").height())
      .attr("id", "main-svg")
    @svgEle.svg = d3.select("#main-svg")
    # Position svg exactly where .fragments.player is
    $('svg#main-svg').css({position: 'absolute', top: 0, left: 0})
    @svgEle.smallPlayersGroup = @svgEle.svg.append 'g'
    @svgEle.bigPlayerGroup = @svgEle.svg.append 'g'
    # Make cursor
    @svgEle.svg.append("rect")
      .attr("id", "big-player-cursor")
      .attr("width", 2)
      .attr("height", @visConfig.fragmentHeight*4)
      .attr("x", $('.tag-list').position().left)
      .attr("y", @svgEle.svg.attr('height')/2 - @visConfig.fragmentHeight*2)
    #Area test
    data = [
      {x: 0, y1: 10, t: 1 },
      {x: 5, y1: 10, t: 1 },
      {x: 10, y1: 10, t: 1 },
      {x: 15, y1: -10, t: 3 },
      {x: 30, y1: -10, t: 3 },
      {x: 45, y1: -10, t: 3 },
      {x: 10, y1: 10, t: 1 },
      {x: 15, y1: 10, t: 1 },
      {x: 20, y1: 10, t: 1 }
    ]
    scale = 10
    pos = {x: 100, y: 200}
    area = d3.svg.area()
      .x0((d, i) ->
        #add = 0
        #if i < data.length-1 and data[i+1].x < data[i].x
        #  console.log 'loopin back'
        #  add = d.t*scale*2
        return d.x*scale+pos.x #-add
      )
      .x1((d) -> return d.x*scale+pos.x)
      .y0((d) -> return (-d.y1*scale-d.t*scale+pos.y))
      .y1((d) -> return (-d.y1*scale+pos.y))
    area.interpolate('cardinal').tension(1)
    @svgEle.svg.append("path")
      .attr("class", "area")
      .attr("d", area(data))

  makePlaylist: (arrayOfFragments) ->
    @state.skipping = true
    soundManager.stopAll() # Stop all playing sounds.
    @state.skipping = false
    @fragmentsPlaylist = {}
    @fragmentsPlaylist.fragments = arrayOfFragments
    @fragmentsPlaylist.currentFragment = 0
    @fragmentsPlaylist.currentSoundObject = soundManager.getSoundById @fragmentsPlaylist.fragments[0].soundID
    @fragmentsPlaylist.isPlaying = false
    # Total length
    @fragmentsPlaylist.duration = 0
    # This is only set to true when user intentionally skips in playlist
    # (not when natural progress from one track to the next)
    @state.skipping = false
    for fragment in @fragmentsPlaylist.fragments
      @fragmentsPlaylist.duration += (fragment.end - fragment.start)
    # Visualize fragments
    barString = ""
    sumSoFar = 0 # Keep track of bars already shown so we use the correct offset to the left.
    barWidth = $('.tag-list').width()
    @svgEle.bigPlayerGroup.selectAll('*').remove() # Delete existing fragments
    that = this
    @svgEle.bigPlayerGroup
      .selectAll("rect")
      .data(@fragmentsPlaylist.fragments)
      .enter()
      .append("rect")
      .attr("x", (d, i) =>
        widthPx = (d.end-d.start) / @fragmentsPlaylist.duration * barWidth + 2
        sumSoFar += widthPx
        return sumSoFar - widthPx + $('.tag-list').position().left
      )
      .attr("y", @svgEle.svg.attr('height')/2 - @visConfig.fragmentHeight/2)
      .attr("width", (d, i) =>
        widthPx = (d.end-d.start) / @fragmentsPlaylist.duration * barWidth
        return widthPx
      )
      .attr("height", @visConfig.fragmentHeight)
      .attr("fill", (d, i) ->
        return d.color
      )
      .attr("id", (d, i) -> return "big-fragment-"+d.id)
      .classed("big-player-fragment", true)
      .on("click", (e) ->
        xInSvg = d3.mouse(this)[0]
        xInBar = xInSvg - $('.big-player-fragment').first().position().left
        barWidth = $('.tag-list').width()
        positionPercent = xInBar / barWidth
        that.skipPlaylist(positionPercent)
      )
    # Display connecting edges
    @displayConnectingEdges(@fragmentsPlaylist.fragments)
    # Position and show play button
    $('.fragments-player .play-button').css({top: $('.big-player-fragment').first().position().top+@visConfig.fragmentHeight/2-$('.fragments-player .play-button').height()/2})
    $('.fragments-player').addClass 'is-playlist-loaded'

  # Display connecting lines between fragments in small players and fragments in
  # big player.
  displayConnectingEdges: (arrayOfFragments) ->
    # Remove existing edges
    @svgEle.svg.selectAll(".connecting-edge").remove() # Delete existing fragments
    # Generate d attribute string from point data
    lineFunction = d3.svg.line()
      .x((d) -> return d.x )
      .y((d) -> return d.y )
      .interpolate("linear")
    for fragment in arrayOfFragments
      # Left edge
      smallFragmentBBox = d3.select('#small-fragment-'+fragment.id).node().getBBox()
      bigFragmentBBox = d3.select('#big-fragment-'+fragment.id).node().getBBox()
      pointData = [
          # Bottom left of small fragment
          x: smallFragmentBBox.x
          y: smallFragmentBBox.y + smallFragmentBBox.height
        ,
          # Top left of big fragment
          x: bigFragmentBBox.x
          y: bigFragmentBBox.y
        ,
          # Top right of big fragment
          x: bigFragmentBBox.x + bigFragmentBBox.width
          y: bigFragmentBBox.y
        ,
          # Bottom right of small fragment
          x: smallFragmentBBox.x + smallFragmentBBox.width
          y: smallFragmentBBox.y + smallFragmentBBox.height
        ]
      path = @svgEle.svg.append("path")
        .classed("connecting-edge", true)
        .attr("d", lineFunction(pointData))
        .style("fill", fragment.color)
        .style("fill-opacity", 0.1)

  positionPositionMarker: (offset) ->
    d3.select('#big-player-cursor').
      attr("x", offset)

  # Calls itself until the playlist is played completely.
  playFragmentPlaylist: (index=0, ms=0) ->
    if Array.isArray(@fragmentsPlaylist.fragments) and @fragmentsPlaylist.currentFragment < @fragmentsPlaylist.fragments.length
      fragment = @fragmentsPlaylist.fragments[index]
      if @state.skipping then @fragmentsPlaylist.currentSoundObject.stop()
      @fragmentsPlaylist.currentSoundObject = soundManager.getSoundById fragment.soundID
      @fragmentsPlaylist.currentFragment = index
      that = this
      @fragmentsPlaylist.currentSoundObject.play
        from: fragment.start+ms
        to: fragment.end
        onplay: =>
          @fragmentsPlaylist.isPlaying = true
          $('.fragments-player').toggleClass 'is-playing', @fragmentsPlaylist.currentSoundObject.playState
        onstop: =>
          @fragmentsPlaylist.isPlaying = false
          #that.positionPositionMarker("100%") # TODO not at the very end but at the end of this fragment
          $('.fragments-player').toggleClass 'is-playing', @fragmentsPlaylist.currentSoundObject.playState
          unless @state.skipping is true
            @playFragmentPlaylist(@fragmentsPlaylist.currentFragment+1)
          @state.skipping = false
        onpause: =>
          @fragmentsPlaylist.isPlaying = false
          $('.fragments-player').toggleClass 'is-playing', @fragmentsPlaylist.currentSoundObject.playState
        onresume: =>
          @fragmentsPlaylist.isPlaying = true
          $('.fragments-player').toggleClass 'is-playing', @fragmentsPlaylist.currentSoundObject.playState
        onfinish: =>
          $('.fragments-player').toggleClass 'is-playing', @fragmentsPlaylist.currentSoundObject.playState
        whileplaying: ->
          $fragmentNode = $('#big-fragment-'+fragment.id)
          left = parseInt($fragmentNode.attr("x"))
          width = d3.select('#big-fragment-'+fragment.id).node().getBBox().width
          left += (this.position-fragment.start)/(fragment.end-fragment.start) * width
          that.positionPositionMarker(left)

  skipPlaylist: (percent) ->
    if !@fragmentsPlaylist or !Array.isArray(@fragmentsPlaylist.fragments) then return
    targetMs = percent * @fragmentsPlaylist.duration
    currentSum = 0
    for fragment, index in @fragmentsPlaylist.fragments
      fragmentDuration = fragment.end - fragment.start
      if (currentSum + fragmentDuration) >= targetMs
        ms = targetMs - currentSum
        i = index
        break
      else currentSum += fragmentDuration
    @state.skipping = true
    $('.fragments-player').addClass 'is-playing'
    @playFragmentPlaylist i, ms

  # Place fragments on small players
  placeAudioFragments: (smallPlayerGroup) ->
    audioFilename = smallPlayerGroup.attr 'data-soundID'
    soundObject = soundManager.getSoundById(audioFilename)
    duration = soundObject.myDuration
    barWidth = smallPlayerGroup.selectAll(".bar").node().getBBox().width
    barPosX = smallPlayerGroup.selectAll(".bar").node().getBBox().x
    barPosY = smallPlayerGroup.selectAll(".bar").node().getBBox().y
    fragmentsArray = @getFragments([{key: 'soundID', value: audioFilename}])
    if fragmentsArray.length is 0 then return
    smallPlayerGroup.append("g")
      .selectAll("rect")
      .data(fragmentsArray)
      .enter()
      .append("rect")
      .attr("class", "small-player-fragment")
      .attr("x", (d, i) ->
        positionPx = d.start / soundObject.myDuration * barWidth + barPosX
        return positionPx
      )
      .attr("y", barPosY)
      .attr("width", (d, i) ->
        widthPx = (d.end-d.start) / soundObject.myDuration * barWidth
        return widthPx
      )
      .attr("height", @visConfig.fragmentHeight)
      .attr("id", (d, i) -> return "small-fragment-"+d.id)
      .attr("data-tag-id", (d, i) -> return d.tagID)

  showSubscribeOptions: ->
    $('.subscribe-options').removeClass 'is-hidden'

  hoursToMs: (string) ->
    # Timecode format: HH:MM:SS.FFF where HH (hours) and FFF (milliseconds) are optional.
    [string, millis] = string.split(".") # Strip milliseconds if available. We'll add them later.
    a = string.split(':')
    s = 0
    m = 1
    while a.length > 0
      s += m * parseInt(a.pop(), 10)
      m *= 60
    result = s*1000
    if millis? then result += parseInt(millis, 10) # Add milliseconds if they were given.
    return result

  msToHours: (ms) ->
    milliseconds = parseInt(ms % 1000 / 100)
    seconds = parseInt(ms / 1000 % 60)
    minutes = parseInt(ms / (1000 * 60) % 60)
    hours = parseInt(ms / (1000 * 60 * 60) % 24)
    #hours = if hours < 10 then '0' + hours else hours
    minutes = if minutes < 10 then '0' + minutes else minutes
    seconds = if seconds < 10 then '0' + seconds else seconds
    string = minutes + ':' + seconds
    if parseInt(hours) > 0 then string = hours + ':' + string
    return string

  highlightMarker: (nr, onOff) ->
    $('.audio-player .audio-marker[data-nr='+nr+']').toggleClass 'is-highlighted', onOff
    $('.marker-list li[data-nr='+nr+']').toggleClass 'is-highlighted', onOff

  onResize: ->
    @determineBreakpoint()
    @windowInnerHeight = window.innerHeight
    @setupRoleModelPath @state.currentPage
    @initMenuPath()
    if @state.menuOpen is true
      @morphPath @menuPath, null, true
    else
      @morphPath @roleModelPath, null, (@state.currentPage isnt 'home')

  updateSoundBar: (px, $node) ->
    $bar = $node.find('.bar')
    positionPercent = px/$bar.width() * 100
    positionPercent = Math.max(0, positionPercent)
    positionPercent = Math.min(100, positionPercent)
    $bar.css 'background-image', 'linear-gradient(90deg, black, black '+positionPercent+'%, white '+positionPercent+'% )'
    $bar.data 'positionPercent', positionPercent

  # Jump to audio position based on position of visual timeline.
  updateAudioPosition: (soundObject) ->
    $bar = $('.audio-player[data-audio-filename='+soundObject.id+']').find('.bar')
    positionPercent = $bar.data 'positionPercent'
    soundObject.setPosition(positionPercent / 100 * soundObject.myDuration)
    unless soundObject.isBuffering
      @updatePositionIndicator soundObject

  # Update time digits
  updatePositionIndicator: (soundObject, ms = null) ->
    $node = $('.audio-player[data-audio-filename='+soundObject.id+']').find('.duration')
    pos = if ms then ms else soundObject.position
    pos = if pos then pos else soundObject.myDuration
    $node.html(F.prototype.msToHours pos)

  # Request animation frame polyfill
  scroll = window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.msRequestAnimationFrame or window.oRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60

  scrollLoop: =>
    if window.pageYOffset isnt @oldPageYOffset
      @oldPageYOffset = window.pageYOffset
      if @state.currentPage is 'home'
        @selectFocusedArticle()
    scroll(@scrollLoop)

  getUserAgentData: ->
    @state.ua = {}
    vendor = $body.attr 'data-ua-vendor'
    if vendor then @state.ua.vendor = vendor
    version = $body.attr 'data-ua-version'
    if version then @state.ua.version = version

  loadPageAjax: (url, fromPage, toPage) ->
    $.ajax
      url: url
      success: (data) =>
        $response = $(data)
        colorString = $response.find('.ajax').attr('data-color')
        if colorString then @state.currentColor = colorString
        ajaxContent = $response.find('.ajax').html()
        $('.main').html(ajaxContent)
        @setupPage fromPage, toPage
        @popped = true
      error: ->
        $('#mailchimp-subscribe').addClass 'state-error'
        $('#result').html('Tut uns leid, es gab ein Verbindungsproblem. Schreib eine Mail an <a href="mailto:hey@formfunk-podcast.de">hey@formfunk-podcast.de</a>')

  bindUserEvents: ->
    # Bind user events
    $('.menu-link').click =>
      if @state.menuOpen then @closeMenu(true) else @openMenu()
      false
    # Use back / forward buttons
    $(window).on 'popstate', (e) =>
      if !@popped
        console.log 'wrong popstate event'
        return # Some browsers fire popState event on page load. Prevent this.
      fromPage = @state.currentPage
      @state = e.originalEvent.state
      # Some browsers (Safari) produce page transitions when using trackpad gestures which make the path animation look ugly. This prevents the path animation.
      if @state.ua.vendor? and @state.ua.vendor is "Safari" then @state.dontAnimateNextMorphPath = true
      @loadPageAjax(location.href, fromPage, @state.currentPage)
    $(document).on 'click', 'a.home-link, a.v-home-link', (e) =>
      if e.metaKey or e.ctrlKey then return # Let people use CMD+click / CTRL+click to open in new tab
      unless @state.currentPage is 'home'
        $this = $(e.currentTarget)
        history.pushState(@state, 'Home', $this.attr('href'))
        @loadPageAjax($this.attr('href'), @state.currentPage, 'home')
      if @state.currentPage is 'home' and @state.menuOpen is true
        @closeMenu()
      false
    $(document).on 'click', 'a.ajax-link', (e) =>
      if e.metaKey or e.ctrlKey then return # Let people use CMD+click / CTRL+click to open in new tab
      $this = $(e.currentTarget)
      history.pushState(@state, null, $this.attr('href'))
      @loadPageAjax($this.attr('href'), @state.currentPage, $this.attr('data-target-page'))
      false
    # Ajax submit of newsletter subscription
    $(document).on 'submit', '#mailchimp-subscribe', =>
      @mailchimpSubscribe()
      return false
    # Track when faded-in subscribe links on episode page are clicked
    $(document).on 'click', '.subscribe-options a', ->
      ga('send',
        hitType: 'event'
        eventCategory: 'faded-in-subscribe-options'
        eventAction: 'click'
        eventLabel: $(this).html()
      )
    # Necessary for audio player
    window.timeDrag = false # Mouse drag status
    $(document).mouseup (e) =>
      if window.timeDrag
        window.timeDrag = false
        @updateSoundBar(e.pageX - $('.audio-player .bar').offset().left, $('.audio-player'))
        @updateAudioPosition @sound
    $(document).mousemove (e) =>
      if window.timeDrag
        @updateSoundBar(e.pageX - $('.audio-player .bar').offset().left, $('.audio-player'))

    $(document)
      .on 'keydown', (event) =>
        switch (event.which)
          # Escape
          when 27
            # Is menu open?
            if @state.menuOpen is true
              @closeMenu(true)
            break

f = new F()
$('body').removeClass('is-transparent')

# Click anywhere to enter fullScreeen
$('body').click(->
  console.log 'You clicked. Launching fullscreen…'
  document.documentElement.webkitRequestFullScreen()
)
