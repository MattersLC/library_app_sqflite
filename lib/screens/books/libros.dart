import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../models/libro.dart';
import '../../util/responsive.dart';
import '../busqueda/busqueda.dart';
import '../books/libro_detallado/libro_detallado.dart';

class LibrosPage extends StatefulWidget {
  const LibrosPage({super.key});

  @override
  State<LibrosPage> createState() => _LibrosPageState();
}

class _LibrosPageState extends State<LibrosPage> {
  List<Libro> _librosPage = [];
  Responsive? responsive;

  @override
  void initState() {
    super.initState();
    _getLibros();
  }

  Future<void> _getLibros() async {
    final libros = await DatabaseHelper.getAllLibros();
    if (libros != null) {
      setState(() {
        _librosPage = libros;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Libros guardados',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.8))),
        backgroundColor: Colors.blue,
        elevation: 1,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: responsive!.wp(2)),
            child: IconButton(
              icon: Icon(Icons.search, size: responsive!.dp(2.8)),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusquedaPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: _librosPage.isEmpty
          ? Center(
              child: Text(
                'Sin libros para mostrar',
                style: TextStyle(fontSize: responsive!.dp(2.5)),
              ),
            )
          : Column(
              children: <Widget>[
                SizedBox(height: responsive!.hp(1)),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total de libros guardados: ${_librosPage.length}',
                      style: TextStyle(fontSize: responsive!.dp(2.5)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _librosPage.length,
                    itemBuilder: (context, index) =>
                        librosTile(_librosPage[index]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          Navigator.pushNamed(context, 'nuevoLibro');
        },
        child: Icon(Icons.add, size: responsive!.dp(2.8)),
      ),
    );
  }

  Widget librosTile(Libro libro) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibroDetallado(
                  libroId: libro.id,
                ),
              ),
            );
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
                      base64Decode(libro.picture),
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
                        libro.titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive!.dp(3)),
                      ),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Autor(a): ${libro.autor}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Serie: ${libro.serie}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                      SizedBox(height: responsive!.hp(2)),
                      Text('Género: ${libro.genero}',
                          style: TextStyle(fontSize: responsive!.dp(2))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(responsive!.dp(1.5)),
                child: IconButton(
                  onPressed: () => deleteLibro(libro),
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

  deleteLibro(Libro libro) {
    if (Platform.isAndroid) {
      return showDialog(
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
                  //Navigator.pushNamed(context, 'librosPage');
                },
                child: const Text('Cancelar'),
              ),
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () async {
                  await DatabaseHelper.deleteLibro(libro);
                  setState(() {
                    _librosPage.remove(libro);
                    Navigator.of(context).pop(true);
                  });
                },
                child: const Text('Eliminar'),
              )
            ],
          );
        },
      ).then((confirmed) {
        if (!confirmed) {
          setState(() {});
        }
      });
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('¿Estás seguro de eliminar el elemento?'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                await DatabaseHelper.deleteLibro(libro);
                setState(() {
                  _librosPage.remove(libro);
                  Navigator.of(context).pop(true);
                });
              },
              child: const Text('Add'),
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
