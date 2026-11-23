import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/app_logger.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';
import 'package:route_ecommerce/features/orders/presentation/payment/payment_web_view_args.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final PaymentWebViewArgs args;

  const PaymentWebViewPage({super.key, required this.args});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  static const String _logTag = 'PaymentWebView';

  late final WebViewController _controller;
  int _progress = 0;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    AppLogger.i(
      'Initializing payment WebView | url=${widget.args.checkoutUrl} | '
      'successUrl=${widget.args.successUrl} | cancelUrl=${widget.args.cancelUrl}',
      tag: _logTag,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _onNavigationRequest,
          onPageStarted: _onPageStarted,
          onProgress: _onProgress,
          onPageFinished: _onPageFinished,
          onUrlChange: _onUrlChange,
          onWebResourceError: _onWebResourceError,
          onHttpError: _onHttpError,
        ),
      );

    final uri = Uri.tryParse(widget.args.checkoutUrl);
    if (uri != null) {
      _controller.loadRequest(uri);
    } else {
      AppLogger.e(
        'Invalid checkout URL provided: ${widget.args.checkoutUrl}',
        tag: _logTag,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _completeWith(PaymentWebViewResult.failed, reason: 'invalid_url');
      });
    }
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    AppLogger.i(
      'onNavigationRequest | url=${request.url} | isMainFrame=${request.isMainFrame}',
      tag: _logTag,
    );
    final result = _resolveCallback(request.url);
    if (result != null) {
      _completeWith(result, reason: 'navigation_request:${request.url}');
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void _onPageStarted(String url) {
    AppLogger.d('onPageStarted | url=$url', tag: _logTag);
    if (!mounted) return;
    setState(() => _progress = 0);
  }

  void _onProgress(int progress) {
    AppLogger.d('onProgress | progress=$progress%', tag: _logTag);
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  void _onPageFinished(String url) {
    AppLogger.i('onPageFinished | url=$url', tag: _logTag);
    if (!mounted) return;
    setState(() => _progress = 100);
  }

  void _onUrlChange(UrlChange change) {
    final url = change.url;
    AppLogger.i('onUrlChange | url=$url', tag: _logTag);
    if (url == null) return;
    final result = _resolveCallback(url);
    if (result != null) {
      _completeWith(result, reason: 'url_change:$url');
    }
  }

  void _onWebResourceError(WebResourceError error) {
    AppLogger.e(
      'onWebResourceError | code=${error.errorCode} | type=${error.errorType} | '
      'isMainFrame=${error.isForMainFrame} | url=${error.url} | '
      'description=${error.description}',
      tag: _logTag,
    );
    if (error.url != null) {
      final result = _resolveCallback(error.url!);
      if (result != null) {
        _completeWith(
          result,
          reason: 'web_resource_error_callback:${error.url}',
        );
        return;
      }
    }
  }

  void _onHttpError(HttpResponseError error) {
    AppLogger.w(
      'onHttpError | statusCode=${error.response?.statusCode} | '
      'url=${error.request?.uri}',
      tag: _logTag,
    );
  }

  PaymentWebViewResult? _resolveCallback(String url) {
    return PaymentWebViewCallbackResolver.resolve(
      url,
      successUrl: widget.args.successUrl,
      cancelUrl: widget.args.cancelUrl,
    );
  }

  void _completeWith(PaymentWebViewResult result, {required String reason}) {
    if (_hasCompleted) return;
    _hasCompleted = true;
    AppLogger.i(
      'Payment callback resolved | result=${result.name} | reason=$reason',
      tag: _logTag,
    );
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _completeWith(
            PaymentWebViewResult.cancelled,
            reason: 'user_back_navigation',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            context.locale.paymentTitle,
            style: context.text.titleLarge,
          ),
          leading: IconButton(
            onPressed: () => _completeWith(
              PaymentWebViewResult.cancelled,
              reason: 'user_close_button',
            ),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: Icon(Icons.close, color: context.colors.primary),
          ),
        ),
        body: Column(
          children: [
            if (_progress < 100)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress / 100 : null,
                color: context.colors.primary,
                backgroundColor: context.colors.outline.withValues(alpha: 0.2),
              ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
