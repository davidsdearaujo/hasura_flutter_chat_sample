import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:chat_hasura/src/models/message_model.dart';
import 'package:chat_hasura/src/models/user_model.dart';
import 'package:hasura_connect/hasura_connect.dart';

class AppRepository extends Disposable {
  final HasuraConnect connection;

  AppRepository(this.connection);

  Future<UserModel> getUser(String user) async {
    var query = """
      getUser(\$name:String!){
        users(where: {name: {_eq: \$name}}) {
          name
          id
        }
      }
    """;

    var data = await connection.query(query, variables: {"name": user});
    if (data["data"]["users"].isEmpty) {
      return createUser(user);
    } else {
      return UserModel.fromJson(data["data"]["users"][0]);
    }
  }

  Future<UserModel> createUser(String name) async {
    var query = """
      mutation createUser(\$name:String!) {
        insert_users(objects: {name: \$name}) {
          returning {
            id
          }
        }
      }
    """;

    var data = await connection.mutation(query, variables: {"name": name});
    var id = data["data"]["insert_users"]["returning"][0]["id"];
    return UserModel(id: id, name: name);
  }

  Stream<List<MessageModel>> getMessages() {
    var query = """
      subscription {
        messages(order_by: {id: desc}) {
          content
          id
          user {
            name
            id
          }
        }
      }
    """;

    Snapshot snapshot = connection.subscription(query);
    return snapshot.stream.map(
      (jsonList) => MessageModel.fromJsonList(jsonList["data"]["messages"]),
    );
  }

  Future<dynamic> sendMessage(String message, int userId){
    var query = """
      sendMessage(\$message:String!,\$userId:Int!) {
        insert_messages(objects: {id_usuario: \$userId, content: \$message}) {
          affected_rows
        }
      }
    """;

    return connection.mutation(query, variables: {
      "message": message,
      "userId": userId,
    });
  }

  Future<MessageModel> random()async {
    var query = """
      subscription {
        messages(order_by: {id: desc}) {
          content
          id
          user {
            name
            id
          }
        }
      }
    """;

    var jsonList = await connection.query(query);
    var messages = MessageModel.fromJsonList(jsonList["data"]["messages"]);
    var randomIndex = Random().nextInt(messages.length);
    return messages[randomIndex];
  }

  @override
  void dispose() {}
}
