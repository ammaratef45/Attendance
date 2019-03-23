# Attendance
Application to be used for attendance registeration


# Ho to contribute

## installation
- Install Flutter
- Switch to dev channel flutter channel dev
- Upgrade flutter flutter upgrade
- Run tests flutter test
- Run app flutter run

You can use docker image ammaratef45/flutter:latest

## Install RVM (for pdd)
- `curl -sSL https://get.rvm.io | bash -s stable --ruby`
- `gem install pdd`

## Fingerprint
To be able to use our firebase auth service, we must allow you.
Run `keytool -exportcert -alias your-key-name -keystore /path/to/your/keystore/file -list -v` and send me the SHA-1

## contribution
- Make a fork.
- Pick an issue you want to solve, or implement a feature.
- Run the following commands before make a PR and make sure no one fails.
```
flutter packages get
flutter test
flutter -v build apk
pdd -f /dev/null -v
```
- Submit a PR
