import 'dart:math';

import 'package:protos/protos.dart';

//Funciona como una interfaz
class TodoService extends TodoServiceBase {
  //Aca se implementan los metodos

  //Recibe la call y la request
  @override
  Future<Todo> getTodo(ServiceCall call, GetTodoByIdRequest request) async {
    //Aca se implementa la logica
    final id = request.id;

    //Aca vamos a hardcodear el todo
    final todo = Todo()
      ..id = id
      ..title = 'title $id'
      ..completed = id % 2 == 0 ? true : false;
    return todo;
  }

  //async* tu función devuelve un stream y cada vez que usas "yield" el objeto que cedes va al stream
  @override
  Stream<Todo> getTodoStream(
      ServiceCall call, GetTodoByIdRequest request) async* {
    while (true) {
      final id = Random().nextInt(100);
      final todo = Todo()
        ..id = id
        ..title = 'title $id'
        ..completed = id % 2 == 0 ? true : false;

      //Como estanmos con un stream, no se puede retornar un valor, sino que se usa yield
      //Pues el yield es como un return pero para un stream
      yield todo;

      //Permite poder ver que ocurre en el cliente
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
