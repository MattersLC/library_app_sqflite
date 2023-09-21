import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../models/estudiante.dart';
import '../../models/libro.dart';
import '../../models/solicitud.dart';
import '../../util/uppercase.dart';
import '../../util/responsive.dart';

class SolicitudesPorLibro extends StatefulWidget {
  final String libroName;
  final String type;
  const SolicitudesPorLibro(
      {super.key, required this.libroName, required this.type});

  @override
  State<SolicitudesPorLibro> createState() => _SolicitudesPorLibroState();
}

class _SolicitudesPorLibroState extends State<SolicitudesPorLibro> {
  List<Solicitud> _solicitudesPorLibro = [];
  final numControlController = TextEditingController();
  Responsive? responsive;

  _getTypeOfSearch() async {
    if (widget.type == 'total') {
      _getSolicitudes();
    } else {
      _getSolicitudesActivas();
    }
  }

  @override
  void initState() {
    super.initState();
    _getTypeOfSearch();
    //_getSolicitudes();
  }

  Future<void> _getSolicitudes() async {
    final solicitudes =
        await DatabaseHelper.getSolicitudesPorLibro(widget.libroName);
    if (solicitudes != null) {
      setState(() {
        _solicitudesPorLibro = solicitudes;
      });
    }
  }

  Future<void> _getSolicitudesActivas() async {
    final solicitudes =
        await DatabaseHelper.getSolicitudesPorLibroActivas(widget.libroName);
    if (solicitudes != null) {
      setState(() {
        _solicitudesPorLibro = solicitudes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestamos de ${widget.libroName}',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.8))),
        backgroundColor: Colors.blue,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              'home', // Reemplaza 'ruta_inicial' con el nombre de la ruta de la página inicial
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: _solicitudesPorLibro.isEmpty
          ? Center(
              child: Text(
                'Sin prestamos para mostrar',
                style: TextStyle(fontSize: responsive!.dp(2.5)),
              ),
            )
          : ListView.builder(
              itemCount: _solicitudesPorLibro.length,
              itemBuilder: (context, index) =>
                  solicitudesTile(_solicitudesPorLibro[index]),
            ),
    );
  }

  Widget solicitudesTile(Solicitud solicitud) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: colorStatus(solicitud.estatus), width: 3),
            borderRadius: BorderRadius.circular(8.0)),
        child: Card(
          child: InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: responsive!.wp(30),
                  height: responsive!.hp(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(
                        base64Decode(solicitud.libroPortada),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive!.wp(3)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          solicitud.libroTitulo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: responsive!.dp(3)),
                        ),
                        Text('Fecha de solicitud: ${solicitud.fechaSolicitud}',
                            style: TextStyle(fontSize: responsive!.dp(2))),
                        Text('Devolución prevista: ${solicitud.fechaPrevista}',
                            style: TextStyle(fontSize: responsive!.dp(2))),
                        Text(
                            'Fecha de devolución: ${solicitud.fechaDevolucion}',
                            style: TextStyle(fontSize: responsive!.dp(2))),
                        Text(
                            'Estudiante: ${solicitud.nombreEstudiante} ${solicitud.apellidoPaternoEstudiante} ${solicitud.apellidoMaternoEstudiante}',
                            style: TextStyle(fontSize: responsive!.dp(2))),
                        Row(
                          children: [
                            Text('Estatus: ',
                                style: TextStyle(fontSize: responsive!.dp(2))),
                            Text(
                              solicitud.estatus,
                              style: TextStyle(
                                  color: colorStatus(solicitud.estatus),
                                  fontSize: responsive!.dp(2)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(responsive!.dp(1.5)),
                  child: _estatusIcon(solicitud.estatus, solicitud.libroTitulo),
                  //child: _backIcon(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color colorStatus(String status) {
    Color color = Colors.grey;
    switch (status) {
      case 'devuelto':
        color = Colors.green;
        break;
      case 'prestado':
        color = Colors.orange;
        break;
      case 'con retraso':
        color = Colors.red;
        break;
    }

    return color;
  }

  Widget _estatusIcon(String estatus, String libro) {
    IconData iconData = Icons.help_outline;
    Color color = Colors.grey;

    switch (estatus) {
      case 'devuelto':
        iconData = Icons.check;
        color = Colors.green;
        break;
      case 'prestado':
        iconData = Icons.keyboard_return_rounded;
        color = Colors.blue;
        IconButton button = IconButton(
            onPressed: () {
              devolverLibro(context, libro);
            },
            icon: Icon(
              iconData,
              color: color,
              size: responsive!.dp(3),
            ));
        return button;
      //break;
      case 'con retraso':
        iconData = Icons.warning;
        color = Colors.red;
        break;
    }

    return Icon(iconData, color: color);
  }

// Función para escanear el código de barras o QR
  Future<void> scanBarcode() async {
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
  }

  // Método para construir el campo de texto
  Widget buildTextField() {
    return TextFormField(
      style: TextStyle(fontSize: responsive!.dp(2.5)),
      inputFormatters: [
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
        SizedBox(height: responsive!.hp(1)),
        Center(
          child: Text('ó', style: TextStyle(fontSize: responsive!.dp(2.2))),
        ),
        SizedBox(height: responsive!.hp(0.8)),
        buildScanButton(),
      ],
    );
  }

  devolverLibro(BuildContext context, String libro) async {
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
      String numControl, String libro, BuildContext context) async {
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
    await DatabaseHelper.devolverLibroSolicitud(
        numControlController.text, libro);
    Libro? libroInfo = await DatabaseHelper.getLibroByName(libro);
    await DatabaseHelper.updateLibroAfterDevolucion(libroInfo!.id);
    if (mounted) {
      Navigator.pop(context);
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
}
