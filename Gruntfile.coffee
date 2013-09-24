
module.exports = (grunt) ->
  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key
  
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        bare: true
        sourceMap: false
      dev:  
        files: [
          expand: true
          cwd: 'src/scripts/'
          src: [ '**/*.coffee' ]
          dest: 'dist/scripts/'
          ext: '.js'
        ]
      dist:
        files: [
          expand: true
          cwd: 'src/scripts/'
          src: [ '**/*.coffee' ]
          dest: 'dist/scripts/'
          ext: '.js'
        ]

    less:
      dev:
        options:
          yuicompress: false
        files: [
          expand: true
          cwd: 'src/styles/'
          src: [ '**/*.less' ]
          dest: 'dist/styles/'
          ext: '.css'
        ]
      dist:
        options:
          yuicompress: true
        files: [
          expand: true
          cwd: 'src/styles/'
          src: [ '**/*.less' ]
          dest: 'dist/styles/'
          ext: '.css'
        ]

    jade:
      dev:
        options:
          pretty: true
          compileDebug: true
        files: [
          expand: true
          cwd: 'src/views/'
          src: [ '**/*.jade' ]
          dest: 'dist/views/'
          ext: '.html'
        ]
      dist:
        options:
          pretty: true
          compileDebug: false
        files: [
          expand: true
          cwd: 'src/views/'
          src: [ '**/*.jade' ]
          dest: 'dist/views/'
          ext: '.html'
        ]

    copy:
      assets:
        files: [
          expand: true
          dot: true
          cwd: 'src/'
          dest: 'dist/'
          src: [
            'assets/**/*'
          ]
        ]
      others:
        files: [
          expand: true
          dot: true
          cwd: 'src/'
          dest: 'dist/'
          src: [
            '**/*'
            '!assets/**/*'
            '!scripts/**/*.coffee'
            '!styles/**/*.less'
            '!views/**/*.jade'
          ]
        ]
      dist_font:
        files: [
          expand: true
          dot: true
          cwd: 'dist/bower_components/font-awesome/font/'
          dest: 'dist/font/'
          src: [
            '**/*'
          ]
        ]

    useminPrepare:
      html: [ 'dist/views/**/*.html' ]
      options:
        dest: 'dist/'

    usemin:
      html: [ 'dist/views/**/*.html' ]
      options:
        dirs: [ 'dist/' ]

    uglify:
      dist:
        files: [
          expand: true
          cwd: 'dist/scripts/'
          src: [
            '**/*.js'
            '!script.usemin.js'
          ]
          dest: 'dist/scripts/'
          ext: '.js'
        ]

    cssmin:
      dist:
        files: [
          expand: true
          cwd: 'dist/styles/'
          src: [
            '**/*.css'
            '!style.usemin.css'
          ]
          dest: 'dist/styles/'
          ext: '.css'
        ]

    htmlmin:
      dist:
        options:
          removeCommentsFromCDATA: true
          # https://github.com/yeoman/grunt-usemin/issues/44
          collapseWhitespace: true
          collapseBooleanAttributes: true
          # removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true
        files: [
          expand: true
          cwd: 'dist/'
          src: [ 'views/**/*.html' ]
          dest: 'dist/'
        ]

    watch:
      dev_scripts:
        files: [ 'src/scripts/*' ]
        tasks: [ 'coffee:dev' ]
      dev_styles:
        files: [ 'src/styles/*' ]
        tasks: [ 'less:dev' ]
      dev_views:
        files: [ 'src/views/*' ]
        tasks: [ 'jade:dev' ]
      dev_assets:
        files: [ 'src/assets/*' ]
        tasks: [ 'copy:assets' ]
      dev_others:
        files: [
          'src/**/*'
          '!src/assets/**/*'
          '!src/scripts/**/*.coffee'
          '!src/styles/**/*.less'
          '!src/views/**/*.jade'
        ]
        tasks: [
          'copy:others'
        ]

    clean: 
      dev_scripts: [
        'dist/scripts/popup.js'
      ]
      dev_styles: [
        'dist/styles/**/*'
        '!dist/styles/style.usemin.css'
      ]
      dev_bower: [
        'dist/bower_components'
      ]
      all: [ 'dist/' ]

    crx:
      dist:
        src: 'dist/'
        dest: 'crx/three-sentences.crx'
        privateKey: 'cert/chrome-three-sentences.pem'


  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'build', [
    'build:dist'
  ]

  grunt.registerTask 'build:dev', [
    'clean:all'
    'coffee:dev'
    'less:dev'
    'jade:dev'
    'copy:assets'
    'copy:others'
    'watch'
  ]

  grunt.registerTask 'build:dist', [
    'clean:all'
    'coffee:dist'
    'less:dist'
    'jade:dist'
    'copy:assets'
    'copy:others'
    'copy:dist_font'
    'useminPrepare'
    'concat'
    'uglify'
    'cssmin'
    'usemin'
    'htmlmin'
    'clean:dev_scripts'
    'clean:dev_styles'
    'clean:dev_bower'
  ]

  grunt.registerTask 'build:crx', [
    'build:dist'
    'crx'
  ]
