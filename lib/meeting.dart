import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class TestMeeting {
  static startMeeting() async {
    String? serverUrl;
    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isWelcomePageEnabled: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlag.isCallIntegrationEnabled] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlag.isPipEnabled] = false;
      }
    }
    var options = JitsiMeetingOptions(
      roomNameOrUrl:
          "Meeting Room 5", //  This is meeting room number, it;s a very important one!
      serverUrl: serverUrl,
      subject: "Test Group Meeting",
      // token: tokenText.text,
      isAudioMuted: true,
      isAudioOnly: false,
      isVideoMuted: true,
      userDisplayName: "test User",
      userEmail: "test@gmail.com",
      featureFlags: featureFlags,
    );

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint(
                "${options.roomNameOrUrl} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint(
                "${options.roomNameOrUrl} joined with message: $message");
          },
          onConferenceTerminated: (message, obj) {
            debugPrint(
                "${options.roomNameOrUrl} terminated with message: $message");
          },

          // genericListeners: [
          //   JitsiGenericListener(
          //       eventName: 'readyToClose',
          //       callback: (dynamic message) {
          //         debugPrint("readyToClose callback");
          //       }),
          // ]),
        ));
  }
}
