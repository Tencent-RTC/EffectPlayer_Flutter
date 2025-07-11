This article mainly introduces the Flutter API interface document of Tencent Gift AR SDK for easy reference and use.

## FTCMediaXBase

### instance

**Description**

Get a single instance of FTCMediaXBase.

**Interface**

``` dart
static FTCMediaXBase get instance
```

**Parameter Description**

None

### setLicense

**Description**

Set License.

**Interface**

``` dart
Future<void> setLicense(String url, String key, FTCMediaLicenseListener listener) async
```

**Parameter Description**

| Parameter name | Type | Description |
| -------- | ---------------- | ---------------- |
| url | String | The url of the license. |
| key | String | The key of the license. |
| callback | ILicenseCallback | Callback |

Callback declaration:

``` dart
typedef FTCMediaLicenseListener = void Function(int errCode, String msg);
```

Common error codes for license verification:

| Error code | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| 0          | Success. Success.                                            |
| -1         | Invalid input parameters, for example, URL or KEY is empty.  |
| -3         | Download failed, please check network settings.              |
| -4         | The TE authorization information read from the local is empty, which may be caused by IO failure. |
| -5         | The content of the VCUBE TEMP License file is empty, which may be caused by IO failure. |
| -6         | The JSON field of the v_cube.license file is incorrect. Please contact the Tencent Cloud team for processing. |
| -7         | Signature verification failed. Please contact the Tencent Cloud team for processing. |
| -8         | Decryption failed. Please contact the Tencent Cloud team for processing. |
| -9         | The JSON field in the TELicense field is incorrect. Please contact the Tencent Cloud team for processing. |
| -10        | The TE authorization information parsed from the network is empty. Please contact the Tencent Cloud team for processing. |
| -11        | Failed to write the TE authorization information to the local file, which may be caused by IO failure. |
| -12        | Download failed, and parsing of local assets also failed.    |
| -13        | Authentication failed, please check whether so is in the package, or the so path has been set correctly. |
| 3004/3005  | Invalid authorization. Please contact the Tencent Cloud team for processing. |
| 3015       | Bundle Id / Package Name does not match. Check whether the Bundle Id / Package Name used by your App is consistent with the one applied for, and check whether the correct authorization file is used. |
| 3018       | The authorization file has expired and needs to be renewed from Tencent Cloud. |
| Others     | Please contact the Tencent Cloud team for processing.        |

### setLogEnable

**Description**

Whether to enable log output, default is on.

**Note:** Android side saves in /sdcard/Android/data/packagename/files/TCMediaX directory, iOS side saves in Documents/TCMediaX directory of sandbox, you can upload the logs in this directory to the business backend according to business needs, to locate online user problems.

**Interface**

``` dart
Future<void> setLogEnable(bool enable) async
```

## FTCEffectAnimView

### FTCEffectAnimView

**Description**

Create `FTCEffectAnimView` gift animation playback instance.

**Interface**

``` dart
FTCEffectAnimView({this.controllerCallback, Key? viewKey})
```

**Parameter Description**

**Parameter Description**

| Parameter Name     | Type                          | Description                                                  |
| ------------------ | ----------------------------- | ------------------------------------------------------------ |
| controllerCallback | FEffectViewControllerCallback | The playback controller of the current gift animation is successfully created. |

## FTCEffectViewController

### startPlay

**Description**

Start the player.

**Interface**

``` dart
Future<int> startPlay(String playUrl) async
```

**Parameter Description**

playUrl is the video resource address.

**Note:** Only local video resources on the phone are supported. If you use online video resources, download them locally before playing.

### setVideoMode

**Description**

Set the alignment of the alpha and rgb areas of the tep animation.

**Interface**

``` dart
Future<void> setVideoMode(FVideoMode videoMode) async
```

**Parameter Description**

videoMode supports the following formats:

| Enumeration value                              | Meaning                                     |
| ---------------------------------------------- | ------------------------------------------- |
| FVideoMode.VIDEO_MODE_NONE                     | Ordinary mp4 file                           |
| FVideoMode.EVIDEO_MODE_SPLIT_HORIZONTAL        | Align left and right (alpha left\rgb right) |
| FVideoMode.VIDEO_MODE_SPLIT_VERTICAL           | Align top and bottom (alpha top\rgb bottom) |
| FVideoMode.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE | Align left and right (rgb left\alpha right) |
| FVideoMode.VIDEO_MODE_SPLIT_VERTICAL_REVERSE   | Align up and down (RGB up\alpha down)       |

