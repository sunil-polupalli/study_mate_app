import 'package:study_mate_app/screens/utils/permission.dart';
import 'package:flutter/material.dart';
import 'package:study_mate_app/theme/app_theme.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:study_mate_app/screens/key_center.dart';

class CallScreen extends StatefulWidget {
  final String roomID;
  final String localUserID;
  final String localUserName;

  const CallScreen({
    super.key,
    required this.roomID,
    required this.localUserID,
    required this.localUserName,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // Zego SDK state variables
  Widget? localView;
  int? localViewID;
  Widget? remoteView;
  int? remoteViewID;
  Widget? screenSharingView;
  int? screenSharingViewID;
  String? localScreenSharingStreamID;

  // UI control state variables
  bool _isCameraOn = true;
  bool _isMicOn = true;
  bool _isFrontCamera = true;
  bool _isScreenSharing = false;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    requestPermission().then((granted) {
      if (granted) {
        setState(() {
          _permissionsGranted = true;
        });
        createEngine().then((_) {
          startListenEvent();
          loginRoom();
        });
      }
    });
  }

  @override
  void dispose() {
    stopListenEvent();
    logoutRoom();
    super.dispose();
  }

  Future<void> createEngine() async {
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(appID, ZegoScenario.Default, appSign: appSign),
    );
  }

