package com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.ui.view;

import android.graphics.Bitmap;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.messages.TCEffectMessages;
import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools.FEffectViewHelper;
import com.tcmedia.tcmediax.tceffectplayer.tceffectplayer_flutter.tools.ThreadHelper;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectAnimView;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectConfig;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectPlayerConstant;
import com.tencent.tcmediax.tceffectplayer.api.data.TCEffectText;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResource;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResourceImgResult;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResourceTxtResult;
import com.tencent.tcmediax.tceffectplayer.api.mix.Resource;
import com.tencent.tcmediax.tceffectplayer.api.plugin.OnResourceClickListener;
import com.tencent.tcmediax.utils.Log;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.CountDownLatch;

import io.flutter.plugin.common.BinaryMessenger;

public class FTCEffectAnimController implements TCEffectMessages.FTCEffectAnimViewApi {

    private static final String TAG = "FTCEffectAnimController";

    private final int mViewId;
    private final TCEffectMessages.FTCEffectAnimViewFlutterEvent mEffectViewEvent;
    private final TCEffectAnimView mEffectView;

    public FTCEffectAnimController(int viewId, BinaryMessenger messenger, TCEffectAnimView effectView) {
        mViewId = viewId;
        mEffectViewEvent = new TCEffectMessages.FTCEffectAnimViewFlutterEvent(messenger, String.valueOf(viewId));
        mEffectView = effectView;
        TCEffectMessages.FTCEffectAnimViewApi.setUp(messenger, String.valueOf(viewId), this);
        mEffectView.setFetchResource(new FEffectFetchResourceImpl(mEffectViewEvent));
        mEffectView.setOnResourceClickListener(new FEffectResourceClickListenerImpl(mEffectViewEvent));
        mEffectView.setPlayListener(new FEffectAnimPlayListenerImpl(mEffectViewEvent));
    }

    public int getViewId() {
        return mViewId;
    }

    @NonNull
    @Override
    public Long startPlay(@NonNull String playUrl) {
        int ret = mEffectView.startPlay(playUrl);
        return (long) ret;
    }

    @Override
    public void setVideoMode(@NonNull Long videoModeValue) {
        TCEffectPlayerConstant.VideoMode type = FEffectViewHelper.findVideoModeByValue(videoModeValue);
        if (null != type) {
            mEffectView.setVideoMode(type);
        } else {
            innerLogE("setVideoMode failed, video mode not found:" + videoModeValue);
        }
    }

    @Override
    public void setConfig(@NonNull TCEffectMessages.FTCEffectConfigMsg config) {
        TCEffectConfig effectConfig = FEffectViewHelper.transConfigFromMsg(config);
        mEffectView.setConfig(effectConfig);
    }

    @Override
    public void setScaleType(@NonNull Long scaleTypeValue) {
        TCEffectPlayerConstant.ScaleType type = FEffectViewHelper.findScaleTypeByValue(scaleTypeValue);
        if (null != type) {
            mEffectView.setScaleType(type);
        } else {
            innerLogE("setScaleType failed, scale type not found:" + scaleTypeValue);
        }
    }

    @Override
    public void requestUpdateResource() {
        new Thread(){
            @Override
            public void run() {
                super.run();
                mEffectView.requestUpdateResource();
            }
        }.start();
    }

    @Override
    public void setRenderRotation(@NonNull Long rotation) {
        mEffectView.setRenderRotation(rotation.intValue());
    }

    @NonNull
    @Override
    public Boolean isPlaying() {
        return mEffectView.isPlaying();
    }

    @Override
    public void resume() {
        mEffectView.resume();
    }

    @Override
    public void pause() {
        mEffectView.pause();
    }

    @Override
    public void seekTo(@NonNull Long milliSec) {
        mEffectView.seekTo(milliSec);
    }

    @Override
    public void seekProgress(@NonNull Double progress) {
        mEffectView.seekProgress(progress.floatValue());
    }

