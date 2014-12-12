module.exports = function(grunt) {
  
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      },
      build: {
        src: 'src/js/<%= pkg.name %>.js',
        dest: 'build/js/<%= pkg.name %>.min.js'
      }
    },
    cssmin: {
      add_banner: {
        options: {
          banner: '/* My minified css file. Last build: <%= grunt.template.today("yyyy-mm-dd") %> */'
        },
        files: {
          'build/css/<%= pkg.name %>.min.css': ['src/css/*.css']
        }
      }
    },
    wiredep: {
      
      task: {
        
        // Point to the files that should be updated when
        // you run `grunt wiredep`
        src: [
        'atlmapsEmber/**/*.html',   // .html support...
        'atlmapsEmber/**/*.jade',   // .jade support...
        'atlmapsEmber/styles/main.scss',  // .scss & .sass support...
        'atlmapsEmber/config.yml'         // and .yml & .yaml support out of the box!
        ],
        
        options: {
          // See wiredep's configuration documentation for the options
          // you may pass:
          
          // https://github.com/taptapship/wiredep#configuration
        }
      }
    },
    bower: {
      dev: {
        
      }
    }
  });
  
  grunt.loadNpmTasks('grunt-bower');
  
  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');
  
  // Load the plugin that finds your components and injects them directly into the HTML.
  grunt.loadNpmTasks('grunt-wiredep');
  
  //Load the plugin that provides CSS minification task.
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  
  // Default task(s).
  // grunt.registerTask('default', ['uglify','cssmin','bower','wiredep']);
  
  grunt.registerTask('default', ['bower','wiredep']);
  
  // grunt.registerTask('default', 'Log some stuff.', function() {
  //   grunt.log.write('Logging some stuff...').ok();
  // });
  
};
