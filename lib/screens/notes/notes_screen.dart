import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/note.dart';
import '../../providers/notes_provider.dart';
import '../../widgets/bedrock_app_bar.dart';
import '../../widgets/bedrock_fab.dart';
import '../../widgets/section_header.dart';
import '../../widgets/glass_search_bar.dart';
import 'widgets/pinned_note_card.dart';
import 'widgets/recent_note_card.dart';
import 'note_editor_screen.dart';

/// Notes screen with multi-select + search support.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  Future<void> _openEditor({Note? note}) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)));
    if (!mounted) return;
    context.read<NotesProvider>().loadNotes();
  }

  void _onNoteTap(NotesProvider notes, Note note) {
    if (notes.isSelecting) {
      notes.toggleSelection(note.id!);
    } else {
      _openEditor(note: note);
    }
  }

  void _onNoteLongPress(NotesProvider notes, Note note) {
    if (!notes.isSelecting) {
      notes.startSelecting(note.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>();
    final cs = Theme.of(context).colorScheme;

    final pinned = notes.filteredPinnedNotes;
    final recent = notes.filteredRecentNotes;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ── App bar — switches between normal / select ──
          if (notes.isSelecting)
            _buildSelectBar(notes, cs)
          else
            Column(
              children: [
                const BedrockAppBar(),
                GlassSearchBar(
                  controller: _searchController,
                  hintText: 'Search notes...',
                  onChanged: (q) => notes.updateSearch(q),
                  onClear: notes.searchQuery.isNotEmpty
                      ? () {
                          _searchController.clear();
                          notes.updateSearch('');
                        }
                      : null,
                ),
              ],
            ),

          Expanded(
            child: notes.isLoading
                ? Center(child: CircularProgressIndicator(color: cs.primary))
                : Stack(
                    children: [
                      pinned.isEmpty && recent.isEmpty
                          ? _buildEmptyState(cs, notes.isSearching)
                          : ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                // ── Pinned section ──────────────
                                if (pinned.isNotEmpty) ...[
                                  const SectionHeader(
                                    icon: Icons.push_pin,
                                    title: 'Pinned',
                                  ),
                                  ...pinned.map((note) {
                                    return _wrapSelectable(
                                      notes,
                                      note,
                                      PinnedNoteCard(
                                        note: note,
                                        timeAgo: _timeAgo(note.updatedAt),
                                        onTap: () => _onNoteTap(notes, note),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 8),
                                ],

                                // ── Recent section ──────────────
                                if (recent.isNotEmpty) ...[
                                  const SectionHeader(
                                    icon: Icons.access_time,
                                    title: 'Recent Notes',
                                  ),
                                  ...recent.map((note) {
                                    return _wrapSelectable(
                                      notes,
                                      note,
                                      RecentNoteCard(
                                        note: note,
                                        onTap: () => _onNoteTap(notes, note),
                                      ),
                                    );
                                  }),
                                ],

                                const SizedBox(height: 220),
                              ],
                            ),

                      // FAB — hidden during selection
                      if (!notes.isSelecting)
                        Positioned(
                          right: 16,
                          bottom:
                              160, // Shifted up further to avoid dock overlap
                          child: BedrockFab(onPressed: () => _openEditor()),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Wraps a card with long-press + selection highlight.
  Widget _wrapSelectable(NotesProvider notes, Note note, Widget child) {
    final isSelected = notes.isSelecting && notes.selectedIds.contains(note.id);
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPress: () => _onNoteLongPress(notes, note),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: cs.primary, width: 2) : null,
        ),
        child: Stack(
          children: [
            IgnorePointer(ignoring: notes.isSelecting, child: child),
            if (notes.isSelecting)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _onNoteTap(notes, note),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? cs.primary.withValues(alpha: 0.08)
                          : Colors.transparent,
                    ),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected ? cs.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected ? cs.primary : cs.outline,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Multi-select toolbar.
  Widget _buildSelectBar(NotesProvider notes, ColorScheme cs) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              color: cs.onSurface,
              onPressed: () => notes.clearSelection(),
            ),
            Text(
              '${notes.selectedCount} selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => notes.selectAll(),
              child: Text(
                'ALL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent.shade200,
              onPressed: notes.selectedCount > 0
                  ? () => _confirmDelete(notes)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // _buildSearchBar removed in favor of GlassSearchBar

  void _confirmDelete(NotesProvider notes) {
    final cs = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(
          'Delete ${notes.selectedCount} note${notes.selectedCount > 1 ? 's' : ''}?',
          style: TextStyle(color: cs.onSurface),
        ),
        content: Text(
          'This action cannot be undone.',
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              notes.deleteSelected();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent.shade200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, bool isSearching) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.note_add_outlined,
            size: 64,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'No results found' : 'No notes yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Try a different search term'
                : 'Tap + to create your first note',
            style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
