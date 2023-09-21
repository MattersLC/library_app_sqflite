import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter_library_app/database/database.dart';

import '../../models/docente.dart';
import '../../util/responsive.dart';

class NuevoDocentePage extends StatefulWidget {
  const NuevoDocentePage({Key? key}) : super(key: key);

  @override
  State<NuevoDocentePage> createState() => _NuevoDocentePageState();
}

class _NuevoDocentePageState extends State<NuevoDocentePage> {
  final _formKey = GlobalKey<FormState>();
  Responsive? responsive;

  // Controllers
  final _nombreController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  // FocusNodes
  final _apellidoPaternoFocusNode = FocusNode();
  final _apellidoMaternoFocusNode = FocusNode();
  final _dayControllerFocusNode = FocusNode();
  final _monthControllerFocusNode = FocusNode();
  final _yearControllerFocusNode = FocusNode();
  int cantidadCaracteres = 2;

  // Variables
  List<String> grados = ['1°', '2°', '3°', '4°', '5°', '6°'];
  List<String> grupos = ["A", "B", "C"];
  String selectedGrado = '1°';
  String selectedGrupo = 'A';
  String _nombre = '';
  String _apellidoPaterno = '';
  String _apellidoMaterno = '';
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
          'Nuevo docente',
          style: TextStyle(fontSize: responsive!.dp(2.8)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive!.dp(2.8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                    Center(
                      child: Text(
                        "DATOS DEL DOCENTE",
                        style: TextStyle(
                            fontSize: responsive!.dp(3),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre(s)'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _nombreController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_apellidoPaternoFocusNode);
                      },
                      onSaved: (value) {
                        _nombre = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Apellido paterno'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _apellidoPaternoController,
                      focusNode: _apellidoPaternoFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un apellido';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_apellidoMaternoFocusNode);
                      },
                      onSaved: (value) {
                        _apellidoPaterno = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Apellido materno'),
                      style: TextStyle(fontSize: responsive!.dp(2.0)),
                      controller: _apellidoMaternoController,
                      focusNode: _apellidoMaternoFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un apellido';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context)
                            .requestFocus(_dayControllerFocusNode);
                      },
                      onSaved: (value) {
                        _apellidoMaterno = value!;
                      },
                    ),
                    SizedBox(height: responsive!.hp(4)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Fecha de nacimiento',
                            style: TextStyle(
                                fontSize: responsive!.dp(2.5),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text(
                            '(DD/MM/YYYY)',
                            style: TextStyle(
                                fontSize: responsive!.dp(2),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Día'),
                                style: TextStyle(fontSize: responsive!.dp(2.0)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  DateTextFormatter()
                                ],
                                controller: _dayController,
                                focusNode: _dayControllerFocusNode,
                                onChanged: (value) {
                                  if (value.characters.length ==
                                      cantidadCaracteres) {
                                    FocusScope.of(context).requestFocus(
                                        _monthControllerFocusNode);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa un día';
                                  }
                                  int? day = int.tryParse(value);
                                  if (day == null || day < 1 || day > 31) {
                                    return 'No es un día válido (1-31)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Mes'),
                                style: TextStyle(fontSize: responsive!.dp(2.0)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  DateTextFormatter()
                                ],
                                controller: _monthController,
                                focusNode: _monthControllerFocusNode,
                                onChanged: (value) {
                                  if (value.characters.length ==
                                      cantidadCaracteres) {
                                    FocusScope.of(context)
                                        .requestFocus(_yearControllerFocusNode);
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa un mes';
                                  }
                                  int? month = int.tryParse(value);
                                  if (month == null ||
                                      month < 1 ||
                                      month > 12) {
                                    return 'No es un mes válido (1-12)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Año'),
                                style: TextStyle(fontSize: responsive!.dp(2.0)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  DateTextFormatter()
                                ],
                                controller: _yearController,
                                focusNode: _yearControllerFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa un año';
                                  }
                                  int? year = int.tryParse(value);
                                  if (year == null ||
                                      year < 1920 ||
                                      year > DateTime.now().year) {
                                    return 'No es un año válido (1920-2023)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: responsive!.hp(4)),
                    Row(
                      children: [
                        Text(
                          "Grado: ",
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
                            value: selectedGrado,
                            items: grados
                                .map((grado) => DropdownMenuItem<String>(
                                      value: grado,
                                      child: Text(grado,
                                          style: const TextStyle(fontSize: 20)),
                                    ))
                                .toList(),
                            onChanged: (grado) => setState(() {
                              selectedGrado = grado!;
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "Grupo: ",
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
                            value: selectedGrupo,
                            items: grupos
                                .map((grupo) => DropdownMenuItem<String>(
                                      value: grupo,
                                      child: Text(grupo,
                                          style: const TextStyle(fontSize: 20)),
                                    ))
                                .toList(),
                            onChanged: (grupo) => setState(() {
                              selectedGrupo = grupo!;
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive!.hp(4)),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 450,
                            maxHeight: responsive!.hp(5),
                            minHeight: responsive!.hp(5)),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              String base64Image = await _imageTo64(_image);
                              final Docente docente = Docente(
                                id: '${_apellidoPaterno.substring(0, 2).toUpperCase()}${_apellidoMaterno.substring(0, 1).toUpperCase()}${_nombre.substring(0, 1).toUpperCase()}${_yearController.text.substring(2)}${_monthController.text}${_dayController.text}',
                                picture: base64Image,
                                nombre: _nombreController.text,
                                apellidoPaterno:
                                    _apellidoPaternoController.text,
                                apellidoMaterno:
                                    _apellidoMaternoController.text,
                                fechaNacimiento:
                                    '${_dayController.text}/${_monthController.text}/${_yearController.text}',
                                grado: selectedGrado,
                                grupo: selectedGrupo,
                                librosLeidos: 0,
                              );
                              await DatabaseHelper.addDocente(docente);
                              if (mounted) {
                                Navigator.pushNamed(context, 'docentesPage');
                              }
                            }
                          },
                          child: Text("Registrar docente",
                              style: TextStyle(fontSize: responsive!.dp(2))),
                        ),
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

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        //buffer.write('/');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
