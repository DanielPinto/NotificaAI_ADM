import 'package:appnotify_adm/models/user.dart';
import 'package:appnotify_adm/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController bodyController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  Future createNotify() async {
    if (titleController.text != "" && bodyController.text != "") {
      final docNotify =
          FirebaseFirestore.instance.collection('notifications').doc();

      final user = User(
          id: docNotify.id,
          title: titleController.text,
          body: bodyController.text,
          date: DateTime.now().toString());

      final json = user.toJson();
      await docNotify.set(json);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Create Notify",
                style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 60,
              ),
              Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5.0,
                shadowColor: Colors.grey.shade300,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title_outlined),
                    label: const Text("Title"),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 25.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5.0,
                shadowColor: Colors.grey.shade300,
                child: TextField(
                  maxLines: 10,
                  controller: bodyController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.message_outlined),
                    label: const Text("Body"),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 25.0,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0)),
                onPressed: () => createNotify(),
                child: const Text(
                  "Enviar",
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 15.0)),
                onPressed: () =>
                    Navigator.of(Routes.navigatorKey!.currentContext!)
                        .pushReplacementNamed('/notificacao'),
                child: const Text(
                  "ver todas noticações",
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