    @Override
    public void setLoop(@NonNull Boolean isLoop) {
        mEffectView.setLoop(isLoop);
    }

    @Override
    public void setLoopCount(@NonNull Long loopCount) {
        mEffectView.setLoopCount(loopCount.intValue());
    }

    @Override
    public void setDuration(@NonNull Long durationInMilliSec) {
        mEffectView.setDuration(durationInMilliSec);
    }

    @Override
    public void stopPlay(@NonNull Boolean clearLastFrame) {
        mEffectView.stopPlay(clearLastFrame);
    }

    @Override
    public void setMute(@NonNull Boolean mute) {
        mEffectView.setMute(mute);
    }

    @NonNull
    @Override
    public TCEffectMessages.FTCEffectAnimInfoMsg getTCAnimInfo() {
        return FEffectViewHelper.transAnimInfoToMsg(mEffectView.getTCAnimInfo());
    }

    @Override
    public void onDestroy() {
        mEffectView.onDestroy();
    }

    @Override
    public void setRate(@NonNull Double rate) {
        mEffectView.getTCEffectPlayer().setRate(rate.floatValue());
    }

    @NonNull
    @Override
    public TCEffectMessages.FTCEffectAnimInfoMsg preloadTCAnimInfo(@NonNull String playUrl, @NonNull TCEffectMessages.FTCEffectConfigMsg config) {
        TCEffectConfig effectConfig = FEffectViewHelper.transConfigFromMsg(config);
        return FEffectViewHelper.transAnimInfoToMsg(TCEffectAnimView.preloadTCAnimInfo(playUrl, effectConfig));
    }

    @NonNull
    @Override
    public String getSdkVersion() {
        return TCEffectAnimView.getSdkVersion();
    }

    public TCEffectAnimView getEffectView() {
        return mEffectView;
    }

    private void innerLogE(String msg) {
        Log.e(TAG, msg + ",viewId:" + mViewId);
    }

    private static class FEffectFetchResourceImpl implements IFetchResource {
        private final TCEffectMessages.FTCEffectAnimViewFlutterEvent mEffectViewEvent;
        final Object[] finalResult = {null};

        public FEffectFetchResourceImpl(TCEffectMessages.FTCEffectAnimViewFlutterEvent effectViewEvent) {
            this.mEffectViewEvent = effectViewEvent;
        }

        @Override
        public void fetchImage(Resource resource, IFetchResourceImgResult fetchImgResult) {
            CountDownLatch countDownLatch = new CountDownLatch(1);
            ThreadHelper.runMain(() -> {
                TCEffectMessages.FResourceMsg resourceMsg = FEffectViewHelper.transResourceToMsg(resource);
                mEffectViewEvent.fetchImage(resourceMsg, new TCEffectMessages.NullableResult<>() {
                    @Override
                    public void success(@Nullable byte[] result) {
                        finalResult[0] = FEffectViewHelper.transByteArrToBitmap(result);
                        countDownLatch.countDown();
                    }

                    @Override
                    public void error(@NonNull Throwable error) {
                        finalResult[0] = null;
                        countDownLatch.countDown();
                    }
                });
            });
            try {
                countDownLatch.await();
            } catch (Throwable t) {
                t.printStackTrace();
            }
            fetchImgResult.fetch((finalResult[0] instanceof Bitmap) ? (Bitmap) finalResult[0] : null);
            finalResult[0] = null;
        }

