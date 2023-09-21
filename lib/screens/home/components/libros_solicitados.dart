import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_app/models/solicitud.dart';
import 'package:flutter_library_app/screens/solicitudes/solicitudes.dart';
import 'package:flutter_library_app/util/responsive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';

ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

class MostrarLibrosSolicitados extends StatefulWidget {
  const MostrarLibrosSolicitados({Key? key}) : super(key: key);

  @override
  State<MostrarLibrosSolicitados> createState() =>
      _MostrarLibrosSolicitadosState();
}

class _MostrarLibrosSolicitadosState extends State<MostrarLibrosSolicitados> {
  late Future<List<Solicitud>?> solicitudesFuture;

  @override
  void initState() {
    super.initState();
    solicitudesFuture = _getSolicitudes();
  }

  Future<List<Solicitud>?> _getSolicitudes() async {
    List<Solicitud>? solicitudes =
        await DatabaseHelper.getAllSolicitudesSinDevolver();
    if (solicitudes != null) {
      await DatabaseHelper.updateSolicitudConRetraso(solicitudes);
      return await DatabaseHelper.getAllSolicitudesSinDevolver();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 25.0),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.calendar,
                size: responsive.dp(4),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Libros Solicitados",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: responsive.dp(3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0, top: 20.0),
          height: responsive.hp(35),
          child: FutureBuilder<List<Solicitud>?>(
            future: solicitudesFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Platform.isAndroid
                          ? const CircularProgressIndicator()
                          : const CupertinoActivityIndicator(),
                      const Text("Cargando libros..."),
                    ],
                  );

                default:
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final solicitudesBD = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(
                              solicitudesBD.length,
                              (int index) {
                                return ConstruirAspetoLivrosRequisitados(
                                  indexAspecto: index,
                                  pressionar: () {
                                    selectedIndexNotifier.value = index;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SolicitudesPage()),
                                    );
                                  },
                                  solicitudes: solicitudesBD,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Sin libros solicitados para mostrar...',
                        style: TextStyle(fontSize: responsive.dp(2.5)),
                      ),
                    );
                  }
              }
            },
          ),
        ),
      ],
    );
  }
}

class ConstruirAspetoLivrosRequisitados extends StatelessWidget {
  final int indexAspecto;
  final Function() pressionar;
  final List<Solicitud> solicitudes;

  const ConstruirAspetoLivrosRequisitados(
      {Key? key,
      required this.indexAspecto,
      required this.pressionar,
      required this.solicitudes})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    var data = DateTime.now().toLocal();
    var formato = DateFormat('dd/MM/yyyy');
    String fechaActual = formato.format(data.toLocal());
    String fechaUnDiaAntes =
        formato.format(data.subtract(const Duration(days: 1)));
    String fechaUnDiaDespues =
        formato.format(data.add(const Duration(days: 1)));
    return GestureDetector(
      onTap: pressionar,
      child: LayoutBuilder(builder: (context, constraints) {
        //double aspectRatio = constraints.maxWidth / constraints.maxHeight;
        return Container(
          margin: const EdgeInsets.only(left: 15.0),
          width: responsive.wp(35),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(240, 240, 240, 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              //
              // Imagem do livro
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: responsive.wp(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.memory(
                    base64Decode(solicitudes[indexAspecto].libroPortada),
                    fit: BoxFit.fitWidth,
                    height: responsive.hp(22),
                    width: responsive.wp(21),
                  ),
                ),
              ),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    solicitudes[indexAspecto].libroTitulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsive.dp(2),
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(30, 58, 94, 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              if (solicitudes[indexAspecto].estatus.toString() ==
                  'con retraso') ...[
                Text(
                  'Devolución estimada: \n${solicitudes[indexAspecto].fechaPrevista}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syabil',
                    color: Colors.red,
                    fontSize: responsive.dp(1.7),
                  ),
                ),
              ] else if (solicitudes[indexAspecto].fechaPrevista.toString() ==
                      fechaActual.toString() ||
                  solicitudes[indexAspecto].fechaPrevista.toString() ==
                      fechaUnDiaAntes.toString() ||
                  solicitudes[indexAspecto].fechaPrevista.toString() ==
                      fechaUnDiaDespues.toString()) ...[
                Text(
                  'Devolución estimada: \n${solicitudes[indexAspecto].fechaPrevista}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syabil',
                    color: Colors.orange,
                    fontSize: responsive.dp(1.7),
                  ),
                ),
              ] else ...[
                Text(
                  'Devolución estimada: \n${solicitudes[indexAspecto].fechaPrevista}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syabil',
                    fontSize: responsive.dp(1.7),
                  ),
                ),
              ]
            ],
          ),
        );
      }),
    );
  }
}
