import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../newspaper.dart';

class EmbeddedReader extends StatefulWidget {
  const EmbeddedReader({
    super.key,
    required this.url,
    required this.bangla,
    this.focused = false,
  });
  final Uri url;
  final bool bangla, focused;
  @override
  State<EmbeddedReader> createState() => _EmbeddedReaderState();
}

class _EmbeddedReaderState extends State<EmbeddedReader> {
  late final WebViewController controller;
  int progress = 0;
  bool failed = false, canBack = false, canForward = false;
  String host = '';
  @override
  void initState() {
    super.initState();
    host = widget.url.host;
    controller = WebViewController()
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) {
            if (mounted) setState(() => progress = value);
          },
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                progress = 0;
                failed = false;
                host = Uri.tryParse(url)?.host ?? '';
              });
            }
          },
          onPageFinished: (_) async {
            final back = await controller.canGoBack();
            final forward = await controller.canGoForward();
            if (mounted) {
              setState(() {
                progress = 100;
                canBack = back;
                canForward = forward;
              });
            }
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() => failed = true);
            }
          },
          onHttpError: (error) async {
            final currentUrl = await controller.currentUrl();
            if (error.request?.uri.toString() == currentUrl && mounted) {
              setState(() => failed = true);
            }
          },
          onNavigationRequest: (request) =>
              safeWebUrl(Uri.tryParse(request.url) ?? Uri())
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
        ),
      )
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (!widget.focused)
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Row(
            children: [
              IconButton(
                tooltip: widget.bangla ? 'আগের পাতা' : 'Back',
                onPressed: canBack ? () => controller.goBack() : null,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                tooltip: widget.bangla ? 'পরের পাতা' : 'Forward',
                onPressed: canForward ? () => controller.goForward() : null,
                icon: const Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: Text(
                  host,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              IconButton(
                tooltip: widget.bangla ? 'আবার লোড করুন' : 'Reload',
                onPressed: () {
                  setState(() => failed = false);
                  controller.reload();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      if (progress < 100 && !failed)
        LinearProgressIndicator(value: progress / 100),
      Expanded(
        child: failed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 44),
                      const SizedBox(height: 16),
                      Text(
                        widget.bangla
                            ? 'রিডার লোড হয়নি। ইন্টারনেট সংযোগ দেখুন, আবার চেষ্টা করুন বা রিডারের মেনু থেকে প্রকাশকের সাইট খুলুন।'
                            : 'The reader could not load. Check your connection, retry, or choose Open publisher in the reader menu.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          setState(() => failed = false);
                          controller.loadRequest(widget.url);
                        },
                        child: Text(
                          widget.bangla ? 'আবার চেষ্টা করুন' : 'Try again',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : WebViewWidget(controller: controller),
      ),
    ],
  );
}
