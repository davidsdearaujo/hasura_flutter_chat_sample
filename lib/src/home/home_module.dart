import 'package:chat_hasura/src/app_module.dart';
import 'package:chat_hasura/src/home/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:chat_hasura/src/home/home_page.dart';

import '../app_bloc.dart';
import '../app_repository.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc(
          (i) => HomeBloc(
            AppModule.to.get<AppRepository>(),
            AppModule.to.bloc<AppBloc>(),
          ),
        ),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => HomePage();

  static Inject get to => Inject<HomeModule>.of();
}
