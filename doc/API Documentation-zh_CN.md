本文主要介绍腾讯礼物动画特效 SDK 的 Flutter 端 API 接口文档，以便于查阅和使用。

## FTCMediaXBase

### instance

**说明**

获取 FTCMediaXBase 的单例。

**接口**
``` dart
static FTCMediaXBase get instance
```

**参数说明**

无

### setLicense

**说明**

设置 License。

**接口**
``` dart
Future<void> setLicense(String url, String key, FTCMediaLicenseListener listener) async
```

**参数说明**

**参数说明**

| 参数名   | 类型             | 描述             |
| -------- | ---------------- | ---------------- |
| url      | String           | licence 的 url。 |
| key      | String           | licence 的 key。 |
| callback | ILicenseCallback | 回调             |


回调声明：
``` dart
typedef FTCMediaLicenseListener = void Function(int errCode, String msg);
```

License 校验常见错误码：

| 错误码    | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| 0         | 成功。Success。                                              |
| -1        | 输入参数无效，例如 URL 或 KEY 为空。                         |
| -3        | 下载环节失败，请检查网络设置。                               |
| -4        | 从本地读取的 TE 授权信息为空，可能是 IO 失败引起。           |
| -5        | 读取 VCUBE TEMP License文件内容为空，可能是 IO 失败引起。    |
| -6        | v_cube.license 文件 JSON 字段不对。请联系腾讯云团队处理。    |
| -7        | 签名校验失败。请联系腾讯云团队处理。                         |
| -8        | 解密失败。请联系腾讯云团队处理。                             |
| -9        | TELicense 字段里的 JSON 字段不对。请联系腾讯云团队处理。     |
| -10       | 从网络解析的 TE 授权信息为空。请联系腾讯云团队处理。         |
| -11       | 把TE授权信息写到本地文件时失败，可能是 IO 失败引起。         |
| -12       | 下载失败，解析本地 asset 也失败。                            |
| -13       | 鉴权失败，请检查 so 是否在包里，或者已正确设置 so 路径。     |
| 3004/3005 | 无效授权。请联系腾讯云团队处理。                             |
| 3015      | Bundle Id / Package Name 不匹配。检查您的 App 使用的 Bundle Id / Package Name 和申请的是否一致，检查是否使用了正确的授权文件。 |
| 3018      | 授权文件已过期，需要向腾讯云申请续期。                       |
| 其他      | 请联系腾讯云团队处理。                                       |


### setLogEnable

**说明**

是否开启 Log 输出，默认开始。

**注意：**Android 端保存在 /sdcard/Android/data/packagename/files/TCMediaX 目录，iOS 端保存在 sandbox 的 Documents/TCMediaX 目录，您可以根据业务需要把此目录的日志上传到业务后台，用于定位线上用户问题。

**接口**

``` dart
Future<void> setLogEnable(bool enable) async
```

## FTCEffectAnimView

### FTCEffectAnimView

**说明**

创建 `FTCEffectAnimView` 礼物动画播放实例。

**接口**

``` dart
FTCEffectAnimView({this.controllerCallback, Key? viewKey})
```

**参数说明**

**参数说明**

| 参数名             | 类型                          | 描述                                   |
| ------------------ | ----------------------------- | -------------------------------------- |
| controllerCallback | FEffectViewControllerCallback | 当前礼物动画的播放控制器创建成功回调。 |

## FTCEffectViewController

### startPlay

**说明**

启动播放器。

**接口**
``` dart
Future<int> startPlay(String playUrl) async
```

**参数说明**

playUrl 为视频资源地址。

**注意：**只支持播放手机本地视频资源， 如果您使用的网络视频资源， 先下载到本地再播放。


### setVideoMode

**说明**

设置 tep 动画的 alpha 和 rgb 区域的对齐方式。 

**接口**
``` dart
Future<void> setVideoMode(FVideoMode videoMode) async
```

**参数说明**

videoMode 支持以下格式：

