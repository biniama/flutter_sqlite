import 'package:flutter/material.dart';
import 'package:flutter_sqlite/Database.dart';
import 'dart:math' as math;

import 'package:flutter_sqlite/SettingModel.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // data for testing
  List<Setting> testSettings = [
    Setting(property: "Raouf", value: "Rahiche", expired: false),
    Setting(property: "Zaki", value: "oun", expired: true),
    Setting(property: "oussama", value: "ali", expired: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Setting>>(
        future: DBProvider.db.getAllSettings(),
        builder: (BuildContext context, AsyncSnapshot<List<Setting>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Setting item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBProvider.db.deleteSetting(item.id);
                  },
                  child: ListTile(
                    title: Text(item.value),
                    leading: Text(item.id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBProvider.db.expireOrUnexpire(item);
                        setState(() {});
                      },
                      value: item.expired,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Setting rnd = testSettings[math.Random().nextInt(testSettings.length)];
          await DBProvider.db.createSetting(rnd);
          setState(() {});
        },
      ),
    );
  }
}