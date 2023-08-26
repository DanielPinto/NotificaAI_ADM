// ignore_for_file: non_constant_identifier_names

import 'package:appnotify_adm/models/item.dart';
import 'package:appnotify_adm/models/zone.dart';
import 'package:appnotify_adm/pages/notificationsPage/form_notifications_page.dart';
import 'package:appnotify_adm/services/invite_notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SelectedNotification extends StatefulWidget {
  final String item_id;
  const SelectedNotification({
    Key? key,
    // ignore: non_constant_identifier_names
    required this.item_id,
  }) : super(key: key);

  @override
  State<SelectedNotification> createState() => _SelectedNotificationState();
}

class _SelectedNotificationState extends State<SelectedNotification> {
  late var scaffold;
  CollectionReference<Map<String, dynamic>> instanceNotifications =
      FirebaseFirestore.instance.collection('notifications');

  Item item = Item(
      title: '',
      body: '',
      date: '',
      description: '',
      status: false,
      id: '',
      users: '',
      zones: []);

  bool haveItem = false;

  List<Zone> zonesList = [];

  List<String> conditionals = [];
  String conditional = "";
  String idTodas = "";
  late BuildContext contextPage;

  @override
  void initState() {
    super.initState();

    readItem();

    readZones();
  }

  readZones() async {
    var obj = await FirebaseFirestore.instance.collection('zone').get();

    for (var element in obj.docs) {
      //zones.add(element.id);
      final documents =
          FirebaseFirestore.instance.collection('zone').doc(element.id);
      await documents.get().then((value) {
        Zone zone = Zone.fromJson(value.data()!);
        zonesList.add(zone);
        if (zone.sigla == "TODAS") idTodas = zone.id;
        print("LEITURA de ZONE TODAS ${idTodas}");
      });
    }
    setState(() {});
  }

  readItem() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(widget.item_id)
        .get()
        .then((obj) {
      item = Item.fromJson(obj.data()!);
      haveItem = true;
      setState(() {});
    });
  }

  changeZones(String zoneId) async {
    showAlertDialogProgress();

    if (!item.zones.contains(zoneId) && !item.zones.contains(idTodas)) {
      if (zoneId == idTodas) {
        item.zones.clear();
      }

      item.zones.add(zoneId);

      if (item.zones.length > 5) {
        item.zones.clear();
        item.zones.add(idTodas);
      }
    } else {
      item.zones.remove(zoneId);
    }

    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(item.id)
        .set(item.toJson())
        .then(
      (value) {
        Navigator.of(contextPage).pop();
        readItem();
      },
    );
    print("TODAS ZONAS: ${item.zones}");
  }

  void updateStatus() async {
    DocumentReference docs =
        FirebaseFirestore.instance.collection('notifications').doc(item.id);
    item.status = !item.status;
    await docs.update(item.toJson()).whenComplete(() {
      showToast("successfully updated!");
    }).catchError((e) {
      showToast(e.toString());
    });

    setState(() {});
  }

  void send() async {
    InviteNotify invite = InviteNotify();

    int response;

    response = await invite.inviteNotify(
        id: item.id,
        body: item.body,
        title: item.title,
        zones: item.zones,
        conditions: conditional);

    if (response == 200) {
      if (!item.status) {
        updateStatus();
      }
      readItem();
      showToast('Mensagem enviada');
    } else {
      showToast('Erro ao enviar a Mensagem!');
      print(response);
    }
    //updateStatus();
  }

  void showToast(String message) {
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  showAlertDialog(BuildContext context, Function onPressed, String content) {
    Widget cancelaButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[200])),
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continuaButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber[100])),
      child: const Text("OK"),
      onPressed: () {
        onPressed();
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Atenção"),
      content: Text(content),
      actions: [
        cancelaButton,
        if (item.zones.isNotEmpty) continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSelectZoneDialog(
      BuildContext context, Function onPressed, String content) {
    Widget cancelaButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey[200])),
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continuaButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber[100])),
      child: const Text("OK"),
      onPressed: () {
        onPressed();
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Select Zone"),
      content: DropdownButtonFormField(
        items: zonesList
            .map((e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.description),
                ))
            .toList(),
        onChanged: (value) => print(value),
      ),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildItem(Zone zone) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 60),
        onTap: () {},
        textColor: Colors.black54,
        trailing: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: item.zones.contains(zone.id),
            onChanged: item.zones.contains(idTodas) && zone.id != idTodas
                ? (value) {}
                : (value) => changeZones(zone.id),
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.amber.shade600;
              }
              return Colors.amber.shade600;
            }),
          ),
        ),
        title: Text(zone.description),
      );

  @override
  Widget build(BuildContext context) {
    scaffold = ScaffoldMessenger.of(context);
    contextPage = context;
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 8.0,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.edit,
              color: Colors.orange[400],
            ),
            label: 'Editar',
            onTap: () => showModalBottomSheet(
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
                          instanceNotifications: instanceNotifications,
                          itemUpdate: item,
                          callback: readItem()),
                    ),
                  ),
                );
              }),
            ), //showSelectZoneDialog(context, edit, 'Edit'),
          ),
          SpeedDialChild(
            child: item.status
                ? Icon(
                    Icons.notifications_off,
                    color: Colors.red[400],
                  )
                : Icon(
                    Icons.notifications_active,
                    color: Colors.green[400],
                  ),
            label: item.status ? 'Desabilitar' : 'Abilitar',
            onTap: () => updateStatus(),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.send,
              color: Colors.blue,
            ),
            label: 'Notificar',
            onTap: () => showAlertDialog(
                context,
                enviar,
                item.zones.isNotEmpty
                    ? 'Enviar esta notificação?'
                    : 'Você precisa selecionar pelo menos uma Regional!'),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: const Text('Informa.AI'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: item.status
                ? Icon(
                    Icons.notifications_active,
                    color: Colors.green[400],
                  )
                : Icon(
                    Icons.notifications_off,
                    color: Colors.red[400],
                  ),
          )
        ],
      ),
      body: item.id != '' && zonesList.isNotEmpty
          ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  alignment: Alignment.topCenter,
                  child: Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 8.0),
                  child: Text(
                    item.body,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: zonesList.length,
                    itemBuilder: (context, index) =>
                        buildItem(zonesList[index]),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void enviar() {
    conditionals.clear();
    zonesList.forEach((element) {
      if (item.zones.contains(element.id)) {
        addConditionals(element.id);
      }
    });
    mountStringConditional();
    send();
  }

  void addConditionals(String? itemId) {
    print("================== add $itemId ==============");
    if (itemId != null) {
      if (conditionals.isEmpty) {
        conditionals.add("'$itemId' in topics");
      } else if (!conditionals.contains("'$itemId' in topics") &&
          !conditionals.contains(" || '$itemId' in topics")) {
        conditionals.add(" || '$itemId' in topics");
      }
    }
  }

  void mountStringConditional() {
    if (conditionals.isNotEmpty) {
      conditional = '';
      conditionals.forEach((e) {
        conditional += e;
      });
    }
    print("======== $conditional ================");
  }

  showAlertDialogProgress() {
    // set up the buttons

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amber[50],
      title: const Text("Atualizando..."),
      content: LinearProgressIndicator(
        color: Colors.amber[600],
      ),
    );
    // show the dialog
    showDialog(
      context: contextPage,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
