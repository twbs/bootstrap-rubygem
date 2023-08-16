var gulp = require("gulp");
var sass = require('gulp-sass')(require('sass'))
var autoprefixer = require('gulp-autoprefixer');

// COMPILA O SASS E ADICONA PREFIXER
function compilaSass() {
    return gulp
        .src('assets/stylesheets/*.scss')
        .pipe(sass({
            outputStyle: 'compressed'
        }))
        .pipe(autoprefixer({
            browsers: ['last 2 versions'],
            cascade: false
        }))
        .pipe(gulp.dest('public/assets/css/'));
}


// TAREFA DO SASS
gulp.task('sass', compilaSass);

//COMPILA O JS E MINIFICA

// WATCH DO GULP
function watch() {
    gulp.watch('assets/stylesheets/*.scss', compilaSass);
}

// TAREFA DO WATCH
gulp.task('watch', watch);

// TAREFA DO GULP PADRAO
gulp.task('default', gulp.parallel('sass'));
