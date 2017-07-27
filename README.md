# android-emulator-debian

```sh
$ docker pull mdholloway/android-emulator-debian:latest
$ cd <project root>
$ docker run --privileged -d -P -v `pwd`:/workspace --name android mdholloway/android-emulator-debian
$ docker exec android <your commands here>
```
