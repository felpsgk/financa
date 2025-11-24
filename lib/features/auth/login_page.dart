import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'session_storage.dart';
import 'auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> login() async {
    setState(() => loading = true);

    final Uri url = Uri.parse("https://felpsti.com.br/backend_financas/auth/login.php");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": userCtrl.text.trim(),
        "pass": passCtrl.text.trim(),
      }),
    );

    setState(() => loading = false);
    if (!mounted) return;

    if (res.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Servidor indisponível")),
      );
      return;
    }

    final body = jsonDecode(res.body);

    if (body["success"] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body["message"] ?? "Login inválido")),
      );
      return;
    }

    // Salvar usuário no provider
    ref.read(userIdProvider.notifier).state = body["data"]["id"];

    // Persistir por 1 hora
    await _persistSession((body["data"]["id"] as num).toInt(), const Duration(hours: 1));

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/summary');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userCtrl,
                  decoration: const InputDecoration(labelText: "Usuário"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Senha"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Entrar"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/register"),
                  child: const Text("Criar conta"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on _LoginPageState {
  Future<void> _persistSession(int userId, Duration ttl) async {
    const SessionStorage storage = SessionStorage();
    final int exp = DateTime.now().add(ttl).millisecondsSinceEpoch;
    await storage.writeString(key: 'USER_ID', value: userId.toString());
    await storage.writeString(key: 'SESSION_EXP', value: exp.toString());
  }

  Future<void> _restoreSession() async {
    const SessionStorage storage = SessionStorage();
    final String? idStr = await storage.readString(key: 'USER_ID');
    final String? expStr = await storage.readString(key: 'SESSION_EXP');
    if (idStr == null || expStr == null) return;
    final int? id = int.tryParse(idStr);
    final int? exp = int.tryParse(expStr);
    if (id == null || exp == null) return;
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= exp) {
      await storage.delete(key: 'USER_ID');
      await storage.delete(key: 'SESSION_EXP');
      return;
    }
    ref.read(userIdProvider.notifier).state = id;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/summary');
  }
}