| 枚举值                                         | 含义                      |
| ---------------------------------------------- | ------------------------- |
| FVideoMode.VIDEO_MODE_NONE                     | 普通mp4文件               |
| FVideoMode.EVIDEO_MODE_SPLIT_HORIZONTAL        | 左右对齐（alpha左\rgb右） |
| FVideoMode.VIDEO_MODE_SPLIT_VERTICAL           | 上下对齐（alpha上\rgb下） |
| FVideoMode.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE | 左右对齐（rgb左\alpha右） |
| FVideoMode.VIDEO_MODE_SPLIT_VERTICAL_REVERSE   | 上下对齐（rgb上\alpha下） |


### setConfig

**说明**

设置特效播放器参数，需要在启动播放前调用。

**接口**
``` dart
Future<void> setConfig(FTCEffectConfig config) async
```

**参数说明**

参考下面 FTCEffectConfig 类。

### setScaleType

**说明**

设置对齐方式。

**接口**
``` dart
Future<void> setScaleType(FScaleType type) async
```

**参数说明**

type 支持以下格式：

| 枚举值                 | 含义                                       |
| ---------------------- | ------------------------------------------ |
| FScaleType.FIT_XY      | 完整填充整个布局，默认值。                 |
| FScaleType.FIT_CENTER  | 按视频比例在布局中间完整显示。             |
| FScaleType.CENTER_CROP | 按视频比例完整填充布局（多余部分不显示）。 |


### setFetchResource

**说明**

设置融合动画的资源。

**接口**
``` dart
void setFetchResource(FResourceFetcher resFetcher)
```

**参数说明**

FResourceFetcher 接口：
``` dart
class FResourceFetcher {
  // 获取图片
  FResImgResultFetcher? imgFetcher;
  
  // 获取文字
  FResTextResultFetcher? textFetcher;

   // 资源释放通知
  FResReleaseListener? releaseListener;

  FResourceFetcher({this.imgFetcher, this.textFetcher, this.releaseListener});
}
```

FEffectResource#tag 为融合动画的 tag（下标），可以判断 tag 传入不同的文字或图片资源。

### requestUpdateResource

**说明**

播放过程中更新融合动画信息。

调用当前方法之后，会触发 IFetchResource 接口回调更新融合动画信息。

**接口**
``` dart
Future<void> requestUpdateResource() async
```

### setRenderRotation

**说明**

设置融合动画选择旋转角度，支持 0， 90，180, 270， 360 度。

**接口**
``` dart
Future<void> setRenderRotation(int rotation) async
```

### isPlaying

**说明**

返回特效播放器是否在播放中。

**接口**
``` dart
Future<bool> isPlaying() async
```

### resume

**说明**

恢复特效动画播放。

**接口**
``` dart
Future<void> resume() async
```

### pause

**说明**

暂停特效动画播放。

**接口**
``` dart
Future<void> pause() async
```

### seekTo

**说明**

跳转到指定位置开始播放。

**注意：**

- startPlay() 之后才可以调用该方法，否则不生效。
- 该接口对于 tcmp4 动画、或者设置了 FCodecType.TX_LITEAV_SDK 时播放的mp4动画生效。
- milliSec：要跳转到指定时长处开始播放，单位毫秒。


**接口**
``` dart
Future<void> seekTo(int millSec) async
```

### seekProgress

**说明**

跳转到指定位置开始播放。

progress：跳转到动画时长的指定百分比处开始播放，单位百分比，取值范围为：[0.0-1.0]。

**注意：**

1. startPlay() 之后才可以调用该方法，否则不生效。
2. 该接口对于 tcmp4 动画、或者设置了 FCodecType.TX_LITEAV_SDK 时播放的mp4动画生效。
3. 入参 progress 取值范围为 [0.0-1.0]，超出范围的不生效。


**接口**
``` dart
Future<void> seekProgress(double progress) async
```

### setLoop

**说明**

设置循环播放。
- true： 表示循环播放。

- false： 表示关闭循环播放。


   **接口**

   ``` dart
   Future<void> setLoop(bool isLoop) async
   ```

### setLoopCount

**说明**

设置循环播放次数。

loopCount：表示循环播放次数。当 loopCount <= 0 时，表示无限循环播放；当 loopCount=n(n>=1)时表示从开始播放到播放结束，共播放 n 次。

**注意：**