### setConfig

**Description**

Set the special Gift AR playr parameters, which needs to be called before starting playback.

**Interface**

``` dart
Future<void> setConfig(FTCEffectConfig config) async
```

**Parameter Description**

Refer to the FTCEffectConfig class below.

### setScaleType

**Description**

Set the alignment.

**Interface**

``` dart
Future<void> setScaleType(FScaleType type) async
```

**Parameter Description**

type supports the following formats:

| Enumeration value      | Meaning                                                      |
| ---------------------- | ------------------------------------------------------------ |
| FScaleType.FIT_XY      | Completely fill the entire layout, default value.            |
| FScaleType.FIT_CENTER  | Display completely in the middle of the layout according to the video ratio. |
| FScaleType.CENTER_CROP | Fill the layout completely according to the video ratio (the excess part is not displayed). |

### setFetchResource

**Description**

Set the resources of the fusion animation.

**Interface**

``` dart
void setFetchResource(FResourceFetcher resFetcher)
```

**Parameter Description**

FResourceFetcher interface:

``` dart
class FResourceFetcher {
// Get image
FResImgResultFetcher? imgFetcher;

// Get text
FResTextResultFetcher? textFetcher;

// Resource release notification
FResReleaseListener? releaseListener;

FResourceFetcher({this.imgFetcher, this.textFetcher, this.releaseListener});
}
```

FEffectResource#tag is the tag (subscript) of the fusion animation, which can be used to judge the tag and pass in different text or image resources.

### requestUpdateResource

**Description**

Update the fusion animation information during playback.

After calling the current method, the IFetchResource interface callback will be triggered to update the fusion animation information.

**Interface**

``` dart
Future<void> requestUpdateResource() async
```

### setRenderRotation

**Description**

Set the rotation angle of the fusion animation selection, supporting 0, 90, 180, 270, 360 degrees.

**Interface**

``` dart
Future<void> setRenderRotation(int rotation) async
```

### isPlaying

**Description**

Return whether the special Gift AR player is playing.

**Interface**

``` dart
Future<bool> isPlaying() async
```

### resume

**Description**

Resume the special effect animation playback.

**Interface**

``` dart
Future<void> resume() async
```

### pause

**Description**

Pause the special effect animation playback.

**Interface**

``` dart
Future<void> pause() async
```

### seekTo

**Description**

Jump to the specified position to start playback.

**Note:**

- This method can be called only after startPlay(), otherwise it will not take effect.

- This interface is effective for tcmp4 animations, or mp4 animations played when FCodecType.TX_LITEAV_SDK is set.

- milliSec: To jump to the specified duration to start playback, in milliseconds.

**Interface**

``` dart
Future<void> seekTo(int millSec) async
```

### seekProgress

**Description**

Go to the specified position to start playing.

progress: Jump to the specified percentage of the animation duration to start playing, in percentage, value range: [0.0-1.0].

**Note:**

1. This method can be called only after startPlay(), otherwise it will not take effect.

2. This interface is effective for tcmp4 animation, or mp4 animation played when FCodecType.TX_LITEAV_SDK is set.

3. The value range of the input parameter progress is [0.0-1.0]. If it exceeds the range, it will not take effect.

**Interface**

``` dart
Future<void> seekProgress(double progress) async
```

### setLoop

**Description**

Set loop playback.

- true: Indicates loop playback.

- false: Indicates closing loop playback.

**Interface**

``` dart
Future<void> setLoop(bool isLoop) async
```

### setLoopCount

**Description**

Set the number of loop playback.

loopCount: Indicates the number of loop playback. When loopCount <= 0, it means infinite loop playback; when loopCount=n(n>=1), it means that the playback is played n times from the beginning to the end.

**Note:**

1. The default value of loopCount is 1, that is, when the external method is not actively called, the animation is played only once and then ends.

