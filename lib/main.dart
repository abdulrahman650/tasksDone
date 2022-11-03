// @dart=2.9

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fristmansour2/shared/bloc_observer.dart';

import 'layout/home_layout.dart';
import 'modules/counter/counter_screen.dart';
import 'modules/login/login_screen.dart';



void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );

  }
}
