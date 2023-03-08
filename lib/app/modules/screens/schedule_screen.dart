import 'package:agenda/app/modules/helpers/notification_helper.dart';
import 'package:agenda/app/modules/screens/home_page_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agenda/app/modules/constants/schedule_constants.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const List<String> list = <String>['Única', 'Recorrente', 'Anual'];
const List<String> listTask = <String>['Finalizada', 'Aguardando'];

class TasksPage extends StatefulWidget {
  final String title;
  const TasksPage({Key? key, this.title = 'Task'}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  late DateTime _selectedDateDay;
  String dropdownValue = list.first;
  String dropdownValueTask = listTask.first;
  late String uid;

  @override
  void initState() {
    super.initState();
    print(user?.displayName);
  }


  calenderPicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2026)
    ).then((value) => {
      setState((){
        dateControl = value!;
        dateController.text = formatter.format(dateControl!);
      }),
    });
  }

  String daysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays.toString();
  }

  void addTask() async {
    await usersRef.doc(user?.uid).collection('Tasks').add({
      'Titulo': titleController.text,
      'Descricao': descriptionController.text,
      'Recorrência': recurrenceController.text,
      'DataCompleta': DateTime.now(),
      'Contagem': dateControl,
      'Data': dateController.text,
      'Status': statusController.text,
      'Dia': dayController.text,
      'Mês': monthController.text,
    });
    titleController.text = "";
    descriptionController.text = "";
    dayController.text = "";
    monthController.text = "";
    dateController.text = "";
    statusController.text = "";
    Navigator.of(context).pop();
  }

  void updateTask(String data) async {
    await FirebaseFirestore.instance.collection('Users').doc(user?.uid).collection('Tasks').doc(data.toString()).update({
      'Status': statusController.text,
    });
    Navigator.of(context).pop();
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Título',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    controller: titleController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Descrição',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    controller: descriptionController,
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                Row(
                  children: [
                    const Text('Recorrência: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .1,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.calendar_month, size: 20),
                        onPressed: () {
                          setState((){
                            calenderPicker();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text('Status: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .1,
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValueTask,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.red[300],
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValueTask = value!;
                            statusController.text = dropdownValueTask;
                          });
                        },
                        items: listTask.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text('Tarefa: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .1,
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.red[300],
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                            recurrenceController.text = dropdownValue;
                          });
                          if(recurrenceController.text == "Recorrente"){
                            dayController.text = formatterDay.format(dateControl!);
                            print(dayController.text);
                          }

                          if(recurrenceController.text == "Anual"){
                            monthController.text = formatterMonth.format(dateControl!);
                          }
                        },
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

              ],
            );
          }
        ),
        actions: [
          TextButton(
              onPressed: (){
                addTask();
              },
              child: Text(
                "Adicionar",
                style: TextStyle(
                  color: Colors.red[300],
                  fontWeight: FontWeight.w500,
                ),
              ),
          )
        ],
      ),
    ),
  );

  Future openDialogTask(Map data, String id) => showDialog(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Text('Título: ' + data!['Titulo'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text('Descrição: ' + data!['Descricao'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .1,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValueTask,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.red[300],
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueTask = value!;
                          statusController.text = dropdownValueTask;
                        });
                      },
                      items: listTask.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
        ),
        actions: [
          TextButton(
            onPressed: (){
              updateTask(id);
            },
            child: Text("EDITAR"),
          )
        ],
      ),
    ),
  );

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut().then((user) =>
        Modular.to.pushNamed('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[300],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1,
                vertical: MediaQuery.of(context).size.height * .05,
              ),
              color: Colors.red[300],
              child: Column(
                children: [
                  const Text (
                    'Seja bem-vindo(a)!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                      displayName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Editar perfil'),
              onTap: () {
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await logout();
              },
            ),

          ],
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .1,
              vertical: MediaQuery.of(context).size.height * .05,
            ),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: taskRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Ocorreu um erro ao buscar os dados');
                    }

                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        final data = document.data() as Map;
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        if((data['Recorrência'] == "Única") && data['Contagem'] == DateTime.now()){
                        }

                        // if((data['Recorrência'] == "Recorrente") && data['Dia'] == formatterDay.format(dateControl!)){
                        //
                        // }
                        //
                        // if((data['Recorrência'] == "Anual") && data['Mês'] == formatterMonth.format(dateControl!)){
                        //
                        // }

                        return GestureDetector(
                          onTap: (){
                            openDialogTask(data, snap.id);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: Text(
                                  data!['Titulo'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(data!['Descricao'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                              trailing: Text(data!['Status'] + '\n' + 'Restam: ' + daysUntil(data!['Contagem'].toDate()) + ' dias'),
                              leading: Text(data!['Recorrência'] + '\n' + data!['Data']),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
          ],
            ),
          ),
        ),
      ),
    );
  }

}


