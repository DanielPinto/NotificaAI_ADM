import 'package:appnotify_adm/models/item.dart';
import 'package:appnotify_adm/pages/notificationsPage/form_notifications_page.dart';
import 'package:appnotify_adm/pages/selectedNotification/selected_notification.dart';
import 'package:appnotify_adm/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  CollectionReference<Map<String, dynamic>> instanceNotifications =
      FirebaseFirestore.instance.collection('notifications');
  bool progress = false;
  late BuildContext pageContext;

  logout() async => await FirebaseAuth.instance.signOut().whenComplete(() =>
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushReplacementNamed('/login'));

  Stream<List<Item>> readItens() =>
      instanceNotifications.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());

  deleteItem(String idItem) async {
    showAlertDialogProgress(pageContext);
    try {
      await instanceNotifications.doc(idItem).delete();
      Navigator.of(pageContext).pop();
      showAlertDialogOK(pageContext);
    } on FirebaseException catch (e) {
      print("==== ERRO CODe: ${e.code} ==========");
      print("==== ERRO CODe: ${e.message} ==========");
      setState(() {});
    }
  }

  showAlertDialogConfirmDelete(BuildContext context, Item item) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancelar",
        style: TextStyle(color: Colors.grey[700], fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text(
        "Excluir",
        style: TextStyle(color: Colors.redAccent[700], fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        deleteItem(item.id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amber[50],
      title: const Text("você deseja excluir o item?"),
      content: Text(item.description),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      icon: Icon(
        Icons.warning_rounded,
        color: Colors.redAccent[700],
        size: 48,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogOK(BuildContext context) async {
    // set up the buttons

    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.greenAccent[700], fontSize: 18),
      ),
      onPressed: () {
        setState(() {
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amber[50],
      title: const Text("Item excluido com sucesso!"),
      actionsAlignment: MainAxisAlignment.center,
      icon: Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.greenAccent[700],
        size: 96,
      ),
      actions: [okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogProgress(BuildContext context) {
    // set up the buttons

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amber[50],
      title: const Text("Deletando..."),
      content: LinearProgressIndicator(
        color: Colors.amber[600],
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildItem(Item item) => Card(
        child: ListTile(
          onLongPress: () => showAlertDialogConfirmDelete(context, item),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectedNotification(
                      item_id: item.id,
                    )),
          ),
          textColor: Colors.amber[600],
          tileColor: Colors.amber[50],
          leading: item.status
              ? Icon(
                  Icons.notifications_active,
                  color: Colors.green[400],
                )
              : Icon(
                  Icons.notifications_off,
                  color: Colors.red[400],
                ),
          trailing: Icon(
            Icons.arrow_circle_right,
            color: Colors.amber[600],
            size: 30.0,
          ),
          title: Text(item.description),
        ),
      );

  @override
  Widget build(BuildContext context) {
    pageContext = context;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[200],
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.amber[200],
          isScrollControlled: true,
          builder: ((context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: ((MediaQuery.of(context).size.height) / 3) * 2,
                child: Center(
                  child: FormNotificationPage(
                      instanceNotifications: instanceNotifications),
                ),
              ),
            );
          }),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
          title: const Text('Informa.AI'),
          backgroundColor: Colors.amber[200],
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton(
                onSelected: (value) => {if (value == 0) logout()},
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('SAIR'),
                          Icon(Icons.logout_sharp),
                        ]),
                  )
                ],
              ),
            )
          ]),
      body: StreamBuilder<List<Item>>(
          stream: readItens(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child:
                    Text('Erro ao carregar as notificações: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final itens = snapshot.data!;

              return ListView(
                children: itens.map(buildItem).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
