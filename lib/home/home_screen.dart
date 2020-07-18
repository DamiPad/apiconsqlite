import 'package:flutter/material.dart';
import 'package:apiconsqlite/models/db.dart';
import 'package:apiconsqlite/models/profile.dart';
import 'package:apiconsqlite/home/form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;
  DB apiBaseDatos;
  String _task;
  List<Materias> _tasks = [];
  //List<Widget> get _items => _tasks.map((item) => _buildListView(_tasks)).toList();

  @override
  void initState() {
    //super.initState();
    //apiBaseDatos = DB();//NO ENTIENDO
    
     create();
    
      super.initState();

  }


  void create(){
     Materias materia = Materias(nombre: 'el', profesor: 'ella', cuatrimestre: 'ultimo', horario: 'el');
 
    DB.insert('materias_db',materia);
    refresh();
  }
  void refresh() async {

        List<Map<String, dynamic>> _results = await DB.query(Materias.table);
        _tasks = _results.map((item) => Materias.fromMap(item)).toList();
        setState(() { });

    }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: FutureBuilder(
        future:DB.getMaterias(),
        builder: (BuildContext context, AsyncSnapshot<List<Materias>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Materias> materia = snapshot.data;
            return _buildListView(materia);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Materias> materias) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Materias materia = materias[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      materia.nombre,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(materia.profesor),
                    Text(materia.cuatrimestre),
                    Text(materia.horario),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                        "Are you sure want to delete data profile ${materia.nombre}?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                         DB.delete(Materias.table, materia)
                                        .then((isSucces) {
                                            if (isSucces==1) {
                                              setState(() {});
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Delete data success")));
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Delete data failed")));
                                            }
                                          });
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FormAddScreen(materia: materia);
                            }));
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: materias.length,
      ),
    );
  }
}