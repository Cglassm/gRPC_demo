import 'dart:math';

import 'package:protos/protos.dart';

//Funciona como una interfaz
class TodoService extends TodoServiceBase {
  //Aca se implementan los metodos
  @override
  Future<Todo> getTodo(ServiceCall call, GetTodoByIdRequest request) async {
    //Aca se implementa la logica
    final id = request.id;
    final todo = Todo()
      ..id = id
      ..title = 'title $id'
      ..completed = false;
    return todo;
  }

  //async* your function returns a stream and every time you use "yield" the object that you yield goes on the stream
  @override
  Stream<Todo> getTodoStream(
      ServiceCall call, GetTodoByIdRequest request) async* {
    while (true) {
      final id = Random().nextInt(100);
      final todo = Todo()
        ..id = id
        ..title = 'title $id'
        ..completed = false;

      yield todo;

      await Future.delayed(Duration(seconds: 1));
    }
  }
}
