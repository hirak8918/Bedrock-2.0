import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/task.dart';
import '../../providers/tasks_provider.dart';
import '../../widgets/bedrock_app_bar.dart';
import '../../widgets/bedrock_fab.dart';
import '../../widgets/section_header.dart';
import 'widgets/date_pill_tabs.dart';
import 'widgets/task_card.dart';
import 'task_editor_screen.dart';

/// Tasks / Schedule screen — pixel-perfect match to "Task.png".
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Future<void> _openEditor({Task? task}) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => TaskEditorScreen(task: task)));
    if (!mounted) return;
    context.read<TasksProvider>().loadTasks();
  }

  Future<void> _pickDate() async {
    final tasks = context.read<TasksProvider>();
    final picked = await showDatePicker(
      context: context,
      initialDate: tasks.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      tasks.selectDate(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const BedrockAppBar(),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Schedule header + date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          tasks.displayDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date pills
                    DatePillTabs(
                      selectedOffset: tasks.selectedDayOffset,
                      onChanged: (offset) => tasks.selectDay(offset),
                      onCalendarTap: _pickDate,
                    ),
                    const SizedBox(height: 20),

                    // ── Pending section ────────────────────
                    SectionHeader(
                      icon: Icons.access_time,
                      title: 'Pending',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: cs.outline, width: 1),
                        ),
                        child: Text(
                          '${tasks.pendingCount}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ),

                    if (tasks.pendingTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No pending tasks',
                            style: TextStyle(
                              fontSize: 14,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    else
                      ...tasks.pendingTasks.map((task) {
                        return TaskCard(
                          task: task,
                          onToggle: () => tasks.toggleComplete(task),
                          onTap: () => _openEditor(task: task),
                        );
                      }),

                    const SizedBox(height: 16),

                    // ── Done section ───────────────────────
                    SectionHeader(
                      icon: Icons.done_all,
                      title: 'Done',
                      iconColor: cs.onSurfaceVariant,
                    ),

                    if (tasks.doneTasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No completed tasks',
                            style: TextStyle(
                              fontSize: 14,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    else
                      ...tasks.doneTasks.map((task) {
                        return TaskCard(
                          task: task,
                          onToggle: () => tasks.toggleComplete(task),
                        );
                      }),

                    const SizedBox(height: 220),
                  ],
                ),

                // FAB
                Positioned(
                  right: 16,
                  bottom: 160, // Shifted up further to avoid dock overlap
                  child: BedrockFab(onPressed: () => _openEditor()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
