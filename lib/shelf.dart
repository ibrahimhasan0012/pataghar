import 'package:flutter/material.dart';
import 'newspaper.dart';
import 'paper_widgets.dart';
import 'reader_screen.dart';

class NewspaperShelf extends StatefulWidget {
  const NewspaperShelf({
    super.key,
    required this.papers,
    required this.bangla,
    required this.dark,
    required this.favourites,
    required this.onToggleFavourite,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.onOpened,
    this.lastPaper,
    this.warning,
  });
  final List<Newspaper> papers;
  final bool bangla, dark;
  final Set<String> favourites;
  final ValueChanged<String> onToggleFavourite, onOpened;
  final VoidCallback onToggleLanguage, onToggleTheme;
  final String? lastPaper, warning;
  @override
  State<NewspaperShelf> createState() => _NewspaperShelfState();
}

class _NewspaperShelfState extends State<NewspaperShelf> {
  final search = TextEditingController();
  String filter = 'all';
  int tab = 0;
  bool? listView;
  String tr(String en, String bn) => widget.bangla ? bn : en;
  @override
  void initState() {
    super.initState();
    search.addListener(refreshSearch);
  }

  void refreshSearch() => setState(() {});
  @override
  void dispose() {
    search.removeListener(refreshSearch);
    search.dispose();
    super.dispose();
  }

