//Aca se crea el gRPC server
import 'dart:io';

import 'package:protos/protos.dart';
import 'package:server/todo_service.dart';

void main(List<String> arguments) async {
  //Define a server
  //Here goes an array of services
  final server = Server.create(services: [
    TodoService(), //This is the service that we created
  ]);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await server.serve(port: port);

  print('Server listening on port ${server.port}...');
}
