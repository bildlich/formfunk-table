var $body, F, changeAudioVisual, chapterData, episodeData, f, hoursToMs, movementDiminisher, randomInt, resetEverything, setStartPoint, setupSoundObjects, socket, speedFactor, tableSettings,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

socket = io();

socket.on('connect', function() {
  console.log('projection connect');
  return socket.emit('projection connect');
});

socket.on('disconnect', function() {
  console.log('projection disconnect');
  return socket.emit('projection disconnect');
});

socket.on('change audiovisual', function(chapterID) {
  console.log('changing audiovisual to ' + chapterID);
  return changeAudioVisual(chapterID);
});

socket.on('reset', function() {
  console.log('resetting…');
  return resetEverything();
});

episodeData = {
  'erik-spiekermann-onl': {
    color: 'blue'
  }
};

chapterData = {
  '804009FA3CAD04': {
    'soundID': 'erik-spiekermann-onl',
    'start': '0:29.810'
  },
  '804009FA3CEB04': {
    'soundID': 'erik-spiekermann-onl',
    'start': '12:48.747'
  },
  '804009FA3CEC04': {
    'soundID': 'erik-spiekermann-onl',
    'start': '24:19.164'
  }
};

setupSoundObjects = function() {
  return soundManager.setup({
    debugMode: false,
    onready: function() {
      var color, results, soundID, soundObject;
      console.log('ready!');
      results = [];
      for (soundID in episodeData) {
        color = episodeData[soundID].color;
        results.push(soundObject = soundManager.createSound({
          id: soundID,
          url: '/local-mp3/' + soundID + '.mp3',
          autoLoad: false,
          autoPlay: false,
          volume: 100,
          onfinish: (function(_this) {
            return function(e) {
              return f.state.playing = false;
            };
          })(this),
          onplay: (function(_this) {
            return function(e) {
              return f.state.playing = true;
            };
          })(this),
          onresume: (function(_this) {
            return function(e) {
              return f.state.playing = true;
            };
          })(this),
          onpause: (function(_this) {
            return function() {
              return f.state.playing = false;
            };
          })(this),
          onstop: (function(_this) {
            return function() {
              return f.state.playing = false;
            };
          })(this)
        }));
      }
      return results;
    }
  });
};

setupSoundObjects();

resetEverything = function() {
  soundManager.stopAll();
  return f.changePathColor('#ff0000');
};

changeAudioVisual = function(chapterID) {
  var soundObject;
  if (!chapterData[chapterID]) {
    console.log("The chapterID " + chapterID + " doesn't exist.");
    return;
  }
  soundObject = soundManager.getSoundById(chapterData[chapterID].soundID);
  soundManager.stopAll();
  if (episodeData[chapterData[chapterID].soundID]) {
    f.changePathColor(episodeData[chapterData[chapterID].soundID].color);
  }
  return soundObject.play({
    from: hoursToMs(chapterData[chapterID].start)
  });
};

hoursToMs = function(string) {
  var a, m, millis, ref, result, s;
  ref = string.split("."), string = ref[0], millis = ref[1];
  a = string.split(':');
  s = 0;
  m = 1;
  while (a.length > 0) {
    s += m * parseInt(a.pop(), 10);
    m *= 60;
  }
  result = s * 1000;
  if (millis != null) {
    result += parseInt(millis, 10);
  }
  return result;
};

speedFactor = 1.5;

movementDiminisher = 0.1;

$body = $('body');

tableSettings = {
  logoMarginLeft: 20,
  logoMarginTop: 18,
  logoScale: 0.9,
  strokeWidth: 7,
  strokeWidthLogo: 5,
  colorChangeSpeed: 50,
  fadePageSpeed: 1000
};

randomInt = function(min, max) {
  var randomnumber;
  return randomnumber = Math.floor(Math.random() * (max - min + 1)) + min;
};

setStartPoint = function(path, index) {
  var buffer, i, j, ref, results;
  results = [];
  for (i = j = 0, ref = index - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
    buffer = path.segments.shift();
    results.push(path.segments.push(buffer));
  }
  return results;
};

