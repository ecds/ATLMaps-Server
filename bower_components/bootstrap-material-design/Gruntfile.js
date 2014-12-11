module.exports = function(grunt) {
  "use strict";

  require("load-grunt-tasks")(grunt);

  grunt.initConfig({


    // Compile less to .css
    // Compile less to .min.css
    // Create source maps of both
    less: {
      material: {
        options: {
          paths: ["less"],
          sourceMap: true,
          sourceMapRootpath: "/",
          sourceMapFilename: "dist/css/material.css.map",
          sourceMapURL: "material.css.map"
        },
        files: {
          "dist/css/material.css": "less/material.less",
        }
      },
      materialwfont: {
        options: {
          paths: ["less"],
          sourceMap: true,
          sourceMapRootpath: "/",
          sourceMapFilename: "dist/css/material-wfont.css.map",
          sourceMapURL: "material-wfont.css.map",
          outputSourceFiles: true
        },
        files: {
          "dist/css/material-wfont.css": "less/material-wfont.less",
        }
      },
      ripples: {
        options: {
          paths: ["less"],
          sourceMap: true,
          sourceMapRootpath: "/",
          sourceMapFilename: "dist/css/ripples.css.map",
          sourceMapURL: "ripples.css.map",
          outputSourceFiles: true
        },
        files: {
          "dist/css/ripples.css": "less/ripples.less",
        }
      }
    },

    // Autoprefix .css and edit its source map
    // Autoprefix .min.css an edit its source map
    autoprefixer: {
      options: {
        map: true,
        browsers: ["last 3 versions", "ie 8", "ie 9", "ie 10", "ie 11"]
      },
      material: {
        files: {
          "dist/css/material.css": "dist/css/material.css",
          "dist/css/material.min.css": "dist/css/material.min.css"
        }
      },
      materialwfont: {
        files: {
          "dist/css/material-wfont.css": "dist/css/material-wfont.css",
          "dist/css/material-wfont.min.css": "dist/css/material-wfont.min.css"
        }
      },
      ripples: {
        files: {
          "dist/css/ripples.css": "dist/css/ripples.css",
          "dist/css/ripples.min.css": "dist/css/ripples.min.css"
        }
      }
    },

    // Minify CSS and adapt maps
    csswring: {
      material: {
        src: "dist/css/material.css",
        dest: "dist/css/material.min.css"
      },
      materialwfont: {
        src: "dist/css/material-wfont.css",
        dest: "dist/css/material-wfont.min.css"
      },
      ripples: {
        src: "dist/css/ripples.css",
        dest: "dist/css/ripples.min.css"
      }
    },

    // Copy .js to dist/js/ folder
    copy: {
      material: {
        src: "scripts/material.js",
        dest: "dist/js/material.js"
      },
      ripples: {
        src: "scripts/ripples.js",
        dest: "dist/js/ripples.js"
      },
      fonts: {
        expand: true,
        cwd: "fonts/",
        src: "**",
        dest: "dist/fonts/",
        flatten: true,
        filter: "isFile"
      }
    },

    // Compile .js to .min.js
    uglify: {
      options: {
        sourceMap: true
      },
      material: {
        files: {
          "dist/js/material.min.js": "dist/js/material.js"
        }
      },
      ripples: {
        files: {
          "dist/js/ripples.min.js": "dist/js/ripples.js"
        }
      }
    },

    connect: {
      options: {
        port: 8040,
        hostname: "localhost",
        livereload: 35729

      },
      livereload: {
        options: {
          open: true,
          base: "."
        }
      },
      test: {
        options: {
          port: 8041,
          open: "http://localhost:8041/_SpecRunner.html",
          base: "."
        }
      }
    },
    jasmine: {
      scripts: "scripts/**/*.js",
      options: {
        build: true,
        specs: "test/*Spec.js",
        helpers: "test/*Helper.js",
        vendor: [
          "https://code.jquery.com/jquery-1.10.2.min.js",
          "https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"
        ]
      }
    },
    jshint: {
      options: {
        jshintrc: ".jshintrc",
        reporter: require("jshint-stylish")
      },
      all: [
        "Gruntfile.js",
        "scripts/**/*.js",
        "template/**/*.js",
        "!template/**/*.min.js"
      ],
      test: {
        options: {
          jshintrc: "test/.jshintrc",
          src: ["test/**/*.js"]
        }
      }
    },
    watch: {
      js: {
        files: ["Gruntfile.js", "scripts/**/*.js", "template/**/*.js"],
        tasks: ["newer:jshint:all"]
      },
      jsTest: {
        files: ["test/**/*.js"],
        tasks: ["newer:jshint:test", "jasmine"]
      },
      less: {
        files:["less/**/*.less"],
        tasks: ["default"]
      },
      livereload: {
        options: {
          livereload: "<%= connect.options.livereload %>"
        },
        files: [
          "index.html",
          "dist/css/**/*.css",
          "**/*.{png,jpg,jpeg,gif,webp,svg}"
        ]
      }
    }
  });

  grunt.registerTask("default", ["material", "ripples"]);

  grunt.registerTask("material", [
    "material:less",
    "material:js"
  ]);
  grunt.registerTask("material:less", [
    "less:material",
    "less:materialwfont",
    "csswring:material",
    "csswring:materialwfont",
    "autoprefixer:material",
    "autoprefixer:materialwfont"
  ]);
  grunt.registerTask("material:js", [
    "copy:material",
    "uglify:material"
  ]);

  grunt.registerTask("ripples", [
    "ripples:less",
    "ripples:js"
  ]);
  grunt.registerTask("ripples:less", [
    "less:ripples",
    "csswring:ripples",
    "autoprefixer:ripples"
  ]);
  grunt.registerTask("ripples:js", [
    "copy:ripples",
    "uglify:ripples"
  ]);

  grunt.registerTask("build", function(target) {
    var buildType = "default";
    if (target && target === "scss") {
      buildType = "scss";
    }
    grunt.task.run(["newer:jshint", "jasmine:scripts", buildType]);
  });

  grunt.registerTask("test", [
    "jasmine:scripts:build",
    "connect:test:keepalive"
  ]);

  grunt.registerTask("serve", function(target){
    var buildTarget = "material:less";
    if(target && target === "scss") {
      buildTarget = "scss";
    }
    grunt.task.run([
      "build:"+ buildTarget,
      "connect:livereload",
      "watch"
    ]);
  });

  grunt.registerTask("cibuild",["newer:jshint", "jasmine:scripts"]);
};
