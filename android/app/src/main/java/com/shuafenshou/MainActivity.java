package com.shuafenshou;

import android.os.Bundle; // here
import com.facebook.react.ReactActivity;

import com.facebook.react.ReactActivityDelegate;
import com.facebook.react.ReactRootView;
import com.swmansion.gesturehandler.react.RNGestureHandlerEnabledRootView;

import org.devio.rn.splashscreen.SplashScreen; // here

import com.umeng.analytics.MobclickAgent;
import com.umeng.analytics.MobclickAgent.EScenarioType;

public class MainActivity extends ReactActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
      SplashScreen.show(this);  // here
      MobclickAgent.setSessionContinueMillis(1000);
      MobclickAgent.setScenarioType(this, EScenarioType.E_DUM_NORMAL);
      super.onCreate(savedInstanceState);
  }

  @Override
  protected ReactActivityDelegate createReactActivityDelegate() {
    return new ReactActivityDelegate(this, getMainComponentName()) {
      @Override
      protected ReactRootView createRootView() {
       return new RNGestureHandlerEnabledRootView(MainActivity.this);
      }
    };
  }

  /**
   * Returns the name of the main component registered from JavaScript.
   * This is used to schedule rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
      return "shuafenshou";
  }
  @Override
      public void onResume() {
          super.onResume();
          MobclickAgent.onResume(this);
      }
  @Override
  protected void onPause() {
      super.onPause();
      MobclickAgent.onPause(this);
  }
}
