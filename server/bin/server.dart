//Aca se crea el gRPC server
import 'dart:io';

import 'package:protos/protos.dart';
import 'package:server/todo_service.dart';

void main(List<String> arguments) async {
  //Definir un server con un TodoService
  final server = Server.create(services: [
    TodoService(), //Service que creamos
    // UserService(),
  ]);

  //Inicializo el server en el puerto, por default 8080
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await server.serve(port: port);

  // Se imprime por consola si el server esta escuchando en el puerto
  print('Server listening on port ${server.port}...');
}
