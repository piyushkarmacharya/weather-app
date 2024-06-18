import 'package:flutter/material.dart';
class AdditionalInfoItems extends StatelessWidget {
  final IconData icn;
  final String label;
  final String value;
  const AdditionalInfoItems({
    super.key,
    required this.icn,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icn,size: 32,),
        const SizedBox(height: 8,),
        Text(label),
        const SizedBox(height: 8,),
        Text(value,style: const TextStyle(fontSize: 16),)
      ],
    );
  }
}