        @Override
        public void fetchText(Resource resource, IFetchResourceTxtResult fetchTxtResult) {
            CountDownLatch countDownLatch = new CountDownLatch(1);
            ThreadHelper.runMain(() -> {
                TCEffectMessages.FResourceMsg resourceMsg = FEffectViewHelper.transResourceToMsg(resource);
                mEffectViewEvent.fetchText(resourceMsg, new TCEffectMessages.NullableResult<>() {
                    @Override
                    public void success(@Nullable TCEffectMessages.FTCEffectTextMsg result) {
                        if (result == null) {
                            finalResult[0] = null;
                        } else {
                            TCEffectText tcEffectText = new TCEffectText();
                            tcEffectText.text = result.getText();
                            tcEffectText.fontStyle = result.getFontStyle();
                            tcEffectText.color = result.getColor() == null ? 0 : result.getColor().intValue();
                            tcEffectText.alignment = result.getAlignment() == null ? TCEffectText.TEXT_ALIGNMENT_NONE : result.getAlignment().intValue();
                            tcEffectText.fontSize = result.getFontSize() == null ? 0 : result.getFontSize().floatValue();
                            finalResult[0] = tcEffectText;
                        }
                        countDownLatch.countDown();
                    }

                    @Override
                    public void error(@NonNull Throwable error) {
                        finalResult[0] = null;
                        countDownLatch.countDown();
                    }
                });
            });
            try {
                countDownLatch.await();
            } catch (Throwable t) {
                t.printStackTrace();
            }
            fetchTxtResult.loadTextForPlayer((finalResult[0] instanceof TCEffectText) ? (TCEffectText) finalResult[0] : null);
            finalResult[0] = null;
        }

        @Override
        public void releaseResource(List<Resource> list) {

        }
    }

    private static class FEffectResourceClickListenerImpl implements OnResourceClickListener {

        private final TCEffectMessages.FTCEffectAnimViewFlutterEvent mEffectViewEvent;

        public FEffectResourceClickListenerImpl(TCEffectMessages.FTCEffectAnimViewFlutterEvent effectViewEvent) {
            this.mEffectViewEvent = effectViewEvent;
        }

        @Override
        public void onClick(Resource resource) {
            TCEffectMessages.FResourceMsg resourceMsg = FEffectViewHelper.transResourceToMsg(resource);
            ThreadHelper.runMain(() -> mEffectViewEvent.onResClick(resourceMsg, new TCEffectMessages.VoidResult() {
                @Override
                public void success() {
                }

                @Override
                public void error(@NonNull Throwable error) {
                }
            }));
        }
    }

    private static class FEffectAnimPlayListenerImpl implements TCEffectAnimView.IAnimPlayListener {

        private final TCEffectMessages.FTCEffectAnimViewFlutterEvent mEffectViewEvent;

        public FEffectAnimPlayListenerImpl(TCEffectMessages.FTCEffectAnimViewFlutterEvent effectViewEvent) {
            this.mEffectViewEvent = effectViewEvent;
        }


        @Override
        public void onPlayStart() {
            ThreadHelper.runMain(() -> mEffectViewEvent.onPlayStart(new TCEffectMessages.VoidResult() {
                @Override
                public void success() {
                }

                @Override
                public void error(@NonNull Throwable error) {
                }
            }));
        }

        @Override
        public void onPlayEnd() {
            ThreadHelper.runMain(() -> mEffectViewEvent.onPlayEnd(new TCEffectMessages.VoidResult() {
                @Override
                public void success() {
                }

                @Override
                public void error(@NonNull Throwable error) {
                }
            }));
        }

        @Override
        public void onPlayError(int i) {
            ThreadHelper.runMain(() -> mEffectViewEvent.onPlayError((long) i, new TCEffectMessages.VoidResult() {
                        @Override
                        public void success() {
                        }

                        @Override
                        public void error(@NonNull Throwable error) {
                        }
                    })
            );
        }

        @Override
        public void onPlayEvent(int event, Bundle bundle) {
            ThreadHelper.runMain(() -> mEffectViewEvent.onPlayEvent((long) event, FEffectViewHelper.getParams(bundle), new TCEffectMessages.VoidResult() {
                        @Override
                        public void success() {

                        }

                        @Override
                        public void error(@NonNull Throwable error) {

                        }
                    })
            );
        }
    }
}
