import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database/database_service.dart';
import '../data/models/task.dart';

/// Provider for tasks state — supports any date, not just yesterday/today/tomorrow.
class TasksProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  List<Task> _tasks = [];
  int _selectedDayOffset = 0; // -1 = yesterday, 0 = today, 1 = tomorrow, or any offset
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  int get selectedDayOffset => _selectedDayOffset;
  bool get isLoading => _isLoading;

  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get doneTasks => _tasks.where((t) => t.isCompleted).toList();
  int get pendingCount => pendingTasks.length;

  /// Whether the currently selected date is outside the -1/0/1 range.
  bool get isCustomDate =>
      _selectedDayOffset < -1 || _selectedDayOffset > 1;

  String get selectedDateStr {
    final d = DateTime.now().add(Duration(days: _selectedDayOffset));
    return DateFormat('yyyy-MM-dd').format(d);
  }

  DateTime get selectedDate =>
      DateTime.now().add(Duration(days: _selectedDayOffset));

  String get displayDate {
    final d = DateTime.now().add(Duration(days: _selectedDayOffset));
    return DateFormat('MMM dd').format(d).toUpperCase();
  }

  void selectDay(int offset) {
    _selectedDayOffset = offset;
    loadTasks();
  }

  /// Navigate to a specific date string (yyyy-MM-dd).
  void selectDate(String dateStr) {
    final target = DateTime.tryParse(dateStr);
    if (target == null) return;
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final targetNorm = DateTime(target.year, target.month, target.day);
    final diff = targetNorm.difference(todayNorm).inDays;
    _selectedDayOffset = diff;
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _db.getTasksByDate(selectedDateStr);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _db.insertTask(task);
    // After adding, navigate to the task's date so user sees it
    selectDate(task.date);
  }

  Future<void> toggleComplete(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _db.updateTask(updated);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _db.updateTask(task);
    // After updating, navigate to the task's date so user sees it
    selectDate(task.date);
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);
    await loadTasks();
  }
}
