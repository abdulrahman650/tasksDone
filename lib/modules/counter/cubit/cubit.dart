

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fristmansour2/modules/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates>
{
  CounterCubit() : super(CounterInitialStates());

  static CounterCubit get(context) => BlocProvider.of(context);

  int counter =1;
  void minus()
  {
    counter--;
    emit(CounterMinusState(counter));
  }

  void plus()
  {
    counter++;
    emit(CounterPlusState(counter));
  }
}