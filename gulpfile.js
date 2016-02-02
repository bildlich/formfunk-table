var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
// var wiredep = require('wiredep');
// var rename  = require('gulp-rename');
// var uglify  = require('gulp-uglify');
// var concat  = require('gulp-concat');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
// var exec    = require('child_process').exec;
var browserSync = require('browser-sync').create();
var nodemon = require('gulp-nodemon');

// Load configuration
// var config  = require('./gulp-config');

// Transpile Sass
gulp.task('sass', function () {
  gulp.src('./src/scss/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass({
      outputStyle: 'compressed',
      includePaths: [require('node-bourbon').includePaths, './node_modules/susy/sass','./node_modules/breakpoint-sass/stylesheets']
    }).on('error', sass.logError))
    .pipe(sourcemaps.write('./maps'))
    .pipe(gulp.dest('./public/css'))
    .pipe(browserSync.stream());
});
// Transpile Coffee
gulp.task('coffee', function() {
  gulp.src('./src/coffee/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(sourcemaps.write('./maps'))
    .pipe(gulp.dest('./public/js'))
    .pipe(browserSync.stream());
});

// browserSync
// Static Server + watching scss/html files
gulp.task('serve', ['sass', 'coffee'], function() {
  gulp.watch('./src/coffee/*.coffee', ['coffee']);
  gulp.watch('./src/scss/*.scss', ['sass']);

  var started = false;
  return nodemon({
    script: 'index.js',
    ext: 'js html'
  }).on('start', function () {
    // to avoid nodemon being started multiple times
    if (!started) {
      cb();
      started = true;
    }
  });

});

gulp.task('browser-sync', ['serve'], function() {
  browserSync.init(null, {
    proxy: "http://localhost:5000",
      files: ["public/**/*.*"],
      port: 7000,
      ghostmode: false,
      notify: false,
      open: false
  });
});


// The default task (called when you run `gulp` from cli)
gulp.task('default', ['browser-sync']);
