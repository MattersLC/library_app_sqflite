import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_library_app/util/responsive.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter_library_app/database/database.dart';

import '../../models/libro.dart';

class NuevoLibroPage extends StatefulWidget {
  const NuevoLibroPage({Key? key}) : super(key: key);

  @override
  State<NuevoLibroPage> createState() => _NuevoLibroPageState();
}

class _NuevoLibroPageState extends State<NuevoLibroPage> {
  final _formKey = GlobalKey<FormState>();
  Responsive? responsive; // = Responsive.of(context);

  String _scanBarcode = 'Unknown';

  // Controllers
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _unidadesController = TextEditingController();

  // FocusNodes
  final _autorFocusNode = FocusNode();
  final _descripcionFocusNode = FocusNode();
  final _unidadesFocusNode = FocusNode();
  int cantidadCaracteres = 3;

  // Variables
  List<String> series = [
    'Al sol solito',
    'Pasos de luna',
    'Astrolabio',
    'Espejo de urania'
  ];
  List<String> generos = ['Informativo', 'Literario'];
  String selectedSerie = 'Al sol solito';
  String selectedGenero = 'Informativo';
  String? barcode;
  File? _image;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      barcode = _scanBarcode;
    });
  }

  void _getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = image != null ? File(image.path) : null;
    });
  }

  Center _noImage() {
    return Center(
        child: Text(
      "No hay imagen",
      style:
          TextStyle(fontSize: responsive!.dp(3), fontWeight: FontWeight.w300),
    ));
  }

  Column _scannerSection() {
    return Column(
      children: <Widget>[
        Text(
          "CÓDIGO DE BARRAS",
          style: TextStyle(
              fontSize: responsive!.dp(3), fontWeight: FontWeight.w800),
        ),
        SizedBox(height: responsive!.hp(2)),
        Row(
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () => scanBarcodeNormal(),
              icon: Icon(
                Icons.qr_code_scanner,
                size: responsive!.dp(3),
              ),
              label: Text(
                "Escanear",
                style: TextStyle(fontSize: responsive!.dp(2)),
              ),
            ),
            SizedBox(
              width: responsive!.wp(12),
              //width: 80,
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Código: $_scanBarcode',
                    style: TextStyle(fontSize: responsive!.dp(2)),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<Uint8List> compressImage(File imageFile) async {
    Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
      imageFile.readAsBytesSync(),
      minWidth: 600,
      minHeight: 600,
      quality: 80,
    );
    return compressedBytes;
  }

  Future<String> _imageTo64(File? img) async {
    Uint8List compressedBytes = await compressImage(img!);
    String base64File = base64Encode(compressedBytes);
    return base64File;
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo libro',
          style: TextStyle(fontSize: responsive!.dp(2.8)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: responsive!.wp(3.5), right: responsive!.wp(3.5)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 750),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: responsive!.hp(42),
                      color: Colors.transparent,
                      child: _image == null ? _noImage() : Image.file(_image!),
                    ),
                    SizedBox(
                      height: responsive!.hp(1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            var image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {
                              _image = image != null ? File(image.path) : null;
                            });
                          },
                          icon: Icon(Icons.photo_library,
                              size: responsive!.dp(2.8)),
                          label: Text(
                            'Seleccionar foto',
                            style: TextStyle(fontSize: responsive!.dp(2)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _getImage();
                          },
                          icon:
                              Icon(Icons.camera_alt, size: responsive!.dp(2.8)),
                          label: Text(
                            'Tomar foto',
                            style: TextStyle(fontSize: responsive!.dp(2)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive!.hp(5)),
                    _scannerSection(),
                    SizedBox(height: responsive!.hp(5)),
                    Center(
                      child: Text(
                        "DATOS DEL LIBRO",
                        style: TextStyle(
                            fontSize: responsive!.dp(3),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Título'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _tituloController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un título';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_autorFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Autor'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _autorController,
                      focusNode: _autorFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un autor';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_descripcionFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _descripcionController,
                      focusNode: _descripcionFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción';
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_unidadesFocusNode);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Unidades'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _unidadesController,
                      focusNode: _unidadesFocusNode,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un número';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null) {
                          return 'Por favor ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Serie: ",
                          style: TextStyle(fontSize: responsive!.dp(2.0)),
                        ),
                        SizedBox(
                          width: responsive!.wp(3.45),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    width: 1,
                                  )),
                            ),
                            value: selectedSerie,
                            items: series
                                .map((serie) => DropdownMenuItem<String>(
                                      value: serie,
                                      child: Text(serie,
                                          style: const TextStyle(fontSize: 20)),
                                    ))
                                .toList(),
                            onChanged: (serie) => setState(() {
                              selectedSerie = serie!;
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Genero: ",
                          style: TextStyle(fontSize: responsive!.dp(2.0)),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    width: 1,
                                  )),
                            ),
                            value: selectedGenero,
                            items: generos
                                .map((genero) => DropdownMenuItem<String>(
                                      value: genero,
                                      child: Text(genero,
                                          style: const TextStyle(fontSize: 20)),
                                    ))
                                .toList(),
                            onChanged: (genero) => setState(() {
                              selectedGenero = genero!;
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive!.hp(3)),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: 450,
                          maxHeight: responsive!.hp(5),
                          minHeight: responsive!.hp(5)),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            String base64Image = await _imageTo64(_image);
                            final Libro libro = Libro(
                              id: uuid.v1(),
                              titulo: _tituloController.text,
                              autor: _autorController.text,
                              descripcion: _descripcionController.text,
                              unidades: int.parse(_unidadesController.text),
                              serie: selectedSerie,
                              genero: selectedGenero,
                              solicitudes: 0,
                              picture: base64Image,
                              barcode: _scanBarcode,
                              cantidadDisponibles:
                                  int.parse(_unidadesController.text),
                              cantSolicitados: 0,
                            );
                            await DatabaseHelper.addLibro(libro);
                            if (mounted) {
                              Navigator.pushNamed(context, 'librosPage');
                            }
                          }
                        },
                        child: Text("Guardar libro",
                            style: TextStyle(fontSize: responsive!.dp(2))),
                      ),
                    ),
                    SizedBox(height: responsive!.hp(3)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
