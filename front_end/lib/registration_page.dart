import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final message = await authService.register(
        _nameController.text,
        _surnameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(); // Torna alla pagina di login
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrazione')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (val) =>
                        val!.isEmpty ? 'Campo obbligatorio' : null),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _surnameController,
                    decoration: const InputDecoration(labelText: 'Cognome'),
                    validator: (val) =>
                        val!.isEmpty ? 'Campo obbligatorio' : null),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => !(val?.contains('@') ?? false)
                        ? 'Email non valida'
                        : null),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (val) =>
                        (val?.length ?? 0) < 6 ? 'Minimo 6 caratteri' : null),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                      onPressed: _submit, child: const Text('Registrati')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
