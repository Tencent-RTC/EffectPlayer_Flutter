# Run Demo Quickly

## Environment Preparation

- Only supports Flutter 3.16.9 and below.

- Android development:
  - Android Studio 2.0 or above.

  - Android SDK API Level 19 and above.

  - Android 4.4 and above, support mobile devices with armeabi-v7a and arm-v8a architectures.

- iOS development:
  - Xcode 11.0 and above.

  - OSX system version requires 10.11 and above.

  - Please make sure that your project has set a valid developer signature.


## Quick Integration

### Import Project

Import the EffectPlayer_Flutter project into Android Studio and pull dependencies.

### Apply for a License

International customers [click here](https://trtc.io/document/60219?product=beautyar&menulabel=core%20sdk&platform=android) Apply for a Gift Animation Special Effects Test License.

After successfully applying for the LicenseUrl and LicenseKey, assign them to the LICENSE_URL and LICENSE_KEY fields in `example/lib/main.dart`.

### Run the project

Android: Replace `applicationId = "com.tencent.tcmediax.demo"` in the `example/android/app/build.gradle.kts` file with the Package Name filled in when applying for the License.

iOS: Replace the Bundle Identifer of the example run with the Bundle ID filled in when applying for the License.