2. The setLoop(boolean isLoop) method will call the current method internally, that is, when isLoop = true, it is equivalent to calling setLoopCount(-1); that is, when isLoop = false, it is equivalent to calling setLoopCount(1); therefore, these two methods affect each other, and the later call will overwrite the previous call.

**Interface**

``` dart
Future<void> setLoopCount(int loopCount) async
```

### setDuration

**Description**

Set how long the animation takes to play. After setting, the animation playback speed is automatically adjusted during subsequent animation playback to ensure that the animation ends at the specified duration.

That is: if the set duration exceeds the original animation duration, the animation will be slowed down; if it is less than the original animation duration, it will be fast-forwarded.

durationInMilliSec: The duration to be set, in milliseconds.

**Note:**

1. Currently only applies to animations in tcmp4 format.

2. The current method and the setRate method for setting the speed are mutually exclusive, and the later call will overwrite the earlier call.

**Interface**

``` dart
Future<void> setDuration(int durationInMilliSec) async
```

### stopPlay

**Description**

Stop playback.

**interface**

``` dart
Future<void> stopPlay({bool? clearLastFrame}) async
```

### setMute

**Description**

Set whether to play in mute mode.

- true: Play in mute mode.

- false: Play in non-mute mode.

**Interface**

``` dart
Future<void> setMute(bool mute)
```

### setPlayListener

**Description**

Set the playback callback of the special Gift AR player.

**Interface**

``` dart
void setPlayListener(FAnimPlayListener? listener)
```

**Parameter Description**

IAnimPlayListener interface:

``` dart
class FAnimPlayListener {
FEmptyFunction? onPlayStart;

FEmptyFunction? onPlayEnd;

FIntParamsFunction? onPlayError;

FOnPlayEventFunction? onPlayEvent;

FAnimPlayListener({this.onPlayStart, this.onPlayEnd, this.onPlayError, this.onPlayEvent});
}
```

For the event value in the onPlayEvent method, see the constant value in the FTCEffectPlayerConstant class:

``` dart
static static int REPORT_INFO_ON_PLAY_EVT_PLAY_END = 2006;
static static int REPORT_INFO_ON_PLAY_EVT_RCV_FIRST_I_FRAME = 2003;
static static int REPORT_INFO_ON_PLAY_EVT_CHANGE_RESOLUTION = 2009;
static static int REPORT_INFO_ON_PLAY_EVT_LOOP_ONCE_COMPLETE = 6001;
static static int REPORT_INFO_ON_VIDEO_CONFIG_READY = 200001;
static static int REPORT_INFO_ON_NEED_SURFACE = 200002;
static static int REPORT_INFO_ON_VIDEO_SIZE_CHANGE = 200003;
static static int REPORT_ANIM_INFO = 200004;
```

For details on the errorCode value in the onPlayError method, see FTCEffectPlayerConstant Constant values in the class:

``` dart
static const REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT = -10007; // h265 is not supported
static const REPORT_ERROR_TYPE_INVALID_PARAM = -10008; // Illegal parameters
static const REPORT_ERROR_TYPE_INVALID_LICENSE = -10009; // Illegal License
static const REPORT_ERROR_TYPE_ADVANCE_MEDIA_PLAYER = -10010; // MediaPlayer playback failed
static const REPORT_ERROR_TYPE_MC_DECODER = -10011; // Decoder failed in MediaCodec
static const REPORT_ERROR_TYPE_UNKNOWN_ERROR = -20000; // Unknown error
```

### getTCAnimInfo

**Description**

Get the information corresponding to the currently playing animation and return the FTCEffectAnimInfo instance. For details, see FTCEffectAnimInfo.

**Note:**

This method must be called in the FAnimPlayListener#onPlayStart() method or after this method is executed to get the information of the current animation, otherwise it returns null.

**Interface**

``` dart
Future<FTCEffectAnimInfo> getTCAnimInfo() async
```

### FTCEffectConfig

**Description**

Construct special effects player configuration.

**codecType property**

``` dart
// Set CodecType
FCodecType? codecType;
```

**Parameter Description**

It has three values, namely:

- FCodecType.TC_MPLAYER (MPLAYER playback engine, only valid on Android platform)

- FCodecType.TC_MCODEC (MCODEC playback engine, only valid on Android platform)

