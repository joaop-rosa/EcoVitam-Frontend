import 'dart:async';
import 'package:flutter/material.dart';

class HomeInputFilter extends StatefulWidget {
  final Function(String) onChanged;
  final Duration debounceDuration;
  final String? hintText;

  HomeInputFilter({
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.hintText,
  });

  @override
  _HomeInputFilterState createState() => _HomeInputFilterState();
}

class _HomeInputFilterState extends State<HomeInputFilter> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(text); // Chama a função passada como argumento
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Digite algo',
      ),
    );
  }
}
