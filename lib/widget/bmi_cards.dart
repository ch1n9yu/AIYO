import 'package:flutter/material.dart';
const TextStyle styleSmall = TextStyle(
  fontFamily: 'PS',
  fontSize: 14,
);
class BMIcard extends StatefulWidget {

  BMIcard({
    super.key,
    required this.date,
    required this.id,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.heightChanged,
    required this.weightChanged,
  });
  ValueChanged<double> heightChanged;
  ValueChanged<double> weightChanged;
  final DateTime date;
  final int id;
  double height;
  double weight;
  double bmi;

  @override
  State<BMIcard> createState() => _BMIcardState();
}

class _BMIcardState extends State<BMIcard> {
  double _height = 0;
  double _weight = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color(0xFFE6CAFB),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                      '${widget.id}.  ${widget.date.month}/${widget.date.day}',
                    style: styleSmall,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                      _height= double.parse(value);
                      setState(() {});
                      widget.heightChanged(_height);

                    },
                    decoration: InputDecoration(
                      hintStyle: styleSmall,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: '${widget.height} cm',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                        _weight= double.parse(value);
                        setState(() {});
                        widget.weightChanged(_weight);
                    },
                    decoration: InputDecoration(
                      hintStyle: styleSmall,
                      fillColor: Colors.white,
                      filled: true,
                      hintText: '${widget.weight} kg',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    flex: 2,
                    child: Text(
                      'BMI: ${widget.bmi.toStringAsFixed(2)}',
                      style: styleSmall,

                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
