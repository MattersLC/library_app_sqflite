import 'package:flutter/material.dart';

import 'package:flutter_library_app/screens/home/home.dart';
import 'package:flutter_library_app/screens/books/libros.dart';
import 'package:flutter_library_app/screens/books/nuevo_libro.dart';
import 'package:flutter_library_app/screens/books/top_libros.dart';
import 'package:flutter_library_app/screens/estudiantes/estudiantes.dart';
import 'package:flutter_library_app/screens/estudiantes/nuevo_estudiante.dart';
import 'package:flutter_library_app/screens/estudiantes/top_estudiantes.dart';
import 'package:flutter_library_app/screens/docentes/docentes.dart';
import 'package:flutter_library_app/screens/docentes/nuevo_docente.dart';
import 'package:flutter_library_app/screens/solicitudes/solicitudes.dart';
import 'package:flutter_library_app/screens/solicitudes/solicitudes_retrasadas.dart';
import 'package:flutter_library_app/screens/exports/export_libros.dart';
import 'package:flutter_library_app/screens/exports/export_database.dart';

class Routes {
  static Map<String, WidgetBuilder> getApplicationRoutes() {
    return {
      'home': (_) => const HomePage(),
      'librosPage': (_) => const LibrosPage(),
      'nuevoLibro': (_) => const NuevoLibroPage(),
      'topLibros': (_) => const TopTenBooks(),
      'nuevoEstudiante': (_) => const NuevoEstudiantePage(),
      'topEstudiantes': (_) => const TopTenStudents(),
      'estudiantesPage': (_) => const EstudiantesPage(),
      'nuevoDocente': (_) => const NuevoDocentePage(),
      'docentesPage': (_) => const DocentesPage(),
      'solicitudesPage': (_) => const SolicitudesPage(),
      'solicitudesRetrasadas': (_) => const SolicitudesRetrasadasPage(),
      'booksToExcelPage': (_) => const ExportBooksScreen(),
      'exportDatabase': (_) => ExportDatabaseScreen(),
    };
  }
}
