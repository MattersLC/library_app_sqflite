import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_app/models/libro.dart';
import 'package:flutter_library_app/util/responsive.dart';

import 'libros_estanteria.dart';
import 'libros_solicitados.dart';

class InterfaceHome extends StatelessWidget {
  const InterfaceHome({super.key, required List<Libro>? libros});

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MostrarLibrosSolicitados(),

          separacion,

          const Divider(
            height: 15,
            thickness: 1,
          ),

          //? Título [Prateleiras] na interface
          //biblioteca,
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 35.0),
            child: Row(
              children: [
                Icon(
                  FluentIcons.library_28_regular,
                  color: Colors.black,
                  size: responsive.dp(4),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Estante',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: responsive.dp(4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          separacion,

          //?  LIVROS Prateleira
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              //height: 345.0,
              height: responsive.hp(40),
              child: const LibrosEstanteria(),
            ),
          ),
        ],
      ),
    );
  }
}

// espaçamento
const separacion = SizedBox(
  height: 15,
);
