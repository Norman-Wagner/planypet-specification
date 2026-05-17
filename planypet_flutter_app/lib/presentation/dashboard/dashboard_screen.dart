import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_time_utils.dart';
import '../../providers/feeding_log_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/reminder_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);
    final latestFeedingAsync = ref.watch(latestFeedingProvider);
    final upcomingAsync = ref.watch(upcomingRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlanyPet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'KI-Assistent',
            onPressed: () => context.push(AppConstants.chatRoute),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppConstants.remindersRoute),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(petsProvider);
          ref.invalidate(latestFeedingProvider);
          ref.invalidate(remindersProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _GreetingCard(),
            const SizedBox(height: 16),
            _QuickStatsRow(petsAsync: petsAsync),
            const SizedBox(height: 16),
            const _SectionTitle('Letzte Fütterung'),
            _LatestFeedingCard(async: latestFeedingAsync),
            const SizedBox(height: 16),
            const _SectionTitle('Anstehende Erinnerungen'),
            _UpcomingRemindersCard(async: upcomingAsync),
            const SizedBox(height: 16),
            const _SectionTitle('Meine Tiere'),
            petsAsync.when(
              data: (pets) => pets.isEmpty
                  ? const _EmptyPetsCard()
                  : Column(children: pets.map((p) => _PetCard(pet: p)).toList()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppConstants.feedingLogRoute),
        icon: const Icon(Icons.restaurant),
        label: const Text('Fütterung erfassen'),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard();
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Guten Morgen'
        : hour < 18
            ? 'Guten Tag'
            : 'Guten Abend';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 24, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: Theme.of(context).textTheme.titleMedium),
                Text(DateTimeUtils.formatDate(DateTime.now()),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsRow extends ConsumerWidget {
  const _QuickStatsRow({required this.petsAsync});
  final AsyncValue petsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);
    final openReminders = remindersAsync.maybeWhen(
      data: (list) => list.where((r) => !r.completed).length.toString(),
      orElse: () => '-',
    );
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.pets,
            label: 'Tiere',
            value: petsAsync.maybeWhen(
              data: (p) => '${p.length}',
              orElse: () => '-',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.alarm,
            label: 'Offene Reminder',
            value: openReminders,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _LatestFeedingCard extends StatelessWidget {
  const _LatestFeedingCard({required this.async});
  final AsyncValue async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(padding: const EdgeInsets.all(16), child: Text('Fehler: $e')),
      ),
      data: (log) {
        if (log == null) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.restaurant_outlined),
              title: Text('Noch keine Fütterung erfasst'),
              subtitle: Text('Tippe auf den Button unten, um zu starten.'),
            ),
          );
        }
        return Card(
          child: ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text(log.foodName ?? 'Mahlzeit'),
            subtitle: Text(
              '${DateTimeUtils.getRelativeTime(log.fedAt.toLocal())}'
              '${log.portionGrams != null ? " · ${log.portionGrams} g" : ""}',
            ),
          ),
        );
      },
    );
  }
}

class _UpcomingRemindersCard extends StatelessWidget {
  const _UpcomingRemindersCard({required this.async});
  final AsyncValue async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(padding: const EdgeInsets.all(16), child: Text('Fehler: $e')),
      ),
      data: (reminders) {
        if (reminders.isEmpty) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.alarm_off_outlined),
              title: Text('Keine offenen Erinnerungen'),
            ),
          );
        }
        return Card(
          child: Column(
            children: reminders
                .map<Widget>((r) => ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(r.title),
                      subtitle: Text(DateTimeUtils.formatDateTime(r.dueAt.toLocal())),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet});
  final dynamic pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: pet.avatarUrl != null ? NetworkImage(pet.avatarUrl!) : null,
          child: pet.avatarUrl == null ? const Icon(Icons.pets) : null,
        ),
        title: Text(pet.name),
        subtitle: Text('${pet.species}${pet.breed != null ? " · ${pet.breed}" : ""}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('${AppConstants.petsRoute}/${pet.id}'),
      ),
    );
  }
}

class _EmptyPetsCard extends StatelessWidget {
  const _EmptyPetsCard();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.pets, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text('Noch keine Tiere', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text('Tippe auf + um dein erstes Tier hinzuzufügen'),
          ],
        ),
      ),
    );
  }
}
