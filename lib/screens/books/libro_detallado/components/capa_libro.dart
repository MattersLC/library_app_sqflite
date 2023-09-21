/*import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../models/libro.dart';
import '../../../util/config_size.dart';
import 'descripcion_botones.dart';
import 'info_de_libro.dart';

// ignore: must_be_immutable
class CapaDoLivro extends StatelessWidget {
  CapaDoLivro({Key? key, required this.index, required List<Libro>? libros})
      : super(key: key);

  String index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: ConfigSize.orientation == Orientation.landscape
            ? size.width
            : size.height - AppBar().preferredSize.height,
        child: Stack(
          children: [
            InformacaoDoLivro(indexInformacao: index),
            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: DescricaoEBotoes(indexDescricao: index),
            ),
            StreamBuilder(
              stream: DatabaseHelper.getAllLibros().asStream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  //? Caso não esteja conectado, mostra mensagem
                  case ConnectionState.none:
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Sin datos para mostrar...")
                      ],
                    );

                  default:
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.snapshot.value != null) {
                      List<dynamic> dadosBaseDeDados =
                          jsonDecode(jsonEncode(snapshot.data.snapshot.value));

                      LibroModel listaDeLivros =
                          LibroModel.fromJson(dadosBaseDeDados);

                      final List<Libro> _libros = [];

                      _libros.addAll(listaDeLivros.libros);

                      // Posicionar a capa a direita
                      return Positioned(
                        top: 40,
                        right: 15,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 179, 182, 188),
                                blurRadius: 5.0,
                                offset: Offset(0, 10),
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),

                          // Cria um clip retangular arredondado em cima a esquerda e em baixo a direita.
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                            ),

                            //* Capa
                            child: Image.network(
                              //_libros[index].picture.toString(),
                              _libros[1].picture.toString(),
                              fit: BoxFit.cover,
                              height: 340, //378
                              width: 230,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      );
                    }
                }
                return const Text('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/*/