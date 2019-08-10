import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:chat_hasura/src/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../app_bloc.dart';
import '../app_repository.dart';

class HomeBloc extends BlocBase {
  final AppRepository _repository;
  final AppBloc appBloc;

  HomeBloc(this._repository, this.appBloc) {
    Observable(_repository.getMessages()).pipe(messagesController);
  }

  var controller = TextEditingController();
  var messagesController = BehaviorSubject<List<MessageModel>>();

  MessageModel random() {
    var randomIndex = Random().nextInt(messagesController.value.length);
    return messagesController.value[randomIndex];
  }

  void sendMessage() {
    _repository.sendMessage(
      controller.text,
      appBloc.userController.value.id,
    );
    controller.clear();
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    controller.dispose();
    messagesController.close();
    super.dispose();
  }
}
