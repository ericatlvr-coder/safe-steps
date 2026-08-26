import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';

class LocationPickerScreen extends StatelessWidget {
  const LocationPickerScreen({super.key});

  static const locations = ['Head Office', "Virginia's Place", "Nic's Place", 'Other location'];

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);
    return AppShell(
      title: 'Choose location',
      showDrawer: false,
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final location = locations[index];
          final selected = location == store.currentLocation;
          return ListTile(
            tileColor: selected ? SafeStepsColors.lime : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Icon(selected ? Icons.location_on : Icons.location_on_outlined),
            title: Text(location),
            trailing: selected ? const Icon(Icons.check, color: SafeStepsColors.purple) : null,
            onTap: () {
              store.setLocation(location);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
