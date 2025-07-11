This document mainly introduces how to quickly integrate the Tencent Gift AR Flutter SDK into your project. Configure according to the following steps, and you can complete the integration work of the SDK.

## Initialize License Registration

Before officially using the Tencent Gift AR Flutter SDK, you need to set up the License. Only after successfully setting the License can you proceed to use the SDK.

The method to set the License is as follows:

```java
import 'package:flutter_effect_player/ftceffect_player.dart';

const LICENSE_URL = "${licenseUrl}";
const LICENSE_KEY = "${licenseKey}";

FTCMediaXBase.instance.setLicense(LICENSE_URL, LICENSE_KEY, (code, msg) {
  print("TCMediaX license result: errCode:${code}, msg:${msg}");
});
```

> **Note:**
>
> * The License involves strict online verification. After the app is launched for the first time, when calling `FTCMediaXBase.instance.setLicense`, ensure that the network is available. On the app’s first launch, network permission might not have been granted yet. You need to wait for network permissions to be granted and then call the method again.
> * Listen for the callback result of `FTCMediaXBase.instance.setLicense`. If it fails, retry and guide accordingly based on the actual situation. If multiple failures occur, you can limit the frequency and provide product popups or other guidance to help the user check their network situation.

**License errorCode explanation:**

| Error Code | Description                                                                                                                                                                 |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0          | Success.                                                                                                                                                                    |
| -1         | Invalid input parameters, such as empty URL or KEY.                                                                                                                         |
| -3         | Download failed, check network settings.                                                                                                                                    |
| -4         | Local TE authorization info is empty, possibly due to IO failure.                                                                                                           |
| -5         | Failed to read the VCUBE TEMP License file content, possibly due to IO failure.                                                                                             |
| -6         | The `v_cube.license` file JSON fields are incorrect. Please contact the Tencent Cloud team.                                                                                 |
| -7         | Signature verification failed. Please contact the Tencent Cloud team.                                                                                                       |
| -8         | Decryption failed. Please contact the Tencent Cloud team.                                                                                                                   |
| -9         | Incorrect JSON fields in the TELicense field. Please contact the Tencent Cloud team.                                                                                        |
| -10        | TE authorization info parsed from the network is empty. Please contact the Tencent Cloud team.                                                                              |
| -11        | Failed to write TE authorization info to a local file, possibly due to IO failure.                                                                                          |
| -12        | Download failed and parsing local asset also failed.                                                                                                                        |
| -13        | Authorization failed, check if the SO file is in the package, or if the SO path is correctly set.                                                                           |
| 3004/3005  | Invalid authorization. Please contact the Tencent Cloud team.                                                                                                               |
| 3015       | Bundle Id / Package Name mismatch. Check if the Bundle Id / Package Name used by your app matches the application one, and check if the correct authorization file is used. |
| 3018       | License file has expired, renewal from Tencent Cloud is required.                                                                                                           |
| Other      | Please contact the Tencent Cloud team.                                                                                                                                      |

## Log Management

The Tencent Gift Animation Effects SDK supports saving runtime logs by default. If any issues arise during testing, you can extract the logs and provide them to Tencent Cloud support. You can also upload these logs to your backend to help diagnose user issues online.

1. On Android, logs are saved in the directory: `/sdcard/Android/data/${your_packagename}/files/TCMediaLog`. The log files are named by date, and you can export the `TCMediaLog` folder:

![](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100034408908/1a1e4d0e095511f0990f52540099c741.png)

