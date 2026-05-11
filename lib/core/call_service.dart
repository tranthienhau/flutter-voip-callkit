import 'dart:async';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class CallEvent {
  final String id;
  final String handle;
  final String name;
  final bool accepted;
  CallEvent(this.id, this.handle, this.name, this.accepted);
}

class CallService {
  CallService._();
  static final instance = CallService._();

  final _controller = StreamController<CallEvent>.broadcast();
  Stream<CallEvent> get stream => _controller.stream;

  StreamSubscription? _sub;

  Future<void> init() async {
    _sub = FlutterCallkitIncoming.onEvent.listen(_handle);
  }

  Future<void> showIncomingFromData(Map<String, dynamic> data) async {
    final id = (data['uuid'] as String?) ?? const Uuid().v4();
    final handle = (data['handle'] as String?) ?? 'unknown';
    final name = (data['name'] as String?) ?? 'Caller';
    final deepLink = (data['deep_link'] as String?) ?? '';
    final params = CallKitParams(
      id: id,
      nameCaller: name,
      handle: handle,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: {'deep_link': deepLink, 'handle': handle, 'name': name},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
        isShowFullLockedScreen: true,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall(String id) async {
    await FlutterCallkitIncoming.endCall(id);
  }

  Future<void> endAll() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  void _handle(CallEvent? event) {}

  Future<void> _handleEvent(dynamic event) async {}

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }

  Future<void> handlePluginEvent(dynamic event) async {
    if (event is! CallEvent) return;
    _controller.add(event);
  }
}
