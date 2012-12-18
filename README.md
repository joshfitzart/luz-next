# Luz Studio

A live motion graphics editor and performer.

<http://createdigitalmotion.com/2011/03/luz-live-motion-graphics-controlled-by-anything-free-on-linux-and-now-with-dmx>

## Video Tutorials

<http://lighttroupe.com/luz>

## The Luz Project consists of:

- **Luz Studio**: a live motion graphics editor (Ruby, Gtk+, OpenGL)
- **Luz Performer**: plays Luz projects fullscreen (Ruby, SDL, OpenGL)
- **Luz Video Recorder**: renders smooth HD video of Luz projects (Ruby, SDL, OpenGL, ffmpeg)
- **Luz Audio Player**: plays music and sends song progress percentage to Luz (Ruby, GStreamer)
- **Luz Input Manager**: sends live input device data to Luz (C++, Gtk+, XOrg API, libwiimote, SDL Input)
- **Luz Spectrum Analyzer**: sends audio information to Luz (C++, OpenGL, FFTW)
- **Luz Body Tracker**: sends motion-tracked human data to Luz (C++, OpenGL, OpenNI+NITE)

# Getting Luz

Luz currently only runs on Linux.  Help is wanted porting it to OSX.

Luz currently works best on Ubuntu 11.10.  It runs on Ubuntu 12.04 if you provide the Ruby GTK+ OpenGL bindings, either compiled from source or downloaded here and placed in the base Luz directory:

<http://openanswers.org/gtkglext.so> (32-bit version)

1. Clone this repository.

2. Install dependencies as described in README.

3. Run 'make' in the root directory to build Input Manager and Spectrum Analyzer

4. Optionally run the ./build scripts in utils/webcam, utils/video-file, and utils/chipmunk.
