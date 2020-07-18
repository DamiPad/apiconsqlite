import 'package:flutter/material.dart';
import 'package:apiconsqlite/app.dart';
import 'package:apiconsqlite/models/db.dart';

 
// void main() => runApp(MyApp());


void main() async {

    WidgetsFlutterBinding.ensureInitialized();

    await DB.init();
    runApp(MyApp());
}
