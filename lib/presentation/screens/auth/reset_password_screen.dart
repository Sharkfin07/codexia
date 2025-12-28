import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_palette.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authStateProvider).value;
    final email = user?.email;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (email == null || email.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No email found for the current user.')),
      );
      return;
    }

    final notifier = ref.read(authControllerProvider.notifier);
    try {
      await notifier.changePassword(
        email: email,
        currentPassword: _currentCtrl.text.trim(),
        newPassword: _newCtrl.text.trim(),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Password updated successfully.')),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final scheme = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.lock_reset),
            SizedBox(width: 10),
            Text('Change Password'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your current password and choose a new password.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current password',
                    filled: true,
                    fillColor: scheme.surface.withValues(alpha: 0.08),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: scheme.primary, width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    filled: true,
                    fillColor: scheme.surface.withValues(alpha: 0.08),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: scheme.primary, width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'New password is required';
                    }
                    final hasLetter = v.contains(RegExp(r'[A-Za-z]'));
                    final hasDigit = v.contains(RegExp(r'\d'));
                    if (v.length < 8 || !hasLetter || !hasDigit) {
                      return 'Use at least 8 characters with letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm new password',
                    filled: true,
                    fillColor: scheme.surface.withValues(alpha: 0.08),
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: scheme.primary, width: 1.5),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please confirm the new password';
                    }
                    if (v != _newCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: isLoading ? null : _submit,
                  icon: const Icon(Icons.lock_reset),
                  label: Text(isLoading ? 'Updating...' : 'Update password'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppPalette.darkPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
