import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Service that manages Cloudflare Turnstile CAPTCHA challenges.
///
/// Uses a WebView to render the Turnstile widget and extract the token.
/// If the site key is empty (staging/dev), the service returns an empty
/// token and the server will skip validation.
class TurnstileService {
  TurnstileService({required this.siteKey});

  /// Cloudflare Turnstile site key. If empty, CAPTCHA is disabled.
  final String siteKey;

  /// Whether Turnstile is enabled (site key is configured).
  bool get isEnabled => siteKey.trim().isNotEmpty;

  /// Solves a Turnstile challenge and returns the token.
  /// Returns empty string if Turnstile is not enabled.
  ///
  /// The [onWebViewCreated] callback provides the WebViewController
  /// so the caller can embed it in the widget tree if needed.
  Future<String> solveChallenge({
    void Function(WebViewController controller)? onWebViewCreated,
  }) async {
    if (!isEnabled) {
      debugPrint('[Turnstile] Site key not configured, skipping challenge');
      return '';
    }

    final completer = Completer<String>();

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'TurnstileCallback',
        onMessageReceived: (message) {
          if (!completer.isCompleted) {
            debugPrint('[Turnstile] Token received');
            completer.complete(message.message);
          }
        },
      )
      ..loadHtmlString(_buildHtml());

    onWebViewCreated?.call(controller);

    // Timeout after 60 seconds
    return completer.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        debugPrint('[Turnstile] Challenge timed out');
        return '';
      },
    );
  }

  String _buildHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
</head>
<body style="margin:0;padding:16px;display:flex;justify-content:center;align-items:center;min-height:100vh;background:transparent;">
  <div class="cf-turnstile"
       data-sitekey="$siteKey"
       data-callback="onSuccess"
       data-theme="light"
       data-size="normal">
  </div>
  <script>
    function onSuccess(token) {
      if (window.TurnstileCallback) {
        TurnstileCallback.postMessage(token);
      }
    }
  </script>
</body>
</html>
''';
  }
}
