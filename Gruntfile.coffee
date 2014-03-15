dest = '../build'

module.exports = (grunt) ->
  grunt.initConfig
    clean: ["#{dest}/*", "!#{dest}/.*"]

    coffee:
      compile:
        src: 'src/coffee/**/*.coffee'
        dest: "#{dest}/assets/js/script.js"

    stylus:
      compile:
        options:
          compress: off
        src: 'src/stylus/style.styl'
        dest: "#{dest}/assets/css/style.css"

    copy:
      files:
        expand: on
        src: 'src/assets/**'
        dest: "#{dest}"

    jade:
      options:
        pretty: true
      files:
        expand: on
        cwd: 'src/jade'
        src: '**/*.jade'
        ext: '.hbs'
        dest: dest

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.registerTask 'default', ['clean', 'copy', 'jade', 'stylus', 'coffee']
  