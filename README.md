# android-emulator

This repository contains yet another Docker image with Android Platform and emulator inside. Aim is to make a simple and lightweight way to run APKs in an Android emulator.

# Usage

Build image from source with

```
docker build -t android-emulator .
```

Then you can run the emulator and expose required ports to host:

```
docker run -it -p 5555:5555 -p 5554:5554 -p 5900:5900 android-emulator
```

This will expose ADB, control port and VNC port. You will be able to connect the emulator now with ADB and VNC. Note that first start of the emulator takes some time and VNC will not be able to connect in first minutes. ADB should be able to connect as soon as the image is ran.
