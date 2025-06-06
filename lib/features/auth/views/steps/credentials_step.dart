import 'package:flutter/material.dart';
import '../../models/registration_data.dart';

class CredentialsStep extends StatefulWidget {
  final RegistrationData data;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStepIndex;

  const CredentialsStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
    required this.currentStepIndex,
  });

  @override
  State<CredentialsStep> createState() => _CredentialsStepState();
}

class _CredentialsStepState extends State<CredentialsStep> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Добавляем контроллер для поля пароля
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose(); // Важно освобождать ресурсы контроллера
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'example@mail.com',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Wrong format of email';
                }
                return null;
              },
              onSaved: (value) => widget.data.email = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                errorMaxLines: 3, // <-- Добавьте эту строку
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Enter your password';
                if (value!.length < 8) return 'Minimum 8 characters required';
                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
                    .hasMatch(value)) {
                  return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                }
                return null;
              },
              onSaved: (value) => widget.data.password = value,
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              validator: (value) {
                // Сравниваем с текущим значением из контроллера
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onSaved: (value) => widget.data.password = value, // Возможно, это поле не нужно сохранять, если его роль только подтверждение
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.onNext();
                      }
                    },
                    child: const Text('Complete Registration'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}