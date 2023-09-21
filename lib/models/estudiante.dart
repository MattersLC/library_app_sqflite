class Estudiante {
  final String? id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String fechaNacimiento;
  final String grado;
  final String grupo;
  final String numControl;
  final int librosLeidos;

  const Estudiante({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.fechaNacimiento,
    required this.grado,
    required this.grupo,
    required this.numControl,
    required this.librosLeidos,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
      id: json['id'],
      nombre: json['nombre'],
      apellidoPaterno: json['apellidoPaterno'],
      apellidoMaterno: json['apellidoMaterno'],
      fechaNacimiento: json['fechaNacimiento'],
      grado: json['grado'],
      grupo: json['grupo'],
      numControl: json['numControl'],
      librosLeidos: json['librosLeidos']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellidoPaterno': apellidoPaterno,
        'apellidoMaterno': apellidoMaterno,
        'fechaNacimiento': fechaNacimiento,
        'grado': grado,
        'grupo': grupo,
        'numControl': numControl,
        'librosLeidos': librosLeidos,
      };
}
