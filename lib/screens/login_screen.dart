import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_tab_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signInWithEmailAndPassword() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        showErrorDialog("Perfil de usuário não encontrado.");
        return;
      }

      String userRole = userDoc.get('role') ?? 'member';

      if (userRole == 'admin' || userRole == 'member') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainTabNavigator(userRole: userRole),
          ),
        );
      } else {
        showErrorDialog("Acesso negado. Usuário sem permissão.");
      }
    } catch (error) {
      showErrorDialog(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Erro na Autenticação"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email Address"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signInWithEmailAndPassword,
                    child: const Text("Sign In"),
                  ),
          ],
        ),
      ),
    );
  }
}