2. On iOS, logs are saved in the sandbox `Documents/TCMedialog` folder, with log files named by date. For detailed log export instructions, [refer here](https://trtc.io/document/70544?platform=ios&product=beautyar&menulabel=core%20sdk#59b6468e-c7a0-48da-9b96-94c85e49e48c).

> **Note:**
>
> **No log files?**
>
> Check if you have disabled logs by setting `FTCMediaXBase.instance.setLogEnable` to false. By default, file logs are enabled.

## Player Usage

### Introduce FTCEffectAnimView

```dart
Widget _getFTCEffectAnimView() {
  return FTCEffectAnimView(
      controllerCallback: (controller){
        // controller.setLoop(true);
        // controller.startPlay("xxxxxxx");
      }
  );
}
```

### Playback Listener

You can set an animation playback status listener before starting playback by calling the `setPlayListener` method:

```dart
controller?.setPlayListener(FAnimPlayListener(onPlayStart: () {
  // on anim play start
}, onPlayEnd: () {
  // on anim play end
}, onPlayEvent: (int event, Map params) {
  // on anim play events
}, onPlayError: (code) {
  // on anim play error
}));
```

1. If you need to get the current animation information, you can call `getTCAnimInfo()` in the `onPlayStart()` method (or after it is executed) to get the `FTCEffectAnimInfo` object instance, which provides the current animation type, duration, width, height, and merged animation information.

### Playback Configuration

```dart
// Set playback configuration, optional step
final FTCEffectConfig _curConfig = FTCEffectConfig()..codecType = FCodecType.TC_MPLAYER;
controller?.setConfig(_curConfig);
```

The `FTCEffectConfig` currently supports:

1. `FCodecType codecType`: It has three possible values:

* `FCodecType.TC_MPLAYER` (MPLAYER playback engine)
* `FCodecType.TC_MCODEC` (MCODEC playback engine)
* `FCodecType.TX_LITEAV_SDK` (Tencent Cloud Player SDK)

> **Note:**
>
> 1. Currently, `setConfig()` must be called before starting playback, and configurations cannot be modified after playback has started.
> 2. The above settings currently only apply to MP4 animations.
> 3. If set to `FCodecType.TX_LITEAV_SDK`, you also need to introduce the Tencent Cloud Player SDK and apply for and register its corresponding License.
> 4. If no config is set, the default codec type is `FCodecType.TC_MPLAYER`.

2. `FFreezeFrame freezeFrame`: Used to set the animation freeze frame. For a detailed explanation, see the API documentation.

3. `FAnimType animType`: Used to specify the animation format to be played. This is suitable for cases where the animation file extension is changed. The possible values are:

> * `FAnimType.AUTO` (SDK default strategy, determines the animation format based on the file extension, such as tcmp4/mp4/tep/tepg formats).
> * `FAnimType.MP4` (MP4 animation format, the file will always be treated as MP4 format regardless of the file extension).
> * `FAnimType.TCMP4` (TCMP4 animation format, the file will always be treated as TCMP4 format regardless of the file extension).

### Fusion Animation Configuration

Implement the playback of mp4 or tcmp4 fusion animations, you need to implement `FResourceFetcher`.

1. If it's an image-based fusion animation, you need to implement `FResImgResultFetcher`, which returns the corresponding image’s `Uint8List` to replace the corresponding element.

2. If it's a text-based fusion animation, you need to implement `FResTextResultFetcher`, which returns the corresponding `FTCEffectText` object instance to specify the display configuration of the text.

   ```dart
   controller?.setFetchResource(FResourceFetcher(textFetcher: (res) {
      // Return an FTCEffectText instance, where you can specify the text content, color, etc.
      return FTCEffectText()
        ..text = "FTCEffect${res.id}"
        ..color = 0xff0000ff;
    }, imgFetcher: (res) {
      // Prepare the image data to be replaced in advance and return it here.
      // final data = await rootBundle.load('asset/image/head1.png');
      // _samplePng = data.buffer.asUint8List();
      return _samplePng;
    }));
   ```

### Playback Control

#### Start Playback

Supports playing `.mp4`, `.tcmp4` file format resources.

> **Note:**
>
> 1. Only local video resources are supported. If you're using network video resources, download them to local storage before playback.
> 2. Animation resources can be generated using the [Effect Conversion Tool](https://trtc.io/document/70541?platform=android&product=beautyar&menulabel=core%20sdk), and VAP format animation resources are also supported for playback.

```dart
controller?.startPlay("xxxx")
```

#### Pause Playback

```dart
controller?.pause()
```

#### Resume Playback

```dart
controller?.resume()
```

#### Loop Playback

```dart
controller?.setLoop(true)
```

#### Mute Playback

```dart
controller?.setMute(true)
```

#### Stop Playback

When the player is no longer needed, stop playback and release the resources it occupies.

```dart
controller?.stopPlay()
```

## Common Problems

### What to do when the following log appears during playback?

```plaintext
License checked failed! tceffect player
```


license required!

```

Please check if you have applied for the effect player License and initialized it.

## Common Error Codes

| Error Code | Description |
|------------|-------------|
| -10003     | Failed to create thread. |
| -10004     | Failed to create render. |
| -10005     | Failed to parse configuration. |
| -10006     | File cannot be read. |
| -10007     | The animation video encoding format is H.265, which is not supported on the current device. |
| -10008     | Invalid parameter. |
| -10009     | Invalid license. |
| -10010     | MediaPlayer playback failed. |
| -10012     | Missing essential dependencies, such as missing `liteavSDK` when `TX_LITEAV_SDK` is used. |
---
```
