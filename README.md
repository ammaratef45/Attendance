<img src="https://github.com/ammaratef45/Attendance/raw/master/attendance/assets/icons/icon.png" height="100px"/>

[![Managed by Zerocrat](https://www.0crat.com/badge/CH951175M.svg)](https://www.0crat.com/p/CH951175M)
[![Donate via Zerocracy](https://www.0crat.com/contrib-badge/CH951175M.svg)](https://www.0crat.com/contrib/CH951175M)
[![DevOps By Rultor.com](http://www.rultor.com/b/ammaratef45/Attendance)](http://www.rultor.com/p/ammaratef45/Attendance)

[![PDD status](http://www.0pdd.com/svg?name=ammaratef45/Attendance)](http://www.0pdd.com/p?name=ammaratef45/Attendance)
[![CircleCI](https://circleci.com/gh/ammaratef45/Attendance/tree/master.svg?style=svg)](https://circleci.com/gh/ammaratef45/Attendance/tree/master)
[![codecov](https://codecov.io/gh/ammaratef45/Attendance/branch/master/graph/badge.svg)](https://codecov.io/gh/ammaratef45/Attendance)
[![Hits-of-Code](https://hitsofcode.com/github/ammaratef45/attendance)](https://hitsofcode.com/view/github/ammaratef45/attendance)
[![Codemagic build status](https://api.codemagic.io/apps/5ca0a581581a2d000dec8080/5cd016d389dd020011a439ca/status_badge.svg)](https://codemagic.io/apps/5ca0a581581a2d000dec8080/5cd016d389dd020011a439ca/latest_build)

[![MIT License](https://img.shields.io/github/license/ammaratef45/Attendance.svg)](https://github.com/ammaratef45/Attendance/blob/master/LICENSE)
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg)](#contributors)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Watch on GitHub](https://img.shields.io/github/watchers/ammaratef45/Attendance.svg?style=flat&logo=github&colorB=deeppink&label=Watchers)](https://github.com/ammaratef45/Attendance)
[![Star on GitHub](https://img.shields.io/github/stars/ammaratef45/Attendance.svg?style=flat&logo=github&colorB=deeppink&label=Stars)](https://github.com/ammaratef45/Attendance)

QR-Attendance App. [The Admin version](https://github.com/ammaratef45/Attendance-Admin) is designed for users whose job is meant to manage the attendance of a group of persons to a lecture meeting or any similar professional and non-professional gatherings.

This is the users version (student or participant).

[![Get it on Google Play](https://github.com/Volorf/Badges/blob/master/Google%20Play/Google%20Play%20Badge.svg)](https://play.google.com/store/apps/details?id=com.ammar.attendance)
[![Get it on App Store](https://github.com/Volorf/Badges/blob/master/App%20Store/App%20Store%20Badge.svg)]()


## Donation
We pay money to keep the development wheel running and to make the App always FREE for everyone. 
The only source of money is some small Ads that will be added later. We planned them to be light-weight Ads, So we cannot really expect them to afford our work.

If you are willing to [donate](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=U6NJRDMCD3ET2&source=url), That will help the project.

# How to contribute


## Installation ##

  - Install [Android Studio](https://developer.android.com/studio) for building Android.
  - Install [xCode](https://developer.apple.com/xcode/) for building iOS.
  - Install Flutter, See [Getting Started with Flutter](#getting-started-with-flutter).
  - Install PDD, [More about PDD here](https://github.com/yegor256/0pdd).
  - We prefer using [VSCode](https://code.visualstudio.com/)

## Fingerprint
To be able to use our firebase auth service, we must allow you.
Run `keytool -exportcert -alias your-key-name -keystore /path/to/your/keystore/file -list -v` and send me the SHA-1

## Performance
We highly encourage our contributors to benchmark their code performance using [Dart DevTools](https://flutter.github.io/devtools/).

## Contribution
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
