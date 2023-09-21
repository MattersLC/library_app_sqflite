import 'dart:async';

import 'package:flutter/material.dart';

import 'libro.dart';

class LivroRequisitadoModel extends ChangeNotifier {
  Map<String, Libro> _librosRequisitado = {};

  Map<String, Libro> get libros {
    return {..._librosRequisitado};
  }

  int get libroCount {
    return _librosRequisitado.length;
  }

  Future<void> addLibroSolicitado(Libro libro) async {
    // Se a chave já existir, o valor atual é retornado.
    _librosRequisitado.putIfAbsent(
      libro.id.toString(),
      () => Libro(
        id: libro.id,
        titulo: libro.titulo,
        autor: libro.autor,
        descripcion: libro.descripcion,
        unidades: libro.unidades,
        serie: libro.serie,
        genero: libro.genero,
        solicitudes: libro.solicitudes,
        picture: libro.picture,
        barcode: libro.barcode,
        cantidadDisponibles: libro.cantidadDisponibles,
        cantSolicitados: libro.cantSolicitados,
      ),
    );
    notifyListeners();
  }

  void devolverLibroSolicitado(Libro libro) {
    _librosRequisitado.remove(libro.id);
    notifyListeners();
  }

  Map<String, Libro> get libro => _librosRequisitado;

  set libro(Map<String, Libro> nuevoLibro) {
    _librosRequisitado = nuevoLibro;
    notifyListeners();
  }
}
