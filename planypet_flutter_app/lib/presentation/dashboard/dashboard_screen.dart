import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pet_provider.dart';
import '../../core/utils/date_time_utils.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlanyPet'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(petsProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _GreetingCard(),
            const SizedBox(height: 16),
            _QuickStatsRow(petsAsync: petsAsync),
            const SizedBox(height: 16),
            _SectionTitle('Meine Tiere'),
            petsAsync.when(
              data: (pets) => pets.isEmpty
                  ? _EmptyPetsCard()
                  : Column(children: pets.map((p) => _PetCard(pet: p)).toList()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
            ),
            const SizedBox(height: 16),
            _SectionTitle('Heutige Aufgaben'),
            _TodayTasksCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Tier hinzufuegen'),
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Guten Morgen' : hour < 18 ? 'Guten Tag' : 'Guten Abend';
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

class _QuickStatsRow extends StatelessWidget {
  final AsyncValue petsAsync;
  const _QuickStatsRow({required this.petsAsync});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(icon: Icons.pets, label: 'Tiere',
            value: petsAsync.maybeWhen(data: (p) => '${p.length}', orElse: () => '-'))),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(icon: Icons.restaurant, label: 'Mahlzeiten', value: '0')),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(icon: Icons.alarm, label: 'Erinnerungen', value: '0')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _PetCard extends StatelessWidget {
  final dynamic pet;
  const _PetCard({required this.pet});
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
        onTap: () {},
      ),
    );
  }
}

class _EmptyPetsCard extends StatelessWidget {
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
            const Text('Tippe auf + um dein erstes Tier hinzuzufuegen'),
          ],
        ),
      ),
    );
  }
}

class _TodayTasksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            const Text('Keine offenen Aufgaben fuer heute'),
          ],
        ),
      ),
    );
  }
}
