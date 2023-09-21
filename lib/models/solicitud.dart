import 'dart:convert';

class SolicitudModel {
  List<Solicitud> solicitudes;
  SolicitudModel({required this.solicitudes});
  factory SolicitudModel.fromJson(List<dynamic> json) {
    return SolicitudModel(solicitudes: verificarSolicitudes(json));
  }

  static List<Solicitud> verificarSolicitudes(List<dynamic> solicitudJSON) {
    List<dynamic> isSolicitud = jsonDecode(jsonEncode(solicitudJSON));
    List<Solicitud> listaDeSolicitudes =
        isSolicitud.map((datos) => Solicitud.fromJson(datos)).toList();

    return listaDeSolicitudes;
  }
}

class Solicitud {
  final String? id;
  final String fechaSolicitud;
  final String fechaPrevista;
  final String fechaDevolucion;
  final String libroID;
  final String libroPortada;
  final String libroTitulo;
  final String numControlEstudiante;
  final String nombreEstudiante;
  final String apellidoPaternoEstudiante;
  final String apellidoMaternoEstudiante;
  final String gradoEstudiante;
  final String grupoEstudiante;
  final String estatus;

  const Solicitud({
    required this.id,
    required this.fechaSolicitud,
    required this.fechaPrevista,
    required this.fechaDevolucion,
    required this.libroID,
    required this.libroPortada,
    required this.libroTitulo,
    required this.numControlEstudiante,
    required this.nombreEstudiante,
    required this.apellidoPaternoEstudiante,
    required this.apellidoMaternoEstudiante,
    required this.gradoEstudiante,
    required this.grupoEstudiante,
    required this.estatus,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
      id: json['id'],
      fechaSolicitud: json['fechaSolicitud'],
      fechaPrevista: json['fechaPrevista'],
      fechaDevolucion: json['fechaDevolucion'],
      libroID: json['libroID'],
      libroPortada: json['libroPortada'],
      libroTitulo: json['libroTitulo'],
      numControlEstudiante: json['numControlEstudiante'],
      nombreEstudiante: json['nombreEstudiante'],
      apellidoPaternoEstudiante: json['apellidoPaternoEstudiante'],
      apellidoMaternoEstudiante: json['apellidoMaternoEstudiante'],
      gradoEstudiante: json['gradoEstudiante'],
      grupoEstudiante: json['grupoEstudiante'],
      estatus: json['estatus']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'fechaSolicitud': fechaSolicitud,
        'fechaPrevista': fechaPrevista,
        'fechaDevolucion': fechaDevolucion,
        'libroID': libroID,
        'libroPortada': libroPortada,
        'libroTitulo': libroTitulo,
        'numControlEstudiante': numControlEstudiante,
        'nombreEstudiante': nombreEstudiante,
        'apellidoPaternoEstudiante': apellidoPaternoEstudiante,
        'apellidoMaternoEstudiante': apellidoMaternoEstudiante,
        'gradoEstudiante': gradoEstudiante,
        'grupoEstudiante': grupoEstudiante,
        'estatus': estatus
      };
}
