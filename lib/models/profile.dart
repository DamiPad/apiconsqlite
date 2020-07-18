import 'package:apiconsqlite/models/model.dart';

class Materias extends Model {

    static String table = 'materias_db';

   int id;
    String nombre;
    String profesor;
    String cuatrimestre;
    String horario;
    bool complete;

    Materias({
    this.id,
    this.nombre,
    this.profesor,
    this.cuatrimestre,
    this.horario,
    this.complete

  });

    Map<String, dynamic> toMap() {

        Map<String, dynamic> map = {
            "nombre": nombre, 
            "profesor":profesor, 
            "cuatrimestre":cuatrimestre,
            "horario": horario,
            'complete': complete
        };

        if (id != null) { map['id'] = id; }
        return map;
    }

    static Materias fromMap(Map<String, dynamic> map) {
        
        return Materias(
            id: map['id'],
            nombre: map['nombre'],
            profesor: map['profesor'],
            cuatrimestre: map['cuatrimestre'],
            horario: map['horario'],
            complete: map['complete'] == 1
        );
    }
}