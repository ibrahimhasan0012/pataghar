import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'newspaper.dart';
import 'paper_widgets.dart';
import 'reader/embedded_reader.dart';

Future<void> openExternal(BuildContext context, Uri uri) async {
  try {
    if (!safeWebUrl(uri) ||
        !await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_blank',
        )) {
      throw StateError('Cannot open URL');
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The link could not open. Please enable a browser and try again.',
          ),
        ),
      );
    }
  }
}

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    required this.paper,
    required this.bangla,
    this.initialSaved = false,
    this.onSave,
    this.readerBuilder,
  });
  final Newspaper paper;
  final bool bangla, initialSaved;
  final VoidCallback? onSave;

  /// Supplies an alternative surface, e.g. when testing the shared reader controls.
  final Widget Function(bool focused)? readerBuilder;
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool focused = false;
  late bool saved;
  String tr(String en, String bn) => widget.bangla ? bn : en;
  @override
  void initState() {
    super.initState();
    saved = widget.initialSaved;
  }

  void help() => showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.paper.title(widget.bangla),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AccessBadge(paper: widget.paper, bangla: widget.bangla),
            const SizedBox(height: 16),
            Text(widget.paper.note),
            const SizedBox(height: 16),
            Text(
              tr(
                'Use the publisher’s page, date and zoom controls. Focus mode hides the app’s extra controls, giving more room to the original newspaper.',
                'প্রকাশকের রিডারে পাতা, তারিখ ও জুম বেছে নিন। ফোকাস মোডে অ্যাপের বাড়তি বোতাম আড়াল করে পত্রিকা পড়ার জায়গা বাড়ানো হয়।',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'If the embedded reader is blank or sign-in fails, open the publisher’s site. Some publishers do not support embedding or third-party login. Night theme applies to app controls; publisher pages keep their own colours.',
                'রিডার ফাঁকা থাকলে বা লগইন না হলে প্রকাশকের সাইট খুলুন। কিছু প্রকাশক অন্য সাইটে রিডার বা লগইন চালু রাখেন না। নাইট থিম শুধু অ্যাপের বোতাম ও মেনুর রং বদলায়।',
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              widget.paper.url,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${tr('Link/access reviewed', 'লিংক বা পড়ার শর্ত দেখা হয়েছে')}: ${widget.paper.checkedOn}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => openExternal(context, widget.paper.uri),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(tr('Open publisher', 'প্রকাশকের সাইট')),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    return Scaffold(
      appBar: focused
          ? null
          : AppBar(
              toolbarHeight:
                  56 *
                  (MediaQuery.textScalerOf(context).scale(16) / 16).clamp(
                    1,
                    2.5,
                  ),
              titleSpacing: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.paper.title(widget.bangla),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  Text(
                    widget.paper.uri.host,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: tr('Focus mode', 'ফোকাস মোড'),
                  onPressed: () => setState(() => focused = true),
                  icon: const Icon(Icons.fullscreen),
                ),
                PopupMenuButton<String>(
                  tooltip: tr('Reader options', 'রিডারের মেনু'),
                  onSelected: (value) {
                    switch (value) {
                      case 'publisher':
                        openExternal(context, widget.paper.uri);
                      case 'help':
                        help();
                      case 'save':
                        widget.onSave?.call();
                        setState(() => saved = !saved);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved
                                  ? tr(
                                      'Saved to favourites',
                                      'পছন্দে রাখা হয়েছে',
                                    )
                                  : tr(
                                      'Removed from favourites',
                                      'পছন্দ থেকে সরানো হয়েছে',
                                    ),
                            ),
                          ),
                        );
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'publisher',
                      child: Text(tr('Open publisher', 'প্রকাশকের সাইট')),
                    ),
                    if (widget.onSave != null)
                      PopupMenuItem(
                        value: 'save',
                        child: Text(
                          saved
                              ? tr('Remove favourite', 'পছন্দ থেকে সরান')
                              : tr('Add favourite', 'পছন্দে রাখুন'),
                        ),
                      ),
                    PopupMenuItem(
                      value: 'help',
                      child: Text(tr('Reading help', 'পড়ার সহায়তা')),
                    ),
                  ],
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (focused)
              Material(
                color: c.surfaceContainerLow,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => setState(() => focused = false),
                        icon: const Icon(Icons.fullscreen_exit),
                        label: Text(tr('Exit focus', 'ফোকাস বন্ধ করুন')),
                      ),
                    ),
                    IconButton(
                      tooltip: tr('Open publisher', 'প্রকাশকের সাইট'),
                      onPressed: () => openExternal(context, widget.paper.uri),
                      icon: const Icon(Icons.open_in_new),
                    ),
                  ],
                ),
              )
            else
              Container(
                color: c.surfaceContainerLow,
                padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: AccessBadge(
                        paper: widget.paper,
                        bangla: widget.bangla,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: tr('Reading help', 'পড়ার সহায়তা'),
                      onPressed: help,
                      icon: const Icon(Icons.help_outline),
                    ),
                  ],
                ),
              ),
            Expanded(
              child:
                  widget.readerBuilder?.call(focused) ??
                  EmbeddedReader(
                    url: widget.paper.uri,
                    bangla: widget.bangla,
                    focused: focused,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
