import 'package:chat_hasura/src/app_module.dart';
import 'package:chat_hasura/src/home/home_bloc.dart';
import 'package:chat_hasura/src/home/home_module.dart';
import 'package:chat_hasura/src/models/message_model.dart';
import 'package:flutter/material.dart';

import '../app_bloc.dart';
import '../app_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var repo = AppModule.to.get<AppRepository>();
  Stream<List<MessageModel>> messagesOut;
  final bloc = HomeModule.to.bloc<HomeBloc>();
  final appBloc = AppModule.to.bloc<AppBloc>();

  void sendMessage() {
    repo.sendMessage(
      bloc.controller.text,
      appBloc.userController.value.id,
    );
    bloc.controller.clear();
  }

  @override
  void initState() {
    super.initState();
    messagesOut = repo.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              showDialog(
                context: context,
                //  barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sorteado"),
                    content: Center(
                      child: FutureBuilder<MessageModel>(
                        future: repo.random(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());
                          else
                            return Text(
                              snapshot.data.content,
                              style: Theme.of(context).textTheme.title,
                            );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: messagesOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data[index].user.name),
                      subtitle: Text(snapshot.data[index].content),
                    );
                  },
                ),
              ),
              TextField(
                controller: bloc.controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
