import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';

class HomeBloc extends BlocBase {
  var controller = TextEditingController();
  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
  }
}
