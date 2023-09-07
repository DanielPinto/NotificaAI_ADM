import 'package:appnotify_adm/Data/database_helper.dart';
import 'package:appnotify_adm/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dbHelper = DatabaseHelper.instance;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  String alert = "";
  bool progress = false;
  bool obscureTextPassword = true;

  login(BuildContext context) async {
    bool status = false;
    bool resetPassword = false;
    if (emailAddress.text == "" || password.text == "") {
      _showToastFildClean(context);
      return;
    }
    try {
      setState(() {
        progress = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text.trim(), password: password.text.trim());

      setState(() {
        progress = false;
      });

      final users = FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid.toString());
      final user = await users.get();

      user.data()!.forEach((key, value) {
        if (key == 'status' && value) status = value;
        //if (key == 'resetPassword' && value) resetPassword = value;
      });

      if (status) {
        var id = await _inserir(emailAddress.text, password.text);
        print("STATUS: " + id.toString());

        Navigator.of(Routes.navigatorKey!.currentContext!)
            .pushReplacementNamed('/notificacao');
      } else {
        // ignore: use_build_context_synchronously
        _showToast(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        progress = false;
      });
      if (e.code == 'user-not-found') {
        setState(() {
          alert = '* No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          alert = '* Wrong password provided for that user.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          alert = '* Invalid Email.';
        });
      } else {
        setState(() {
          alert = '* ${e.code}';
        });
      }
    }
  }

  Future getUserLoged(String? uid) async {
    bool status = false;
    final users = FirebaseFirestore.instance.collection('users').doc(uid);
    final user = await users.get();

    user.data()!.forEach((key, value) {
      if (key == 'status' && value) status = value;
    });

    return status;
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('unauthorized user!'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _showToastFildClean(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Campo Vazio!'),
        action: SnackBarAction(
            label: 'FECHAR', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<int> _inserir(String inserirEmail, String inserirPassword) async {
    var deleted = await dbHelper.cleantable();

    print("DELETADO: $deleted");
    // linha para incluir
    Map<String, dynamic> row = {
      DatabaseHelper.columnEmail: inserirEmail,
      DatabaseHelper.columnPassword: inserirPassword
    };
    final status = await dbHelper.insert(row);
    return status;
  }

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
              const Text(
                "LOGIN",
                style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
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
                  controller: emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    label: const Text("Login"),
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
              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 5.0,
                shadowColor: Colors.grey.shade300,
                child: TextField(
                  onTap: () => setState(() {
                    alert = "";
                  }),
                  obscureText: obscureTextPassword,
                  controller: password,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        obscureTextPassword = !obscureTextPassword;
                      }),
                      icon: obscureTextPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    label: const Text("Password"),
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
                onPressed: (() => login(context)),
                child: const Text(
                  "LOGIN",
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
                height: 20,
              ),
              Material(
                color: Colors.grey[300],
                child: TextButton(
                  child: const Text("Esqueci a Senha!"),
                  onPressed: () =>
                      Navigator.of(Routes.navigatorKey!.currentContext!)
                          .pushReplacementNamed('/forgotPassword'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
