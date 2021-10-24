docker run -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v $PWD/shared:/shared -p 19996-19999:19996-19999 -it coppeliasim-ubuntu20
