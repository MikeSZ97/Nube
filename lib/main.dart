import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final bd= Firestore.instance;


main()=> runApp(Nube());

class Nube extends StatefulWidget{




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Estado();
  }

}


class Estado extends State{
  final txtMensaje = TextEditingController();

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Text('amigo'),
      subtitle: Text(document['mensaje'].toString()),
    );
  }
  @override
  Widget build (BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('servicios en la nube'),
        ) ,
        body:
        Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'escribe un mensaje',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)
                )
              ),
              controller: txtMensaje,
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('wapsap').snapshots(),
              builder: (context, snapshot){
               return  ListView.builder(
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   itemExtent: 80.0,
                   itemCount: snapshot.data.documents.length,
                   itemBuilder: (context, index)=>
               _buildListItem(context, snapshot.data.documents[index])
               );

              }),


          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
              insertar(txtMensaje.text);

            });

          },
          child: Icon(Icons.message),
        ),
      ),
    );

  }

  void insertar(String mensaje)async{
    setState(() async{
      await bd.collection("wapsap").add({'mensaje': mensaje});

    });

  }

  void eliminar()async{
    await bd.collection('wapsap').document().delete();
  }

  void actualizar()async{
    await bd.collection('wapsap').document("").updateData({'mensaje': 'mensaje actualizado'});
  }


}