1. loopCount 默认值是1，即当外部不主动调用该方法时，动画只播放一次就结束。
2. setLoop(boolean isLoop) 方法内部会调用当前方法，即当 isLoop = true 时，等价于调用 setLoopCount(-1)；即当 isLoop = false 时，等价于调用 setLoopCount(1)；因此这两个方法是互相影响的，后调用的会覆盖之前的调用。


**接口**
``` dart
Future<void> setLoopCount(int loopCount) async
```

### setDuration

**说明**

设置动画需要多长时间播放完成。设置之后，后续动画播放时自动调整动画播放速度，以保证动画在设置的规定时长时播放结束。

即：设置的时长超过动画原时长，则动画慢放；小于动画原时长，则快进播放。

durationInMilliSec： 要设置的时长，单位毫秒。

**注意：**

1. 目前仅对 tcmp4 格式的动画生效。
2. 当前方法和 setRate 设置倍速的方法是互斥的，后调用的会覆盖掉先调用的。


**接口**
``` dart
Future<void> setDuration(int durationInMilliSec) async
```

### stopPlay

**说明**

停止播放。

**接口**
``` dart
Future<void> stopPlay({bool? clearLastFrame}) async
```

### setMute

**说明**

设置是否静音播放。
- true： 静音播放。

- false： 非静音播放。


   **接口**

   ``` dart
   Future<void> setMute(bool mute)
   ```

### setPlayListener

**说明**

设置特效播放器播放回调。

**接口**
``` dart
void setPlayListener(FAnimPlayListener? listener)
```

**参数说明**

IAnimPlayListener 接口：
``` dart
class FAnimPlayListener {
  FEmptyFunction? onPlayStart;

  FEmptyFunction? onPlayEnd;

  FIntParamsFunction? onPlayError;

  FOnPlayEventFunction? onPlayEvent;

  FAnimPlayListener({this.onPlayStart, this.onPlayEnd, this.onPlayError, this.onPlayEvent});
}
```

对于 onPlayEvent 方法中的 event 值详见 FTCEffectPlayerConstant 类中的常量值:
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

对于 onPlayError 方法中的 errorCode 值详见 FTCEffectPlayerConstant 类中的常量值：
``` dart
static const  REPORT_ERROR_TYPE_HEVC_NOT_SUPPORT = -10007; // 不支持h265
static const  REPORT_ERROR_TYPE_INVALID_PARAM = -10008; // 参数非法
static const  REPORT_ERROR_TYPE_INVALID_LICENSE = -10009; // License 不合法
static const  REPORT_ERROR_TYPE_ADVANCE_MEDIA_PLAYER = -10010; // MediaPlayer播放失败
static const  REPORT_ERROR_TYPE_MC_DECODER = -10011; // MediaCodec 中 Decoder 失败
static const  REPORT_ERROR_TYPE_UNKNOWN_ERROR = -20000; // 未知错误
```

### getTCAnimInfo

**说明**

获取当前播放动画对应的信息，返回 FTCEffectAnimInfo 实例，详见 FTCEffectAnimInfo。

**注意：**

该方法必须在 FAnimPlayListener#onPlayStart() 方法中，或者该方法执行之后调用才可以获取到当前动画的信息，否则返回 null。

**接口**

``` dart
Future<FTCEffectAnimInfo> getTCAnimInfo() async
```

## FTCEffectConfig

**说明**

构造特效播放器配置。

**codecType 属性** 

``` dart
// 设置 CodecType
FCodecType? codecType;
```

**参数说明**

它有三个取值，分别是：
- FCodecType.TC_MPLAYER (MPLAYER 播放引擎， 仅在 Android 平台生效)
- FCodecType.TC_MCODEC(MCODEC 播放引擎，仅在 Android 平台生效) 
- FCodecType.TX_LITEAV_SDK (腾讯云播放器 SDK，在 Andriod 和 iOS 平台生效)


**注意：**

1. 目前仅支持在播放器开始前调用 setConfig() 方法来设置播放配置，开始播放后不支持修改配置。
1. 目前支持的三种 CodecType 仅对 TEP 动画生效。
1. 如果设置 CodecType 为 FCodecType.TX_LITEAV_SDK ，则还需要单独引入腾讯云播放器 SDK，以及申请、注册好其对应的license。 

