import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A widget that renders a Cloudflare Turnstile CAPTCHA challenge.
///
/// If [siteKey] is empty, the widget renders nothing and immediately
/// calls [onTokenObtained] with an empty string (CAPTCHA disabled).
class TurnstileChallengeWidget extends StatefulWidget {
  const TurnstileChallengeWidget({
    super.key,
    required this.siteKey,
    required this.onTokenObtained,
    this.height = 80,
  });

  /// Cloudflare Turnstile site key. If empty, CAPTCHA is skipped.
  final String siteKey;

  /// Called when the challenge is solved (or skipped if disabled).
  final ValueChanged<String> onTokenObtained;

  /// Height of the WebView container.
  final double height;

  @override
  State<TurnstileChallengeWidget> createState() =>
      _TurnstileChallengeWidgetState();
}

class _TurnstileChallengeWidgetState extends State<TurnstileChallengeWidget> {
  late final WebViewController _controller;
  bool _tokenObtained = false;

  @override
  void initState() {
    super.initState();

    if (widget.siteKey.trim().isEmpty) {
      // CAPTCHA disabled — notify immediately.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTokenObtained('');
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        'TurnstileCallback',
        onMessageReceived: (message) {
          if (!_tokenObtained) {
            _tokenObtained = true;
            widget.onTokenObtained(message.message);
          }
        },
      )
      ..loadHtmlString(_buildHtml());
  }

  String _buildHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
  <style>
    body { margin: 0; padding: 8px; display: flex; justify-content: center; align-items: center; background: transparent; }
  </style>
</head>
<body>
  <div class="cf-turnstile"
       data-sitekey="${widget.siteKey}"
       data-callback="onSuccess"
       data-theme="light"
       data-size="compact">
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

  @override
  Widget build(BuildContext context) {
    if (widget.siteKey.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: WebViewWidget(controller: _controller),
    );
  }
}
