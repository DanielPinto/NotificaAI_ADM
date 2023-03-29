import 'package:appnotify_adm/models/item.dart';
import 'package:appnotify_adm/pages/notificationsPage/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormNotificationPage extends StatefulWidget {
  late CollectionReference<Map<String, dynamic>> instanceNotifications;
  Future<dynamic>? callback;
  FormNotificationPage(
      {super.key,
      required this.instanceNotifications,
      this.itemUpdate,
      this.callback});
  Item? itemUpdate;

  @override
  State<FormNotificationPage> createState() => _FormNotificationPageState();
}

class _FormNotificationPageState extends State<FormNotificationPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String alert = "";
  bool progress = false;
  final String buttonTitle = "ENVIAR";

  post() {
    widget.itemUpdate == null ? create() : update();
  }

  update() async {
    print("==== progress true ==========");
    setState(() {
      print("==== progress true ==========");
      progress = true;
    });
    try {
      widget.itemUpdate?.title = titleController.text;
      widget.itemUpdate?.description = descriptionController.text;
      widget.itemUpdate?.body = bodyController.text;

      await widget.instanceNotifications
          .doc(widget.itemUpdate?.id)
          .update(widget.itemUpdate!.toJson())
          .then((value) {
        widget.callback!;
      });

      setState(() {
        progress = false;
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      alert = "Erro: ${e.message} !";
      print("==== ERRO CODe: ${e.code} ==========");
      print("==== ERRO CODe: ${e.message} ==========");
      setState(() {
        progress = false;
      });
    }
  }

  create() async {
    print("==== progress true ==========");
    setState(() {
      print("==== progress true ==========");
      progress = true;
    });
    try {
      print("==== criando o item ==========");
      Item item = Item(
          title: titleController.text,
          body: bodyController.text,
          date: DateTime.now().toString(),
          description: descriptionController.text,
          status: false,
          id: "",
          users: "",
          zones: []);

      print("==== cadastrando na base ==========");
      DocumentReference doc =
          await widget.instanceNotifications.add(item.toJson());

      print("==== pegou ID ==========");
      item.id = doc.id;

      print("==== update ID ==========");
      await doc.update(item.toJson());

      setState(() {
        progress = false;
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      alert = "Erro: ${e.message} !";
      print("==== ERRO CODe: ${e.code} ==========");
      print("==== ERRO CODe: ${e.message} ==========");
      setState(() {
        progress = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.itemUpdate != null) {
      titleController.text = widget.itemUpdate!.title;
      bodyController.text = widget.itemUpdate!.body;
      descriptionController.text = widget.itemUpdate!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: progress
                    ? const CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white,
                      )
                    : Container()),
            const SizedBox(
              height: 20,
            ),
            CustonTextField(
              onTap: () => setState(() {
                alert = "";
              }),
              controller: titleController,
              label: "Titulo",
              icon: const Icon(Icons.title_outlined),
            ),
            const SizedBox(
              height: 20,
            ),
            CustonTextField(
              onTap: () => setState(() {
                alert = "";
              }),
              controller: descriptionController,
              label: "Descrição",
              icon: const Icon(Icons.description_outlined),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            CustonTextField(
              onTap: () => setState(() {
                alert = "";
              }),
              controller: bodyController,
              label: "Mensagem",
              icon: const Icon(
                Icons.message_outlined,
              ),
              minLines: 5,
              maxLines: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[50],
                elevation: 5.0,
                minimumSize: Size((MediaQuery.of(context).size.width) / 2, 50),
              ),
              onPressed: () => post(),
              child: Text(
                buttonTitle,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber[600],
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
                    fontSize: 12))
          ],
        ),
      ),
    );
  }
}
