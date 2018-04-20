# Dependency List
This is a list of packages that are dependencies of various versions of the MATLAB MCR, beyond those included in a [CentOS 7 Docker image](https://hub.docker.com/_/centos/), as determined by the process described in the included 'util/readme.md'.  It is assumed that the repositories in said readme are enabled.  

## MCR 2016a
### Known Dependencies

`qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtwebkit qt5-qtwebsockets qt5-qtx11extras libXcursor libXrandr libXt libXtst atk ffmpeg-compat GConf2 gtk2 python34-libs libsndfile`

### Missing Dependencies
* libavcodec.so.53
* libavformat.so.53
* libmwcoderWatermark.so
* libpython3.3m.so.1.0