  void startListenEvent() {
    ZegoExpressEngine.onRoomStreamUpdate =
        (roomID, updateType, List<ZegoStream> streamList, extendedData) {
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          if (stream.streamID.endsWith('_screen')) {
            startPlayScreenShareStream(stream.streamID);
          } else {
            startPlayStream(stream.streamID);
          }
        }
      } else {
        for (final stream in streamList) {
          if (stream.streamID.endsWith('_screen')) {
            stopPlayScreenShareStream(stream.streamID);
          } else {
            stopPlayStream(stream.streamID);
          }
        }
      }
    };
  }

  void stopListenEvent() {
    ZegoExpressEngine.onRoomStreamUpdate = null;
  }

  Future<void> loginRoom() async {
    final user = ZegoUser(widget.localUserID, widget.localUserName);
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
      ..isUserStatusNotify = true;

    ZegoExpressEngine.instance
        .loginRoom(widget.roomID, user, config: roomConfig)
        .then((ZegoRoomLoginResult result) {
      if (result.errorCode == 0) {
        startPreview();
        startPublish();
      } else {
        debugPrint('Login failed: ${result.errorCode}');
      }
    });
  }

  Future<void> logoutRoom() async {
    stopPreview();
    stopPublish();
    if (_isScreenSharing) {
      await ZegoExpressEngine.instance
          .stopPublishingStream(channel: ZegoPublishChannel.Aux);
      await ZegoExpressEngine.instance.stopScreenCapture();
      // Revert the video source setting on logout as well
      await ZegoExpressEngine.instance.setVideoSource(
        ZegoVideoSourceType.None,
        channel: ZegoPublishChannel.Aux,
      );
    }
    await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
    await ZegoExpressEngine.destroyEngine();
  }

  Future<void> startPreview() async {
    if (!_isCameraOn) return;
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      localViewID = viewID;
      ZegoCanvas previewCanvas =
          ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
    }).then((canvasViewWidget) => setState(() => localView = canvasViewWidget));
  }

  Future<void> stopPreview() async {
    ZegoExpressEngine.instance.stopPreview();
    if (localViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
      if (mounted) {
        setState(() {
          localView = null;
          localViewID = null;
        });
      }
    }
  }

  Future<void> startPublish() async {
    String streamID = '${widget.roomID}_${widget.localUserID}_call';
    ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  Future<void> stopPublish() async {
    ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<void> startPlayStream(String streamID) async {
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      remoteViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    }).then(
        (canvasViewWidget) => setState(() => remoteView = canvasViewWidget));
  }

  Future<void> stopPlayStream(String streamID) async {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
      if (mounted) {
        setState(() {
          remoteView = null;
          remoteViewID = null;
        });
      }
    }
  }

  Future<void> startPlayScreenShareStream(String streamID) async {
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      screenSharingViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFit);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    }).then((canvasViewWidget) =>
        setState(() => screenSharingView = canvasViewWidget));
  }

  Future<void> stopPlayScreenShareStream(String streamID) async {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (screenSharingViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(screenSharingViewID!);
      if (mounted) {
        setState(() {
          screenSharingView = null;
          screenSharingViewID = null;
        });
      }
    }
  }

  void toggleMic() {
    setState(() => _isMicOn = !_isMicOn);
    ZegoExpressEngine.instance.muteMicrophone(!_isMicOn);
  }

  void toggleCamera() {
    setState(() => _isCameraOn = !_isCameraOn);
    ZegoExpressEngine.instance.enableCamera(_isCameraOn);
    if (_isCameraOn) {
      startPreview();
    } else {
      stopPreview();
    }
  }

  void switchCamera() {
    setState(() => _isFrontCamera = !_isFrontCamera);
    ZegoExpressEngine.instance.useFrontCamera(_isFrontCamera);
  }

  void toggleScreenSharing() async {
    setState(() => _isScreenSharing = !_isScreenSharing);
    if (_isScreenSharing) {
      localScreenSharingStreamID =
          '${widget.roomID}_${widget.localUserID}_screen';
      await ZegoExpressEngine.instance.setVideoSource(
        ZegoVideoSourceType.ScreenCapture,
        channel: ZegoPublishChannel.Aux,
      );
      await ZegoExpressEngine.instance.startScreenCapture();
      await ZegoExpressEngine.instance.startPublishingStream(
        localScreenSharingStreamID!,
        channel: ZegoPublishChannel.Aux,
      );
    } else {
      await ZegoExpressEngine.instance
          .stopPublishingStream(channel: ZegoPublishChannel.Aux);
      await ZegoExpressEngine.instance.stopScreenCapture();
      await ZegoExpressEngine.instance.setVideoSource(
        ZegoVideoSourceType.None,
        channel: ZegoPublishChannel.Aux,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            AppTheme.backgroundGradient, // Using your app's theme background
        child: _permissionsGranted
            ? Stack(
                children: [
                  // Main video view (fills the background)
                  _buildMainView(),

                  // Remote camera view (picture-in-picture style)
                  Positioned(
                    top: 100,
                    right: 20,
                    child: SizedBox(
                      width: 110,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Rounded corners like your cards
                        child: remoteView ??
                            Container(
                                color:
                                    AppTheme.surfaceVariant.withOpacity(0.5)),
                      ),
                    ),
                  ),

                  // Local camera view (shown only during screen sharing)
                  if (_isScreenSharing)
                    Positioned(
                      top: 100,
                      left: 20,
                      child: SizedBox(
                        width: 110,
                        height: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: localView ?? Container(color: Colors.black54),
                        ),
                      ),
                    ),

                  // Bottom control panel
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: buildControlPanel(),
                  ),

                  // Top-left back button
                  Positioned(
                    top: 50,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text(
                  'Camera and microphone permissions are required to join the call.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.primaryTextColor),
                ),
              ),
      ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildMainView() {
    if (screenSharingView != null) {
      return screenSharingView!;
    } else if (localView != null) {
      return localView!;
    } else {
      // Show a placeholder if the camera is off
      return Container(
        color: AppTheme.surfaceColor,
        child: const Center(
          child: Text(
            'Camera is off',
            style: TextStyle(color: AppTheme.primaryTextColor),
          ),
        ),
      );
    }
  }

  Widget buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          onPressed: toggleMic,
          icon: _isMicOn ? Icons.mic : Icons.mic_off,
          color: AppTheme.accentColor,
        ),
        _buildControlButton(
          onPressed: toggleCamera,
          icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
          color: AppTheme.secondaryColor,
        ),
        _buildControlButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.call_end,
          color: Colors.redAccent,
          isEndCall: true,
        ),
        _buildControlButton(
          onPressed: switchCamera,
          icon: Icons.switch_camera,
          color: AppTheme.primaryColor,
        ),
        _buildControlButton(
          onPressed: toggleScreenSharing,
          icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
          color: AppTheme.successColor,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    bool isEndCall = false,
  }) {
    // Styled circular button matching your app's theme
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(isEndCall ? 10 : 15),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      child: Icon(icon, size: isEndCall ? 40 : 24),
    );
  }
}

extension on ZegoExpressEngine {
  Future<void> startScreenCapture() async {}

  Future<void> stopScreenCapture() async {}
}
// lib/screens/call_screen.dart

// import 'package:flutter/material.dart';
// import 'package:study_mate_app/theme/app_theme.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
// //import '../key_center.dart';

// class CallScreen extends StatefulWidget {
//   final String roomID;
//   final String localUserID;
//   final String localUserName;

