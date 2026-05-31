import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/dot_grid_background.dart';
import '../../data/models/note.dart';
import '../../providers/notes_provider.dart';

/// Full-screen note editor for creating / editing notes.
class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _bodyCtrl;
  String? _category;
  bool _isPinned = false;

  bool get _isEditing => widget.note != null;

  static const _categories = ['WORK', 'URGENT', 'CREATIVE'];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _bodyCtrl = TextEditingController(text: widget.note?.body ?? '');
    _category = widget.note?.category;
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty) return;

    final provider = context.read<NotesProvider>();
    final now = DateTime.now();

    if (_isEditing) {
      provider.updateNote(
        widget.note!.copyWith(
          title: title,
          body: body,
          category: _category,
          isPinned: _isPinned,
          updatedAt: now,
        ),
      );
    } else {
      provider.addNote(
        Note(
          title: title,
          body: body,
          category: _category,
          isPinned: _isPinned,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    if (_isEditing && widget.note!.id != null) {
      context.read<NotesProvider>().deleteNote(widget.note!.id!);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Toolbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: cs.onSurfaceVariant,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    // Pin toggle
                    IconButton(
                      icon: Icon(
                        _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        color: _isPinned ? cs.primary : cs.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _isPinned = !_isPinned),
                    ),
                    if (_isEditing)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent.shade200,
                        ),
                        onPressed: _delete,
                      ),
                    IconButton(
                      icon: Icon(Icons.check, color: cs.primary),
                      onPressed: _save,
                    ),
                  ],
                ),
              ),

              // Category chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _categories.map((cat) {
                    final selected = _category == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selected,
                        selectedColor: cs.primary.withValues(alpha: 0.2),
                        backgroundColor: cs.surface,
                        side: BorderSide(
                          color: selected ? cs.primary : cs.outline,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                        ),
                        onSelected: (v) {
                          setState(() => _category = v ? cat : null);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Timestamp display
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _isEditing && widget.note != null
                        ? [
                            Icon(
                              Icons.calendar_today,
                              size: 13,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Created ${DateFormat('MMM dd, yyyy – hh:mm a').format(widget.note!.createdAt.toLocal())}',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.edit_outlined,
                              size: 13,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edited ${DateFormat('MMM dd, yyyy – hh:mm a').format(widget.note!.updatedAt.toLocal())}',
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ]
                        : [
                            Icon(
                              Icons.schedule,
                              size: 13,
                              color: cs.primary.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat(
                                'MMM dd, yyyy – hh:mm a',
                              ).format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _titleCtrl,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),

              // Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _bodyCtrl,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 15,
                      color: cs.onSurface.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Start writing...',
                      hintStyle: TextStyle(color: cs.onSurfaceVariant),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
