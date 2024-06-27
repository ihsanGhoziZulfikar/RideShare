import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final String? errorText;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.prefixIcon,
    this.errorText,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          controller: widget.controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(1)),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                borderRadius: BorderRadius.circular(20)),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              fontSize: 16,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: Icon(
                widget.prefixIcon,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ),
            ),
            suffixIcon: widget.obscureText
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  )
                : null,
          ),
          obscureText: _obscureText,
        ),
        if (widget.errorText != null) // Add this line
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
