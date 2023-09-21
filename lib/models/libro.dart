import 'dart:convert';

class LibroModel {
  List<Libro> libros;
  LibroModel({required this.libros});
  factory LibroModel.fromJson(List<dynamic> json) {
    return LibroModel(libros: verificarLibros(json));
  }

  static List<Libro> verificarLibros(List<dynamic> libroJSON) {
    List<dynamic> isLibro = jsonDecode(jsonEncode(libroJSON));
    List<Libro> listaDeLibros =
        isLibro.map((datos) => Libro.fromJson(datos)).toList();

    return listaDeLibros;
  }
}

class Libro {
  final String id;
  final String titulo;
  final String autor;
  final String descripcion;
  final int unidades;
  final String serie;
  final String genero;
  final String picture;
  final String barcode;
  int solicitudes;
  int cantidadDisponibles;
  int cantSolicitados;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.descripcion,
    required this.unidades,
    required this.serie,
    required this.genero,
    required this.picture,
    required this.barcode,
    required this.solicitudes,
    required this.cantidadDisponibles,
    required this.cantSolicitados,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
        id: json['id'],
        titulo: json['titulo'],
        autor: json['autor'],
        descripcion: json['descripcion'],
        unidades: json['unidades'],
        serie: json['serie'],
        genero: json['genero'],
        solicitudes: json['solicitudes'],
        picture: json['picture'],
        barcode: json['barcode'],
        cantidadDisponibles: json['cantidadDisponibles'],
        cantSolicitados: json['cantSolicitados'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'descripcion': descripcion,
        'unidades': unidades,
        'serie': serie,
        'genero': genero,
        'solicitudes': solicitudes,
        'picture': picture,
        'barcode': barcode,
        'cantidadDisponibles': cantidadDisponibles,
        'cantSolicitados': cantSolicitados,
      };
}

List<dynamic> menuDeFiltro = [
  'Libro',
  'Estudiante',
  'Docente',
];
