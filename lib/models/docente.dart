import 'dart:convert';

class DocenteModel {
  List<Docente> docentes;
  DocenteModel({required this.docentes});
  factory DocenteModel.fromJson(List<dynamic> json) {
    return DocenteModel(docentes: verificarDocentes(json));
  }

  static List<Docente> verificarDocentes(List<dynamic> docenteJSON) {
    List<dynamic> isDocente = jsonDecode(jsonEncode(docenteJSON));
    List<Docente> listaDeDocentes =
        isDocente.map((datos) => Docente.fromJson(datos)).toList();

    return listaDeDocentes;
  }
}

class Docente {
  final String? id;
  final String picture;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String fechaNacimiento;
  final String grado;
  final String grupo;
  final int librosLeidos;

  const Docente({
    required this.id,
    required this.picture,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.fechaNacimiento,
    required this.grado,
    required this.grupo,
    required this.librosLeidos,
  });

  factory Docente.fromJson(Map<String, dynamic> json) => Docente(
      id: json['id'],
      picture: json['picture'],
      nombre: json['nombre'],
      apellidoPaterno: json['apellidoPaterno'],
      apellidoMaterno: json['apellidoMaterno'],
      fechaNacimiento: json['fechaNacimiento'],
      grado: json['grado'],
      grupo: json['grupo'],
      librosLeidos: json['librosLeidos']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'picture': picture,
        'nombre': nombre,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'fechaNacimiento': fechaNacimiento,
        'grado': grado,
        'grupo': grupo,
        'librosLeidos': librosLeidos,
      };
}
