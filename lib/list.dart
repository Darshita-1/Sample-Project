import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Data>> fetchData() async {
  Uri requestURL =
      Uri.parse('https://run.mocky.io/v3/d53400a3-6126-495e-9d16-0b4414b537b3');
  http.Response response = await http.get(requestURL);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occurred!');
  }
}

class Data {
  final String name;
  final int id;
  final String company;
  final int orderId;
  final String invoicepaid;
  final String invoicePending;

  Data(
      {required this.id,
      required this.name,
      required this.company,
      required this.orderId,
      required this.invoicepaid,
      required this.invoicePending});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['clients'][0]['name'],
      id: json['clients'][0]['id'],
      company: json['clients'][0]['company'],
      orderId: json['clients'][0]['orderId'],
      invoicepaid: json['clients'][0]['invoicepaid'],
      invoicePending: json['clients'][0]['invoicePending'],
    );
  }
}

class ListViewHome extends StatefulWidget {
  const ListViewHome({Key? key}) : super(key: key);
  @override
  _ListViewHomeState createState() => _ListViewHomeState();
}

class _ListViewHomeState extends State<ListViewHome> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    print('$futureData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
      ),
      body: Center(
        child: FutureBuilder<List<Data>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Data>? data = snapshot.data;
              return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 75,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(data[index].name),
                          subtitle: Column(
                            children: [
                        
                              Text(data[index].company),
                           
                            ],
                          ),
                        ));
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
