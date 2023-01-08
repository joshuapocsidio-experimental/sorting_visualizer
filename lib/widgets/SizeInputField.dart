import 'package:flutter/material.dart';

class SizeInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String label;
  final String hint;
  final bool enabled;
  final bool isNumeric;
  final String defaultInput;
  late String input = "";
  final void Function(bool) updateCallback;

  SizeInputField({required this.hint, required this.updateCallback, required this.isNumeric, required this.textEditingController, required this.enabled, required this.defaultInput, required this.label});

  @override
  _SizeInputFieldState createState() => _SizeInputFieldState();
}

class _SizeInputFieldState extends State<SizeInputField> {
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

    if(inputInt < 0 || inputInt > 1000) {
      _errorText = "Size constraint: 0 < size < 1,000!";
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
          fontSize: 16,
        ),
      ),
      title: Tooltip(
        message: widget.hint,
        child: TextField(
          style: TextStyle(fontSize: 14),
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
