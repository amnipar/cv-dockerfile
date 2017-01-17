# amnipar/cv Dockerfile

This is a Dockerfile for easily setting up a build environment for many kinds of computer vision projects based around OpenCV. There are plans to add other libraries and tools in future.

Usage:

```sh
$ docker run --rm -it -v *dir*:/source amnipar/cv
```

where *dir* is a directory to mount as volume /source within the container. In the shell, build commands can be issued.

Inspired by <https://github.com/schickling/dockerfiles/tree/master/opencv>
