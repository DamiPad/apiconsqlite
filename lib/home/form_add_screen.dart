import 'package:flutter/material.dart';
import 'package:apiconsqlite/models/db.dart';
import 'package:apiconsqlite/models/profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  final Materias materia;

  FormAddScreen({this.materia});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  DB _apiService;
  bool _isFieldNombreValid;
  bool _isFieldProfesorValid;
  bool _isFieldCuatrimestreValid;
  bool _isFieldHorarioValid;
  String _task;
  List<Materias> _tasks = [];


  TextEditingController _controllerNombre = TextEditingController();
  TextEditingController _controllerProfesor = TextEditingController();
  TextEditingController _controllerCuatrimestre = TextEditingController();
  TextEditingController _controllerHorario= TextEditingController();
    

  @override
  void initState() {
    if (widget.materia != null) {
      _isFieldNombreValid = true;
      _controllerNombre.text = widget.materia.nombre;
      _isFieldProfesorValid = true;
      _controllerProfesor.text = widget.materia.profesor;
      _isFieldCuatrimestreValid = true;
      _controllerCuatrimestre.text = widget.materia.cuatrimestre;
      _isFieldHorarioValid = true;
      _controllerHorario.text = widget.materia.horario;
     
    }
    refresh();
    super.initState();
  }

    void refresh() async {

        List<Map<String, dynamic>> _results = await DB.query(Materias.table);
        _tasks = _results.map((item) => Materias.fromMap(item)).toList();
        setState(() { });
    }

  
  


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.materia == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldNombre(),
                _buildTextFieldProfesor(),
                _buildTextFieldCuatrimestre(),
                _buildTextFieldHorario(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.materia == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNombreValid == null ||
                          _isFieldProfesorValid == null ||
                          _isFieldCuatrimestreValid == null ||
                          _isFieldHorarioValid == null ||
                          !_isFieldNombreValid ||
                          !_isFieldProfesorValid ||
                          !_isFieldCuatrimestreValid||
                          !_isFieldHorarioValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String nombre = _controllerNombre.text.toString();
                      String profesor = _controllerProfesor.text.toString();
                      String cuatrimestre = _controllerCuatrimestre.text.toString();
                      String horario = _controllerHorario.text.toString();

                     
                      Materias materia =
                          Materias(nombre: nombre, profesor: profesor, cuatrimestre: cuatrimestre, horario: horario);
                      if (widget.materia == null) {
                        DB.insert(Materias.table, materia)
                        .then((isSucces) {
                            if (isSucces==1) {
                        //_apiService.createMaterias(materia).then((isSuccess) {
                          //setState(() => _isLoading = false);
                         // if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Submit data failed"),
                            ));
                          }
                        });
                      } else {
                        materia.id = widget.materia.id;
                        DB.update(Materias.table, materia)
                        .then((isSucces) {
                          if (isSucces==1) {
                        //_apiService.updateMaterias(materia).then((isSuccess) {
                        //  setState(() => _isLoading = false);
                          //if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldNombre() {
    return TextField(
      controller: _controllerNombre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nombre",
        errorText: _isFieldNombreValid == null || _isFieldNombreValid
            ? null
            : "Nombre",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNombreValid) {
          setState(() => _isFieldNombreValid = isFieldValid);
        }
      },
    );
  }

 Widget _buildTextFieldProfesor() {
    return TextField(
      controller: _controllerProfesor,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Profesor",
        errorText: _isFieldProfesorValid == null || _isFieldProfesorValid
            ? null
            : "Profesor",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldProfesorValid) {
          setState(() => _isFieldProfesorValid = isFieldValid);
        }
      },
    );
  }

   Widget _buildTextFieldCuatrimestre() {
    return TextField(
      controller: _controllerCuatrimestre,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Cuatrimestre",
        errorText: _isFieldCuatrimestreValid == null || _isFieldCuatrimestreValid
            ? null
            : "Cuatrimestre",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldCuatrimestreValid) {
          setState(() => _isFieldCuatrimestreValid = isFieldValid);
        }
      },
    );
  }

   Widget _buildTextFieldHorario() {
    return TextField(
      controller: _controllerHorario,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Horario",
        errorText: _isFieldHorarioValid == null || _isFieldHorarioValid
            ? null
            : "Horario",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldHorarioValid) {
          setState(() => _isFieldHorarioValid = isFieldValid);
        }
      },
    );
  }
  
}