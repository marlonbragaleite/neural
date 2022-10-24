import 'package:flutter/material.dart';

class Sliders extends StatefulWidget {
  final List<double> values;
  final Function redraw;
  final String title;
  final double min, max;
  const Sliders({
    Key? key,
    this.title = '',
    required this.values,
    required this.redraw,
    this.min = -1,
    this.max = 1,
  }) : super(key: key);

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  _SlidersState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(100, 100, 150, 100),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      width: 250,
      height: 51.0 * widget.values.length + 20,
      child: Column(children: [
        Text(widget.title),
        ...List.generate(
          widget.values.length,
          (index) => Row(
            children: [
              Slider(
                min: widget.min,
                max: widget.max,
                value: widget.values[index],
                onChanged: (v) => setState(() {
                  widget.values[index] = v;
                  widget.redraw();
                }),
              ),
              Text('${(widget.values[index] * 100).floor() / 100}'),
            ],
          ),
        )
      ]),
    );
  }
}
