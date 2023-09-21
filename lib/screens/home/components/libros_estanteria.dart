import 'dart:convert';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_app/util/responsive.dart';

import '../../../database/database.dart';
import '../../../models/libro.dart';
import '../../books/libro_detallado/libro_detallado.dart';

class LibrosEstanteria extends StatelessWidget {
  const LibrosEstanteria({Key? key}) : super(key: key);

  //Responsive? responsive;
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return StreamBuilder<List<Libro>?>(
      //
      stream: DatabaseHelper.getAllLibros().asStream(),

      //
      builder: (BuildContext context, AsyncSnapshot<List<Libro>?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator(),
            );
          case ConnectionState.none:
            return const Center(
              child: Text(
                'Sin libros para mostrar',
                style: TextStyle(fontSize: 20),
              ),
            );
          default:
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                List<Libro> libros = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: libros.length,
                  itemBuilder: (context, index) {
                    //
                    Size distanciarLibros = MediaQuery.of(context).size;

                    return Container(
                      margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                      width: distanciarLibros.width * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LibroDetallado(
                                    libroId: libros[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                SizedBox(
                                  //width: 125.66,
                                  //height: 170.5,
                                  width: responsive.wp(30),
                                  height: responsive.hp(25),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                            base64Decode(libros[index].picture),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (libros[index].cantSolicitados >= 1)
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      //width: 35,
                                      //height: 35,
                                      width: responsive.wp(10),
                                      height: responsive.hp(5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff34A853),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        FluentIcons
                                            .accessibility_checkmark_24_regular,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LibroDetallado(
                                      libroId: libros[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(243, 246, 248, 1),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 10),
                                      blurRadius: 50,
                                      color:
                                          const Color.fromRGBO(27, 68, 166, 1)
                                              .withOpacity(0.23),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      libros[index].titulo.toString(),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontFamily: 'Syabil',
                                          fontWeight: FontWeight.w700,
                                          fontSize: responsive.dp(2)),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      libros[index].autor.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Syabil',
                                          fontSize: responsive.dp(1.6)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
            return Center(
              child: Text(
                'Sin libros para mostrar',
                style: TextStyle(fontSize: responsive.dp(2.5)),
              ),
            );
        }
      },
    );
  }
}
