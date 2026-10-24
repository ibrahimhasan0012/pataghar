import 'package:flutter/material.dart';
import 'design.dart';
import 'newspaper.dart';

class AccessBadge extends StatelessWidget {
  const AccessBadge({super.key, required this.paper, required this.bangla});
  final Newspaper paper;
  final bool bangla;
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final paid = paper.access == 'SUBSCRIPTION';
    final unknown = paper.access == 'UNKNOWN';
    final icon = switch (paper.access) {
      'PUBLIC_READER' => Icons.check_circle_outline,
      'FREE_SIGN_IN' => Icons.person_outline,
      'SUBSCRIPTION' => Icons.lock_outline,
      _ => Icons.help_outline,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: unknown
            ? c.surfaceContainer
            : paid
            ? c.secondaryContainer
            : c.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              icon,
              size: 16,
              color: unknown
                  ? c.onSurfaceVariant
                  : paid
                  ? c.onSecondaryContainer
                  : c.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              paper.accessLabel(bangla),
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: unknown
                    ? c.onSurfaceVariant
                    : paid
                    ? c.onSecondaryContainer
                    : c.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An illustrative newspaper symbol, not a publisher logo or issue preview.
class PaperMark extends StatelessWidget {
  const PaperMark({super.key, required this.accent});
  final Color accent;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 48,
      height: 60,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .08),
        border: Border.all(color: accent.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 5, color: accent),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(color: accent.withValues(alpha: .2))),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Container(
                              color: accent.withValues(alpha: .35),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 2, color: accent.withValues(alpha: .3)),
        ],
      ),
    ),
  );
}

class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.paper,
    required this.bangla,
    required this.saved,
    required this.onSave,
    required this.onRead,
    required this.onDetails,
    required this.compact,
  });
  final Newspaper paper;
  final bool bangla, saved, compact;
  final VoidCallback onSave, onRead, onDetails;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final accent = Newsprint.accent(paper.id, context);
    final star = IconButton(
      tooltip: saved
          ? (bangla ? 'পছন্দ থেকে সরান' : 'Remove favourite')
          : (bangla ? 'পছন্দে রাখুন' : 'Add favourite'),
      isSelected: saved,
      onPressed: onSave,
      icon: const Icon(Icons.star_outline),
      selectedIcon: const Icon(Icons.star),
      color: c.primary,
    );
    final titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paper.title(bangla),
          maxLines: compact ? null : 3,
          overflow: compact ? null : TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: compact ? 21 : 20,
            color: accent,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bangla ? paper.name : paper.bangla,
          maxLines: compact ? null : 1,
          overflow: compact ? null : TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
    return Semantics(
      container: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 3, color: accent),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      paper.language == 'Bangla' ? 'বাংলা' : 'ENGLISH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .6,
                        color: c.onSurfaceVariant,
                      ),
                    ),
                  ),
                  star,
                ],
              ),
            ),
            if (compact)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaperMark(accent: accent),
                    const SizedBox(width: 16),
                    Expanded(child: titles),
                  ],
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: titles,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AccessBadge(paper: paper, bangla: bangla),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label:
                          '${bangla ? 'ই-পেপার পড়ুন' : 'Read e-paper'}: ${paper.title(bangla)}',
                      button: true,
                      onTap: onRead,
                      excludeSemantics: true,
                      child: TextButton(
                        onPressed: onRead,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                compact
                                    ? (bangla ? 'ই-পেপার পড়ুন' : 'Read e-paper')
                                    : (bangla ? 'পড়ুন' : 'Read'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: bangla ? 'পড়ার বিস্তারিত' : 'Access details',
                    onPressed: onDetails,
                    icon: Icon(Icons.info_outline, color: c.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A phone row: the newspaper area opens the reader; trailing actions stay separate.
class MobilePaperTile extends StatelessWidget {
  const MobilePaperTile({
    super.key,
    required this.paper,
    required this.bangla,
    required this.saved,
    required this.onSave,
    required this.onRead,
    required this.onDetails,
  });
  final Newspaper paper;
  final bool bangla, saved;
  final VoidCallback onSave, onRead, onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final accent = Newsprint.accent(paper.id, context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: onRead,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (MediaQuery.textScalerOf(context).scale(16) <= 22) ...[
                      PaperMark(accent: accent),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            paper.title(bangla),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 19,
                              height: 1.35,
                              color: accent,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            bangla ? paper.name : paper.bangla,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          AccessBadge(paper: paper, bangla: bangla),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  bangla ? 'ই-পেপার পড়ুন' : 'Read e-paper',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: c.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: c.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 2),
            child: Column(
              children: [
                IconButton(
                  tooltip: saved
                      ? (bangla ? 'পছন্দ থেকে সরান' : 'Remove favourite')
                      : (bangla ? 'পছন্দে রাখুন' : 'Add favourite'),
                  isSelected: saved,
                  onPressed: onSave,
                  icon: const Icon(Icons.star_outline_rounded),
                  selectedIcon: const Icon(Icons.star_rounded),
                  color: c.primary,
                ),
                IconButton(
                  tooltip: bangla ? 'পড়ার বিস্তারিত' : 'Access details',
                  onPressed: onDetails,
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
