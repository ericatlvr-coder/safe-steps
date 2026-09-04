import 'package:flutter/material.dart';

void main() {
  runApp(const SafeStepsApp());
}

// ====================================================
// MAIN APP
// ====================================================

class SafeStepsApp extends StatelessWidget {
  const SafeStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeStepsScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Safe Steps',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6847FF),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}

// ====================================================
// HOST MODEL
// ====================================================

class Host {
  final String id;
  final String displayName;
  final String? jobTitle;

  const Host({
    required this.id,
    required this.displayName,
    this.jobTitle,
  });
}

// ====================================================
// CHECK-IN DRAFT MODEL
// ====================================================

class CheckInDraft {
  final String type;
  final String name;
  final String email;
  final String contactNumber;
  final String purpose;
  final String location;

  const CheckInDraft({
    required this.type,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.purpose,
    required this.location,
  });
}

// ====================================================
// STORE
// ====================================================

class SafeStepsStore {
  String location = 'Head Office';

  bool hostSyncing = false;

  String? hostSyncError;

  String hostSourceLabel = 'Local Demo Data';

  final List<Host> hosts = const [
    Host(
      id: '1',
      displayName: 'Sarah Johnson',
      jobTitle: 'Manager',
    ),
    Host(
      id: '2',
      displayName: 'Michael Brown',
      jobTitle: 'Team Leader',
    ),
    Host(
      id: '3',
      displayName: 'Jessica Smith',
      jobTitle: 'Support Worker',
    ),
    Host(
      id: '4',
      displayName: 'Daniel Wilson',
      jobTitle: 'Coordinator',
    ),
    Host(
      id: '5',
      displayName: 'Emily Davis',
      jobTitle: 'Administrator',
    ),
  ];

  void setLocation(String newLocation) {
    location = newLocation;
  }

  Future<void> checkIn(
    CheckInDraft draft,
    Host? host,
  ) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    debugPrint('--------------------------');
    debugPrint('CHECK-IN COMPLETED');
    debugPrint('Type: ${draft.type}');
    debugPrint('Name: ${draft.name}');
    debugPrint('Contact: ${draft.contactNumber}');
    debugPrint('Email: ${draft.email}');
    debugPrint('Purpose: ${draft.purpose}');
    debugPrint('Location: ${draft.location}');
    debugPrint(
      'Host: ${host?.displayName ?? 'Other'}',
    );
    debugPrint('--------------------------');
  }
}

// ====================================================
// SAFE STEPS SCOPE
// ====================================================

class SafeStepsScope extends InheritedWidget {
  SafeStepsScope({
    super.key,
    required super.child,
  });

  final SafeStepsStore store = SafeStepsStore();

  static SafeStepsStore of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SafeStepsScope>();

    if (scope == null) {
      throw Exception(
        'SafeStepsScope not found',
      );
    }

    return scope.store;
  }

  @override
  bool updateShouldNotify(
    SafeStepsScope oldWidget,
  ) {
    return false;
  }
}

// ====================================================
// KIOSK SHELL
// ====================================================

class KioskShell extends StatelessWidget {
  const KioskShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6847FF),
        foregroundColor: Colors.white,
        title: const Text(
          'Safe Steps',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}

// ====================================================
// TERMS LINK
// ====================================================

class TermsLink extends StatelessWidget {
  const TermsLink({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: const Text(
        'Terms and Conditions',
      ),
    );
  }
}

// ====================================================
// WELCOME SCREEN
// ====================================================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volunteer_activism,
              size: 80,
              color: Color(0xFF6847FF),
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome to Safe Steps',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Please select your check-in type.',
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 260,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CheckInFormScreen(
                        type: 'Individual',
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'Individual Check-In',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: 260,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CheckInFormScreen(
                        type: 'Group',
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'Group Check-In',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// CHECK IN FORM
// YOUR ORIGINAL CODE
// ====================================================

class CheckInFormScreen extends StatefulWidget {
  const CheckInFormScreen({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<CheckInFormScreen> createState() =>
      _CheckInFormScreenState();
}

class _CheckInFormScreenState
    extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();

  final _contact = TextEditingController();

  final _email = TextEditingController();

  final _purpose = TextEditingController();

  final _location = TextEditingController(
    text: 'Head Office',
  );

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _email.dispose();
    _purpose.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.type == 'Group';

    return KioskShell(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Check-in with us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 16),

            _field(
              _name,
              group
                  ? 'Organisation name'
                  : 'Full name',
            ),

            _field(
              _contact,
              group
                  ? 'Representative Contact Number'
                  : 'Contact Number',
              keyboard: TextInputType.phone,
            ),

            _field(
              _email,
              group
                  ? "Organisation's Email Address"
                  : 'Email Address',
              keyboard:
                  TextInputType.emailAddress,
              email: true,
            ),

            _field(
              _purpose,
              'Purpose of Visit',
            ),

            _field(
              _location,
              'Location Attended',
            ),

            const SizedBox(height: 4),

            TermsLink(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TermsScreen(),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.center,
              child: FilledButton(
                onPressed: _next,
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboard,
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: (value) {
          final text =
              value?.trim() ?? '';

          if (text.isEmpty) {
            return '$label is required';
          }

          if (email &&
              (!text.contains('@') ||
                  !text.contains('.'))) {
            return 'Enter a valid email address';
          }

          return null;
        },
      ),
    );
  }

  void _next() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final store =
        SafeStepsScope.of(context);

    final draft = CheckInDraft(
      type: widget.type,
      name: _name.text,
      email: _email.text,
      contactNumber: _contact.text,
      purpose: _purpose.text,
      location: _location.text,
    );

    store.setLocation(
      _location.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            HostSelectionScreen(
          draft: draft,
        ),
      ),
    );
  }
}

