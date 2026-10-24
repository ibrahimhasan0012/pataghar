import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:url_launcher/url_launcher.dart';

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
  int attempt = 0;
  bool waiting = true;
  Future<void> openPublisher() async {
    try {
      final opened = await launchUrl(
        widget.url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!opened) throw StateError('No browser');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The publisher link could not open. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (waiting) const LinearProgressIndicator(),
      Expanded(
        child: HtmlElementView.fromTagName(
          key: ValueKey('${widget.url}:$attempt'),
          tagName: 'iframe',
          onElementCreated: (element) {
            final frame = element as web.HTMLIFrameElement;
            frame.title = widget.bangla
                ? 'প্রকাশকের ই-পেপার রিডার'
                : 'Publisher e-paper reader';
            frame.style.width = '100%';
            frame.style.height = '100%';
            frame.style.border = '0';
            // Match a normal browser canvas when the publisher body is transparent.
            frame.style.backgroundColor = 'white';
            frame.setAttribute(
              'referrerpolicy',
              'strict-origin-when-cross-origin',
            );
            frame.setAttribute(
              'sandbox',
              'allow-scripts allow-same-origin allow-forms allow-popups allow-popups-to-escape-sandbox allow-downloads',
            );
            frame.addEventListener(
              'load',
              ((web.Event event) {
                if (mounted) setState(() => waiting = false);
              }).toJS,
            );
            frame.src = widget.url.toString();
          },
        ),
      ),
      if (!widget.focused)
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.bangla
                        ? 'ফাঁকা দেখালে বা লগইন না হলে প্রকাশকের সাইট খুলুন।'
                        : 'Blank reader or trouble signing in? Open the publisher.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: widget.bangla ? 'আবার লোড করুন' : 'Reload reader',
                  onPressed: () => setState(() {
                    waiting = true;
                    attempt++;
                  }),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: widget.bangla ? 'প্রকাশকের সাইট' : 'Open publisher',
                  onPressed: openPublisher,
                  icon: const Icon(Icons.open_in_new),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
