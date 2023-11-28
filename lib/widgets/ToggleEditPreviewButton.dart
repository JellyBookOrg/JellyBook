import 'package:flutter/material.dart';

class ToggleEditPreviewButton extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final double width;

  const ToggleEditPreviewButton({
    Key? key,
    required this.isEditing,
    required this.onEdit,
    required this.onPreview,
    this.width = 0.4,
  }) : super(key: key);

  @override
  _ToggleEditPreviewButtonState createState() =>
      _ToggleEditPreviewButtonState();
}

class _ToggleEditPreviewButtonState extends State<ToggleEditPreviewButton> {
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * widget.width,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: isEditing
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.grey,
              backgroundColor: isEditing
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.2),
            ),
            onPressed: () {
              if (!isEditing) {
                setState(() {
                  isEditing = true;
                });
                widget.onEdit();
              }
            },
            child: const Text('Edit'),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * widget.width,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: !isEditing
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.grey,
              backgroundColor: !isEditing
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withOpacity(0.2),
            ),
            onPressed: () {
              if (isEditing) {
                setState(() {
                  isEditing = false;
                });
                widget.onPreview();
              }
            },
            child: const Text('Preview'),
          ),
        ),
      ],
    );
  }
}