  void openPaper(Newspaper p) {
    widget.onOpened(p.id);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ReaderScreen(
          paper: p,
          bangla: widget.bangla,
          initialSaved: widget.favourites.contains(p.id),
          onSave: () => widget.onToggleFavourite(p.id),
        ),
      ),
    );
  }

  void about() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('A quieter way to read.', 'মন দিয়ে পত্রিকা পড়ুন।'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'Pataghar brings official print editions into one reader. Publishers provide the pages, issue dates, zoom, ads and login. Check the issue date inside each reader.',
                'পাতাঘরে প্রকাশকের ছাপা পত্রিকার ই-পেপার এক রিডারে পড়ুন। পাতা, তারিখ, জুম, বিজ্ঞাপন ও লগইন প্রকাশকের নিজস্ব। প্রতিটি রিডারে সংখ্যার তারিখ দেখে নিন।',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'The app does not require PDF downloads. Reading uses internet data and normal browser or WebView caching. Publisher subscriptions and access requirements still apply.',
                'অ্যাপ থেকে পিডিএফ ডাউনলোডের প্রয়োজন নেই। পড়ার সময় ইন্টারনেট ডেটা ও স্বাভাবিক ক্যাশ ব্যবহার হয়। প্রকাশকের সাবস্ক্রিপশন ও পড়ার শর্ত প্রযোজ্য।',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'Your favourites, language, theme and last opened newspaper stay on this device or browser. There is no app account, server, analytics or advertising SDK. Publisher pages have their own privacy policies and cookies.',
                'পছন্দ, ভাষা, থিম ও সর্বশেষ খোলা পত্রিকার নাম এই ডিভাইস বা ব্রাউজারে রাখা হয়। অ্যাপের নিজস্ব অ্যাকাউন্ট, সার্ভার, অ্যানালিটিক্স বা বিজ্ঞাপন নেই। প্রকাশকের সাইটের নিজস্ব নীতি ও কুকি রয়েছে।',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'The starter catalogue has 16 publications. Links and access were researched on 24 October 2026. The catalogue is not updated live. Last opened reopens a publisher’s reader; it does not restore a particular page or issue.',
                'প্রাথমিক তালিকায় ১৬টি পত্রিকা রয়েছে। ২৪ অক্টোবর ২০২৬ তারিখে লিংক ও পড়ার শর্ত নিয়ে খোঁজ নেওয়া হয়েছে। তালিকা সরাসরি আপডেট হয় না। সর্বশেষ খোলা পত্রিকা থেকে প্রকাশকের রিডার আবার খোলা যায়; নির্দিষ্ট পাতা বা সংখ্যা সংরক্ষণ করা হয় না।',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr(
                'Night theme changes the app controls. Publisher pages keep their original colours.',
                'নাইট থিমে অ্যাপের রং বদলায়। প্রকাশকের পাতার আসল রং অপরিবর্তিত থাকে।',
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => showLicensePage(
                context: context,
                applicationName: 'Pataghar',
                applicationVersion: '0.3.0',
              ),
              icon: const Icon(Icons.code),
              label: Text(tr('Open-source licences', 'ওপেন-সোর্স লাইসেন্স')),
            ),
            Text(
              tr('PATAGHAR  /  VERSION 0.3.0', 'পাতাঘর  /  সংস্করণ ০.৩.০'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );

  void details(Newspaper p) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              p.title(widget.bangla),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AccessBadge(paper: p, bangla: widget.bangla),
            const SizedBox(height: 16),
            Text(p.note),
            const SizedBox(height: 16),
            Text(
              '${tr('Link/access reviewed', 'লিংক বা পড়ার শর্ত দেখা হয়েছে')}: ${p.checkedOn}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SelectableText(p.url),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openPaper(p);
                  },
                  child: Text(tr('Read e-paper', 'ই-পেপার পড়ুন')),
                ),
                TextButton.icon(
                  onPressed: () => openExternal(context, Uri.parse(p.source)),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(tr('Access source', 'তথ্যসূত্র')),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  String dateLabel() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 6));
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    const bnMonths = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];
    return '${now.day} ${widget.bangla ? bnMonths[now.month - 1] : months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final visible = widget.papers
        .where(
          (p) => p.matches(search.text, filter, widget.favourites, tab == 1),
        )
        .toList();
    Newspaper? recent;
    for (final p in widget.papers) {
      if (p.id == widget.lastPaper) recent = p;
    }
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;
    final showList = listView ?? mobile;
    final gutter = width >= 700 ? 32.0 : 16.0;
    final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56 * textScale.clamp(1, 2.5),
        titleSpacing: width > 1120 ? (width - 1120) / 2 + gutter : gutter,
        title: Row(
          children: [
            if (textScale <= 1.3) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/brand/pataghar.png',
                  width: 36,
                  height: 36,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                'পাতাঘর',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'NewsprintBengali',
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: c.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.dark
                ? tr('Switch to day theme', 'দিনের থিম')
                : tr('Switch to night theme', 'নাইট থিম'),
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          if (textScale > 1.3)
            IconButton(
              tooltip: widget.bangla ? 'Switch to English' : 'বাংলায় দেখুন',
              onPressed: widget.onToggleLanguage,
              icon: const Icon(Icons.translate),
            )
          else
            TextButton(
              onPressed: widget.onToggleLanguage,
              child: Text(widget.bangla ? 'English' : 'বাংলা'),
            ),
          IconButton(
            tooltip: tr('About Pataghar', 'পাতাঘর সম্পর্কে'),
            onPressed: about,
            icon: const Icon(Icons.more_horiz),
          ),
          SizedBox(width: width > 1120 ? (width - 1120) / 2 + gutter - 8 : 8),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dateLabel(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                letterSpacing: .8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            tr('DHAKA', 'ঢাকা'),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: mobile ? 10 : 16),
                      Text(
                        tab == 1
                            ? tr(
                                'Your morning shelf.',
                                'আপনার পছন্দের পত্রিকা।',
                              )
                            : tr(
                                mobile ? 'Newspapers' : 'The daily shelf.',
                                'প্রতিদিনের পত্রিকা।',
                              ),
                        style: mobile
                            ? theme.textTheme.headlineSmall
                            : theme.textTheme.headlineLarge,
                      ),
                      if (!mobile) ...[
                        const SizedBox(height: 6),
                        Text(
                          tr(
                            'Original print editions, all in one place.',
                            'ছাপা পত্রিকার আসল রূপ, এক জায়গায়।',
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: c.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (recent != null &&
                          tab == 0 &&
                          search.text.isEmpty) ...[
                        const SizedBox(height: 20),
                        lastOpened(recent),
                      ],
                      const SizedBox(height: 20),
                      TextField(
                        controller: search,
                        decoration: InputDecoration(
                          labelText: tr('Search newspapers', 'পত্রিকা খুঁজুন'),
                          hintText: tr('Bangla or English', 'বাংলা বা ইংরেজি'),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: tr('Clear search', 'খোঁজা মুছুন'),
                                  onPressed: search.clear,
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final item in [
                            ('all', tr('All papers', 'সব পত্রিকা')),
                            ('free', tr('Free options', 'বিনা মূল্যে')),
                            ('Bangla', 'বাংলা'),
                            ('English', 'English'),
                          ])
                            ChoiceChip(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              label: Text(item.$2),
                              selected: filter == item.$1,
                              onSelected: (_) =>
                                  setState(() => filter = item.$1),
                            ),
                        ],
                      ),
                      if (widget.warning != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            widget.warning!,
                            style: TextStyle(color: c.error),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              liveRegion: true,
                              label:
                                  '${visible.length} ${tr('newspapers found', 'টি পত্রিকা পাওয়া গেছে')}',
                              excludeSemantics: true,
                              child: Text(
                                '${visible.length} ${tr('NEWSPAPERS', 'টি পত্রিকা')}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .7,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: showList
                                ? tr('Show grid view', 'গ্রিডে দেখুন')
                                : tr('Show list view', 'তালিকায় দেখুন'),
                            onPressed: () =>
                                setState(() => listView = !showList),
                            icon: Icon(
                              showList
                                  ? Icons.grid_view_outlined
                                  : Icons.view_agenda_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (visible.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          search.text.isEmpty
                              ? Icons.star_outline
                              : Icons.search_off,
                          size: 48,
                          color: c.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tr(
                            'Nothing on this shelf yet.',
                            'এখানে এখনো কোনো পত্রিকা নেই।',
                          ),
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(
                            'Try another search or filter. Tap a star to save a paper.',
                            'অন্য নামে খুঁজুন বা ফিল্টার বদলান। তারকা চিহ্নে পছন্দের পত্রিকা রাখুন।',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (search.text.isNotEmpty || filter != 'all')
                          TextButton(
                            onPressed: () {
                              search.clear();
                              setState(() => filter = 'all');
                            },
                            child: Text(tr('Reset search', 'আবার খুঁজুন')),
                          ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final minWidth = width < 600 ? 156 : 260;
                    final columns =
                        ((constraints.crossAxisExtent + 16) / (minWidth + 16))
                            .floor()
                            .clamp(1, 3);
                    final scaled =
                        MediaQuery.textScalerOf(context).scale(16) / 16;
                    final compact =
                        showList ||
                        columns == 1 ||
                        scaled > 1.3 ||
                        visible.length == 1;
                    Widget card(int index) {
                      final p = visible[index];
                      if (mobile && compact) {
                        return MobilePaperTile(
                          key: ValueKey(p.id),
                          paper: p,
                          bangla: widget.bangla,
                          saved: widget.favourites.contains(p.id),
                          onSave: () => widget.onToggleFavourite(p.id),
                          onRead: () => openPaper(p),
                          onDetails: () => details(p),
                        );
                      }
                      return PaperCard(
                        key: ValueKey(p.id),
                        paper: p,
                        bangla: widget.bangla,
                        saved: widget.favourites.contains(p.id),
                        compact: compact,
                        onSave: () => widget.onToggleFavourite(p.id),
                        onRead: () => openPaper(p),
                        onDetails: () => details(p),
                      );
                    }

                    if (compact) {
                      return SliverList.separated(
                        itemCount: visible.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, index) => card(index),
                      );
                    }
                    return SliverGrid.builder(
                      itemCount: visible.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: (width < 600 ? 286 : 248) * scaled,
                      ),
                      itemBuilder: (_, index) => card(index),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(gutter, 24, gutter, 24),
                  child: Text(
                    tr(
                      'Access is set by each publisher. Check the issue date in the reader.',
                      'পড়ার শর্ত প্রকাশক নির্ধারণ করেন। রিডারে সংখ্যার তারিখ দেখে নিন।',
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.outlineVariant)),
        ),
        child: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.newspaper_outlined),
              selectedIcon: const Icon(Icons.newspaper),
              label: tr('Newspapers', 'পত্রিকা'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.star_outline),
              selectedIcon: const Icon(Icons.star),
              label: tr('Favourites', 'পছন্দ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget lastOpened(Newspaper p) {
    final c = Theme.of(context).colorScheme;
    return Material(
      color: c.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => openPaper(p),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.history, color: c.onPrimaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('LAST OPENED', 'সর্বশেষ খোলা'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: c.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.title(widget.bangla),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        color: c.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward, color: c.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
