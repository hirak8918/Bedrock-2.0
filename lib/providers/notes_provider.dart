import 'package:flutter/material.dart';
import '../data/database/database_service.dart';
import '../data/models/note.dart';

/// Provider for notes state — fully offline, synchronous reads.
class NotesProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  List<Note> _pinnedNotes = [];
  List<Note> _recentNotes = [];
  bool _isLoading = true;

  // ── Multi-select state ──────────────────────────────────
  bool _isSelecting = false;
  final Set<int> _selectedIds = {};

  List<Note> get pinnedNotes => _pinnedNotes;
  List<Note> get recentNotes => _recentNotes;
  bool get isLoading => _isLoading;

  bool get isSelecting => _isSelecting;
  Set<int> get selectedIds => _selectedIds;
  int get selectedCount => _selectedIds.length;

  // ── Search state ────────────────────────────────────────
  String _searchQuery = '';
  bool _isSearching = false;

  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;

  List<Note> get filteredPinnedNotes {
    if (_searchQuery.isEmpty) return _pinnedNotes;
    final q = _searchQuery.toLowerCase();
    return _pinnedNotes
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.body.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Note> get filteredRecentNotes {
    if (_searchQuery.isEmpty) return _recentNotes;
    final q = _searchQuery.toLowerCase();
    return _recentNotes
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.body.toLowerCase().contains(q),
        )
        .toList();
  }

  // ── Search methods ──────────────────────────────────────

  void startSearch() {
    _isSearching = true;
    _searchQuery = '';
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    _searchQuery = '';
    notifyListeners();
  }

  // ── Selection methods ───────────────────────────────────

  void startSelecting(int id) {
    _isSelecting = true;
    _selectedIds.add(id);
    notifyListeners();
  }

  void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) _isSelecting = false;
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _isSelecting = false;
    _selectedIds.clear();
    notifyListeners();
  }

  void selectAll() {
    for (final n in _pinnedNotes) {
      if (n.id != null) _selectedIds.add(n.id!);
    }
    for (final n in _recentNotes) {
      if (n.id != null) _selectedIds.add(n.id!);
    }
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    for (final id in _selectedIds) {
      await _db.deleteNote(id);
    }
    _selectedIds.clear();
    _isSelecting = false;
    await loadNotes();
  }

  // ── CRUD ────────────────────────────────────────────────

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    _pinnedNotes = await _db.getPinnedNotes();
    _recentNotes = await _db.getRecentNotes();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _db.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _db.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _db.deleteNote(id);
    await loadNotes();
  }

  Future<void> togglePin(Note note) async {
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await _db.updateNote(updated);
    await loadNotes();
  }
}
