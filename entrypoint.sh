#!/bin/bash

if [[ $EMULATOR == "" ]]; then
    EMULATOR="android-24"
    echo "Using default emulator $EMULATOR"
fi

if [[ $ARCH == "" ]]; then
    ARCH="armeabi-v7a"
    echo "Using default arch $ARCH"
fi

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi

# Set up and run emulator
if [[ $ARCH == *"x86"* ]]
then 
    EMU="x86"
else
    EMU="arm"
fi

echo "no" | /opt/android-sdk/tools/android create avd -f -n emulator -t ${EMULATOR} --abi default/${ARCH}
echo "no" | /opt/android-sdk/tools/emulator64-${EMU} -prop persist.sys.language=en -prop persist.sys.country=US -avd emulator -ports 5554,5555 -no-snapshot-load -no-snapshot-save -no-audio -no-window -no-boot-anim 
