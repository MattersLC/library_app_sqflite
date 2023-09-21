import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_app/database/database.dart';
import 'package:flutter_library_app/models/solicitud.dart';
import 'package:flutter_library_app/screens/solicitudes/solicitudes_por_libro.dart';
import 'package:flutter_library_app/util/responsive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../models/estudiante.dart';
import '../../../models/libro.dart';
import '../../../util/uppercase.dart';

class LibroDetallado extends StatefulWidget {
  final String libroId;
  const LibroDetallado({super.key, required this.libroId});

  @override
  State<LibroDetallado> createState() => _LibroDetalladoState();
}

class _LibroDetalladoState extends State<LibroDetallado> {
  bool _isRequestButtonEnabled = false;
  final numControlController = TextEditingController();
  Responsive? responsive;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _checkBookAvailability();
  }

  Future<void> _checkBookAvailability() async {
    Libro? libro = await DatabaseHelper.getLibroById(widget.libroId);
    if (libro != null && libro.cantidadDisponibles > 0) {
      setState(() {
        _isRequestButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles de libro",
          style: TextStyle(fontSize: responsive!.dp(2.8)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Acción a realizar cuando se selecciona una opción del menú
              if (value == 'eliminar') {
                deleteLibro(widget.libroId, context);
              } else if (value == 'editar') {
                // Acción a realizar cuando se selecciona la opción "Editar"
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'editar',
                child: ListTile(
                  leading: Icon(Icons.edit, size: responsive!.dp(3)),
                  title: Text(
                    'Editar',
                    style: TextStyle(fontSize: responsive!.dp(2)),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'eliminar',
                child: ListTile(
                  leading: Icon(Icons.delete, size: responsive!.dp(3)),
                  title: Text(
                    'Eliminar',
                    style: TextStyle(fontSize: responsive!.dp(2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Libro?>(
        future: DatabaseHelper.getLibroById(widget.libroId),
        builder: (BuildContext context, AsyncSnapshot<Libro?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            Libro libro = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  libro.titulo,
                                  style: TextStyle(
                                    fontSize: responsive!.dp(3.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: responsive!.hp(3)),
                                Text("Autor(a): ${libro.autor}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                    )),
                                SizedBox(height: responsive!.hp(2.5)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SolicitudesPorLibro(
                                          libroName: libro.titulo,
                                          type: 'total',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                      "Total de prestamos: ${libro.solicitudes}",
                                      style: TextStyle(
                                        fontSize: responsive!.dp(2),
                                      )),
                                ),
                                SizedBox(height: responsive!.hp(2.5)),
                                Text("Unidades: ${libro.unidades}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                    )),
                                SizedBox(height: responsive!.hp(2.5)),
                                Text(
                                    "Disponibles: ${cantDisponibles(libro.unidades, libro.cantSolicitados)}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                    )),
                                SizedBox(height: responsive!.hp(2.5)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SolicitudesPorLibro(
                                          libroName: libro.titulo,
                                          type: 'activos',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Prestamos activos: ${libro.cantSolicitados}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                SizedBox(height: responsive!.hp(2.5)),
                                Text("Serie: ${libro.serie}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                    )),
                                SizedBox(height: responsive!.hp(2.5)),
                                Text("Género: ${libro.genero}",
                                    style: TextStyle(
                                      fontSize: responsive!.dp(2),
                                    )),
                                SizedBox(height: responsive!.hp(2.5)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Container(
                            width: responsive!.wp(50),
                            height: responsive!.hp(45),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  base64Decode(libro.picture),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive!.hp(5)),
                      Center(
                        child: Text(
                          "Descripción del libro",
                          style: TextStyle(
                            fontSize: responsive!.dp(3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: responsive!.hp(2.5)),
                      Text(
                        libro.descripcion,
                        style: TextStyle(fontSize: responsive!.dp(2)),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width -
                          32, // Ajusta el ancho del contenedor a la pantalla
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: responsive!.wp(34),
                              height: responsive!.hp(6),
                              child: ElevatedButton.icon(
                                onPressed:
                                    libro.cantSolicitados >= libro.unidades
                                        ? null
                                        : () {
                                            prestarLibro(context, libro);
                                            // Acción a realizar al presionar el botón
                                          },
                                icon: Icon(Icons.south_outlined,
                                    size: responsive!.dp(3)),
                                label: Text(
                                  'Solicitar',
                                  style: TextStyle(fontSize: responsive!.dp(2)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: responsive!.wp(6)),
                            SizedBox(
                              width: responsive!.wp(34),
                              height: responsive!.hp(6),
                              child: ElevatedButton.icon(
                                onPressed: libro.cantSolicitados == 0
                                    ? null
                                    : () {
                                        //prestarLibro(context, libro);
                                        // Acción a realizar al presionar el botón
                                        devolverLibro(context, libro);
                                      },
                                icon: Icon(
                                  Icons.keyboard_return,
                                  size: responsive!.dp(3),
                                ),
                                label: Text(
                                  'Devolver',
                                  style: TextStyle(fontSize: responsive!.dp(2)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green, // Color de fondo del botón
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  int cantDisponibles(int unidades, int solicitados) {
    return unidades - solicitados;
  }

  // Función para escanear el código de barras o QR
  /*Future<void> scanBarcode() async {
    // ...
  }

  // Método para construir el botón "Escanear"
  Widget buildScanButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: () async {
        await scanBarcode();
      },
      icon: Icon(
        Icons.qr_code,
        size: responsive!.dp(4),
      ),
      label: Text('Escanéalo', style: TextStyle(fontSize: responsive!.dp(2.2))),
    );
  }*/

  // Método para construir el campo de texto
  Widget buildTextField() {
    return TextFormField(
      style: TextStyle(fontSize: responsive!.dp(2.5)),
      inputFormatters: [
        //FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        UpperCaseTextFormatter(),
      ],
      controller: numControlController,
      decoration: InputDecoration(
        hintText: 'Número de control',
        filled: true,
        fillColor: Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  // Método para construir el contenido del cuadro de diálogo
  Widget buildDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTextField(),
        /*SizedBox(height: responsive!.hp(1)),
        Center(
          child: Text('ó', style: TextStyle(fontSize: responsive!.dp(2.2))),
        ),
        SizedBox(height: responsive!.hp(0.8)),
        buildScanButton(),*/
      ],
    );
  }

  prestarLibro(BuildContext context, Libro libro) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
              child: Text('Ingrese sus datos',
                  style: TextStyle(fontSize: responsive!.dp(2.8))),
            )),
            content: buildDialogContent(),
            actions: <Widget>[
              TextButton(
                onPressed: _isRequestButtonEnabled
                    ? () async {
                        await aceptarPrestamo(
                            numControlController.text, libro, context);
                      }
                    : null,
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: responsive!.dp(2.2)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.red, fontSize: responsive!.dp(2.2)),
                ),
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Center(
              child: Text('Ingrese sus datos',
                  style: TextStyle(fontSize: responsive!.dp(2.8)))),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: buildDialogContent(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: _isRequestButtonEnabled
                  ? () async {
                      await aceptarPrestamo(
                          numControlController.text, libro, context);
                    }
                  : null,
              child: Text(
                'Aceptar',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: responsive!.dp(2.2)),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: Text(
                'Cancelar',
                style:
                    TextStyle(color: Colors.red, fontSize: responsive!.dp(2.2)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> aceptarPrestamo(
      String numControl, Libro libro, BuildContext context) async {
    bool estudianteValido = await validarEstudiante(numControl);

    if (!estudianteValido) {
      if (mounted) {
        Navigator.pop(context);

        // Mostrar mensaje de estudiante no válido
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              title: Text(
                'Error',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontSize: responsive!.dp(3)),
              ),
              content: Text(
                'El número de control ingresado no pertenece a ningún estudiante o ya alcanzó su límite de préstamos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: responsive!.dp(2.2)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Cierra el AlertDialog cuando se presiona el botón
                  },
                  child: Text(
                    'Entendido',
                    style: TextStyle(
                        color: Colors.white, fontSize: responsive!.dp(2.2)),
                  ),
                ),
              ],
            );
          },
        );
      }

      return;
    }

    DateTime now = DateTime.now();
    var data = DateTime.now().toLocal();
    var formato = DateFormat('dd/MM/yyyy');
    String fechaActual = formato.format(data.toLocal());
    String fechaPrevista = formato.format(now.add(const Duration(days: 3)));

    List<Estudiante> student =
        await DatabaseHelper.searchEstudiantesByNumControl(numControl);

    Solicitud solicitud = Solicitud(
      id: uuid.v1(),
      fechaSolicitud: fechaActual,
      fechaPrevista: fechaPrevista,
      fechaDevolucion: '-',
      libroID: widget.libroId,
      libroPortada: libro.picture,
      libroTitulo: libro.titulo,
      numControlEstudiante: numControl,
      nombreEstudiante: student[0].nombre,
      apellidoPaternoEstudiante: student[0].apellidoPaterno,
      apellidoMaternoEstudiante: student[0].apellidoMaterno,
      gradoEstudiante: student[0].grado,
      grupoEstudiante: student[0].grupo,
      estatus: 'prestado',
    );

    await DatabaseHelper.addSolicitud(solicitud);
    await DatabaseHelper.updateLibroAfterPrestamo(libro.id);
    await DatabaseHelper.incrementarLibrosLeidos(numControl);
    if (mounted) {
      Navigator.pushNamed(context, 'solicitudesPage');
    }
  }

  devolverLibro(BuildContext context, Libro libro) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
              child: Text('Ingrese sus datos',
                  style: TextStyle(fontSize: responsive!.dp(2.8))),
            )),
            content: buildDialogContent(),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await aceptarDevolucion(
                      numControlController.text, libro, context);
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: responsive!.dp(2.2)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.red, fontSize: responsive!.dp(2.2)),
                ),
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Center(
              child: Text('Ingrese sus datos',
                  style: TextStyle(fontSize: responsive!.dp(2.8)))),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: buildDialogContent(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () async {
                await aceptarDevolucion(
                    numControlController.text, libro, context);
              },
              child: Text(
                'Aceptar',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: responsive!.dp(2.2)),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: Text(
                'Cancelar',
                style:
                    TextStyle(color: Colors.red, fontSize: responsive!.dp(2.2)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> aceptarDevolucion(
      String numControl, Libro libro, BuildContext context) async {
    bool estudianteValido = await validarEstudianteSolicitud(numControl);

    if (!estudianteValido) {
      if (mounted) {
        Navigator.pop(context);

        // Mostrar mensaje de estudiante no válido
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              title: Text(
                'Error',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontSize: responsive!.dp(3)),
              ),
              content: Text(
                'El número de control ingresado no pertenece a ningún estudiante.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: responsive!.dp(2.2)),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Entendido',
                    style: TextStyle(
                        color: Colors.white, fontSize: responsive!.dp(2.2)),
                  ),
                ),
              ],
            );
          },
        );
      }

      return;
    }
    await DatabaseHelper.devolverLibro(numControlController.text, libro);
    await DatabaseHelper.updateLibroAfterDevolucion(libro.id);
    if (mounted) {
      Navigator.pop(context);
      setState(() {});
    }
  }

  Future<bool> validarEstudiante(String numControl) async {
    Estudiante? estudiante = await DatabaseHelper.getEstudiante(numControl);
    if (estudiante == null) {
      return false;
    } else {
      int prestamosActivos =
          await DatabaseHelper.getPrestamosActivos(numControl);
      return prestamosActivos < 3;
    }
  }

  Future<bool> validarEstudianteSolicitud(String numControl) async {
    Estudiante? estudiante = await DatabaseHelper.getEstudiante(numControl);
    if (estudiante == null) {
      return false;
    } else {
      int prestamosActivos =
          await DatabaseHelper.getPrestamosActivos(numControl);
      return prestamosActivos > 0;
    }
  }

  void deleteLibro(String libro, BuildContext context) async {
    if (Platform.isAndroid) {
      bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('¿Estás seguro de eliminar el elemento?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // Navigator.pushNamed(context, 'librosPage');
                },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () async {
                  await DatabaseHelper.deleteLibroById(libro);
                  setState(() {
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('Eliminar'),
              )
            ],
          );
        },
      );

      if (confirmed == null || !confirmed) {
        setState(() {});
      }
    } else {
      await showCupertinoDialog<bool>(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('¿Estás seguro de eliminar este libro?'),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await DatabaseHelper.deleteLibroById(libro);
                  setState(() {
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('Eliminar'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              )
            ],
          );
        },
      );
    }
  }
}
