import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../providers/feeding_log_provider.dart';
import '../../../providers/pet_provider.dart';

class PetDetailScreen extends ConsumerWidget {
  const PetDetailScreen({super.key, required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);
    final feedingsAsync = ref.watch(feedingLogForPetProvider(petId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tier-Detail'),
      ),
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (pets) {
          final matches = pets.where((p) => p.id == petId).toList();
          if (matches.isEmpty) {
            return const Center(child: Text('Tier nicht gefunden'));
          }
          final pet = matches.first;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage:
                      pet.avatarUrl != null ? NetworkImage(pet.avatarUrl!) : null,
                  child: pet.avatarUrl == null
                      ? const Icon(Icons.pets, size: 56)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  pet.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 24),
              _InfoTile(label: 'Spezies', value: pet.species),
              if (pet.breed != null) _InfoTile(label: 'Rasse', value: pet.breed!),
              if (pet.gender != null) _InfoTile(label: 'Geschlecht', value: pet.gender!),
              if (pet.dateOfBirth != null)
                _InfoTile(
                  label: 'Alter',
                  value: DateTimeUtils.getAge(pet.dateOfBirth!),
                ),
              if (pet.weight != null)
                _InfoTile(label: 'Gewicht', value: '${pet.weight} g'),
              if (pet.chipNumber != null)
                _InfoTile(label: 'Chip-Nummer', value: pet.chipNumber!),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.restaurant),
                label: const Text('Fütterungs-Log öffnen'),
                onPressed: () => context.push('${AppConstants.feedingLogRoute}?petId=$petId'),
              ),
              const SizedBox(height: 24),
              Text(
                'Letzte Fütterungen',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              feedingsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Fehler: $e'),
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Noch keine Fütterungen erfasst.'),
                      ),
                    );
                  }
                  return Column(
                    children: logs.take(5).map((log) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.restaurant),
                          title: Text(log.foodName ?? 'Mahlzeit'),
                          subtitle: Text(
                            '${DateTimeUtils.getRelativeTime(log.fedAt)}'
                            '${log.portionGrams != null ? " · ${log.portionGrams} g" : ""}',
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }
}

