import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:logger/web.dart';

class DeepLinkHandler{
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _applink = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Function(String bookingId,String status,Map<String,String> params)? onPaymentResult;


  Future<void> initialize()async{
    try {
      final init = await _applink.getInitialLink();
      if(init!=null){
        Logger().d('Initial deep link: $init');
      }
      _linkSubscription = _applink.uriLinkStream.listen(
        (uri) {
          Logger().d('Received deep link: $uri');
        },
        onError: (err) {
          Logger().e('Deep link error: $err');
        },
      );
    } catch (e) {
      Logger().e('Failed to initialize deep link handler: $e');
    }
  }

   void dispose() {
    _linkSubscription?.cancel();
  }
}