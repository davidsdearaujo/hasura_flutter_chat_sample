import 'package:chat_hasura/src/app_bloc.dart';
import 'package:chat_hasura/src/app_module.dart';
import 'package:chat_hasura/src/home/home_module.dart';
import 'package:flutter/material.dart';

import 'login/login_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AppModule.to.bloc<AppBloc>();
    return MaterialApp(
      title: 'Flutter Slidy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: bloc.userController,
        builder: (context, snapshot) {
          return snapshot.hasData ? HomeModule() : LoginModule();
        },
      ),
    );
  }
}
