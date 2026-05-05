import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../providers/feeding_log_provider.dart';
import '../../../providers/pet_provider.dart';

class FeedingLogScreen extends ConsumerWidget {
  const FeedingLogScreen({super.key, this.initialPetId});

  final String? initialPetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fütterungs-Log')),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (pets) {
          if (pets.isEmpty) {
            return const Center(child: Text('Lege erst ein Tier an.'));
          }
          final activePetId = initialPetId ?? pets.first.id;
          return _LogList(petId: activePetId);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Eintrag hinzufügen'),
        onPressed: () => _openAddSheet(context, ref),
      ),
    );
  }

  Future<void> _openAddSheet(BuildContext context, WidgetRef ref) async {
    final pets = await ref.read(petsProvider.future);
    if (pets.isEmpty) return;
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddFeedingSheet(initialPetId: initialPetId ?? pets.first.id),
    );
  }
}

class _LogList extends ConsumerWidget {
  const _LogList({required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(feedingLogForPetProvider(petId));
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(feedingLogForPetProvider(petId)),
      child: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (logs) {
          if (logs.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 80),
                Center(child: Icon(Icons.restaurant, size: 56, color: Colors.grey)),
                SizedBox(height: 8),
                Center(child: Text('Noch keine Fütterungen erfasst.')),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: logs.length,
            itemBuilder: (_, i) {
              final log = logs[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: Text(log.foodName ?? 'Mahlzeit'),
                  subtitle: Text(
                    '${DateTimeUtils.formatDateTime(log.fedAt.toLocal())}'
                    '${log.portionGrams != null ? " · ${log.portionGrams} g" : ""}',
                  ),
                  trailing: log.synced
                      ? const Icon(Icons.cloud_done, size: 20, color: Colors.grey)
                      : const Icon(Icons.cloud_off, size: 20, color: Colors.orange),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddFeedingSheet extends ConsumerStatefulWidget {
  const _AddFeedingSheet({required this.initialPetId});

  final String initialPetId;

  @override
  ConsumerState<_AddFeedingSheet> createState() => _AddFeedingSheetState();
}

class _AddFeedingSheetState extends ConsumerState<_AddFeedingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _foodController = TextEditingController();
  final _portionController = TextEditingController();
  final _notesController = TextEditingController();
  late String _petId;
  DateTime _fedAt = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _petId = widget.initialPetId;
  }

  @override
  void dispose() {
    _foodController.dispose();
    _portionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final familyId = ref.read(currentFamilyIdProvider);
    if (familyId == null) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(feedingLogRepositoryProvider);
      await repo.add(
        petId: _petId,
        familyId: familyId,
        fedAt: _fedAt,
        foodName: _foodController.text.trim().isEmpty ? null : _foodController.text.trim(),
        portionGrams: int.tryParse(_portionController.text.trim()),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      ref.invalidate(feedingLogForPetProvider(_petId));
      ref.invalidate(latestFeedingProvider);
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
            Text('Fütterung erfassen',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            petsAsync.maybeWhen(
              data: (pets) => DropdownButtonFormField<String>(
                value: _petId,
                decoration: const InputDecoration(labelText: 'Tier'),
                items: pets
                    .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (v) => setState(() => _petId = v ?? _petId),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _foodController,
              decoration: const InputDecoration(labelText: 'Futter (optional)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _portionController,
              decoration: const InputDecoration(labelText: 'Portion in Gramm (optional)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                return int.tryParse(v) == null ? 'Bitte eine ganze Zahl' : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notizen (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Zeitpunkt'),
              subtitle: Text(DateTimeUtils.formatDateTime(_fedAt)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _fedAt,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (picked == null || !mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_fedAt),
                );
                if (!mounted) return;
                setState(() {
                  _fedAt = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    time?.hour ?? _fedAt.hour,
                    time?.minute ?? _fedAt.minute,
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
