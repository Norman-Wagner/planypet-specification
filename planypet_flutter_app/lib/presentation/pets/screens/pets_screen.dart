import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/pet_provider.dart';
import '../../../data/models/pet_model.dart';

class PetsScreen extends ConsumerWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Tiere'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: petsAsync.when(
        data: (pets) => pets.isEmpty ? _EmptyState() : _PetGrid(pets: pets),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text('Fehler beim Laden: $e'),
              ElevatedButton(
                onPressed: () => ref.refresh(petsProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPetDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Tier hinzufuegen'),
      ),
    );
  }

  void _showAddPetDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const _AddPetSheet(),
      ),
    );
  }
}

class _PetGrid extends StatelessWidget {
  final List<PetModel> pets;
  const _PetGrid({required this.pets});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) => _PetGridCard(pet: pets[index]),
    );
  }
}

class _PetGridCard extends StatelessWidget {
  final PetModel pet;
  const _PetGridCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('${AppConstants.petsRoute}/${pet.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: pet.avatarUrl != null
                  ? Image.network(pet.avatarUrl!, fit: BoxFit.cover)
                  : Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.pets, size: 64),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    '${pet.species}${pet.breed != null ? " · ${pet.breed}" : ""}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('Noch keine Tiere', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Tippe auf + um dein erstes Tier hinzuzufuegen', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AddPetSheet extends StatefulWidget {
  const _AddPetSheet();
  @override
  State<_AddPetSheet> createState() => _AddPetSheetState();
}

class _AddPetSheetState extends State<_AddPetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedSpecies = 'Dog';
  final _species = ['Dog', 'Cat', 'Bird', 'Reptile', 'Fish', 'Exotic'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Neues Tier', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.pets)),
              validator: (v) => v == null || v.isEmpty ? 'Bitte Namen eingeben' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedSpecies,
              decoration: const InputDecoration(labelText: 'Tierart'),
              items: _species.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _selectedSpecies = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Tier hinzufuegen'),
            ),
          ],
        ),
      ),
    );
  }
}
