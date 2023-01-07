import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final String hint;
  final bool enabled;
  final bool isNumeric;
  final String defaultInput;
  late String input = "";
  final void Function(bool) updateCallback;

  InputField({required this.hint, required this.updateCallback, required this.isNumeric, required this.textEditingController, required this.enabled, required this.defaultInput, required this.label});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  String _errorText = "";
  bool _isInvalid = false;

  void _validate(String input) {
    if(input.isEmpty) {
      _errorText = "Input is empty!";
      _isInvalid = true;
      widget.updateCallback(!_isInvalid);
      print(_errorText);
      return;
    }

    int? inputInt = int.tryParse(input);
    if(inputInt == null) {
      _errorText = "Numeric input required!";
      _isInvalid = true;
      widget.updateCallback(!_isInvalid);
      print(_errorText);
      return;
    }

    if(inputInt < 0 || inputInt > 10000) {
      _errorText = "Size constraint: 0 < size < 10,000!";
      _isInvalid = true;
      widget.updateCallback(!_isInvalid);
      print(_errorText);
      return;
    }

    _errorText = "";
    _isInvalid = false;
    widget.updateCallback(!_isInvalid);
  }

  @override
  void initState() {
    widget.textEditingController.text = widget.defaultInput;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        widget.label,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      title: Tooltip(
        message: widget.hint,
        child: TextField(
          enabled: widget.enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            errorText: _isInvalid ? _errorText : null,
          ),
          controller: widget.textEditingController,
          onChanged: (text) {
            setState(() {
              _validate(text);
            });
          },
        ),
      ),
    );
  }
}
