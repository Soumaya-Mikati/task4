import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> packageList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('https://apix.freshvery.com/api/home/category/package'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        final List<dynamic> data = json.decode(response.body)['data'];

        print('API Response: $data'); // Add this line for debugging

        setState(() {
          packageList = List<Map<String, dynamic>>.from(
              data.map((item) => Map<String, dynamic>.from(item)));
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package List'),
      ),
      body: ListView.builder(
        itemCount: packageList.length,
        itemBuilder: (context, index) {
          final package = packageList[index];
          return ListTile(
            title: Text(package['name']),
            subtitle: Text(package['namear']),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(package['name']),
                    content: Text(package['description']),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
