import 'package:flutter/material.dart';

import '../models/checkin_draft.dart';
import '../state/safe_steps_store.dart';
import '../widgets/kiosk_shell.dart';
import 'host_selection_screen.dart';
import 'terms_screen.dart';

class CheckInFormScreen extends StatefulWidget {
  const CheckInFormScreen({super.key, required this.type});
  final String type;

  @override
  State<CheckInFormScreen> createState() => _CheckInFormScreenState();
}

class _CheckInFormScreenState extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _purpose = TextEditingController();
  final _location = TextEditingController(text: 'Head Office');

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
            const Text('Check-in with us', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 16),
            _field(_name, group ? 'Organisation name' : 'Full name'),
            _field(_contact, group ? 'Representative Contact Number' : 'Contact Number', keyboard: TextInputType.phone),
            _field(_email, group ? "Organisation's Email Address" : 'Email Address', keyboard: TextInputType.emailAddress, email: true),
            _field(_purpose, 'Purpose of Visit'),
            _field(_location, 'Location Attended'),
            const SizedBox(height: 4),
            TermsLink(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()))),
            Align(
              alignment: Alignment.center,
              child: FilledButton(
                onPressed: _next,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Text('Next', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label, {TextInputType? keyboard, bool email = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return '$label is required';
          if (email && (!text.contains('@') || !text.contains('.'))) return 'Enter a valid email address';
          return null;
        },
      ),
    );
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    final store = SafeStepsScope.of(context);
    final draft = CheckInDraft(
      type: widget.type,
      name: _name.text,
      email: _email.text,
      contactNumber: _contact.text,
      purpose: _purpose.text,
      location: _location.text,
    );
    store.setLocation(_location.text.trim());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HostSelectionScreen(draft: draft)),
    );
  }
}
