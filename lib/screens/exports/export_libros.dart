import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_library_app/models/docente.dart';
import 'package:flutter_library_app/models/solicitud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../database/database.dart';
import '../../models/estudiante.dart';
import '../../models/libro.dart';
import '../../util/responsive.dart';

class ExportBooksScreen extends StatefulWidget {
  const ExportBooksScreen({super.key});

  @override
  State<ExportBooksScreen> createState() => _ExportBooksScreenState();
}

class _ExportBooksScreenState extends State<ExportBooksScreen> {
  List<Libro> _librosPage = [];
  List<Estudiante> _estudiantesPage = [];
  List<Docente> _docentesPage = [];
  List<Solicitud> _solicitudesPage = [];
  List<Solicitud> _solicitudesRetrasadasPage = [];

  @override
  void initState() {
    super.initState();
    _getLibros();
    _getEstudiantes();
    _getDocentes();
    _getSolicitudes();
    _getSolicitudesRetrasadas();
  }

  Future<void> _getLibros() async {
    final libros = await DatabaseHelper.getAllLibros();
    if (libros != null) {
      setState(() {
        _librosPage = libros;
      });
    }
  }

  Future<void> _getEstudiantes() async {
    final estudiantes = await DatabaseHelper.getAllEstudiantesDesc();
    if (estudiantes != null) {
      setState(() {
        _estudiantesPage = estudiantes;
      });
    }
  }

  Future<void> _getDocentes() async {
    final docentes = await DatabaseHelper.getAllDocentes();
    if (docentes != null) {
      setState(() {
        _docentesPage = docentes;
      });
    }
  }

  Future<void> _getSolicitudes() async {
    final solicitudes = await DatabaseHelper.getAllSolicitudes();
    if (solicitudes != null) {
      setState(() {
        _solicitudesPage = solicitudes;
      });
    }
  }

  Future<void> _getSolicitudesRetrasadas() async {
    final solicitudesRetrasadas =
        await DatabaseHelper.getSolicitudesRetrasadas();
    if (solicitudesRetrasadas != null) {
      setState(() {
        _solicitudesRetrasadasPage = solicitudesRetrasadas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Exportar base de datos a Excel',
            style: TextStyle(fontSize: responsive.dp(2.8))),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Presiona el botón para exportar la base de datos a Excel',
                style: TextStyle(
                    fontSize: responsive.dp(2), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.hp(10)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: responsive.dp(2)),
                ),
                onPressed: () async {
                  final directory = await getExternalStorageDirectory();
                  var now = DateTime.now();
                  String docName =
                      'data_${now.day}-${now.month}-${now.year}-${now.hour}-${now.minute}-${now.second}';
                  File file = File('${directory?.path}/$docName.xlsx');
                  var excel = Excel.createExcel();
                  //excel.delete('Sheet1');

                  // LIBROS
                  Sheet sheetObject = excel['libros'];
                  sheetObject.appendRow([
                    "#",
                    "Titulo",
                    "Autor",
                    "Serie",
                    "Genero",
                    "Solicitudes"
                  ]);

                  for (int i = 0; i < _librosPage.length; i++) {
                    Libro book = _librosPage[i];
                    sheetObject.appendRow([
                      i + 1,
                      book.titulo,
                      book.autor,
                      book.serie,
                      book.genero,
                      book.solicitudes
                    ]);
                  }

                  // ESTUDIANTES
                  sheetObject = excel['estudiantes'];
                  sheetObject.appendRow([
                    "#",
                    "Número de control",
                    "Nombre",
                    "Apellido paterno",
                    "Apellido materno",
                    "Fecha de nacimiento",
                    "Grado",
                    "Grupo",
                    "Libros leídos"
                  ]);

                  for (int i = 0; i < _estudiantesPage.length; i++) {
                    Estudiante estudiante = _estudiantesPage[i];
                    sheetObject.appendRow([
                      i + 1,
                      estudiante.numControl,
                      estudiante.nombre,
                      estudiante.apellidoPaterno,
                      estudiante.apellidoMaterno,
                      estudiante.fechaNacimiento,
                      estudiante.grado,
                      estudiante.grupo,
                      estudiante.librosLeidos
                    ]);
                  }

                  // DOCENTES
                  sheetObject = excel['docentes'];
                  sheetObject.appendRow([
                    "#",
                    "Número de control",
                    "Nombre",
                    "Apellido paterno",
                    "Apellido materno",
                    "Fecha de nacimiento",
                    "Grado",
                    "Grupo"
                  ]);

                  for (int i = 0; i < _docentesPage.length; i++) {
                    Docente docente = _docentesPage[i];
                    sheetObject.appendRow([
                      i + 1,
                      docente.id,
                      docente.nombre,
                      docente.apellidoPaterno,
                      docente.apellidoMaterno,
                      docente.fechaNacimiento,
                      docente.grado,
                      docente.grupo,
                    ]);
                  }

                  // SOLICITUDES
                  sheetObject = excel['solicitudes'];
                  sheetObject.appendRow([
                    "#",
                    "Fecha de solicitud",
                    "Fecha prevista de devolución",
                    "Fecha de devolución",
                    "Título de libro",
                    "Estudiante",
                    "Estatus"
                  ]);

                  for (int i = 0; i < _solicitudesPage.length; i++) {
                    Solicitud solicitud = _solicitudesPage[i];
                    sheetObject.appendRow([
                      i + 1,
                      solicitud.fechaSolicitud,
                      solicitud.fechaPrevista,
                      solicitud.fechaDevolucion,
                      solicitud.libroTitulo,
                      '${solicitud.nombreEstudiante} ${solicitud.apellidoPaternoEstudiante} ${solicitud.apellidoMaternoEstudiante}',
                      solicitud.estatus
                    ]);
                  }

                  // SOLICITUDES RETRASADAS
                  sheetObject = excel['solicitudes retrasadas'];
                  sheetObject.appendRow([
                    "#",
                    "Fecha de solicitud",
                    "Fecha prevista de devolución",
                    "Fecha de devolución",
                    "Título de libro",
                    "Estudiante",
                    "Estatus"
                  ]);

                  for (int i = 0; i < _solicitudesRetrasadasPage.length; i++) {
                    Solicitud solicitud = _solicitudesRetrasadasPage[i];
                    sheetObject.appendRow([
                      i + 1,
                      solicitud.fechaSolicitud,
                      solicitud.fechaPrevista,
                      solicitud.fechaDevolucion,
                      solicitud.libroTitulo,
                      '${solicitud.nombreEstudiante} ${solicitud.apellidoPaternoEstudiante} ${solicitud.apellidoMaternoEstudiante}',
                      solicitud.estatus
                    ]);
                  }

                  excel.setDefaultSheet('libros');
                  excel.delete('Sheet1');
                  //excel.sheets;*/

                  var encodedExcel = excel.encode();
                  file.writeAsBytesSync(encodedExcel!);

                  if (mounted) {
                    Flushbar(
                      messageText: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Archivo guardado en $file',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              OpenFile.open(file.path);
                            },
                            child: const Text(
                              'Ver archivo',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      icon: const Icon(
                        Icons.error_outline,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      duration: const Duration(seconds: 7),
                      leftBarIndicatorColor: Colors.green,
                      backgroundColor: Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(16.0),
                      flushbarStyle: FlushbarStyle.FLOATING,
                    ).show(context);
                  }
                },
                child: Text('Exportar a Excel',
                    style: TextStyle(fontSize: responsive.dp(2))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
