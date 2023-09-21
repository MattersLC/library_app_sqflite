/*import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../models/libro.dart';
import '../../../models/solicitud.dart';

// ignore: must_be_immutable
class InformacaoDoLivro extends StatelessWidget {
  InformacaoDoLivro({Key? key, required this.indexInformacao})
      : super(key: key);

  String indexInformacao;

  @override
  Widget build(BuildContext context) {
    TextStyle _estiloTextoLeve =
        TextStyle(color: const Color(0xFF171717).withOpacity(0.6));

    return StreamBuilder(
      stream: DatabaseHelper.getAllLibros().asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          //? Caso não esteja conectado, mostra mensagem
          case ConnectionState.none:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[Text("Sin datos para mostrar...")],
            );

          default:
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              Map<String, dynamic> dadosBaseDeDados =
                  jsonDecode(jsonEncode(snapshot.data.snapshot.value));

              LibroModel listaDeLibros = LibroModel.fromJson(dadosBaseDeDados);

              final List<Libro> _libros = [];

              _libros.addAll(listaDeLibros.libros);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 315,
                width: 160,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _libros[1].toString().toUpperCase(),
                        style: _estiloTextoLeve,
                      ),

                      const SizedBox(height: 8),

                      //** Titulo do livro
                      Text(
                        _libros[1].titulo.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.8,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      //** Autor
                      const Text("Autor:"
                          //_libros[indexInformacao].autor.toString(),
                          //style: _estiloTextoLeve,
                          ),

                      //** Ano
                      const Text("Año"
                          /*_libros[indexInformacao].ano.toString(),
                        style: const TextStyle(
                          fontSize: 16, //16
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),*/
                          ),

                      const SizedBox(height: 20),

                      //** Mostrar ícone se o livro for requisitado
                      if (_libros[index].cantSolicitados > 1) ...[
                        Row(
                          children: [
                            const Text(
                              'Requisitado ',
                              style: TextStyle(
                                fontSize: 15, //16
                                fontWeight: FontWeight.bold,
                                height: 1.6,
                                color: Colors.green,
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: const Color(0xff34A853),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                FluentIcons.accessibility_checkmark_24_regular,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
        }
        return const Text('sin datos');
      },
    );
  }
}
*/*/*/*/*/