//   const CallScreen({
//     super.key,
//     required this.roomID,
//     required this.localUserID,
//     required this.localUserName,
//   });

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   // Zego SDK state variables
//   Widget? localView;
//   int? localViewID;
//   Widget? remoteView;
//   int? remoteViewID;
//   Widget? screenSharingView;
//   int? screenSharingViewID;
//   String? localScreenSharingStreamID;

//   // UI control state variables
//   bool _isCameraOn = true;
//   bool _isMicOn = true;
//   bool _isFrontCamera = true;
//   bool _isScreenSharing = false;

//   @override
//   void initState() {
//     super.initState();
//     startListenEvent();
//     loginRoom();
//   }

//   @override
//   void dispose() {
//     stopListenEvent();
//     logoutRoom();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: AppTheme.backgroundGradient,
//         child: Stack(
//           children: [
//             _buildMainView(),
//             Positioned(
//               top: 100,
//               right: 20,
//               child: SizedBox(
//                 width: 110,
//                 height: 160,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: remoteView ?? Container(color: AppTheme.surfaceVariant.withOpacity(0.5)),
//                 ),
//               ),
//             ),
//             if (_isScreenSharing)
//               Positioned(
//                 top: 100,
//                 left: 20,
//                 child: SizedBox(
//                   width: 110,
//                   height: 160,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: localView ?? Container(color: Colors.black54),
//                   ),
//                 ),
//               ),
//             Positioned(
//               bottom: 40,
//               left: 0,
//               right: 0,
//               child: buildControlPanel(),
//             ),
//             Positioned(
//               top: 50,
//               left: 20,
//               child: CircleAvatar(
//                 backgroundColor: Colors.black.withOpacity(0.3),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainView() {
//     if (screenSharingView != null) {
//       return screenSharingView!;
//     } else if (localView != null) {
//       return localView!;
//     } else {
//       return Container(
//         color: AppTheme.surfaceColor,
//         child: const Center(
//           child: Text('Camera is off', style: TextStyle(color: AppTheme.primaryTextColor)),
//         ),
//       );
//     }
//   }

//   Widget buildControlPanel() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildControlButton(onPressed: toggleMic, icon: _isMicOn ? Icons.mic : Icons.mic_off, color: AppTheme.accentColor),
//         _buildControlButton(onPressed: () => Navigator.pop(context), icon: Icons.call_end, color: Colors.redAccent, isEndCall: true),
//         _buildControlButton(onPressed: toggleCamera, icon: _isCameraOn ? Icons.videocam : Icons.videocam_off, color: AppTheme.secondaryColor),
//         _buildControlButton(onPressed: switchCamera, icon: Icons.switch_camera, color: AppTheme.primaryColor),
//         _buildControlButton(onPressed: toggleScreenSharing, icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share, color: AppTheme.successColor),
//       ],
//     );
//   }

//   Widget _buildControlButton({required VoidCallback onPressed, required IconData icon, required Color color, bool isEndCall = false}) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         shape: const CircleBorder(),
//         padding: EdgeInsets.all(isEndCall ? 20 : 15),
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//       ),
//       child: Icon(icon, size: isEndCall ? 30 : 24),
//     );
//   }

//   // --- Feature Implementation ---

//   void toggleMic() {
//     setState(() => _isMicOn = !_isMicOn);
//     ZegoExpressEngine.instance.muteMicrophone(!_isMicOn);
//   }

//   void toggleCamera() {
//     setState(() => _isCameraOn = !_isCameraOn);
//     ZegoExpressEngine.instance.enableCamera(_isCameraOn);
//     if (_isCameraOn) {
//       startPreview();
//     } else {
//       stopPreview();
//     }
//   }

//   void switchCamera() {
//     setState(() => _isFrontCamera = !_isFrontCamera);
//     ZegoExpressEngine.instance.useFrontCamera(_isFrontCamera);
//   }

//   void toggleScreenSharing() async {
//     setState(() => _isScreenSharing = !_isScreenSharing);
//     if (_isScreenSharing) {
//       localScreenSharingStreamID = '${widget.roomID}_${widget.localUserID}_screen';
//       await ZegoExpressEngine.instance.setVideoSource(
//         ZegoVideoSourceType.ScreenCapture,
//         channel: ZegoPublishChannel.Aux,
//       );
//       await ZegoExpressEngine.instance.startScreenCapture();
//       await ZegoExpressEngine.instance.startPublishingStream(
//         localScreenSharingStreamID!,
//         channel: ZegoPublishChannel.Aux,
//       );
//     } else {
//       await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
//       await ZegoExpressEngine.instance.stopScreenCapture();
//       await ZegoExpressEngine.instance.setVideoSource(
//         ZegoVideoSourceType.None,
//         channel: ZegoPublishChannel.Aux,
//       );
//     }
//   }

