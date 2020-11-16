import 'package:flutter/material.dart';
import './main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditData extends StatefulWidget {
  final Mhs mhs;
    /// Melakukan Consruktor Data
  EditData({this.mhs});
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {

  TextEditingController controllerNim;
  TextEditingController controllerName;
  TextEditingController controllerKelas;
  TextEditingController controllerKdMatkul;
  TextEditingController controllerEmail;
// API Update data
Future<bool>editData() async {
    final url = "https://myflutteryofi.000webhostapp.com/updateDatajson.php";
    final response = await http.post(url, body:{
        'nim': widget.mhs.nim,
        'nama': controllerName.text,
        "kelas": controllerKelas.text,
        "kdmatkul": controllerKdMatkul.text,
        "email": controllerEmail.text
    });
    if(response.statusCode == 200 ) {
        
    final result = jsonDecode(response.body);
        return (result['status'] == 'success');
    }
    return false;
}

@override
void initState() { 
  controllerNim= new TextEditingController(text: widget.mhs.nim);
  controllerName= new TextEditingController(text: widget.mhs.nama );
  controllerKelas= new TextEditingController(text: widget.mhs.kelas);
  controllerKdMatkul= new TextEditingController(text: widget.mhs.kdmatkul );
  controllerEmail= new TextEditingController(text: widget.mhs.email );
  super.initState(); 
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Edit Data Mahasiswa"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            new Column(
              children: <Widget> [
                new TextField(
                  controller: controllerNim,
                  decoration: new InputDecoration(
                    hintText: "Nim", labelText: "Nim"
                  ),
                ),
                new TextField(
                  controller: controllerName,
                  decoration: new InputDecoration(
                    hintText: "Name", labelText: "Name"
                  ),
                ),
                new TextField(
                  controller: controllerKelas,
                  decoration: new InputDecoration(
                    hintText: "Kelas", labelText: "Kelas"
                  ),
                ),
                new TextField(
                  controller: controllerKdMatkul,
                  decoration: new InputDecoration(
                    hintText: "Kode Matkul", labelText: "Kode Matkul"
                  ),
                ),
                new TextField(
                  controller: controllerEmail,
                  decoration: new InputDecoration(
                    hintText: "Email", labelText: "Email"
                  ),
                ),
                new Padding( 
                  padding: const EdgeInsets.all(10.0),
                ),
                new RaisedButton(
                  child: new Text("Edit Data"),
                  color: Colors.blueAccent,
                  onPressed: () async{
                    if(await editData()){
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        // kembali kehalaman awal
                        builder: (BuildContext context)=> new MyApp()
                      )
                    );}
                  },
                )
              ],
            ),
          ],
        ),
        ),
    );
  }
}