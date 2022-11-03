import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristmansour2/shared/cubit/state.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  Future<void> createDatabase()  async {
 openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) {
          print("database created");
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT, status TEXT )')
              .then((value) {
            print("table created");
          }).catchError((error) {
            print("Error When Creating Table ${error.toString()}");
          });
        },
     onOpen: (database) {
          getDataFromDatabase(database);
          print('database opend');
        },
        ).then((value) 
 {
   database= value;
   emit(AppCreateDatabaseState());
 });
  }

  insertToDatabase({
    required String? title,
    required String? time,
    required String? date,
  }) async =>
      await database.transaction((txn) async {
        txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")',
        ).then((value)
        {
          print('$value inserted successfully');

          emit(AppInsertDatabaseState());
          getDataFromDatabase(database);
        }).catchError((error)
        {
          print("Error When Inserting New Record ${error.toString()}");
        });
      });

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

     value.forEach((element)
     {
       if(element['status']== 'new')
         newTasks.add(element);
       else if(element['status']== 'done')
         doneTasks.add(element);
       else archiveTasks.add(element);
     });
      emit(AppGetDatabaseState());
    });
  }

  void updateDate({
  required String status,
  required int id,

  }) async
  {
   database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdatabaseLoadingState());

   });

  }
  void deleteDate({
    required int id,

  }) async
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [ id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeletebaseLoadingState());

    });

  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
    required IconData icon,
})
{
   isBottomSheetShown = isShow;
   fabIcon = icon;

   emit(AppChangeBottomSheetState());
}
}