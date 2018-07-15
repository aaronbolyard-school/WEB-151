# WEB-151
This repository was created for WEB-151.

## Final project
If you want to play the final project, go here: [http://aaronbolyard.itch.io/school-sneaksy](http://v6p9d9t4.ssl.hwcdn.net/html/960830/index.html).

To build the final project and play it locally:

```
$ git submodule --init
$ cd Final/love.js/release-performance
$ python27 ../emscripten/tools/file_packager.py game.data --preload ../../sneaksy\@/ --js-output=game.js
$ python -m http.server
```

Aaron Bolyard

2018-06-04
