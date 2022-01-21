# QLKCL Project (Mobile)

QLKCL Mobile


## Version info
* Flutter 2.5.3
* Dart 2.14.4
* minSdkVersion 20

## Check system
```
flutter doctor
flutter doctor --android-licenses
```

## Sync library
```
flutter clean
flutter pub get
```

## Run app
```
flutter run
```
or
```
flutter run --no-sound-null-safety
```

## Release app
```
flutter run --release
```
or
```
flutter build apk --release
flutter install
```

## Release web
```
flutter build web --release --base-href '/QLKCL_Web/' --no-sound-null-safety
```

## Change icon
```
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

# Default account
Login as admin
```
phone: 0123456789
password: 123456
```

Login as member
```
phone: 0123456780
password: 123456
```

# Authors
1. [Lê Trung Sơn](https://github.com/lesonlhld)
2. [Châu Thanh Tân](https://github.com/cttan2000)
3. [Nguyễn Bá Tiến](https://github.com/batiencd09)
4. [Trương Ngọc Minh Châu](https://github.com/chauandvi4) (Contribute the system in the first stage)