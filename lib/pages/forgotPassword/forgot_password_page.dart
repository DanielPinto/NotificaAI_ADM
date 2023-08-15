import 'package:appnotify_adm/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();
  String alert = "";
  bool progress = false;

  bool obscureTextRepeatPassword = true;
  bool obscureTextPassword = true;
  int passwordZise = 8;

  bool fieldsIsEmpt() => email.text == "";

  _sendPasswordResetEmail() async {
    try {
      setState(() {
        progress = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      setState(() {
        progress = false;
        alert = 'Email enviado!';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        progress = false;
        alert = '* ERRO: $e.message';
      });
    }
  }

  /*
  Widget getIconCheck(bool status) => status
      ? const Icon(
          Icons.check,
          color: Colors.green,
          size: 20,
        )
      : const Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
          size: 20,
        );
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: progress
                      ? const CircularProgressIndicator(
                          strokeWidth: 1.5,
                        )
                      : Container()),
              const SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 5.0,
                shadowColor: Colors.grey.shade300,
                child: TextField(
                  onTap: () => setState(() {
                    alert = "";
                  }),
                  onChanged: (_) => setState(() {}),
                  controller: email,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    label: const Text("E-mail"),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8.0),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[50],
                  elevation: 5.0,
                  minimumSize:
                      Size((MediaQuery.of(context).size.width) / 2, 50),
                ),
                onPressed: (() => _sendPasswordResetEmail()),
                child: const Text(
                  "ENVIAR",
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(alert,
                  style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              const SizedBox(
                height: 10,
              ),
              Material(
                color: Colors.grey[300],
                child: TextButton(
                    child: const Text("Voltar para Tela de Login"),
                    onPressed: () =>
                        Navigator.of(Routes.navigatorKey!.currentContext!)
                            .pushReplacementNamed('/login')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
