import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final cpf = TextEditingController();
  final tel = TextEditingController();
  final email = TextEditingController();
  final user = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    final url = Uri.parse("https://felpsti.com.br/backend_financas/auth/register.php");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nome": name.text,
        "cpf": cpf.text,
        "telefone": tel.text,
        "email": email.text,
        "user": user.text,
        "pass": pass.text,
      }),
    );

    setState(() => loading = false);
    if (!mounted) return;

    final body = jsonDecode(res.body);

    if (body["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário registrado!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body["message"] ?? "Erro ao registrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: "Nome")),
              TextField(controller: cpf, decoration: const InputDecoration(labelText: "CPF")),
              TextField(controller: tel, decoration: const InputDecoration(labelText: "Telefone")),
              TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: user, decoration: const InputDecoration(labelText: "Usuário")),
              TextField(controller: pass, decoration: const InputDecoration(labelText: "Senha"), obscureText: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Criar conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
