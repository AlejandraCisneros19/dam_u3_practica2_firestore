import 'package:flutter/material.dart';
import 'package:dam_u3_practica2_firestore/serviciosremotos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppP2 extends StatefulWidget {
  const AppP2({super.key});

  @override
  State<AppP2> createState() => _AppP2State();
}

class _AppP2State extends State<AppP2> {
  String titulo = "App Firebase";
  int _index=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${titulo}"),
        centerTitle: true,
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("AC"),),
                SizedBox(height: 20,),
                Text("Alejandra Cisneros", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.purple),
            ),
            SizedBox(height: 20,),
            _item(Icons.add, "Agregar", 1),
            _item(Icons.format_list_bulleted, "Pedidos", 0),
          ],
        ),
      ),
    );
  }
//******************** ITEM ***********************+
  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 2,)],
      ),
    );
  }
//******************* DINAMICO *************************
  Widget dinamico(){
    if(_index==1){
      return agregar();
    }
    return cargarData();
  }
//********************* AGREGAR ***************************
  Widget agregar(){
    final nombre = TextEditingController();
    final ingredientes = TextEditingController();
    final tamano = TextEditingController();
    final precio = TextEditingController();
    final descripcion = TextEditingController();


    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: ingredientes,
          decoration: InputDecoration(
              labelText: "Ingredientes:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: tamano,
          decoration: InputDecoration(
              labelText: "Tamaño:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
        controller: precio,
        decoration: InputDecoration(
        labelText: "Precio:"
        ),
        ),
        SizedBox(height: 10,),
        TextField(
        controller: descripcion,
        decoration: InputDecoration(
        labelText: "Descripcion:"
        ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JSonTemporal={
                    'nombre':nombre.text,
                    'ingredientes':ingredientes.text,
                    'tamaño':tamano.text,
                    'precio':int.parse(precio.text),
                    'descripcion':descripcion.text
                  };
                  DB.insertar(JSonTemporal).then((value){
                    setState((){
                      titulo="SE INSERTÓ";
                    });
                  });
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancel")
            ),
          ],
        )
      ],
    );
  }
//***************** CARGAR DATA ********************
  Widget cargarData(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (context, listaJSON){
          if(listaJSON.hasData){
            return ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice){
                  return ListTile(
                    title: Text("${listaJSON.data?[indice]['nombre']}"),
                    subtitle: Text("${listaJSON.data?[indice]['descripcion']}"),
                    trailing: IconButton(
                      onPressed: (){
                        DB.eliminar(listaJSON.data?[indice]['id']).then((value){
                          setState(() {
                            titulo="SE BORRO";
                          });
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        });
  }
}
