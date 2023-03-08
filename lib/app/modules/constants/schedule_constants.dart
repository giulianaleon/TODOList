import 'package:agenda/app/modules/screens/schedule_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController dayController = TextEditingController();
TextEditingController monthController = TextEditingController();
TextEditingController statusController = TextEditingController();
TextEditingController recurrenceController = TextEditingController();
TextEditingController dateController = TextEditingController();

late DateTime dateControl;
DateFormat formatter = DateFormat('dd/MM/yy');
DateFormat formatterDay = DateFormat('dd');
DateFormat formatterMonth = DateFormat('MM');

enum statusTask { Aguardando, Realizado }

statusTask? status = statusTask.Aguardando;

late String newUserId;
FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');
DocumentReference companyDocRef = usersRef.doc(newUserId);
CollectionReference taskRef = companyDocRef.collection('Tasks');

String? displayName = user?.displayName;
String? displayEmail = user?.email;

void updateCurrentUser() async {
  await user?.reload();
  user = auth.currentUser;
  print(user);
}

Future<List<TaskEntity>> getTasksByUserId() async {
  var tasksJson = await FirebaseFirestore.instance.collection('Users').doc(newUserId).collection('Tasks').get();
  List<TaskEntity> tasksInternal = [];
  for (var doc in tasksJson.docs) {
    var element =
        await FirebaseFirestore.instance.collection('Users').doc(newUserId).collection('Tasks').doc(doc.id).get();
    tasksInternal.add(TaskEntity.fromJson(element.data()));
  }
  return tasksInternal;
}

enum TasksViewState { loading, success, error }

class MyController extends ChangeNotifier {
  static ValueNotifier<TasksViewState> state = ValueNotifier(TasksViewState.loading);
  static List<TaskEntity> tasks = [];

  static initializeTasks() async {
    try {
      tasks.clear();
      state.value = TasksViewState.loading;
      state.notifyListeners();
      tasks = await getTasksByUserId();
      state.value = TasksViewState.success;
      state.notifyListeners();
    } catch (e) {
      state.value = TasksViewState.error;
      state.notifyListeners();
    }
  }
}

class TaskEntity {
  final String data;
  final String descricao;
  final String dia;
  final String mes;
  final String recorrencia;
  final String status;
  final String titulo;

  TaskEntity({
    required this.data,
    required this.descricao,
    required this.dia,
    required this.mes,
    required this.recorrencia,
    required this.status,
    required this.titulo,
  });

  factory TaskEntity.fromJson(json) {
    return TaskEntity(
      data: json['Data'].toString(),
      descricao: json['Descricao'].toString(),
      dia: json['Dia'].toString(),
      mes: json['Mês'].toString(),
      recorrencia: json['Recorrência'].toString(),
      status: json['Status'].toString(),
      titulo: json['Titulo'].toString(),
    );
  }
}
