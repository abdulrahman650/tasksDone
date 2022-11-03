 abstract class CounterStates{}

 class CounterInitialStates extends CounterStates{}


 class CounterPlusState extends CounterStates
 {
  final int counter;

  CounterPlusState(this.counter);
 }

 class CounterMinusState extends CounterStates
 {
  final int counter;

  CounterMinusState(this.counter);
 }