import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/models/reminder_model.dart';
import '../../../providers/pet_provider.dart';
import '../../../providers/reminder_provider.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Erinnerungen')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(remindersProvider),
        child: remindersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (reminders) {
            if (reminders.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(child: Icon(Icons.alarm_off, size: 56, color: Colors.grey)),
                  SizedBox(height: 8),
                  Center(child: Text('Keine Erinnerungen vorhanden.')),
                ],
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              itemBuilder: (_, i) => _ReminderTile(reminder: reminders[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Neue Erinnerung'),
        onPressed: () => _openAddSheet(context, ref),
      ),
    );
  }

  Future<void> _openAddSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddReminderSheet(),
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});

  final ReminderModel reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('reminder-${reminder.id}'),
      direction: reminder.completed
          ? DismissDirection.none
          : DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.green.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('Erledigt', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        if (reminder.completed) return false;
        await ref.read(reminderRepositoryProvider).markComplete(reminder);
        ref.invalidate(remindersProvider);
        return false;
      },
      child: Card(
        child: ListTile(
          leading: Icon(
            reminder.completed ? Icons.check_circle : Icons.alarm,
            color: reminder.completed ? Colors.green : null,
          ),
          title: Text(
            reminder.title,
            style: TextStyle(
              decoration: reminder.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(DateTimeUtils.formatDateTime(reminder.dueAt.toLocal())),
        ),
      ),
    );
  }
}

class _AddReminderSheet extends ConsumerStatefulWidget {
  const _AddReminderSheet();

  @override
  ConsumerState<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends ConsumerState<_AddReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _dueAt = DateTime.now().add(const Duration(hours: 1));
  String? _petId;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(reminderRepositoryProvider).add(
            familyId: familyId,
            title: _titleController.text.trim(),
            dueAt: _dueAt,
            petId: _petId,
          );
      ref.invalidate(remindersProvider);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petsProvider);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, viewInsets + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Neue Erinnerung',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel *'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Bitte Titel eingeben'
                  : null,
            ),
            const SizedBox(height: 12),
            petsAsync.maybeWhen(
              data: (pets) => DropdownButtonFormField<String?>(
                value: _petId,
                decoration: const InputDecoration(labelText: 'Tier (optional)'),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('— allgemein —')),
                  ...pets.map((p) => DropdownMenuItem<String?>(
                        value: p.id,
                        child: Text(p.name),
                      )),
                ],
                onChanged: (v) => setState(() => _petId = v),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Fällig am'),
              subtitle: Text(DateTimeUtils.formatDateTime(_dueAt)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueAt,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                );
                if (picked == null || !mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_dueAt),
                );
                if (!mounted) return;
                setState(() {
                  _dueAt = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    time?.hour ?? _dueAt.hour,
                    time?.minute ?? _dueAt.minute,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