F = (function() {
  var scroll;

  function F() {
    this.scrollLoop = bind(this.scrollLoop, this);
    this.playerAnalytics = bind(this.playerAnalytics, this);
    var i, j, k, ref, ref1;
    this.state = {};
    this.state.currentPage = $body.attr('data-current-page');
    this.getUserAgentData();
    history.replaceState(this.state, null, null);
    this.popped = false;
    this.oldPageYOffset = window.pageYOffset;
    paper.install(window);
    this.mainP = new paper.Project('paper-canvas');
    this.logoP = new paper.Project('logo-canvas');
    this.mainP.activate();
    this.windowInnerHeight = window.innerHeight;
    this.noOfPoints = 4;
    this.smooth = false;
    this.path = new Path();
    this.mousePos = view.center.divide(new Point(2, 2));
    this.pathHeight = this.mousePos.x;
    this.path.style = {
      fillColor: this.getCurrentColor(),
      strokeWidth: tableSettings.strokeWidth,
      strokeColor: 'black'
    };
    this.framesWhenPlayStateChanged = 0;
    this.center = view.center;
    this.width = view.size.width / 2;
    this.height = view.size.height / 2;
    this.path.segments = [];
    for (i = j = 1, ref = this.noOfPoints + 4; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
      this.path.add(new Point(0, 0));
    }
    for (i = k = 2, ref1 = this.noOfPoints + 1; 2 <= ref1 ? k <= ref1 : k >= ref1; i = 2 <= ref1 ? ++k : --k) {
      this.path.segments[i].data = {
        movable: true
      };
    }
    this.path.position = view.center;
    this.roleModelPath = this.path.clone();
    this.roleModelPath.visible = false;
    this.initLogo();
    view.onFrame = (function(_this) {
      return function(event) {
        if (event.count % 2 === 0) {
          if (!_this.state.menuOpen) {
            if (_this.state.currentPage === 'home') {
              _this.animateWaves(event.count, 'horizontal');
              _this.animateColor();
            } else if (_this.state.currentPage === 'episode' || 'table') {
              _this.animateWaves(event.count, 'vertical');
              _this.animateColor();
            }
            _this.movePoints(event, _this.path);
          }
        }
        if (event.count % 4 === 0) {
          _this.animateLogo(event);
          return true;
        }
      };
    })(this);
    this.setupPage('', this.state.currentPage);
    this.bindUserEvents();
    this.scrollLoop();
  }

  F.prototype.getAllSegments = function(item) {
    var allSegments, g, j, k, len, len1, path, ref, segment;
    if (!item.children) {
      return item.segments;
    } else {
      g = item.children;
      allSegments = [];
      for (j = 0, len = g.length; j < len; j++) {
        path = g[j];
        ref = path.segments;
        for (k = 0, len1 = ref.length; k < len1; k++) {
          segment = ref[k];
          allSegments.push(segment);
        }
      }
      return allSegments;
    }
  };

  F.prototype.getCurrentColor = function() {
    if (!this.state.currentColor) {
      this.state.currentColor = $('.ajax').attr('data-color');
    }
    return this.state.currentColor;
  };

  F.prototype.animateWaves = function(count, orientation) {
    var allSegments, index, j, len, results, segment, sinHeight, sinSeed;
    allSegments = this.getAllSegments(this.path);
    results = [];
    for (index = j = 0, len = allSegments.length; j < len; index = ++j) {
      segment = allSegments[index];
      if (!(segment.data && segment.data.movable === true)) {
        continue;
      }
      sinSeed = count + 200 * index;
      sinHeight = Math.sin(sinSeed / 200);
      if (orientation === 'horizontal') {
        results.push(segment.data.offsetX = (Math.sin(sinSeed / 100) * sinHeight * this.pathHeight) / 3);
      } else if (orientation === 'vertical') {
        if (!this.heightDiminisher) {
          this.heightDiminisher = 4;
        }
        if (!this.speedDiminisher) {
          this.speedDiminisher = 120;
        }
        if (this.state.playing !== this.state.oldPlaying) {
          this.state.oldPlaying = this.state.playing;
          this.framesWhenPlayStateChanged = count;
        }
        if (!this.state.playing) {
          this.heightDiminisher = this.changeVarOverTime(this.heightDiminisher, 2, 1000, this.framesWhenPlayStateChanged, count);
        } else {
          this.heightDiminisher = this.changeVarOverTime(this.heightDiminisher, 4, 1000, this.framesWhenPlayStateChanged, count);
        }
        results.push(segment.data.offsetY = (Math.sin(sinSeed / this.speedDiminisher) * sinHeight) * (this.pathHeight / this.heightDiminisher));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  F.prototype.animateLogo = function(event) {
    var index, j, len, maxWobble, moveVector, ref, segment;
    maxWobble = this.wavable.bounds.width / 30;
    ref = this.wavable.segments;
    for (index = j = 0, len = ref.length; j < len; index = ++j) {
      segment = ref[index];
      if ((segment.data.targetPoint === void 0) || segment.data.targetVector.length < 1) {
        if (segment.data.goBackHome === void 0) {
          segment.data.goBackHome = true;
        }
        segment.data.goBackHome = !segment.data.goBackHome;
        if (!segment.data.goBackHome) {
          if (index === 5) {
            segment.data.targetVector = this.getRandomVector(maxWobble, 0);
            segment.data.targetPoint = segment.point.add(segment.data.targetVector);
          } else if (index === 11) {
            segment.data.targetVector = this.getRandomVector(maxWobble, 0);
            segment.data.targetPoint = segment.point.add(segment.data.targetVector);
          } else {
            segment.data.targetVector = this.getRandomVector(maxWobble);
            segment.data.targetPoint = segment.point.add(segment.data.targetVector);
          }
        } else {
          segment.data.targetPoint = segment.data.originalPosition.clone();
          segment.data.targetVector = segment.data.targetPoint.subtract(segment.point);
        }
        segment.data.speed = 30;
      }
      moveVector = segment.data.targetVector.clone();
      moveVector.length *= segment.data.speed / 1000 * speedFactor;
      segment.point = segment.point.add(moveVector);
      segment.data.targetVector.length -= moveVector.length;
    }
    return this.logoP.view.update();
  };

  F.prototype.initLogo = function() {
    var homeLink, j, len, ref, segment;
    if (this.logo) {
      this.logo.remove();
    }
    this.logoP.activate();
    this.logo = this.svgToPath('wavable');
    this.logo.visible = true;
    this.logo.style = {
      fillColor: 'black'
    };
    this.wavable = this.logo.children['wavable-o'];
    this.wavable.style = {
      fillColor: 'red',
      strokeColor: 'black'
    };
    this.logo.scale(tableSettings.logoScale);
    this.logo.pivot = this.logo.bounds.topLeft;
    this.logo.position = new Point(0, 0);
    this.wavable.strokeWidth = tableSettings.strokeWidthLogo;
    ref = this.wavable.segments;
    for (j = 0, len = ref.length; j < len; j++) {
      segment = ref[j];
      segment.data = {
        originalPosition: segment.point.clone()
      };
    }
    homeLink = $('.home-link').clone().empty().removeClass('home-link').addClass('v-home-link').css({
      left: this.logo.position.x + 'px',
      top: this.logo.position.y + 'px',
      width: this.logo.bounds.width,
      height: this.logo.bounds.height
    });
    $('body').append(homeLink);
    view.update();
    return this.mainP.activate();
  };

  F.prototype.changeVarOverTime = function(startValue, endValue, durationInFrames, startFrame, currentFrame) {
    var t, val;
    t = (currentFrame - startFrame) / durationInFrames;
    if (t > 1) {
      return endValue;
    }
    return val = startValue + t * (endValue - startValue);
  };

  F.prototype.svgToPath = function(svgID) {
    var imported, newPath, newPaths, relativeHeight, relativeWidth;
    imported = project.importSVG(document.getElementById(svgID));
    newPath = imported.reduce();
    relativeWidth = newPath.bounds.width / view.bounds.width;
    relativeHeight = newPath.bounds.height / newPath.bounds.height;
    if (relativeWidth > relativeHeight) {
      newPath.scale(1 / relativeWidth);
    } else {
      newPath.scale(1 / relativeHeight);
    }
    newPath.applyMatrix = true;
    newPath.translate(view.bounds.center.subtract(newPath.bounds.center));
    newPath.visible = false;
    newPath.closed = true;
    newPaths = newPath.hasChildren() ? newPath.children : [newPath];
    view.update();
    return newPath;
  };

  F.prototype.morphPath = function(roleModelPath, callback, instantly, speed, easing, animateHandles) {
    var allPathHandleIns, allPathHandleOuts, allPathPoints, allRoleModelPathData, allRoleModelPathHandleIns, allRoleModelPathHandleOuts, allRoleModelPathPoints, childPath, clone, clonePath, clonePaths, index, j, k, l, len, len1, len2, len3, len4, len5, n, o, p, pathCounter, paths, ref, ref1, ref2, roleModelPathChild, roleModelPaths, segment;
    if (callback == null) {
      callback = void 0;
    }
    if (instantly == null) {
      instantly = false;
    }
    if (speed == null) {
      speed = void 0;
    }
    if (easing == null) {
      easing = void 0;
    }
    if (animateHandles == null) {
      animateHandles = false;
    }
    paths = this.path.hasChildren() ? this.path.children : [this.path];
    allPathPoints = [];
    if (animateHandles) {
      allPathHandleIns = [];
      allPathHandleOuts = [];
    }
    for (j = 0, len = paths.length; j < len; j++) {
      childPath = paths[j];
      ref = childPath.segments;
      for (k = 0, len1 = ref.length; k < len1; k++) {
        segment = ref[k];
        allPathPoints.push(segment.point.clone());
        if (animateHandles) {
          allPathHandleIns.push(segment.handleIn.clone());
          allPathHandleOuts.push(segment.handleOut.clone());
        }
      }
    }
    roleModelPaths = roleModelPath.hasChildren() ? roleModelPath.children : [roleModelPath];
    allRoleModelPathPoints = [];
    if (animateHandles) {
      allRoleModelPathHandleIns = [];
      allRoleModelPathHandleOuts = [];
    }
    allRoleModelPathData = [];
    for (l = 0, len2 = roleModelPaths.length; l < len2; l++) {
      roleModelPathChild = roleModelPaths[l];
      ref1 = roleModelPathChild.segments;
      for (n = 0, len3 = ref1.length; n < len3; n++) {
        segment = ref1[n];
        if (!segment.data) {
          segment.data = {};
        }
        allRoleModelPathPoints.push(segment.point.clone());
        allRoleModelPathData.push(segment.data);
        if (animateHandles) {
          allRoleModelPathHandleIns.push(segment.handleIn.clone());
          allRoleModelPathHandleOuts.push(segment.handleOut.clone());
        }
      }
    }
    clone = roleModelPath.clone();
    clonePaths = clone.hasChildren() ? clone.children : [clone];
    index = 0;
    for (pathCounter = o = 0, len4 = clonePaths.length; o < len4; pathCounter = ++o) {
      clonePath = clonePaths[pathCounter];
      ref2 = clonePath.segments;
      for (p = 0, len5 = ref2.length; p < len5; p++) {
        segment = ref2[p];
        if (!(instantly || this.state.dontAnimateNextMorphPath)) {
          if (allPathPoints[index]) {
            segment.point = allPathPoints[index];
          } else {
            if (roleModelPath.data && (roleModelPath.data.createNewPointsAtIndex != null)) {
              segment.point = clonePath.segments[roleModelPath.data.createNewPointsAtIndex].point;
            }
          }
          if (animateHandles) {
            segment.handleIn = allPathHandleIns[index];
            segment.handleOut = allPathHandleOuts[index];
          }
        }
        segment.data = allRoleModelPathData[index];
        segment.data.explicitTarget = allRoleModelPathPoints[index];
        segment.data.originalPosition = allRoleModelPathPoints[index].clone();
        if (speed) {
          segment.data.speed = speed;
        }
        if (easing) {
          segment.data.easing = easing;
        }
        if (animateHandles) {
          segment.data.animateHandles = true;
          segment.data.handleInTarget = allRoleModelPathHandleIns[index];
          segment.data.handleOutTarget = allRoleModelPathHandleOuts[index];
        }
        index++;
      }
    }
    clonePaths[0].firstSegment.data.callback = callback;
    clone.visible = true;
    clone.selected = this.path.selected;
    clone.style = this.path.style;
    clone.data = this.path.data;
    clone.insertBelow(this.path);
    this.path.remove();
    this.path = clone;
    this.state.isMorphing = true;
    if (this.state.dontAnimateNextMorphPath) {
      this.state.dontAnimateNextMorphPath = false;
    }
    return view.update();
  };

  F.prototype.movePoints = function(event, path) {
    var finishedAnimation, j, k, len, len1, moveVector, pathIndex, paths, ref, results, segment, segmentIndex;
    paths = path.hasChildren() ? path.children : [path];
    results = [];
    for (pathIndex = j = 0, len = paths.length; j < len; pathIndex = ++j) {
      path = paths[pathIndex];
      ref = path.segments;
      for (segmentIndex = k = 0, len1 = ref.length; k < len1; segmentIndex = ++k) {
        segment = ref[segmentIndex];
        if (!segment.data) {
          segment.data = {};
        }
        if (segment.data.explicitTarget != null) {
          finishedAnimation = true;
          segment.data.targetPoint = segment.data.explicitTarget;
          segment.data.targetVector = segment.data.explicitTarget.subtract(segment.point);
          if (!segment.data.speed) {
            segment.data.speed = 5;
          }
          if (segment.data.easing === 'linear') {
            segment.data.projectedDuration = 1000 / segment.data.speed * speedFactor;
            segment.data.movePerStep = segment.data.targetVector.length / segment.data.projectedDuration;
          }
          segment.data.explicitTarget = null;
          segment.data.pointWithoutOffset = segment.point.clone();
        }
        if (segment.data.targetVector && segment.data.targetVector.length > 1) {
          finishedAnimation = false;
          moveVector = segment.data.targetVector.clone();
          if (segment.data.easing === 'linear') {
            moveVector.length = Math.min(segment.data.movePerStep, segment.data.targetVector.length);
          } else {
            moveVector.length *= segment.data.speed / 50 * speedFactor;
          }
          segment.data.pointWithoutOffset = segment.data.pointWithoutOffset.add(moveVector);
          segment.data.targetVector.length -= moveVector.length;
        }
        if (segment.data.offsetX) {
          segment.point.x = segment.data.pointWithoutOffset.x + segment.data.offsetX;
          segment.data.offsetX = void 0;
        } else {
          segment.point.x = segment.data.pointWithoutOffset.x;
        }
        if (segment.data.offsetY) {
          segment.point.y = segment.data.pointWithoutOffset.y + segment.data.offsetY;
          segment.data.offsetY = void 0;
        } else {
          segment.point.y = segment.data.pointWithoutOffset.y;
        }
      }
      if (finishedAnimation === true) {
        if (this.state.isMorphing) {
          this.state.isMorphing = false;
        }
        if (path.segments[0].data.callback) {
          path.segments[0].data.callback.call(this);
        }
        results.push(finishedAnimation = false);
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  F.prototype.animateColor = function() {
    var blueDifference, greenDifference, redDifference;
    if (this.path.data.targetColor !== void 0) {
      redDifference = this.path.data.targetColor.red - this.path.fillColor.red;
      greenDifference = this.path.data.targetColor.green - this.path.fillColor.green;
      blueDifference = this.path.data.targetColor.blue - this.path.fillColor.blue;
      if (Math.max(Math.abs(redDifference), Math.abs(greenDifference), Math.abs(blueDifference)) > 0.001) {
        this.path.fillColor.red += redDifference / tableSettings.colorChangeSpeed;
        this.path.fillColor.green += greenDifference / tableSettings.colorChangeSpeed;
        this.path.fillColor.blue += blueDifference / tableSettings.colorChangeSpeed;
        this.wavable.fillColor.red += redDifference / tableSettings.colorChangeSpeed;
        this.wavable.fillColor.green += greenDifference / tableSettings.colorChangeSpeed;
        return this.wavable.fillColor.blue += blueDifference / tableSettings.colorChangeSpeed;
      } else {
        return this.path.data.targetColor = void 0;
      }
    }
  };

  F.prototype.changePathColor = function(color, instantly) {
    if (instantly == null) {
      instantly = false;
    }
    if (!instantly) {
      return this.path.data.targetColor = new Color(color);
    } else {
      this.path.fillColor = color;
      this.wavable.fillColor = color;
      this.mainP.view.update();
      return this.logoP.view.update();
    }
  };

  F.prototype.getRandomVector = function(maxLength, direction) {
    var randomVector;
    if (direction == null) {
      direction = 'random';
    }
    if (direction !== 'random') {
      randomVector = new Point(0, 1 - randomInt(0, 1) * 2);
      randomVector = randomVector.rotate(direction);
    } else {
      randomVector = Point.random();
      randomVector = randomVector.rotate(randomInt(0, 360));
    }
    randomVector.length = randomInt(0, maxLength);
    return randomVector;
  };

  F.prototype.validateEmail = function(email) {
    var re;
    re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
  };

  F.prototype.selectFocusedArticle = function() {
    var $article, $articleToFocus, article, distanceFromScreenMiddle, j, len, minimumSoFar, ref;
    minimumSoFar = 10000;
    ref = this.articles;
    for (j = 0, len = ref.length; j < len; j++) {
      article = ref[j];
      $article = $(article);
      $article.data('positionOnScreen', $article.offset().top - this.oldPageYOffset);
      if (!$article.data('height')) {
        $article.data('height', $article.height());
      }
      distanceFromScreenMiddle = Math.abs($article.data('positionOnScreen') - this.windowInnerHeight / 2 + $article.data('height') / 2);
      if (distanceFromScreenMiddle < minimumSoFar) {
        $articleToFocus = $article;
        minimumSoFar = distanceFromScreenMiddle;
      }
    }
    if (!$articleToFocus.is(this.lastFocusedArticle)) {
      if (this.lastFocusedArticle) {
        this.lastFocusedArticle.trigger('focus:unfocus');
      }
      return $articleToFocus.trigger('focus:focus');
    }
  };

  F.prototype.makeElementAsWideAsViewport = function($element) {
    if ($element.length > 0) {
      return $element.css({
        'position': 'relative',
        'left': -$element.offset().left,
        'width': $body.width()
      });
    }
  };

  F.prototype.setupPage = function(fromPage, toPage) {
    if (location.href.indexOf('interviews/') > -1) {
      toPage = "episode";
    }
    console.log('setup from ' + fromPage + ' to ' + toPage);
    this.state.currentPage = toPage;
    history.replaceState(this.state, null, null);
    $body.attr('data-current-page', toPage);
    $body.removeClass('page-' + fromPage).addClass('page-' + toPage);
    if (this.state.menuOpen) {
      this.closeMenu();
    }
    if (fromPage === 'home') {
      this.articles.off('focus:focus');
      this.lastFocusedArticle = '';
    }
    if (fromPage === 'episode') {
      if (this.sound) {
        this.sound.destruct();
      }
      this.changeCssColor('white');
    }
    if (toPage === 'home') {
      this.setupRoleModelPath('home');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
      this.articles = $('article');
      this.articles.on('focus:focus', (function(_this) {
        return function(e) {
          var $this;
          $this = $(e.currentTarget);
          _this.lastFocusedArticle = $this;
          if ($this.data('color')) {
            _this.state.currentColor = $this.data('color');
            return _this.changePathColor(_this.getCurrentColor());
          }
        };
      })(this));
      this.selectFocusedArticle();
      this.changePathColor(this.getCurrentColor(), true);
    }
    if (toPage === 'abo') {
      this.setupRoleModelPath('abo');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
    }
    if (toPage === 'ueber') {
      this.setupRoleModelPath('ueber');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
    }
    if (toPage === 'frage') {
      this.setupRoleModelPath('frage');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
    }
    if (toPage === 'error') {
      this.setupRoleModelPath('error');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
    }
    if (toPage === 'episode') {
      $('body, html').scrollTop(0);
      this.setupRoleModelPath('episode');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
      this.changePathColor(this.getCurrentColor(), (fromPage == null) || fromPage === '');
      if ($('.audio-player').length > 0) {
        this.prepareAudioPlayer($('.audio-player'));
      }
      this.prepareSmallEpisodeList();
      this.changeCssColor(this.getCurrentColor());
      if (this.state.currentBreakPoint === 'xl') {
        this.makeElementAsWideAsViewport($('.guest-images'));
        this.makeElementAsWideAsViewport($('.more-header'));
        this.makeElementAsWideAsViewport($('.episode-list'));
      }
    }
    if (toPage === 'table') {
      $('body, html').scrollTop(0);
      this.setupRoleModelPath('table');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
      this.changePathColor(this.getCurrentColor(), (fromPage == null) || fromPage === '');
    }
    if (toPage === 'fragment') {
      this.setupRoleModelPath('fragment');
      this.morphPath(this.roleModelPath, null, (fromPage == null) || fromPage === '');
      this.changePathColor(this.getCurrentColor(), (fromPage == null) || fromPage === '');
      if ($('.small-player').length > 0) {
        this.setupSmallPlayers();
      }
      this.changeCssColor(this.getCurrentColor());
    }
    if ((fromPage != null) && fromPage !== '') {
      return ga('send', 'pageview', window.location.pathname);
    }
  };

  F.prototype.setupRoleModelPath = function(pageSlug) {
    var factor, i, j, k, l, offset, pieceLength, ref, ref1, ref2, ref3, ref4, yPos;
    if (this.roleModelPath) {
      this.roleModelPath.remove();
    }
    if (pageSlug === 'home') {
      this.roleModelPath = new Path({
        segments: [view.bounds.topCenter, view.bounds.topRight, view.bounds.bottomRight, view.bounds.bottomCenter],
        selected: false,
        closed: true,
        visible: false,
        strokeColor: 'black',
        strokeWidth: strokeWidths[this.state.currentBreakPoint]
      });
      pieceLength = this.roleModelPath.curves[3].length / (this.noOfPoints + 1);
      offset = this.roleModelPath.getOffsetOf(this.roleModelPath.curves[3].point1);
      for (i = j = 1, ref = this.noOfPoints; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
        this.roleModelPath.insert(3 + i, this.roleModelPath.getPointAt(offset + i * pieceLength));
        this.roleModelPath.lastSegment.data = {
          movable: true
        };
        this.roleModelPath.lastSegment.handleIn = new Point(0, pieceLength / 2);
        this.roleModelPath.lastSegment.handleOut = new Point(0, -pieceLength / 2);
      }
      this.roleModelPath.scale(1.1, view.center);
      return this.roleModelPath.data.createNewPointsAtIndex = 0;
    } else if (pageSlug === 'episode') {
      this.roleModelPath = new Path({
        segments: [view.bounds.rightCenter, view.bounds.bottomRight, view.bounds.bottomLeft, view.bounds.leftCenter],
        selected: false,
        closed: true,
        fillColor: 'red',
        visible: false,
        strokeColor: 'black',
        strokeWidth: strokeWidths[this.state.currentBreakPoint]
      });
      factor = 0.8;
      if ((ref1 = this.state.currentBreakPoint) === 's' || ref1 === 'm') {
        factor += 0.3;
      }
      yPos = $('.guest-name').offset().top + $('.guest-name').height() * factor;
      this.roleModelPath.segments[0].point.y = this.roleModelPath.segments[3].point.y = yPos;
      pieceLength = this.roleModelPath.curves[3].length / (this.noOfPoints + 1);
      offset = this.roleModelPath.getOffsetOf(this.roleModelPath.curves[3].point1);
      for (i = k = 1, ref2 = this.noOfPoints; 1 <= ref2 ? k <= ref2 : k >= ref2; i = 1 <= ref2 ? ++k : --k) {
        this.roleModelPath.insert(3 + i, this.roleModelPath.getPointAt(offset + i * pieceLength));
        this.roleModelPath.lastSegment.data = {
          movable: true
        };
        this.roleModelPath.lastSegment.handleIn = new Point(-pieceLength / 2, 0);
        this.roleModelPath.lastSegment.handleOut = new Point(pieceLength / 2, 0);
      }
      return this.roleModelPath.scale(1.1, view.center);
    } else if (pageSlug === 'table') {
      this.roleModelPath = new Path({
        segments: [view.bounds.rightCenter, view.bounds.bottomRight, view.bounds.bottomLeft, view.bounds.leftCenter],
        selected: false,
        closed: true,
        fillColor: 'red',
        visible: false,
        strokeColor: 'black',
        strokeWidth: tableSettings.strokeWidth
      });
      if ((ref3 = this.state.currentBreakPoint) === 's' || ref3 === 'm') {
        factor += 0.3;
      }
      yPos = view.bounds.height / 2;
      this.roleModelPath.segments[0].point.y = this.roleModelPath.segments[3].point.y = yPos;
      pieceLength = this.roleModelPath.curves[3].length / (this.noOfPoints + 1);
      offset = this.roleModelPath.getOffsetOf(this.roleModelPath.curves[3].point1);
      for (i = l = 1, ref4 = this.noOfPoints; 1 <= ref4 ? l <= ref4 : l >= ref4; i = 1 <= ref4 ? ++l : --l) {
        this.roleModelPath.insert(3 + i, this.roleModelPath.getPointAt(offset + i * pieceLength));
        this.roleModelPath.lastSegment.data = {
          movable: true
        };
        this.roleModelPath.lastSegment.handleIn = new Point(-pieceLength / 2, 0);
        this.roleModelPath.lastSegment.handleOut = new Point(pieceLength / 2, 0);
      }
      return this.roleModelPath.scale(1.1, view.center);
    } else if (pageSlug === 'ueber' || pageSlug === 'abo' || pageSlug === 'frage' || pageSlug === 'error' || pageSlug === 'fragment') {
      this.roleModelPath = new Path({
        segments: [view.bounds.topRight, view.bounds.topRight, view.bounds.bottomRight, view.bounds.bottomRight],
        selected: false,
        closed: true,
        visible: false,
        strokeColor: 'black',
        strokeWidth: strokeWidths[this.state.currentBreakPoint]
      });
      return this.roleModelPath.position = this.roleModelPath.position.add(new Point(20, 0));
    }
  };

  F.prototype.playerAnalytics = function() {
    if (this.playerAnalyticsTimeout != null) {
      window.clearTimeout(this.playerAnalyticsTimeout);
    }
    if (this.sound.playState !== 1 || this.sound.paused === true) {

    } else {
      ga('send', {
        hitType: 'event',
        eventCategory: 'AudioHeatMap',
        eventAction: window.location.pathname,
        eventLabel: '' + Math.ceil(this.sound.position / 1000 / 60)
      });
      return this.playerAnalyticsTimeout = window.setTimeout(this.playerAnalytics, 1000 * 60);
    }
  };

  F.prototype.prepareAudioPlayer = function($node) {
    var $audioPlayer, $playButton, audioFilename, minutes, ms, re, seconds, tokens;
    $node.addClass('is-loading');
    audioFilename = $node.attr('data-audio-filename');
    soundManager.setup({
      debugMode: false
    });
    this.sound = soundManager.createSound({
      id: audioFilename,
      url: 'http://cdn.podseed.org/formfunk/' + audioFilename + '.mp3',
      autoLoad: true,
      autoPlay: false,
      onbufferchange: (function(_this) {
        return function() {
          $('.audio-player').toggleClass('is-buffering', _this.sound.isBuffering);
          if (_this.sound.isBuffering) {
            return $('.duration').html('Lade…');
          } else {
            return _this.state.barHover = false;
          }
        };
      })(this),
      onfinish: (function(_this) {
        return function(e) {
          _this.state.playing = false;
          $('.audio-player').toggleClass('is-playing', _this.sound.playState);
          return _this.updateSoundBar(0, $('.audio-player'));
        };
      })(this),
      onplay: (function(_this) {
        return function(e) {
          _this.state.playing = true;
          $('.audio-player').toggleClass('is-playing', _this.sound.playState);
          _this.playerAnalyticsTimeout = window.setTimeout(_this.playerAnalytics, 1000 * 60);
          return setTimeout(_this.showSubscribeOptions, 60000);
        };
      })(this),
      onresume: (function(_this) {
        return function(e) {
          _this.state.playing = true;
          $('.audio-player').toggleClass('is-playing', _this.sound.playState);
          return _this.playerAnalyticsTimeout = window.setTimeout(_this.playerAnalytics, 1000 * 60);
        };
      })(this),
      onpause: (function(_this) {
        return function() {
          _this.state.playing = false;
          return $('.audio-player').toggleClass('is-playing', _this.sound.playState);
        };
      })(this),
      onstop: (function(_this) {
        return function() {
          _this.state.playing = false;
          return $('.audio-player').toggleClass('is-playing', _this.sound.playState);
        };
      })(this),
      onload: (function(_this) {
        return function(success) {
          if (!success) {
            $('.duration').html('Fehler :-(');
            return alert('Fehler: Die Folge konnte nicht geladen werden. Wenn das Problem weiter auftritt, schreibe bitte an hey@formfunk-podcast.de');
          }
        };
      })(this),
      whileplaying: (function(_this) {
        return function(e) {
          var $bar, positionPercent;
          if (!window.timeDrag) {
            $bar = $('.audio-player').find('.bar');
            positionPercent = _this.sound.position / _this.sound.durationEstimate;
            _this.updateSoundBar(positionPercent * $bar.width(), $('.audio-player'));
          }
          if (!(_this.state.barHover || _this.sound.isBuffering)) {
            return _this.updatePositionIndicator(_this.sound);
          }
        };
      })(this),
      volume: 100
    });
    $audioPlayer = $('.audio-player');
    $audioPlayer.removeClass('is-loading');
    this.placeAudioMarkers(this.sound);
    $audioPlayer.find('.duration').html(this.msToHours(this.sound.myDuration));
    $playButton = $audioPlayer.find('.play-button');
    $playButton.click((function(_this) {
      return function(event) {
        if (_this.sound.playState === 0) {
          _this.sound.play();
        } else {
          _this.sound.togglePause();
        }
        return false;
      };
    })(this));
    $audioPlayer.find('.bar').mousedown((function(_this) {
      return function(e) {
        var $bar;
        window.timeDrag = true;
        $bar = $('.audio-player').find('.bar');
        _this.updateSoundBar(e.pageX - $bar.offset().left, $('.audio-player'));
        return _this.updateAudioPosition(_this.sound);
      };
    })(this)).mousemove((function(_this) {
      return function(e) {
        var $bar, positionMs, positionPercent;
        _this.state.barHover = true;
        $bar = $('.audio-player').find('.bar');
        positionPercent = (e.clientX - $bar.offset().left) / $bar.width();
        positionMs = positionPercent * _this.sound.myDuration;
        if (!_this.sound.isBuffering) {
          return _this.updatePositionIndicator(_this.sound, positionMs);
        }
      };
    })(this)).mouseleave((function(_this) {
      return function() {
        _this.state.barHover = false;
        if (!_this.sound.isBuffering) {
          return _this.updatePositionIndicator(_this.sound);
        }
      };
    })(this));
    re = /[?&]?t=(\d*)m(\d*)s/g;
    tokens = re.exec(location.search);
    if (tokens) {
      minutes = tokens[1];
      seconds = tokens[2];
      ms = 1000 * seconds + 1000 * 60 * minutes;
      this.sound.setPosition(ms);
      if (this.sound.playState === 0) {
        return this.sound.play();
      }
    }
  };

  F.prototype.placeAudioMarkers = function(soundObject) {
    var $audioPlayer, $bar, $list, audioData, index, j, len, listString, marker, markerData, pointString, positionPercent;
    $audioPlayer = $('.audio-player');
    audioData = JSON.parse($("#audio-data-" + soundObject.id).html());
    markerData = audioData.markers;
    soundObject.myDuration = this.hoursToMs(audioData.duration);
    $bar = $('.audio-player').find('.bar');
    $list = $('.marker-list');
    pointString = "";
    listString = "";
    for (index = j = 0, len = markerData.length; j < len; index = ++j) {
      marker = markerData[index];
      if ((('' + marker.position).indexOf(':')) > -1) {
        marker.position = this.hoursToMs(marker.position);
      }
      positionPercent = marker.position / soundObject.myDuration * 100;
      pointString += '<span class="audio-marker" data-nr="' + index + '" style="left:' + positionPercent + '%"></span>';
      listString += '<li data-nr="' + index + '"><span class="bullet" data-audio-position="' + marker.position + '"></span>' + marker.html + '</li>';
    }
    $bar.append(pointString);
    $list.append(listString);
    $list.find('a').attr('target', '_blank');
    $('.audio-marker, .marker-list li').hover((function(_this) {
      return function(e) {
        return _this.highlightMarker($(e.currentTarget).attr('data-nr'), true);
      };
    })(this), (function(_this) {
      return function(e) {
        return _this.highlightMarker($(e.currentTarget).attr('data-nr'), false);
      };
    })(this));
    return $('span.bullet').click((function(_this) {
      return function(e) {
        _this.sound.setPosition($(e.currentTarget).attr('data-audio-position'));
        if (_this.sound.playState === 0) {
          return _this.sound.play();
        }
      };
    })(this));
  };

  F.prototype.setupSmallPlayers = function() {
    var $playButton, $playerNodeHtml, color, index, j, len, player, playerGroup, ref, soundID, soundObject, that;
    this.buildFragmentsObj();
    this.buildTagObj();
    this.buildTagList();
    this.prepareSVG();
    soundManager.setup({
      debugMode: false
    });
    that = this;
    ref = $('div.small-player');
    for (index = j = 0, len = ref.length; j < len; index = ++j) {
      player = ref[index];
      $playerNodeHtml = $(player);
      soundID = $playerNodeHtml.attr('data-soundID');
      color = $playerNodeHtml.attr('data-color');
      playerGroup = this.svgEle.smallPlayersGroup.append("g").attr("class", "small-player").attr("data-soundID", soundID);
      playerGroup.append("rect").attr("class", "bar").attr("fill", "white").attr("x", $playerNodeHtml.parent().position().left + $playerNodeHtml.position().left).attr("y", $playerNodeHtml.position().top + 20).attr("width", $playerNodeHtml.width()).attr("height", this.visConfig.fragmentHeight);
      soundObject = soundManager.createSound({
        id: soundID,
        url: 'http://formfunk.betelgeuse.uberspace.de/formfunk-sandbox/assets/local-mp3/' + soundID + '.mp3',
        autoLoad: false,
        autoPlay: false,
        onbufferchange: function() {
          this.$playerNodeHtml.toggleClass('is-buffering', this.isBuffering);
          if (this.isBuffering) {
            return this.$playerNodeHtml.find('.duration').html('Lade…');
          }
        },
        onfinish: function(e) {
          this.$playerNodeHtml.toggleClass('is-playing', this.playState);
          return that.updateSoundBar(0, this.$playerNodeHtml);
        },
        onplay: function(e) {
          return this.$playerNodeHtml.toggleClass('is-playing', this.playState);
        },
        onresume: function(e) {
          return this.$playerNodeHtml.toggleClass('is-playing', this.playState);
        },
        onpause: function() {
          return this.$playerNodeHtml.toggleClass('is-playing', this.playState);
        },
        onstop: function() {
          return this.$playerNodeHtml.toggleClass('is-playing', this.playState);
        },
        onload: function(success) {
          if (!success) {
            this.$playerNodeHtml.find('.duration').html('Fehler :-(');
            return alert('Fehler: Die Folge konnte nicht geladen werden. Wenn das Problem weiter auftritt, schreibe bitte an hey@formfunk-podcast.de');
          }
        },
        whileplaying: function() {
          var $bar, positionPercent;
          if (!window.timeDrag) {
            $bar = this.$playerNodeHtml.find('.bar');
            positionPercent = this.position / this.durationEstimate;
            true;
          }
          if (!this.isBuffering) {
            return true;
          }
        },
        volume: 100
      });
      soundObject.$playerNodeHtml = $playerNodeHtml;
      $playerNodeHtml.removeClass('is-loading');
      $playButton = $playerNodeHtml.find('.play-button');
      soundObject.myDuration = this.hoursToMs(JSON.parse($("#audio-data-" + soundID).html()).duration);
      this.placeAudioFragments(playerGroup);
      $playerNodeHtml.find('.duration').html(this.msToHours(soundObject.myDuration));
      $playerNodeHtml.find('.bar').css('background-color', $playerNodeHtml.parent().attr('data-color'));
      $playButton.click(function(event) {
        var soundId;
        soundId = $(this).parent().attr('data-audio-filename');
        soundObject = soundManager.getSoundById(soundId);
        if (soundObject.playState === 0) {
          soundObject.play();
        } else {
          soundObject.togglePause();
        }
        return false;
      });
    }
    $playerNodeHtml.find('.bar').mousedown((function(_this) {
      return function(e) {
        var $bar, soundId;
        $bar = $(e.currentTarget);
        _this.updateSoundBar(e.pageX - $bar.offset().left, $bar.parent());
        soundId = $bar.parent().attr('data-audio-filename');
        soundObject = soundManager.getSoundById(soundId);
        return _this.updateAudioPosition(soundObject);
      };
    })(this));
    $('.fragments-player').find('.bar').click((function(_this) {
      return function(e) {
        var $bar, positionPercent;
        $bar = $(e.currentTarget);
        positionPercent = (e.pageX - $bar.offset().left) / $bar.width();
        return _this.skipPlaylist(positionPercent);
      };
    })(this));
    $('.fragments-player').find('.play-button').click((function(_this) {
      return function(e) {
        if (_this.fragmentsPlaylist.isPlaying) {
          return _this.fragmentsPlaylist.currentSoundObject.pause();
        } else {
          return _this.playFragmentPlaylist();
        }
      };
    })(this));
    return this.makePlaylist(this.getFragments([
      {
        key: 'tagID',
        value: 'frage-weitergeben'
      }
    ]));
  };

  F.prototype.getFragments = function(keyValueArray) {
    return this.fragmentsObj.filter(function(x) {
      var condition, j, len;
      for (j = 0, len = keyValueArray.length; j < len; j++) {
        condition = keyValueArray[j];
        if (x[condition.key] !== condition.value) {
          return false;
        }
      }
      return true;
    });
  };

  F.prototype.buildFragmentsObj = function() {
    var fragment, fragmentData, index, j, len, playerNode, ref, ref1, scriptElement, soundIDlist;
    this.fragmentsObj = [];
    scriptElement = $("script[id^=audio-fragments]");
    fragmentData = JSON.parse($(scriptElement).html());
    if (!fragmentData.fragments) {
      return;
    } else {
      this.fragmentsObj = fragmentData.fragments;
    }
    soundIDlist = [];
    ref = this.fragmentsObj;
    for (index = j = 0, len = ref.length; j < len; index = ++j) {
      fragment = ref[index];
      fragment.start = this.hoursToMs(fragment.start);
      fragment.end = this.hoursToMs(fragment.end);
      playerNode = $('.small-player[data-soundID=' + fragment.soundID + ']');
      fragment.color = playerNode.attr('data-color');
      fragment.id = index;
      if (!(ref1 = fragment.soundID, indexOf.call(soundIDlist, ref1) >= 0)) {
        soundIDlist.push(fragment.soundID);
      }
    }
    return this.fragmentsObj.sort(function(a, b) {
      var indexComparison, soundIDComparison;
      soundIDComparison = soundIDlist.indexOf(a.soundID) - soundIDlist.indexOf(b.soundID);
      if (soundIDComparison === 0) {
        return indexComparison = parseInt(a.index, 10) - parseInt(b.index, 10);
      } else {
        return soundIDComparison;
      }
    });
  };

  F.prototype.buildTagObj = function() {
    var fragment, j, len, lookup, ref, results, tag;
    this.tagObj = [];
    lookup = {};
    ref = this.fragmentsObj;
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      fragment = ref[j];
      if (!(fragment.tagID in lookup)) {
        this.tagObj.push({
          tagID: fragment.tagID,
          frequency: 1
        });
        results.push(lookup[fragment.tagID] = 1);
      } else {
        results.push((function() {
          var k, len1, ref1, results1;
          ref1 = this.tagObj;
          results1 = [];
          for (k = 0, len1 = ref1.length; k < len1; k++) {
            tag = ref1[k];
            if (tag.tagID === fragment.tagID) {
              results1.push(tag.frequency++);
            }
          }
          return results1;
        }).call(this));
      }
    }
    return results;
  };

  F.prototype.buildTagList = function() {
    var j, len, ref, tag, tagString;
    tagString = "";
    this.tagObj.sort(function(a, b) {
      return b.frequency - a.frequency;
    });
    ref = this.tagObj;
    for (j = 0, len = ref.length; j < len; j++) {
      tag = ref[j];
      tagString += '<li><a href="#" data-tag-id="' + tag.tagID + '">' + tag.tagID + '</a><span class="frequency">' + tag.frequency + '</span></li> ';
    }
    $('.tag-list').append(tagString);
    $('.tag-list').mouseenter((function(_this) {
      return function(e) {
        return $('.fragments-player').addClass('is-hovering-tag-list');
      };
    })(this)).mouseleave((function(_this) {
      return function(e) {
        return $('.fragments-player').removeClass('is-hovering-tag-list');
      };
    })(this));
    return $('.tag-list a').mouseenter((function(_this) {
      return function(e) {
        var that;
        that = _this;
        return $('.small-player .small-player-fragment[data-tag-id=' + $(e.currentTarget).attr('data-tag-id') + ']').each(function() {
          var color, fragmentID;
          this.classList.add('is-highlighted');
          fragmentID = $(this).attr('id').match(/([^-]*)$/)[0];
          color = that.getFragments([
            {
              key: 'id',
              value: parseInt(fragmentID)
            }
          ])[0].color;
          return d3.select(this).style("fill", color);
        });
      };
    })(this)).mouseleave((function(_this) {
      return function(e) {
        return $('.small-player .small-player-fragment[data-tag-id=' + $(e.currentTarget).attr('data-tag-id') + ']').each(function() {
          this.classList.remove('is-highlighted');
          return d3.select(this).style("fill", "");
        });
      };
    })(this)).mouseup((function(_this) {
      return function(e) {
        var fragmentsArray;
        fragmentsArray = _this.getFragments([
          {
            key: 'tagID',
            value: $(e.currentTarget).attr('data-tag-id')
          }
        ]);
        _this.makePlaylist(fragmentsArray);
        _this.playFragmentPlaylist();
        return $('.fragments-player').removeClass('is-hovering-tag-list');
      };
    })(this)).click(function(e) {
      return e.preventDefault();
    });
  };

  F.prototype.prepareSVG = function() {
    var area, data, pos, scale;
    this.visConfig = {
      width: '100%',
      height: '100%',
      fragmentHeight: 10,
      smallPlayerWidth: (100 / $('.small-player').length) + '%',
      smallPlayerHeight: 100
    };
    this.svgEle = {};
    d3.select(".fragments-player").append("svg").attr("width", $(".fragments-player").width()).attr("height", $(".fragments-player").height()).attr("id", "main-svg");
    this.svgEle.svg = d3.select("#main-svg");
    $('svg#main-svg').css({
      position: 'absolute',
      top: 0,
      left: 0
    });
    this.svgEle.smallPlayersGroup = this.svgEle.svg.append('g');
    this.svgEle.bigPlayerGroup = this.svgEle.svg.append('g');
    this.svgEle.svg.append("rect").attr("id", "big-player-cursor").attr("width", 2).attr("height", this.visConfig.fragmentHeight * 4).attr("x", $('.tag-list').position().left).attr("y", this.svgEle.svg.attr('height') / 2 - this.visConfig.fragmentHeight * 2);
    data = [
      {
        x: 0,
        y1: 10,
        t: 1
      }, {
        x: 5,
        y1: 10,
        t: 1
      }, {
        x: 10,
        y1: 10,
        t: 1
      }, {
        x: 15,
        y1: -10,
        t: 3
      }, {
        x: 30,
        y1: -10,
        t: 3
      }, {
        x: 45,
        y1: -10,
        t: 3
      }, {
        x: 10,
        y1: 10,
        t: 1
      }, {
        x: 15,
        y1: 10,
        t: 1
      }, {
        x: 20,
        y1: 10,
        t: 1
      }
    ];
    scale = 10;
    pos = {
      x: 100,
      y: 200
    };
    area = d3.svg.area().x0(function(d, i) {
      return d.x * scale + pos.x;
    }).x1(function(d) {
      return d.x * scale + pos.x;
    }).y0(function(d) {
      return -d.y1 * scale - d.t * scale + pos.y;
    }).y1(function(d) {
      return -d.y1 * scale + pos.y;
    });
    area.interpolate('cardinal').tension(1);
    return this.svgEle.svg.append("path").attr("class", "area").attr("d", area(data));
  };

  F.prototype.makePlaylist = function(arrayOfFragments) {
    var barString, barWidth, fragment, j, len, ref, sumSoFar, that;
    this.state.skipping = true;
    soundManager.stopAll();
    this.state.skipping = false;
    this.fragmentsPlaylist = {};
    this.fragmentsPlaylist.fragments = arrayOfFragments;
    this.fragmentsPlaylist.currentFragment = 0;
    this.fragmentsPlaylist.currentSoundObject = soundManager.getSoundById(this.fragmentsPlaylist.fragments[0].soundID);
    this.fragmentsPlaylist.isPlaying = false;
    this.fragmentsPlaylist.duration = 0;
    this.state.skipping = false;
    ref = this.fragmentsPlaylist.fragments;
    for (j = 0, len = ref.length; j < len; j++) {
      fragment = ref[j];
      this.fragmentsPlaylist.duration += fragment.end - fragment.start;
    }
    barString = "";
    sumSoFar = 0;
    barWidth = $('.tag-list').width();
    this.svgEle.bigPlayerGroup.selectAll('*').remove();
    that = this;
    this.svgEle.bigPlayerGroup.selectAll("rect").data(this.fragmentsPlaylist.fragments).enter().append("rect").attr("x", (function(_this) {
      return function(d, i) {
        var widthPx;
        widthPx = (d.end - d.start) / _this.fragmentsPlaylist.duration * barWidth + 2;
        sumSoFar += widthPx;
        return sumSoFar - widthPx + $('.tag-list').position().left;
      };
    })(this)).attr("y", this.svgEle.svg.attr('height') / 2 - this.visConfig.fragmentHeight / 2).attr("width", (function(_this) {
      return function(d, i) {
        var widthPx;
        widthPx = (d.end - d.start) / _this.fragmentsPlaylist.duration * barWidth;
        return widthPx;
      };
    })(this)).attr("height", this.visConfig.fragmentHeight).attr("fill", function(d, i) {
      return d.color;
    }).attr("id", function(d, i) {
      return "big-fragment-" + d.id;
    }).classed("big-player-fragment", true).on("click", function(e) {
      var positionPercent, xInBar, xInSvg;
      xInSvg = d3.mouse(this)[0];
      xInBar = xInSvg - $('.big-player-fragment').first().position().left;
      barWidth = $('.tag-list').width();
      positionPercent = xInBar / barWidth;
      return that.skipPlaylist(positionPercent);
    });
    this.displayConnectingEdges(this.fragmentsPlaylist.fragments);
    $('.fragments-player .play-button').css({
      top: $('.big-player-fragment').first().position().top + this.visConfig.fragmentHeight / 2 - $('.fragments-player .play-button').height() / 2
    });
    return $('.fragments-player').addClass('is-playlist-loaded');
  };

  F.prototype.displayConnectingEdges = function(arrayOfFragments) {
    var bigFragmentBBox, fragment, j, len, lineFunction, path, pointData, results, smallFragmentBBox;
    this.svgEle.svg.selectAll(".connecting-edge").remove();
    lineFunction = d3.svg.line().x(function(d) {
      return d.x;
    }).y(function(d) {
      return d.y;
    }).interpolate("linear");
    results = [];
    for (j = 0, len = arrayOfFragments.length; j < len; j++) {
      fragment = arrayOfFragments[j];
      smallFragmentBBox = d3.select('#small-fragment-' + fragment.id).node().getBBox();
      bigFragmentBBox = d3.select('#big-fragment-' + fragment.id).node().getBBox();
      pointData = [
        {
          x: smallFragmentBBox.x,
          y: smallFragmentBBox.y + smallFragmentBBox.height
        }, {
          x: bigFragmentBBox.x,
          y: bigFragmentBBox.y
        }, {
          x: bigFragmentBBox.x + bigFragmentBBox.width,
          y: bigFragmentBBox.y
        }, {
          x: smallFragmentBBox.x + smallFragmentBBox.width,
          y: smallFragmentBBox.y + smallFragmentBBox.height
        }
      ];
      results.push(path = this.svgEle.svg.append("path").classed("connecting-edge", true).attr("d", lineFunction(pointData)).style("fill", fragment.color).style("fill-opacity", 0.1));
    }
    return results;
  };

  F.prototype.positionPositionMarker = function(offset) {
    return d3.select('#big-player-cursor').attr("x", offset);
  };

  F.prototype.playFragmentPlaylist = function(index, ms) {
    var fragment, that;
    if (index == null) {
      index = 0;
    }
    if (ms == null) {
      ms = 0;
    }
    if (Array.isArray(this.fragmentsPlaylist.fragments) && this.fragmentsPlaylist.currentFragment < this.fragmentsPlaylist.fragments.length) {
      fragment = this.fragmentsPlaylist.fragments[index];
      if (this.state.skipping) {
        this.fragmentsPlaylist.currentSoundObject.stop();
      }
      this.fragmentsPlaylist.currentSoundObject = soundManager.getSoundById(fragment.soundID);
      this.fragmentsPlaylist.currentFragment = index;
      that = this;
      return this.fragmentsPlaylist.currentSoundObject.play({
        from: fragment.start + ms,
        to: fragment.end,
        onplay: (function(_this) {
          return function() {
            _this.fragmentsPlaylist.isPlaying = true;
            return $('.fragments-player').toggleClass('is-playing', _this.fragmentsPlaylist.currentSoundObject.playState);
          };
        })(this),
        onstop: (function(_this) {
          return function() {
            _this.fragmentsPlaylist.isPlaying = false;
            $('.fragments-player').toggleClass('is-playing', _this.fragmentsPlaylist.currentSoundObject.playState);
            if (_this.state.skipping !== true) {
              _this.playFragmentPlaylist(_this.fragmentsPlaylist.currentFragment + 1);
            }
            return _this.state.skipping = false;
          };
        })(this),
        onpause: (function(_this) {
          return function() {
            _this.fragmentsPlaylist.isPlaying = false;
            return $('.fragments-player').toggleClass('is-playing', _this.fragmentsPlaylist.currentSoundObject.playState);
          };
        })(this),
        onresume: (function(_this) {
          return function() {
            _this.fragmentsPlaylist.isPlaying = true;
            return $('.fragments-player').toggleClass('is-playing', _this.fragmentsPlaylist.currentSoundObject.playState);
          };
        })(this),
        onfinish: (function(_this) {
          return function() {
            return $('.fragments-player').toggleClass('is-playing', _this.fragmentsPlaylist.currentSoundObject.playState);
          };
        })(this),
        whileplaying: function() {
          var $fragmentNode, left, width;
          $fragmentNode = $('#big-fragment-' + fragment.id);
          left = parseInt($fragmentNode.attr("x"));
          width = d3.select('#big-fragment-' + fragment.id).node().getBBox().width;
          left += (this.position - fragment.start) / (fragment.end - fragment.start) * width;
          return that.positionPositionMarker(left);
        }
      });
    }
  };

  F.prototype.skipPlaylist = function(percent) {
    var currentSum, fragment, fragmentDuration, i, index, j, len, ms, ref, targetMs;
    if (!this.fragmentsPlaylist || !Array.isArray(this.fragmentsPlaylist.fragments)) {
      return;
    }
    targetMs = percent * this.fragmentsPlaylist.duration;
    currentSum = 0;
    ref = this.fragmentsPlaylist.fragments;
    for (index = j = 0, len = ref.length; j < len; index = ++j) {
      fragment = ref[index];
      fragmentDuration = fragment.end - fragment.start;
      if ((currentSum + fragmentDuration) >= targetMs) {
        ms = targetMs - currentSum;
        i = index;
        break;
      } else {
        currentSum += fragmentDuration;
      }
    }
    this.state.skipping = true;
    $('.fragments-player').addClass('is-playing');
    return this.playFragmentPlaylist(i, ms);
  };

  F.prototype.placeAudioFragments = function(smallPlayerGroup) {
    var audioFilename, barPosX, barPosY, barWidth, duration, fragmentsArray, soundObject;
    audioFilename = smallPlayerGroup.attr('data-soundID');
    soundObject = soundManager.getSoundById(audioFilename);
    duration = soundObject.myDuration;
    barWidth = smallPlayerGroup.selectAll(".bar").node().getBBox().width;
    barPosX = smallPlayerGroup.selectAll(".bar").node().getBBox().x;
    barPosY = smallPlayerGroup.selectAll(".bar").node().getBBox().y;
    fragmentsArray = this.getFragments([
      {
        key: 'soundID',
        value: audioFilename
      }
    ]);
    if (fragmentsArray.length === 0) {
      return;
    }
    return smallPlayerGroup.append("g").selectAll("rect").data(fragmentsArray).enter().append("rect").attr("class", "small-player-fragment").attr("x", function(d, i) {
      var positionPx;
      positionPx = d.start / soundObject.myDuration * barWidth + barPosX;
      return positionPx;
    }).attr("y", barPosY).attr("width", function(d, i) {
      var widthPx;
      widthPx = (d.end - d.start) / soundObject.myDuration * barWidth;
      return widthPx;
    }).attr("height", this.visConfig.fragmentHeight).attr("id", function(d, i) {
      return "small-fragment-" + d.id;
    }).attr("data-tag-id", function(d, i) {
      return d.tagID;
    });
  };

  F.prototype.showSubscribeOptions = function() {
    return $('.subscribe-options').removeClass('is-hidden');
  };

  F.prototype.hoursToMs = function(string) {
    var a, m, millis, ref, result, s;
    ref = string.split("."), string = ref[0], millis = ref[1];
    a = string.split(':');
    s = 0;
    m = 1;
    while (a.length > 0) {
      s += m * parseInt(a.pop(), 10);
      m *= 60;
    }
    result = s * 1000;
    if (millis != null) {
      result += parseInt(millis, 10);
    }
    return result;
  };

  F.prototype.msToHours = function(ms) {
    var hours, milliseconds, minutes, seconds, string;
    milliseconds = parseInt(ms % 1000 / 100);
    seconds = parseInt(ms / 1000 % 60);
    minutes = parseInt(ms / (1000 * 60) % 60);
    hours = parseInt(ms / (1000 * 60 * 60) % 24);
    minutes = minutes < 10 ? '0' + minutes : minutes;
    seconds = seconds < 10 ? '0' + seconds : seconds;
    string = minutes + ':' + seconds;
    if (parseInt(hours) > 0) {
      string = hours + ':' + string;
    }
    return string;
  };

  F.prototype.highlightMarker = function(nr, onOff) {
    $('.audio-player .audio-marker[data-nr=' + nr + ']').toggleClass('is-highlighted', onOff);
    return $('.marker-list li[data-nr=' + nr + ']').toggleClass('is-highlighted', onOff);
  };

  F.prototype.onResize = function() {
    this.determineBreakpoint();
    this.windowInnerHeight = window.innerHeight;
    this.setupRoleModelPath(this.state.currentPage);
    this.initMenuPath();
    if (this.state.menuOpen === true) {
      return this.morphPath(this.menuPath, null, true);
    } else {
      return this.morphPath(this.roleModelPath, null, this.state.currentPage !== 'home');
    }
  };

  F.prototype.updateSoundBar = function(px, $node) {
    var $bar, positionPercent;
    $bar = $node.find('.bar');
    positionPercent = px / $bar.width() * 100;
    positionPercent = Math.max(0, positionPercent);
    positionPercent = Math.min(100, positionPercent);
    $bar.css('background-image', 'linear-gradient(90deg, black, black ' + positionPercent + '%, white ' + positionPercent + '% )');
    return $bar.data('positionPercent', positionPercent);
  };

  F.prototype.updateAudioPosition = function(soundObject) {
    var $bar, positionPercent;
    $bar = $('.audio-player[data-audio-filename=' + soundObject.id + ']').find('.bar');
    positionPercent = $bar.data('positionPercent');
    soundObject.setPosition(positionPercent / 100 * soundObject.myDuration);
    if (!soundObject.isBuffering) {
      return this.updatePositionIndicator(soundObject);
    }
  };

  F.prototype.updatePositionIndicator = function(soundObject, ms) {
    var $node, pos;
    if (ms == null) {
      ms = null;
    }
    $node = $('.audio-player[data-audio-filename=' + soundObject.id + ']').find('.duration');
    pos = ms ? ms : soundObject.position;
    pos = pos ? pos : soundObject.myDuration;
    return $node.html(F.prototype.msToHours(pos));
  };

  scroll = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || function(callback) {
    return window.setTimeout(callback, 1000 / 60);
  };

  F.prototype.scrollLoop = function() {
    if (window.pageYOffset !== this.oldPageYOffset) {
      this.oldPageYOffset = window.pageYOffset;
      if (this.state.currentPage === 'home') {
        this.selectFocusedArticle();
      }
    }
    return scroll(this.scrollLoop);
  };

  F.prototype.getUserAgentData = function() {
    var vendor, version;
    this.state.ua = {};
    vendor = $body.attr('data-ua-vendor');
    if (vendor) {
      this.state.ua.vendor = vendor;
    }
    version = $body.attr('data-ua-version');
    if (version) {
      return this.state.ua.version = version;
    }
  };

  F.prototype.loadPageAjax = function(url, fromPage, toPage) {
    return $.ajax({
      url: url,
      success: (function(_this) {
        return function(data) {
          var $response, ajaxContent, colorString;
          $response = $(data);
          colorString = $response.find('.ajax').attr('data-color');
          if (colorString) {
            _this.state.currentColor = colorString;
          }
          ajaxContent = $response.find('.ajax').html();
          $('.main').html(ajaxContent);
          _this.setupPage(fromPage, toPage);
          return _this.popped = true;
        };
      })(this),
      error: function() {
        $('#mailchimp-subscribe').addClass('state-error');
        return $('#result').html('Tut uns leid, es gab ein Verbindungsproblem. Schreib eine Mail an <a href="mailto:hey@formfunk-podcast.de">hey@formfunk-podcast.de</a>');
      }
    });
  };

  F.prototype.bindUserEvents = function() {
    $('.menu-link').click((function(_this) {
      return function() {
        if (_this.state.menuOpen) {
          _this.closeMenu(true);
        } else {
          _this.openMenu();
        }
        return false;
      };
    })(this));
    $(window).on('popstate', (function(_this) {
      return function(e) {
        var fromPage;
        if (!_this.popped) {
          console.log('wrong popstate event');
          return;
        }
        fromPage = _this.state.currentPage;
        _this.state = e.originalEvent.state;
        if ((_this.state.ua.vendor != null) && _this.state.ua.vendor === "Safari") {
          _this.state.dontAnimateNextMorphPath = true;
        }
        return _this.loadPageAjax(location.href, fromPage, _this.state.currentPage);
      };
    })(this));
    $(document).on('click', 'a.home-link, a.v-home-link', (function(_this) {
      return function(e) {
        var $this;
        if (e.metaKey || e.ctrlKey) {
          return;
        }
        if (_this.state.currentPage !== 'home') {
          $this = $(e.currentTarget);
          history.pushState(_this.state, 'Home', $this.attr('href'));
          _this.loadPageAjax($this.attr('href'), _this.state.currentPage, 'home');
        }
        if (_this.state.currentPage === 'home' && _this.state.menuOpen === true) {
          _this.closeMenu();
        }
        return false;
      };
    })(this));
    $(document).on('click', 'a.ajax-link', (function(_this) {
      return function(e) {
        var $this;
        if (e.metaKey || e.ctrlKey) {
          return;
        }
        $this = $(e.currentTarget);
        history.pushState(_this.state, null, $this.attr('href'));
        _this.loadPageAjax($this.attr('href'), _this.state.currentPage, $this.attr('data-target-page'));
        return false;
      };
    })(this));
    $(document).on('submit', '#mailchimp-subscribe', (function(_this) {
      return function() {
        _this.mailchimpSubscribe();
        return false;
      };
    })(this));
    $(document).on('click', '.subscribe-options a', function() {
      return ga('send', {
        hitType: 'event',
        eventCategory: 'faded-in-subscribe-options',
        eventAction: 'click',
        eventLabel: $(this).html()
      });
    });
    window.timeDrag = false;
    $(document).mouseup((function(_this) {
      return function(e) {
        if (window.timeDrag) {
          window.timeDrag = false;
          _this.updateSoundBar(e.pageX - $('.audio-player .bar').offset().left, $('.audio-player'));
          return _this.updateAudioPosition(_this.sound);
        }
      };
    })(this));
    $(document).mousemove((function(_this) {
      return function(e) {
        if (window.timeDrag) {
          return _this.updateSoundBar(e.pageX - $('.audio-player .bar').offset().left, $('.audio-player'));
        }
      };
    })(this));
    return $(document).on('keydown', (function(_this) {
      return function(event) {
        switch (event.which) {
          case 27:
            if (_this.state.menuOpen === true) {
              _this.closeMenu(true);
            }
            break;
        }
      };
    })(this));
  };

  return F;

})();

f = new F();

$('body').removeClass('is-transparent');

$('body').click(function() {
  console.log('You clicked. Launching fullscreen…');
  return document.documentElement.webkitRequestFullScreen();
});

//# sourceMappingURL=maps/projection.js.map
