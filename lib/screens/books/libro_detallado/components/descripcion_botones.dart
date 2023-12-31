/*import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../models/libro.dart';
import 'controlar_solicitar_devolver.dart';

class DescricaoEBotoes extends StatelessWidget {
  const DescricaoEBotoes({
    Key? key,
    required this.indexDescricao,
  }) : super(key: key);

  final String indexDescricao;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 440),

      padding: const EdgeInsets.only(
        top: 45,
        left: 20,
        right: 20,
      ),

      //height: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.white,
      ),

      child: StreamBuilder(
        stream: DatabaseHelper.getAllLibros().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            //? Caso não esteja conectado, mostra mensagem
            case ConnectionState.none:
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[Text("Sem dados para mostrar...")],
              );

            default:
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                List<dynamic> dadosBaseDeDados =
                    jsonDecode(jsonEncode(snapshot.data.snapshot.value));

                LibroModel listaDeLibros =
                    LibroModel.fromJson(dadosBaseDeDados);

                final List<Libro> _libros = [];

                _libros.addAll(listaDeLibros.libros);

                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        _libros[indexDescricao].descripcion.toString(),
                        style: TextStyle(
                          color: const Color(0xFF171717).withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      //  _Botão Requisitar e Devolver
                      ControlarRequisitarEDevolver(
                        livroARequisitar: _libros[indexDescricao],
                      ),
                    ],
                  ),
                );
              }
          }
          return const Text('Sin datos');
        },
      ),
    );
  }
}*/