// ====================================================
// HOST SELECTION
// YOUR ORIGINAL CODE
// ====================================================

class HostSelectionScreen extends StatefulWidget {
  const HostSelectionScreen({
    super.key,
    required this.draft,
  });

  final CheckInDraft draft;

  @override
  State<HostSelectionScreen> createState() =>
      _HostSelectionScreenState();
}

class _HostSelectionScreenState
    extends State<HostSelectionScreen> {
  Host? selected;

  bool otherSelected = false;

  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final store =
        SafeStepsScope.of(context);

    final hosts =
        store.hosts.take(5).toList();

    return KioskShell(
      child: Column(
        children: [
          const Text(
            'Please select the person you are here to meet',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          if (store.hostSyncing)
            const LinearProgressIndicator(
              minHeight: 2,
            )
          else if (store.hostSyncError !=
              null)
            Text(
              store.hostSyncError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
              children: [
                ...hosts.map(_hostCard),
                _otherCard(),
              ],
            ),
          ),

          Text(
            'Hosts synced from ${store.hostSourceLabel}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),

          TermsLink(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const TermsScreen(),
                ),
              );
            },
          ),

          FilledButton(
            onPressed: saving ||
                    (selected == null &&
                        !otherSelected)
                ? null
                : _finish,
            child: Text(
              saving
                  ? 'Saving...'
                  : 'Finish',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hostCard(
    Host host,
  ) {
    final isSelected =
        selected?.id == host.id &&
            !otherSelected;

    return InkWell(
      onTap: () {
        setState(() {
          selected = host;
          otherSelected = false;
        });
      },
      borderRadius:
          BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(
                  0xFFD2FFA1,
                )
              : Colors.white
                  .withOpacity(0.78),
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: isSelected
                ? const Color(
                    0xFF6847FF,
                  )
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  const Color(
                0xFFE1E1E1,
              ),
              child: Text(
                _initials(
                  host.displayName,
                ),
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 4,
              ),
              child: Text(
                host.displayName,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),

            if (host.jobTitle != null)
              Text(
                host.jobTitle!,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize: 10,
                  color:
                      Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _otherCard() {
    return InkWell(
      onTap: () {
        setState(() {
          selected = null;
          otherSelected = true;
        });
      },
      borderRadius:
          BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: otherSelected
              ? const Color(
                  0xFFD2FFA1,
                )
              : Colors.white
                  .withOpacity(0.78),
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: otherSelected
                ? const Color(
                    0xFF6847FF,
                  )
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              child: Icon(
                Icons.more_horiz,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Other',
              style: TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(
    String name,
  ) {
    final bits = name
        .trim()
        .split(
          RegExp(r'\s+'),
        );

    if (bits.length == 1) {
      return bits.first
          .substring(0, 1)
          .toUpperCase();
    }

    return '${bits.first[0]}${bits.last[0]}'
        .toUpperCase();
  }

  Future<void> _finish() async {
    setState(() {
      saving = true;
    });

    final store =
        SafeStepsScope.of(context);

    try {
      await store.checkIn(
        widget.draft,
        selected,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const WelcomeScreen(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to complete check-in: $error',
          ),
        ),
      );
    }
  }
}

// ====================================================
// TERMS SCREEN
// ====================================================

class TermsScreen extends StatelessWidget {
  const TermsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: ListView(
        children: const [
          Text(
            'Terms and Conditions',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'By using this visitor check-in system, '
            'you agree that the information entered '
            'may be used for visitor management, '
            'safety, security and administrative purposes.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}