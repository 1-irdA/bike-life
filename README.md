# bike_life

Frontend of [bike-life-services](https://github.com/1-irdA/bike-life-services)    

## Check devices

```sh
flutter devices
```

## Add config on existing project

```sh
flutter create --platforms=windows,macos,linux .
```

## Add developper mode

```sh
start ms-settings:developers
```

## Config desktop app

```sh
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

## Run     

```sh
flutter run 
```

## Debug

```sh
flutter run -d [platform]
```

## Release

```sh
flutter build apk --release
flutter build windows --release
flutter build web --release --web-renderer canvaskit
```