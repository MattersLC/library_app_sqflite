import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/docente.dart';
import '../models/estudiante.dart';
import '../models/libro.dart';
import '../models/solicitud.dart';

class DatabaseHelper {
  static const int _dbVersion = 1;
  static const String _dbName = "Biblioteca.db";

  static Future<Database> _getDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE libros (id TEXT PRIMARY KEY, titulo TEXT NOT NULL, autor TEXT NOT NULL, descripcion TEXT NOT NULL, unidades INTEGER NOT NULL, serie TEXT NOT NULL, genero TEXT NOT NULL, solicitudes INTEGER NOT NULL, picture TEXT NOT NULL, barcode NOT NULL, cantidadDisponibles INTEGER NOT NULL, cantSolicitados INTEGER NOT NULL)");
    await db.execute(
        "CREATE TABLE docentes (id TEXT PRIMARY KEY, picture TEXT NOT NULL, nombre TEXT NOT NULL, apellidoPaterno TEXT NOT NULL, apellidoMaterno TEXT NOT NULL, fechaNacimiento TEXT NOT NULL, grado TEXT NOT NULL, grupo TEXT NOT NULL, librosLeidos INTEGER NOT NULL)");
    await db.execute(
        "CREATE TABLE estudiantes (id TEXT PRIMARY KEY, nombre TEXT NOT NULL, apellidoPaterno TEXT NOT NULL, apellidoMaterno TEXT NOT NULL, fechaNacimiento TEXT NOT NULL, grado TEXT NOT NULL, grupo TEXT NOT NULL, numControl TEXT NOT NULL, librosLeidos INTEGER NOT NULL)");
    await db.execute(
        "CREATE TABLE solicitudes (id TEXT PRIMARY KEY, fechaSolicitud TEXT NOT NULL, fechaPrevista TEXT NOT NULL, fechaDevolucion TEXT NULL, libroID TEXT NOT NULL, libroPortada TEXT NOT NULL, libroTitulo TEXT NOT NULL, numControlEstudiante TEXT NOT NULL, nombreEstudiante TEXT NOT NULL, apellidoPaternoEstudiante TEXT NOT NULL, apellidoMaternoEstudiante TEXT NOT NULL, gradoEstudiante TEXT NOT NULL, grupoEstudiante TEXT NOT NULL, estatus TEXT NOT NULL)");
  }

  // ADD METHODS
  static Future<int> addLibro(Libro libro) async {
    final db = await _getDB();
    return await db.insert("libros", libro.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addDocente(Docente docente) async {
    final db = await _getDB();
    return await db.insert("docentes", docente.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addEstudiante(Estudiante estudiante) async {
    final db = await _getDB();
    return await db.insert("estudiantes", estudiante.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addSolicitud(Solicitud solicitud) async {
    final db = await _getDB();
    return await db.insert("solicitudes", solicitud.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // UPDATE METHODS
  static Future<int> updateLibro(Libro libro) async {
    final db = await _getDB();
    return await db.update("libros", libro.toJson(),
        where: 'id = ?',
        whereArgs: [libro.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> devolverLibro(String numControl, Libro libro) async {
    final db = await _getDB();

    // Buscar la solicitud que corresponda al estudiante y al libro
    final List<Map<String, dynamic>> maps = await db.query(
      'solicitudes',
      where:
          'numControlEstudiante = ? AND libroTitulo = ? AND estatus IN (?, ?)',
      whereArgs: [numControl, libro.titulo, 'prestado', 'con retraso'],
    );

    if (maps.isEmpty) {
      // No se encontró una solicitud que corresponda
      return 0;
    }

    // Suponiendo que solo haya una solicitud que corresponda, obtener su ID
    String solicitudId = maps[0]['id'];

    // Obtener la fecha actual
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    // Actualizar el estatus de la solicitud y la fecha de devolución
    return await db.update(
      'solicitudes',
      {
        'estatus': 'devuelto',
        'fechaDevolucion': formattedDate, // Agregar la fecha de devolución
      },
      where: 'id = ?',
      whereArgs: [solicitudId],
    );
  }

  static Future<int> devolverLibroSolicitud(
      String numControl, String libro) async {
    final db = await _getDB();

    // Buscar la solicitud que corresponda al estudiante y al libro
    final List<Map<String, dynamic>> maps = await db.query(
      'solicitudes',
      where:
          'numControlEstudiante = ? AND libroTitulo = ? AND estatus IN (?, ?)',
      whereArgs: [numControl, libro, 'prestado', 'con retraso'],
    );

    if (maps.isEmpty) {
      // No se encontró una solicitud que corresponda
      return 0;
    }

    // Suponiendo que solo haya una solicitud que corresponda, obtener su ID
    String solicitudId = maps[0]['id'];

    // Obtener la fecha actual
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    // Actualizar el estatus de la solicitud y la fecha de devolución
    return await db.update(
      'solicitudes',
      {
        'estatus': 'devuelto',
        'fechaDevolucion': formattedDate, // Agregar la fecha de devolución
      },
      where: 'id = ?',
      whereArgs: [solicitudId],
    );
  }

  static Future<void> updateLibroAfterPrestamo(String libroId) async {
    // Obtén una referencia a la base de datos.
    final db = await _getDB();

    // Primero, obtén el libro actual.
    final List<Map<String, dynamic>> libroMaps = await db.query(
      'libros',
      where: 'id = ?',
      whereArgs: [libroId],
    );

    if (libroMaps.isNotEmpty) {
      // Convierte el Map a un objeto Libro.
      final libro = Libro.fromJson(libroMaps.first);

      // Actualiza los campos.
      libro.cantSolicitados += 1;
      libro.solicitudes += 1;
      libro.cantidadDisponibles -= 1;

      // Realiza la actualización en la base de datos.
      await DatabaseHelper.updateLibro(libro);
    }
  }

  static Future<void> updateLibroAfterDevolucion(String libroId) async {
    // Obtén una referencia a la base de datos.
    final db = await _getDB();

    // Primero, obtén el libro actual.
    final List<Map<String, dynamic>> libroMaps = await db.query(
      'libros',
      where: 'id = ?',
      whereArgs: [libroId],
    );

    if (libroMaps.isNotEmpty) {
      // Convierte el Map a un objeto Libro.
      final libro = Libro.fromJson(libroMaps.first);

      // Actualiza los campos.
      libro.cantSolicitados -= 1;
      libro.cantidadDisponibles += 1;

      // Realiza la actualización en la base de datos.
      await DatabaseHelper.updateLibro(libro);
    }
  }

  static Future<int> updateDocente(Docente docente) async {
    final db = await _getDB();
    return await db.update("docentes", docente.toJson(),
        where: 'id = ?',
        whereArgs: [docente.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateEstudiante(Estudiante estudiante) async {
    final db = await _getDB();
    return await db.update("estudiantes", estudiante.toJson(),
        where: 'id = ?',
        whereArgs: [estudiante.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> incrementarLibrosLeidos(String numControl) async {
    // Obtener una referencia a la base de datos
    final db = await _getDB();

    // Ejecutar la consulta para incrementar el número de libros leídos del estudiante
    await db.rawUpdate('''
    UPDATE Estudiantes
    SET librosLeidos = librosLeidos + 1
    WHERE numControl = ?
  ''', [numControl]);
  }

  static Future<int> updateSolicitud(Solicitud solicitud) async {
    final db = await _getDB();
    return await db.update("solicitudes", solicitud.toJson(),
        where: 'id = ?',
        whereArgs: [solicitud.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateSolicitudConRetraso(
      List<Solicitud> solicitudes) async {
    final db = await _getDB();
    var data = DateTime.now().toLocal();
    var formato = DateFormat('dd/MM/yyyy');
    String fechaActual = formato.format(data.toLocal());
    //String fechaSinEntregar = formato.format(data.add(const Duration(days: 1)));

    for (var solicitud in solicitudes) {
      if (solicitud.estatus == 'prestado' &&
          solicitud.fechaPrevista == fechaActual) {
        await db.update(
          'solicitudes',
          {
            'estatus': 'con retraso',
          },
          where: 'id = ?',
          whereArgs: [solicitud.id],
        );
      }
    }
  }

  // DELETE METHODS
  static Future<int> deleteLibro(Libro libro) async {
    final db = await _getDB();
    return await db.delete(
      "libros",
      where: 'id = ?',
      whereArgs: [libro.id],
    );
  }

  static Future<int> deleteDocente(Docente docente) async {
    final db = await _getDB();
    return await db.delete(
      "docentes",
      where: 'id = ?',
      whereArgs: [docente.id],
    );
  }

  static Future<int> deleteEstudiante(Estudiante estudiante) async {
    final db = await _getDB();
    return await db.delete(
      "estudiantes",
      where: 'id = ?',
      whereArgs: [estudiante.id],
    );
  }

  static Future<int> deleteSolicitud(Solicitud solicitud) async {
    final db = await _getDB();
    return await db.delete(
      "solicitudes",
      where: 'id = ?',
      whereArgs: [solicitud.id],
    );
  }

  // 'DELETE BY ID' METHODS
  static Future<int> deleteLibroById(String id) async {
    final db = await _getDB();
    return await db.delete(
      "libros",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 'GET ALL' METHODS
  static Future<List<Libro>?> getAllLibros() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("libros");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Libro.fromJson(maps[index]));
  }

  static Future<List<Docente>?> getAllDocentes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("docentes");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Docente.fromJson(maps[index]));
  }

  static Future<List<Estudiante>?> getAllEstudiantes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("estudiantes");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Estudiante.fromJson(maps[index]));
  }

  static Future<List<Estudiante>?> getAllEstudiantesDesc() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.query('estudiantes', orderBy: 'grado DESC');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Estudiante.fromJson(maps[index]));
  }

  static Future<List<Solicitud>?> getAllSolicitudes() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("solicitudes");

    if (maps.isEmpty) {
      return null;
    }

    List<Solicitud> solicitudes =
        List.generate(maps.length, (index) => Solicitud.fromJson(maps[index]));

    // Ordenamos la lista de solicitudes basándonos en el estado.
    solicitudes.sort(
        (a, b) => _statusValue(a.estatus).compareTo(_statusValue(b.estatus)));

    return solicitudes;
  }

  static Future<List<Solicitud>?> getAllSolicitudesSinDevolver() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("solicitudes",
        where: 'estatus = ? OR estatus = ?',
        whereArgs: ['prestado', 'con retraso']);

    if (maps.isEmpty) {
      return null;
    }

    List<Solicitud> solicitudes =
        List.generate(maps.length, (index) => Solicitud.fromJson(maps[index]));

    // Ordenamos la lista de solicitudes basándonos en el estado.
    solicitudes.sort(
        (a, b) => _statusValue(a.estatus).compareTo(_statusValue(b.estatus)));

    return solicitudes;
  }

// Esta función devuelve un entero correspondiente a cada estado.
// Este valor se utiliza para el ordenamiento. Cuanto menor sea el valor, más alta será la prioridad.
  static int _statusValue(String status) {
    switch (status) {
      case 'con retraso':
        return 1;
      case 'prestado':
        return 2;
      case 'devuelto':
        return 3;
      default:
        return 4; // Si el estado no coincide con ninguno de los anteriores, se le asigna la menor prioridad.
    }
  }

  static Future<List<Solicitud>?> getSolicitudesPorLibro(libroTitulo) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("solicitudes",
        where: "libroTitulo = ?", whereArgs: [libroTitulo]);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Solicitud.fromJson(maps[index]));
  }

  static Future<List<Solicitud>?> getSolicitudesPorLibroActivas(
      libroTitulo) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("solicitudes",
        where: "libroTitulo = ? AND estatus IN (?, ?)",
        whereArgs: [libroTitulo, 'prestado', 'con retraso']);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Solicitud.fromJson(maps[index]));
  }

  static Future<List<Solicitud>?> getSolicitudesPorEstudiante(
      numControl) async {
    final db = await _getDB();
    /*final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT * FROM solicitudes 
    WHERE numControlEstudiante = ? 
    ORDER BY 
      CASE estatus 
        WHEN 'con retraso' THEN 1 
        WHEN 'prestado' THEN 2 
        WHEN 'devuelto' THEN 3 
        ELSE 4 
      END
    ''', [numControl]);*/

    final List<Map<String, dynamic>> maps = await db.query("solicitudes",
        where: "numControlEstudiante = ?",
        whereArgs: [numControl],
        orderBy: 'estatus');

    if (maps.isEmpty) {
      return null;
    }

    List<Solicitud> solicitudes =
        List.generate(maps.length, (index) => Solicitud.fromJson(maps[index]));

    // Ordenamos la lista de solicitudes basándonos en el estado.
    solicitudes.sort(
        (a, b) => _statusValue(a.estatus).compareTo(_statusValue(b.estatus)));

    return solicitudes;
  }

  static Future<List<Solicitud>?> getSolicitudesPorEstudianteActivas(
      numControl) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("solicitudes",
        where: "numControlEstudiante = ? AND estatus IN (?, ?)",
        whereArgs: [numControl, 'prestado', 'con retraso']);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Solicitud.fromJson(maps[index]));
  }

  static Future<List<Solicitud>?> getSolicitudesRetrasadas() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db
        .query('solicitudes', where: 'estatus = ?', whereArgs: ['con retraso']);

    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => Solicitud.fromJson(maps[index]));
  }

  // GET BY ID
  static Future<Libro?> getLibroById(String id) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      "libros",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Libro.fromJson(maps[0]);
  }

  static Future<Libro?> getLibroByName(String name) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      "libros",
      where: "titulo = ?",
      whereArgs: [name],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Libro.fromJson(maps[0]);
  }

  // TOP 10 METHODS
  static Future<List<Libro>> getTopTenBooks() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'libros',
      orderBy: 'solicitudes DESC',
      limit: 10,
    );

    return List.generate(maps.length, (i) {
      return Libro.fromJson(maps[i]);
    });
  }

  static Future<List<Estudiante>> getTopTenStudents() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      'estudiantes',
      orderBy: 'librosLeidos DESC',
      limit: 10,
    );

    return List.generate(maps.length, (i) {
      return Estudiante.fromJson(maps[i]);
    });
  }

  // SEARCH METHODS
  static Future<List<Libro>> searchLibros(String searchText) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'libros',
      where: 'titulo LIKE ?',
      whereArgs: ['%$searchText%'],
    );
    return List.generate(maps.length, (i) => Libro.fromJson(maps[i]));
  }

  static Future<List<Estudiante>> searchEstudiantes(String searchText) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'estudiantes',
      where: 'nombre LIKE ?',
      whereArgs: ['%$searchText%'],
    );
    return List.generate(maps.length, (i) => Estudiante.fromJson(maps[i]));
  }

  static Future<List<Estudiante>> searchEstudiantesByNumControl(
      String searchText) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'estudiantes',
      where: 'numControl LIKE ?',
      whereArgs: ['%$searchText%'],
    );
    return List.generate(maps.length, (i) => Estudiante.fromJson(maps[i]));
  }

  static Future<Estudiante?> getEstudiante(String numControl) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'estudiantes',
      where: 'numControl = ?',
      whereArgs: [numControl],
    );

    if (maps.isNotEmpty) {
      return Estudiante.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<int> getPrestamosActivos(String numControl) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'solicitudes',
      where: 'numControlEstudiante = ? AND estatus IN (?, ?)',
      whereArgs: [numControl, 'prestado', 'con retraso'],
    );

    return maps.length;
  }

  static Future<List<Docente>> searchDocentes(String searchText) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'docentes',
      where: 'nombre LIKE ?',
      whereArgs: ['%$searchText%'],
    );
    return List.generate(maps.length, (i) => Docente.fromJson(maps[i]));
  }
}
