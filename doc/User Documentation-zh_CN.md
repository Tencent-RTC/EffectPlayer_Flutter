本文将详细介绍如何在项目中快速地使用腾讯礼物动画特效 Flutter SDK。只需遵循以下步骤，即可完成 SDK 的配置和使用。

## 初始化注册 License

在正式使用腾讯礼物动画特效 SDK 时，需要先设置 License，设置 License 成功之后，才可以进行后续的 SDK 使用。

设置 License 方式如下：
``` java
import 'package:flutter_effect_player/ftceffect_player.dart';

const LICENSE_URL = "${licenseUrl}";
const LICENSE_KEY = "${licenseKey}";

FTCMediaXBase.instance.setLicense(LICENSE_URL, LICENSE_KEY, (code, msg) {
  print("TCMediaX license result: errCode:${code}, msg:${msg}");
});
```

> **注意：**
>
> - License 是强线上检验逻辑，应用首次启动后调用 FTCMediaXBase.instance.setLicense 时，需确保网络可用。 在 App 首次启动时，可能还没有授权联网权限，则需要等授予联网权限后，再次调用该方法。
> - 监听 FTCMediaXBase.instance.setLicense 加载回调结果，如果失败要根据实际情况做对应重试及引导，如果多次失败后，可以限频，并业务辅以产品弹窗等引导，让用户检查网络情况。


**鉴权 errorCode 说明：**
<table>
<tr>
<td rowspan="1" colSpan="1" >错误码</td>

<td rowspan="1" colSpan="1" >描述</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >0</td>

<td rowspan="1" colSpan="1" >成功。Success。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-1</td>

<td rowspan="1" colSpan="1" >输入参数无效，例如 URL 或 KEY 为空。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-3</td>

<td rowspan="1" colSpan="1" >下载环节失败，请检查网络设置。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-4</td>

<td rowspan="1" colSpan="1" >从本地读取的 TE 授权信息为空，可能是 IO 失败引起。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-5</td>

<td rowspan="1" colSpan="1" >读取 VCUBE TEMP License文件内容为空，可能是 IO 失败引起。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-6</td>

<td rowspan="1" colSpan="1" >v_cube.license 文件 JSON 字段不对。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-7</td>

<td rowspan="1" colSpan="1" >签名校验失败。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-8</td>

<td rowspan="1" colSpan="1" >解密失败。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-9</td>

<td rowspan="1" colSpan="1" >TELicense 字段里的 JSON 字段不对。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10</td>

<td rowspan="1" colSpan="1" >从网络解析的 TE 授权信息为空。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-11</td>

<td rowspan="1" colSpan="1" >把 TE 授权信息写到本地文件时失败，可能是 IO 失败引起。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-12</td>

<td rowspan="1" colSpan="1" >下载失败，解析本地 asset 也失败。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-13</td>

<td rowspan="1" colSpan="1" >鉴权失败，请检查so是否在包里，或者已正确设置 so 路径。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >3004/3005</td>

<td rowspan="1" colSpan="1" >无效授权。请联系腾讯云团队处理。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >3015</td>

<td rowspan="1" colSpan="1" >Bundle Id / Package Name 不匹配。检查您的 App 使用的 Bundle Id / Package Name 和申请的是否一致，检查是否使用了正确的授权文件。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >3018</td>

<td rowspan="1" colSpan="1" >授权文件已过期，需要向腾讯云申请续期。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >其他</td>

<td rowspan="1" colSpan="1" >请联系腾讯云团队处理。</td>
</tr>
</table>


## 日志管理

腾讯礼物动画特效 SDK 默认支持保存运行日志，如果测试过程中出现问题，可以提取日志反馈给腾讯云客服，您可以根据业务需要把此目录的日志上传到业务后台，用于定位线上用户问题。

1. Android 端的日志保存在目录：`/sdcard/Android/data/${your_packagename}/files/TCMediaLog`，日志文件按照日期命名，把 TCMediaLog 文件夹导出即可：

