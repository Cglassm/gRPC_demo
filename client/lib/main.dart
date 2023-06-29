import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protos/protos.dart';

void main() {
  runApp(const MyApp());
}

//Dealing with a Stream in both ends (client and server)
//We can see that random todos are streamed from the server to the client within seconds
//We are streaming data from a server. It feels like calling a native mathod locally available. This is the power of gRPC.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Aca se crea el canal de comunicacion con gRPC
  late ClientChannel _channel;

  //Se crea el stub que es una abstraccion, sirve como un proxy para comuncarse con grpc. Sirve para llamar a los metodos
  //Es la clase autogenerada con el protobuff
  late TodoServiceClient _stub;

  //Todo que se va a mostrar en la pantalla
  Todo? todo;

  //Todo que se va a streamear con 1 segundo entre uno y otro
  Stream<Todo>? _todoStream;

  @override
  void initState() {
    super.initState();

    //Pongo localhost porque estoy corriendo el server local
    _channel = ClientChannel(
      'localhost',
      port: 8080,
      //El canal de comunicacion es inseguro porque no tiene certificado pero si se tiene SSL se puede poner secure

      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    //Inicializar el stub para poder llamar a los metodos
    _stub = TodoServiceClient(_channel);

    //Aca hay que inicializar el stream o sea una vez que el widget se inicializa
    //Se va a mostrar de a un todo cada 1 segundo
    _todoStream = _stub.getTodoStream(GetTodoByIdRequest()..id = 1);
  }

  void _getTodo() async {
    final id = Random().nextInt(100);
    final todo = await _stub.getTodo(GetTodoByIdRequest()..id = id);

    setState(() {
      this.todo = todo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _todoStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final todo = snapshot.data as Todo;
                    return Column(
                      children: [
                        Text(todo.id.toString()),
                        Text(todo.title),
                        Text(todo.completed.toString()),
                      ],
                    );
                  } else {
                    return const Text('Cargando ...');
                  }
                }),
            // if (todo != null)
            //   Column(
            //     children: [
            //       Text(todo!.id.toString()),
            //       Text(todo!.title),
            //       Text(todo!.completed.toString()),
            //     ],
            //   )
            // else
            //   const Text('No hay todo'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getTodo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
