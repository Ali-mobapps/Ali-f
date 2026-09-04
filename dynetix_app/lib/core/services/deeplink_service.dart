import 'dart:async';
import 'package:app_links/app_links.dart';
import '../../main.dart';

class DeepLinkService {
  static final _appLinks = AppLinks();
  static StreamSubscription? _linkSubscription;

  static void initialize() {
    // 1. Handle links when app is already open
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    // 2. Handle links that opened the app
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  static void _handleDeepLink(Uri uri) {
    print('Received Deep Link: $uri');
    // Example: dynetix://app/announcements
    if (uri.path == '/announcements') {
      navigatorKey.currentState?.pushNamed('/announcements');
    }
  }

  static void dispose() {
    _linkSubscription?.cancel();
  }
}
