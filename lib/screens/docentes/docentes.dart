import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../models/docente.dart';
import '../../util/responsive.dart';

class DocentesPage extends StatefulWidget {
  const DocentesPage({super.key});

  @override
  State<DocentesPage> createState() => _DocentesPageState();
}

class _DocentesPageState extends State<DocentesPage> {
  List<Docente> _docentesPage = [];
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _getDocentes();
  }

  Future<void> _getDocentes() async {
    final docentes = await DatabaseHelper.getAllDocentes();
    if (docentes != null) {
      setState(() {
        _docentesPage = docentes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Docentes',
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
      body: _docentesPage.isEmpty
          ? Center(
              child: Text(
                'Sin docentes para mostrar',
                style: TextStyle(fontSize: responsive!.dp(3)),
              ),
            )
          : ListView.builder(
              itemCount: _docentesPage.length,
              itemBuilder: (context, index) => librosTile(_docentesPage[index]),
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          Navigator.pushNamed(context, 'nuevoDocente');
        },
        child: Icon(Icons.add, size: responsive!.dp(2.8)),
      ),
    );
  }

  Widget librosTile(Docente docente) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibroDetallado(
                  libroId: libro.id,
                ),
              ),
            );*/
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //width: 100,
                //height: 150,
                width: responsive!.wp(30),
                height: responsive!.hp(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(
                      base64Decode(docente.picture),
                    ),
                  ),
                ),
              ),
              //const SizedBox(width: 8.0),
              SizedBox(width: responsive!.wp(3)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${docente.nombre} ${docente.apellidoPaterno} ${docente.apellidoMaterno}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive!.dp(3)),
                      ),
                      SizedBox(height: responsive!.hp(2)),
                      Text('ID: ${docente.id}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                      SizedBox(height: responsive!.hp(2)),
                      Text(
                          'Grado: ${docente.grado}  -  Grupo: ${docente.grupo}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(responsive!.dp(1.5)),
                child: IconButton(
                  onPressed: () => deleteDocente(docente),
                  icon: Icon(
                    Icons.delete,
                    size: responsive!.dp(3.5),
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // MODIFICAR -> Antes de eliminar deslizando, preguntar si está seguro de eliminar
  deleteDocente(Docente docente) {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('¿Estás seguro de eliminar a este docente?'),
            actions: <Widget>[
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () async {
                  await DatabaseHelper.deleteDocente(docente);
                  setState(() {
                    _docentesPage.remove(docente);
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('Eliminar'),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('¿Estás seguro de eliminar a este docente?'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                await DatabaseHelper.deleteDocente(docente);
                setState(() {
                  _docentesPage.remove(docente);
                  Navigator.of(context).pop(true);
                });
              },
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                _docentesPage.remove(docente);
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
