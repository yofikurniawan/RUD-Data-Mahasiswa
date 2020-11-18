import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './editdata.dart';

// API Tampil Data
Future<List<Mhs>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://myflutteryofi.000webhostapp.com/readDatajson.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Mhs> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Mhs>((json) => Mhs.fromJson(json)).toList();
}

// API Delete Data 
  Future<bool> deleteMahasiswa(String nim) async {
    var client = http.Client();
    String url ="https://myflutteryofi.000webhostapp.com/deleteDatajson.php";
    var response = await client.post(url, body: {'nim': nim});
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return (result['status'] == 'success');
    }
    return false;
  }


class Mhs {
  final String nim;
  final String nama;
  final String kelas;
  final String kdmatkul;
  final String email;

  Mhs({this.nim, this.nama, this.kelas, this.kdmatkul, this.email});

  factory Mhs.fromJson(Map<String, dynamic> json) {
    return Mhs(
      nim: json['nim'] as String,
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      kdmatkul: json['kdmatkul'] as String,
      email: json['email'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Mahasiswa';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Mhs>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(mhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

//alert delete
//  void confirm (){
//   AlertDialog alertDialog = new AlertDialog(
//     content: new Text("Apakah data yakin ingin di delete?"),
//     actions: <Widget>[
//       new RaisedButton(
//         child: new Text(" Ok Delete! "),
//         color: Colors.red,
//         onPressed: (){},
//       ),
//       new RaisedButton(
//         child: new Text("Batal"),
//         color: Colors.green,
//         onPressed: (){},
//       ),
//     ],
//   );
//   showDialog(context: context, child: alertDialog);
// }


class MhssList extends StatelessWidget {
  final List<Mhs> mhsData;

  MhssList({Key key, this.mhsData}) : super(key: key);

Widget viewData(var data,int index,BuildContext context)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://avatars0.githubusercontent.com/u/74368872?s=400&v=4"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://avatars0.githubusercontent.com/u/74368872?s=400&v=4",
             // ),
            title: Text(data[index].nim, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                OutlineButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>EditData(mhs:data[index])));
                   },
                ),
                OutlineButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  splashColor: Colors.blueAccent,
                  onPressed: (){
                    deleteMahasiswa(data[index].nim);
                    Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
                  },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: mhsData.length,
      itemBuilder: (context, index) {
        return viewData(mhsData,index,context);
      },
    );
  }


}