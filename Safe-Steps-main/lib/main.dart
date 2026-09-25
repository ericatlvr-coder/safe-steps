import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/welcome_screen.dart';
import 'services/host_service.dart';
import 'services/visitor_repository.dart';
import 'state/safe_steps_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = SafeStepsStore(
    hostService: LocalHostService(),
    visitorRepository: const VisitorRepository(),
  );

  await store.initialise();

  runApp(
    SafeStepsScope(
      store: store,
      child: const SafeStepsApp(),
    ),
  );
}

class SafeStepsApp extends StatelessWidget {
  const SafeStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Steps',
      debugShowCheckedModeBanner: false,
      theme: buildSafeStepsTheme(),
      home: const WelcomeScreen(),
    );
  }
}