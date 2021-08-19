import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class Data {
  late final int userId;
  late final int id;
  late final String title;

  Data({
    required this.userId,
    required this.id,
    required this.title
  });

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );

  }
}

Future<List<Data>> fetchData() async{
  final Uri url = Uri.parse("https://jsonplaceholder.typicode.com/albums");
  const String URL_I = "https://jsonplaceholder.typicode.com/albums";
  const String URL_II = "https://jsonplaceholder.typicode.com/todos/1";
  final response = await http.get(url);

  final responseII = await Dio().get(
    URL_I,
      options: buildCacheOptions(
          Duration(hours: 1),
          forceRefresh: false
      ),

  );

  if(response.statusCode == 200){
    print(response.body);
    lineBreak();
    print(json.decode(response.body));
    lineBreak();
  }

  if(responseII.statusCode == 200){

    print(json.encode(responseII.data));
    lineBreak();
  }

  if(responseII.statusCode == 200){
    List jsonResponse =  responseII.data; //json.decode(json.encode(responseII.data));

    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  }
  else{
    throw Exception('Unexpected error occurred!');
  }


}

void main(){
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final String _title = "List View From API With Cache";
  late Future <List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: _title,
      home : Scaffold(
        appBar: AppBar(
          title : Text(_title)
        ),
        body: Center(
          child: FutureBuilder <List<Data>>(
            future : futureData,
            builder : (context, snapshot){
              if(snapshot.hasData){
                List<Data>? data = snapshot.data;

                return ListView.builder(
                    itemCount : data!.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        height : 75,
                        color : Colors.white,
                        child : Center(
                          child : Text(data[index].title)
                        )
                      );
                    }
                );

              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            }
          ),
        ),
      )
    );
  }
}

void lineBreak(){
  print("\n \n \n -------------------------------------------------------------------------- \n \n \n");
}






