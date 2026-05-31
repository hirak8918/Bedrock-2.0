import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dot_grid_background.dart';
import '../../data/models/task.dart';
import '../../providers/tasks_provider.dart';

/// Task editor for creating / editing tasks.
class TaskEditorScreen extends StatefulWidget {
  final Task? task;

  const TaskEditorScreen({super.key, this.task});

  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  String? _priority;
  late String _date;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority;
    _date =
        widget.task?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final provider = context.read<TasksProvider>();

    if (_isEditing) {
      provider.updateTask(
        widget.task!.copyWith(
          title: title,
          description: _descCtrl.text.trim(),
          priority: _priority,
          date: _date,
        ),
      );
    } else {
      provider.addTask(
        Task(
          title: title,
          description: _descCtrl.text.trim(),
          priority: _priority,
          date: _date,
          createdAt: DateTime.now(),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  void _delete() {
    if (_isEditing && widget.task!.id != null) {
      context.read<TasksProvider>().deleteTask(widget.task!.id!);
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      TextField(
                        controller: _titleCtrl,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Task title',
                          hintStyle: TextStyle(color: cs.onSurfaceVariant),
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                          filled: false,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      TextField(
                        controller: _descCtrl,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 15,
                          color: cs.onSurface.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add description...',
                          hintStyle: TextStyle(color: cs.onSurfaceVariant),
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                          filled: false,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Priority selector
                      Text(
                        'PRIORITY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['HIGH', 'ROUTINE'].map((p) {
                          final selected = _priority == p;
                          final chipColor = p == 'HIGH'
                              ? AppColors.priorityHigh
                              : cs.primary;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(p),
                              selected: selected,
                              selectedColor: chipColor.withValues(alpha: 0.15),
                              backgroundColor: cs.surface,
                              side: BorderSide(
                                color: selected ? chipColor : cs.outline,
                              ),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: selected
                                    ? chipColor
                                    : cs.onSurfaceVariant,
                              ),
                              onSelected: (v) {
                                setState(() => _priority = v ? p : null);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Date display
                      GestureDetector(
                        onTap: () async {
                          final initialDate = DateTime.tryParse(_date) ?? DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _date = DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: cs.outline, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: cs.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _date,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
