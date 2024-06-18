import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icn;
  final String value;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icn,
    required this.value

    });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Card(
        shape:const  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icn,
                size: 32,
              ),
             const  SizedBox(
                height: 8,
              ),
              Text(value)
            ],
          ),
        ),
      ),
    );
  }
}
