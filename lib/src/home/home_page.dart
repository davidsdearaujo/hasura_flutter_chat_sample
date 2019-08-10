import 'package:chat_hasura/src/home/home_bloc.dart';
import 'package:chat_hasura/src/home/home_module.dart';
import 'package:chat_hasura/src/models/message_model.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = HomeModule.to.bloc<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              showDialog(
                context: context,
                //  barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sorteado"),
                    content: SizedBox(
                      width: 50,
                      height: 50,
                      child: Text(
                        bloc.random().content,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.red),
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
        stream: bloc.messagesController,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(5,0,5,5),
                child: TextField(
                  controller: bloc.controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: bloc.sendMessage,
                    ),
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