**freezeFrame 属性** 

   ``` dart
   // 设置冻结停留帧索引
   FFreezeFrame? freezeFrame;
   ```

   **参数说明**


   入参 frame 表示当动画播放中需要停留在哪一帧。目前可选值：

- FFreezeFrame.FREEZE_FRAME_NONE：关闭 freezeFrame 能力，播放器正常播放暂停消失。
- FFreezeFrame.FREEZE_FRAME_LAST：当第一次播放完毕之后，画面停留在最后一帧。

**animType 属性** 

``` dart
// 设置后续要播放的动画格式
FAnimType? animType;
```

**参数说明**


   用于指定后续要播放的动画格式，适用于某些情况下，要播放的动画文件后缀被修改的场景。入参 type 表示要指定的动画格式。目前可选值：

- FAnimType.AUTO  (SDK 默认策略，即以动画文件的后缀来判断动画格式，比如 tcmp4/mp4/tep/tepg 等格式。)

- FAnimType.MP4  (MP4动画格式，后续都将动画文件当做MP4类型来播放，无视文件后缀名。)

- FAnimType.TCMP4 (TCMP4动画格式，后续都将动画文件当做TCMP4类型来播放，无视文件后缀名。)


## FTCEffectAnimInfo

**说明**

存储当前播放的动画信息。

**属性说明**

| 属性名       | 类型     | 描述                                                         |
| ------------ | -------- | ------------------------------------------------------------ |
| type         | int      | 当前动画类型，取值：FAnimType.MP4  MP4类型的资源和 FAnimType.TCMP4 TCMP4类型的资源。 |
| duration     | long     | 动画时长，单位毫秒。                                         |
| width        | int      | 动画宽度。                                                   |
| height       | int      | 动画高度。                                                   |
| encryptLevel | int      | 当前动画的高级加密类型，取值如果是 0，表示没有高级加密，否则表示已是高级加密。 |
| mixInfo      | FMixInfo | 融合动画信息，为 null 时则表示该动画无融合信息。             |


## FMixInfo

**说明**

存储当前播放动画中的融合信息。

**属性说明**
| 属性名           | 类型           | 描述                                           |
| ---------------- | -------------- | ---------------------------------------------- |
| textMixItemList  | List<FMixItem> | 文字融合信息，为 null 时则表示无文字融合信息。 |
| imageMixItemList | List<FMixItem> | 图片融合信息，为 null 时则表示无图片融合信息。 |


## FMixItem

**说明**

存储当前播放动画中的融合信息。

**属性说明**

| 属性名 | 类型   | 描述                                                         |
| ------ | ------ | ------------------------------------------------------------ |
| id     | String | 当前融合动画 id。                                            |
| tag    | String | 当前融合动画 tag。                                           |
| text   | String | 当前文字融合动画文字内容(图片融合动画时该值为空)。如果是 tcmp4 时，则是其内部原始的文字内容；如果是 mp4 时，则是在工具中填写的 tag 值。 |


## FTCEffectText

**说明**

融合动画替换文本样式数据类。

**属性说明**

| 属性名    | 类型   | 描述                                                         |
| --------- | ------ | ------------------------------------------------------------ |
| text      | String | 最终要替换显示的文本内容。                                   |
| color     | int    | 文字颜色，格式要求：ARGB，如 0xFFFFFFFF。                    |
| fontStyle | String | 文字显示样式，可取值："bold"表示粗体，不传则默认大小。       |
| alignment | int    | 文字对齐方式，可取值：TEXT_ALIGNMENT_NONE（默认值，即保持 SDK 默认对齐方式）、TEXT_ALIGNMENT_LEFT（居左） 、TEXT_ALIGNMENT_CENTER（居中）、 TEXT_ALIGNMENT_RIGHT（居右）。 |
| fontSize  | double | 文字大小，单位是px；如果设置了文字大小(值大于0)，则内部自动缩放策略失效，强制以设置的文字大小为准，则可能出现文字过大显示不全的问题。 |
