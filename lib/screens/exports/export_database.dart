import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:open_file/open_file.dart';
import 'package:external_path/external_path.dart';

import '../../util/responsive.dart';

class ExportDatabaseScreen extends StatefulWidget {
  @override
  _ExportDatabaseScreenState createState() => _ExportDatabaseScreenState();
}

class _ExportDatabaseScreenState extends State<ExportDatabaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> exportDatabase(BuildContext context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Biblioteca.db');

    // get the path to the Download directory
    String newPath = join(
        await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS),
        'Biblioteca.db');

    // copy the database
    await File(path).copy(newPath);

    if (mounted) {
      Flushbar(
        messageText: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Archivo guardado en $newPath',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                OpenFile.open(newPath);
              },
              child: const Text(
                'Ver archivo',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        icon: const Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.green,
        ),
        duration: const Duration(seconds: 7),
        leftBarIndicatorColor: Colors.green,
        backgroundColor: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        flushbarStyle: FlushbarStyle.FLOATING,
      ).show(context);
    }
  }

  Future<void> importDatabase(BuildContext context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Biblioteca.db');

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // Delete the old database
      await deleteDatabase(path);

      // Copy the selected database to the correct location
      await file.copy(path);

      if (mounted) {
        flushbarGenerator(
          context,
          'La base de datos ha sido importada con éxito.',
          Colors.green,
        );
      }
    } else {
      if (mounted) {
        flushbarGenerator(context, 'Importación cancelada.', Colors.red);
      }
    }
  }

  void flushbarGenerator(BuildContext context, String message, Color color) {
    Flushbar(
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: color,
      ),
      duration: const Duration(seconds: 5),
      leftBarIndicatorColor: color,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Base de Datos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Gestiona la base de datos',
                style: TextStyle(
                  fontSize: responsive.dp(3),
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Puedes exportar la base de datos actual o importar un archivo para reemplazar la base de datos existente.',
                style: TextStyle(
                  fontSize: responsive.dp(1.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () => exportDatabase(context),
                child: Text(
                  'Exportar base de datos',
                  style: TextStyle(
                      fontSize: responsive.dp(1.4), color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () => importDatabase(context),
                child: Text(
                  'Importar base de datos',
                  style: TextStyle(
                      fontSize: responsive.dp(1.4), color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