- FCodecType.TX_LITEAV_SDK (Tencent Cloud Player SDK, valid on Andriod and iOS platforms)

**Note:**

1. Currently, only calling the setConfig() method before the player starts to set the playback configuration is supported. Configuration modification is not supported after the playback starts.
1. The three currently supported CodecTypes are only valid for TEP animations.
1. If CodecType is set to FCodecType.TX_LITEAV_SDK , you also need to separately introduce Tencent Cloud Player SDK, and apply for and register its corresponding license.

**freezeFrame property**

``` dart
// Set the freeze frame index
FFreezeFrame? freezeFrame;
```

**Parameter description**

The input parameter frame indicates which frame the animation needs to stay at during playback. Currently available values:

- FFreezeFrame.FREEZE_FRAME_NONE: Turn off the freezeFrame capability, and the player will pause and disappear when playing normally.

- FFreezeFrame.FREEZE_FRAME_LAST: After the first playback is completed, the picture stays at the last frame.

**animType attribute**

``` dart
// Set the animation format to be played later
FAnimType? animType;
```

**Parameter description**

Used to specify the animation format to be played later, applicable to the scene where the suffix of the animation file to be played is modified in some cases. The input parameter type indicates the animation format to be specified. Currently available values:

- FAnimType.AUTO (SDK default strategy, that is, the animation format is determined by the suffix of the animation file, such as tcmp4/mp4/tep/tepg and other formats.)

- FAnimType.MP4 (MP4 animation format, animation files will be played as MP4 type in the future, regardless of the file suffix.)

- FAnimType.TCMP4 (TCMP4 animation format, animation files will be played as TCMP4 type in the future, regardless of the file suffix.)

## FTCEffectAnimInfo

**Description**

Stores the animation information currently being played.

**Property Description**

| Property Name | Type     | Description                                                  |
| ------------- | -------- | ------------------------------------------------------------ |
| type          | int      | Current animation type, value: FAnimType.MP4 MP4 type resource and FAnimType.TCMP4 TCMP4 type resource. |
| duration      | long     | Animation duration, in milliseconds.                         |
| width         | int      | Animation width.                                             |
| height        | int      | Animation height.                                            |
| encryptLevel  | int      | Advanced encryption type of the current animation, if the value is 0, it means there is no advanced encryption, otherwise it means it is already advanced encryption. |
| mixInfo       | FMixInfo | Fusion animation information, if it is null, it means that the animation has no fusion information. |

## FMixInfo

**Description**

Stores the fusion information of the currently playing animation.

**Property Description**

| Property Name    | Type           | Description                                                  |
| ---------------- | -------------- | ------------------------------------------------------------ |
| textMixItemList  | List<FMixItem> | Text fusion information. When null, it means there is no text fusion information. |
| imageMixItemList | List<FMixItem> | Image fusion information. When null, it means there is no image fusion information. |

## FMixItem

**Description**

Stores the fusion information of the currently playing animation.

**Property Description**

| Property Name | Type   | Description                                                  |
| ------------- | ------ | ------------------------------------------------------------ |
| id            | String | Current fusion animation id.                                 |
| tag           | String | Current fusion animation tag.                                |
| text          | String | Current text fusion animation text content (the value is empty for image fusion animation). If it is tcmp4, it is the original text content inside; if it is mp4, it is the tag value filled in the tool. |

## FTCEffectText

**Description**

Fusion animation replacement text style data class.

**Property Description**

| Property Name | Type   | Description                                                  |
| ------------- | ------ | ------------------------------------------------------------ |
| text          | String | The text content to be replaced in the end.                  |
| color         | int    | Text color, format requirements: ARGB, such as 0xFFFFFFFF.   |
| fontStyle     | String | Text display style, possible values: "bold" means bold, default size if not passed. |
| alignment     | int    | Text alignment, possible values: TEXT_ALIGNMENT_NONE (default value, i.e. keep the SDK default alignment), TEXT_ALIGNMENT_LEFT (left), TEXT_ALIGNMENT_CENTER (center), TEXT_ALIGNMENT_RIGHT (right). |
| fontSize      | double | Text size, in px; if the text size is set (value greater than 0), the internal automatic scaling strategy will fail, and the set text size will be used as the standard, which may cause the text to be too large and not fully displayed. |
