import 'package:flutter/material.dart';
import '../../../data/models/note.dart';
import '../../../widgets/glass_card.dart';
import 'category_tag.dart';

/// Pinned note card — matches the design with title, expand icon, preview, tags, timestamp.
class PinnedNoteCard extends StatelessWidget {
  final Note note;
  final String timeAgo;
  final VoidCallback? onTap;

  const PinnedNoteCard({
    super.key,
    required this.note,
    required this.timeAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        borderRadius: 12,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header image (if present)
            if (note.headerImagePath != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: cs.outline,
                  child: Center(
                    child: Icon(
                      Icons.landscape,
                      color: cs.onSurfaceVariant,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.open_in_new,
                        color: cs.onSurfaceVariant,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Body preview (2 lines)
                  Text(
                    note.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tags + timestamp row
                  Row(
                    children: [
                      if (note.category != null)
                        CategoryTag(label: note.category!),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
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
    );
  }
}
