import 'package:appnotify_adm/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  String alert = "";
  bool progress = false;
  bool obscureTextRepeatPassword = true;
  bool obscureTextPassword = true;
  int passwordZise = 8;

  bool passwordIsEqual() => password.text == repeatPassword.text;
  bool fieldsIsEmpt() => password.text == "" && repeatPassword.text == "";
  bool fieldsIsLongSize() => password.text.length >= passwordZise;
  bool hasUpperCase() {
    // Expressão regular para encontrar um caractere maiúsculo
    RegExp upperCaseRegex = RegExp(r'[A-Z]');
    return upperCaseRegex.hasMatch(password.text);
  }

  bool hasLowerCase() {
    // Expressão regular para encontrar um caractere maiúsculo
    RegExp lowerCaseRegex = RegExp(r'[a-z]');
    return lowerCaseRegex.hasMatch(password.text);
  }

  bool hasNotAlphanumeric() {
    // Expressão regular para encontrar um caractere maiúsculo
    RegExp notAlphanumericRegex =
        RegExp(r'[<>\[\]}{,;@.^?~=+)(%&$#!\-_\/*\-+.\|]');
    return notAlphanumericRegex.hasMatch(password.text);
  }

  bool hasNumeric() {
    // Expressão regular para encontrar um caractere maiúsculo
    RegExp numericRegex = RegExp(r'[0-9]');
    return numericRegex.hasMatch(password.text);
  }

  bool validFields() =>
      passwordIsEqual() &&
      !fieldsIsEmpt() &&
      hasLowerCase() &&
      hasUpperCase() &&
      hasNotAlphanumeric() &&
      hasNumeric() &&
      fieldsIsLongSize();

  resetPassword(BuildContext context) async {
    User? user;
    try {
      setState(() {
        progress = true;
      });
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(password.text);
        Navigator.of(Routes.navigatorKey!.currentContext!)
            .popAndPushNamed('/notificacao');
      } else {
        Navigator.of(Routes.navigatorKey!.currentContext!)
            .pushReplacementNamed('/login');
      }
      setState(() {
        progress = false;
      });
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
                    label: const Text("New Password"),
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
                  onChanged: (_) => setState(() {}),
                  obscureText: obscureTextRepeatPassword,
                  controller: repeatPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        obscureTextRepeatPassword = !obscureTextRepeatPassword;
                      }),
                      icon: Icon(
                        obscureTextRepeatPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    label: const Text("Reapet Password"),
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
                  backgroundColor:
                      validFields() ? Colors.amber[50] : Colors.grey[50],
                  elevation: validFields() ? 5.0 : 0.0,
                  minimumSize:
                      Size((MediaQuery.of(context).size.width) / 2, 50),
                ),
                onPressed:
                    (validFields() ? () => resetPassword(context) : null),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "campos iguais:",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(passwordIsEqual() && !fieldsIsEmpt()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "minimo de 8 caracter: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(fieldsIsLongSize()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "contém 1 caracter Maiúsculo: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(hasUpperCase()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "contém 1 caracter Minúsculo: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(hasLowerCase()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "contém 1 caracter Especial: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(hasNotAlphanumeric()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "contém 1 Número: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    getIconCheck(hasNumeric()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
