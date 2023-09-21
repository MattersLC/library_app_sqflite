//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_library_app/models/estudiante.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_library_app/database/database.dart';

import '../../util/responsive.dart';

class NuevoEstudiantePage extends StatefulWidget {
  const NuevoEstudiantePage({Key? key}) : super(key: key);

  @override
  State<NuevoEstudiantePage> createState() => _NuevoEstudiantePageState();
}

class _NuevoEstudiantePageState extends State<NuevoEstudiantePage> {
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

  String _nombre = '';
  String _apellidoPaterno = '';
  String _apellidoMaterno = '';
  List<String> grados = ['1°', '2°', '3°', '4°', '5°', '6°'];
  List<String> grupos = ["A", "B", "C"];
  String selectedGrado = '1°';
  String selectedGrupo = 'A';

  var uuid = const Uuid();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatTwoDigit(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo estudiante',
            style:
                TextStyle(color: Colors.white, fontSize: responsive!.dp(2.8))),
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
                    SizedBox(height: responsive!.hp(3)),
                    Center(
                      child: Text(
                        "DATOS DEL ESTUDIANTE",
                        style: TextStyle(
                            fontSize: responsive!.dp(3),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: responsive!.hp(3)),
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
                    SizedBox(height: responsive!.hp(5)),
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
                                textInputAction: TextInputAction.next,
                                //maxLength: cantidadCaracteres,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  DateTextFormatter()
                                ],
                                controller: _dayController,
                                focusNode: _dayControllerFocusNode,
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
                                onChanged: (value) {
                                  if (value.characters.length ==
                                      cantidadCaracteres) {
                                    FocusScope.of(context).requestFocus(
                                        _monthControllerFocusNode);
                                  }
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
                                textInputAction: TextInputAction.next,
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
                                //textInputAction: TextInputAction.next,
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
                    SizedBox(height: responsive!.hp(5)),
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
                                      ))),
                              value: selectedGrado,
                              items: grados
                                  .map((grado) => DropdownMenuItem<String>(
                                        value: grado,
                                        child: Text(grado,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ))
                                  .toList(),
                              onChanged: (grado) =>
                                  setState(() => selectedGrado = grado!)),
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
                                      ))),
                              value: selectedGrupo,
                              items: grupos
                                  .map((grupo) => DropdownMenuItem<String>(
                                        value: grupo,
                                        child: Text(grupo,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                      ))
                                  .toList(),
                              onChanged: (grupo) =>
                                  setState(() => selectedGrupo = grupo!)),
                        )
                      ],
                    ),
                    SizedBox(height: responsive!.hp(5)),
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

                              int day = int.parse(_dayController.text);
                              int month = int.parse(_monthController.text);
                              String formattedDay = formatTwoDigit(day);
                              String formattedMonth = formatTwoDigit(month);

                              final Estudiante estudiante = Estudiante(
                                id: uuid.v1(),
                                nombre: _nombre,
                                apellidoPaterno: _apellidoPaterno,
                                apellidoMaterno: _apellidoMaterno,
                                fechaNacimiento:
                                    '$formattedDay/$formattedMonth/${_yearController.text}',
                                grado: selectedGrado,
                                grupo: selectedGrupo,
                                numControl:
                                    '${_apellidoPaterno.substring(0, 2).toUpperCase()}${_apellidoMaterno.substring(0, 1).toUpperCase()}${_nombre.substring(0, 1).toUpperCase()}${_yearController.text.substring(2)}${_monthController.text}${_dayController.text}',
                                librosLeidos: 0,
                              );
                              await DatabaseHelper.addEstudiante(estudiante);
                              if (mounted) {
                                Navigator.pushNamed(context, 'estudiantesPage');
                              }
                            }
                          },
                          child: Text(
                            "Registrar estudiante",
                            style: TextStyle(fontSize: responsive!.dp(2.5)),
                          ),
                        ),
                      ),
                    )
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
