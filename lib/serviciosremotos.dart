import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic>cake) async{
    return await baseRemota.collection("cake").add(cake);
  }

  static Future<List> mostrarTodos() async{
    List temporal = [];
    var query = await baseRemota.collection("cake").get();

    query.docs.forEach((element) {
      Map<String, dynamic> data=element.data();
      data.addAll({
        'id': element.id
      });
      temporal.add(data);
    });
    return temporal;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("cake").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> cake) async{
    String id = cake['id'];
    cake.remove(id);
    return await baseRemota.collection("cake").doc(id).update(cake);

  }
}