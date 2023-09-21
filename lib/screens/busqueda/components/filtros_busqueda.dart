import 'package:flutter/material.dart';

import '../../../models/libro.dart';

int selecionarFiltro = 0;

class _FiltrosDeBusquedaState extends State<FiltrosDeBusqueda> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: List.generate(
              menuDeFiltro.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    selecionarFiltro = index;
                    widget.onFiltroChanged(menuDeFiltro[selecionarFiltro]);
                  });
                },
                child: Container(
                  // Alinhamento das palavras no retangulo dos filtros
                  alignment: Alignment.center,

                  margin: EdgeInsets.only(
                    left: 17.0,
                    right: index == menuDeFiltro.length - 1 ? 20.0 : 0,
                  ),

                  // Comportamento quando um filtro é selecionado
                  // quando não está selecionado fica sem o retangulo e a cor azul escuro
                  decoration: BoxDecoration(
                    // Alternar cor
                    color: selecionarFiltro == index
                        ? const Color(0xff4285f4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),

                  // Comprimento e largura dos retangulos do filtro
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),

                    // Alterar a cor do texto quando é selecionado um filtro
                    child: Text(
                      menuDeFiltro[index],
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: selecionarFiltro == index
                            ? Colors.white
                            : const Color(0xff7C7A8B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FiltrosDeBusqueda extends StatefulWidget {
  final ValueChanged<String> onFiltroChanged;
  const FiltrosDeBusqueda({Key? key, required this.onFiltroChanged})
      : super(key: key);

  @override
  State<FiltrosDeBusqueda> createState() => _FiltrosDeBusquedaState();
}