![](https://write-document-release-1258344699.cos.ap-guangzhou.tencentcos.cn/100034408908/1a1e4d0e095511f0990f52540099c741.png)

2. iOS 端保存在沙箱 Documents/TCMedialog 文件夹，日志文件按照日期命名。详细日志导出教程 [参考这里](https://cloud.tencent.com/document/product/616/116481#59b6468e-c7a0-48da-9b96-94c85e49e48c)

> **注意：**
>

> **没有日志文件？**
>

> 请检查是否通过 FTCMediaXBase.instance.setLogEnable 传入 false 关闭了日志，默认文件日志是开启的。
>


## 播放器使用

### 引入 FTCEffectAnimView 
``` dart
Widget _getFTCEffectAnimView() {
  return FTCEffectAnimView(
      controllerCallback: (controller){
        // controller.setLoop(true);
        // controller.startPlay("xxxxxxx");
      }
  );
}
```

### 播放监听

可以在开始播放之前通过调用`setPlayListener`方法来设置动画播放状态监听：
``` dart
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
1. 如果您需要获取当前正在播放的动画信息，可以在`onPlayStart()`方法中(或者该方法执行之后)调用`getTCAnimInfo()`方法来获取到`FTCEffectAnimInfo`对象实例，进而获取到当前播放动画的类型、时长、宽高、融合动画等信息。



### 播放配置
``` dart
// 设置播放配置，非必需的步骤
final FTCEffectConfig _curConfig = FTCEffectConfig()..codecType = FCodecType.TC_MPLAYER;
controller?.setConfig(_curConfig);
```

FTCEffectConfig 中目前支持：
1. FCodecType codecType ：它有三个取值，分别是：
- FCodecType.TC_MPLAYER (MPLAYER 播放引擎)
- FCodecType.TC_MCODEC(MCODEC 播放引擎)
- FCodecType.TX_LITEAV_SDK (腾讯云播放器 SDK)

>     注意：
>     1. 目前仅支持在播放器开始前调用 setConfig() 方法来设置播放配置，开始播放后不支持修改配置。
>     2. 目前如上设置仅对 MP4 动画生效。
>     3. 如果设置为 FCodecType.TX_LITEAV_SDK ，则还需要单独引入腾讯云播放器 SDK，以及申请、注册好其对应的 License。 
>     4. 如果不设置 config，则会默认使用 CodecType = FCodecType.TC_MPLAYER。

2. FFreezeFrame freezeFrame：用于设置播放动画冻结帧，详细解释见 API 文档。

3. FAnimType animType：用于指定后续要播放的动画格式，适用于某些情况下，要播放的动画文件后缀被修改的场景。可取值如下：

> - FAnimType.AUTO（SDK 默认策略，即以动画文件的后缀来判断动画格式，例如 tcmp4/mp4/tep/tepg 等格式）。
> - FAnimType.MP4（MP4 动画格式，后续都将动画文件当做 MP4 类型来播放，无视文件后缀名）
> - FAnimType.TCMP4（TCMP4 动画格式，后续都将动画文件当做 TCMP4 类型来播放，无视文件后缀名）。


### 融合动画配置

实现 mp4 或者 tcmp4 融合动画的播放，需要实现 FResourceFetcher。
1. 如果是图片类型的融合动画，需要实现 FResImgResultFetcher ，来返回对应图片的 Uint8List 来替换对应的元素；

2. 如果是文字类型的融合动画，需要实现 FResTextResultFetcher ，来返回对应的 FTCEffectText 对象实例，来指定文字的显示配置信息。

   ``` dart
   controller?.setFetchResource(FResourceFetcher(textFetcher: (res) {
      // 返回 FTCEffectText 实例，内部可以指定文字内容、颜色等
      return FTCEffectText()
        ..text = "FTCEffect${res.id}"
        ..color = 0xff0000ff;
    }, imgFetcher: (res) {
      // 需要提前准备好要替换的图片数据，这里直接返回即可。
      // final data = await rootBundle.load('asset/image/head1.png');
      // _samplePng = data.buffer.asUint8List();
      return _samplePng;
    }));
   ```

### 播放控制

#### 开始播放

支持播放 .mp4、.tcmp4 文件格式资源。

> **注意：**
>
> 1. 只支持播放本地视频资源，如果您使用的网络视频资源， 先下载到本地再播放。
> 2. 动画资源可以通过 [特效转换工具](https://write.woa.com/document/172562058121748480) 来生成，除此之外也支持 VAP 格式动画资源播放。

``` dart
controller?.startPlay("xxxx")
```

#### 暂停播放
``` dart
controller?.pause()
```

#### 继续播放
``` dart
controller?.resume()
```

#### 循环播放
``` dart
controller?.setLoop(true)
```

#### 静音播放
``` dart
controller?.setMute(true)
```

#### 停止播放

当不需要继续使用播放器时，需要停止播放，释放占用的资源。
``` dart
controller?.stopPlay()
```

## 常见问题

### 在播放过程中出现下面的日志信息，如何处理？
``` plaintext
License checked failed! tceffect player license required!
```

请检查是否申请特效播放器 License，并进行了初始化注册。


## 常见错误码
<table>
<tr>
<td rowspan="1" colSpan="1" >错误码</td>

<td rowspan="1" colSpan="1" >描述</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10003</td>

<td rowspan="1" colSpan="1" >创建线程失败。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10004</td>

<td rowspan="1" colSpan="1" >render 创建失败。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10005</td>

<td rowspan="1" colSpan="1" >配置解析失败。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10006</td>

<td rowspan="1" colSpan="1" >文件无法读取。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10007</td>

<td rowspan="1" colSpan="1" >动画视频编码格式是 H.265，在当前设备上不支持。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10008</td>

<td rowspan="1" colSpan="1" >参数非法。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10009</td>

<td rowspan="1" colSpan="1" >license 不合法。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10010</td>

<td rowspan="1" colSpan="1" >MediaPlayer 播放失败。</td>
</tr>

<tr>
<td rowspan="1" colSpan="1" >-10012</td>

<td rowspan="1" colSpan="1" >缺少必备的依赖，比如播放类型为 TX_LITEAV_SDK 时没有引入 liteavSDK。</td>
</tr>
</table>