//   // --- Zego SDK Lifecycle Management ---

//   Future<void> loginRoom() async {
//     await ZegoExpressEngine.createEngineWithProfile(
//         ZegoEngineProfile( 1215738257, ZegoScenario.Default, appSign: "0d1f6a260cccf266b337f4f46daf676b0d65eba5bd53e73f4c9f59958ac6df56"));

//     final user = ZegoUser(widget.localUserID, widget.localUserName);
//     ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;

//     ZegoExpressEngine.instance.loginRoom(widget.roomID, user, config: roomConfig).then((result) {
//       if (result.errorCode == 0) {
//         startPreview();
//         startPublish();
//       } else {
//         debugPrint('Login failed: ${result.errorCode}');
//       }
//     });
//   }

//   Future<void> logoutRoom() async {
//     stopPreview();
//     stopPublish();
//     if (_isScreenSharing) {
//       await ZegoExpressEngine.instance.stopPublishingStream(channel: ZegoPublishChannel.Aux);
//       await ZegoExpressEngine.instance.stopScreenCapture();
//       await ZegoExpressEngine.instance.setVideoSource(ZegoVideoSourceType.None, channel: ZegoPublishChannel.Aux);
//     }
//     await ZegoExpressEngine.instance.logoutRoom(widget.roomID);
//     await ZegoExpressEngine.destroyEngine();
//   }

//   void startListenEvent() {
//     ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, streamList, extendedData) {
//       if (updateType == ZegoUpdateType.Add) {
//         for (final stream in streamList) {
//           if (stream.streamID.endsWith('_screen')) {
//             startPlayScreenShareStream(stream.streamID);
//           } else {
//             startPlayStream(stream.streamID);
//           }
//         }
//       } else {
//         for (final stream in streamList) {
//           if (stream.streamID.endsWith('_screen')) {
//             stopPlayScreenShareStream(stream.streamID);
//           } else {
//             stopPlayStream(stream.streamID);
//           }
//         }
//       }
//     };
//   }

//   void stopListenEvent() {
//     ZegoExpressEngine.onRoomStreamUpdate = null;
//   }
  
//   // --- Video Stream and Preview Handling ---

//   Future<void> startPreview() async {
//     if (!_isCameraOn) return;
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       localViewID = viewID;
//       ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
//     }).then((canvasViewWidget) => setState(() => localView = canvasViewWidget));
//   }
  
//   Future<void> stopPreview() async {
//     ZegoExpressEngine.instance.stopPreview();
//     if (localViewID != null) {
//       await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
//       if (mounted) setState(() { localView = null; localViewID = null; });
//     }
//   }
  
//   Future<void> startPublish() async {
//     String streamID = '${widget.roomID}_${widget.localUserID}_call';
//     ZegoExpressEngine.instance.startPublishingStream(streamID);
//   }
  
//   Future<void> stopPublish() async {
//     ZegoExpressEngine.instance.stopPublishingStream();
//   }
  
//   Future<void> startPlayStream(String streamID) async {
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       remoteViewID = viewID;
//       ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
//       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//     }).then((canvasViewWidget) => setState(() => remoteView = canvasViewWidget));
//   }
  
//   Future<void> stopPlayStream(String streamID) async {
//     ZegoExpressEngine.instance.stopPlayingStream(streamID);
//     if (remoteViewID != null) {
//       await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//       if (mounted) setState(() { remoteView = null; remoteViewID = null; });
//     }
//   }

//   Future<void> startPlayScreenShareStream(String streamID) async {
//     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//       screenSharingViewID = viewID;
//       ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFit);
//       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//     }).then((canvasViewWidget) => setState(() => screenSharingView = canvasViewWidget));
//   }
  
//   Future<void> stopPlayScreenShareStream(String streamID) async {
//     ZegoExpressEngine.instance.stopPlayingStream(streamID);
//     if (screenSharingViewID != null) {
//       await ZegoExpressEngine.instance.destroyCanvasView(screenSharingViewID!);
//       if (mounted) setState(() { screenSharingView = null; screenSharingViewID = null; });
//     }
//   }
// }

// extension on ZegoExpressEngine {
//   Future<void> startScreenCapture() async {}
  
//   Future<void> stopScreenCapture() async {}
// }