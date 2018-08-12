#!/bin/bash

# Detect ip and forward ADB ports outside to outside interface
ip=$(ifconfig | grep 'inet '| grep -v '127.0.0.1' | cut -d' ' -f10 | tr -d '\n')
socat tcp-listen:5037,bind=$ip,fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$ip,fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &

echo "no" | /usr/local/android-sdk/tools/android create avd -f -n test -t ${ANDROID_PLATFORM} --abi default/${ANDROID_ARCH}
echo "no" | /usr/local/android-sdk/tools/emulator64-${ANDROID_ARCH} -avd test -noaudio -no-window -gpu off -verbose -qemu -usbdevice tablet -vnc :0
