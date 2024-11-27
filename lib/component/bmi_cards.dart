import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
const TextStyle styleSmall = TextStyle(
  fontFamily: 'PS',
  fontSize: 14,
);
<<<<<<< HEAD

class BMIcard extends StatefulWidget {
=======
class BMIcard extends StatefulWidget {


>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
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
<<<<<<< HEAD
          color: const Color(0xFFBDB5DA),
=======
          color: const Color(0xFFE6CAFB),
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
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
<<<<<<< HEAD
                    '${widget.id}.  ${widget.date.month}/${widget.date.day}',
=======
                      '${widget.id}.  ${widget.date.month}/${widget.date.day}',
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
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
<<<<<<< HEAD
                      _height = double.parse(value);
                      setState(() {});
                      widget.heightChanged(_height);
=======
                      _height= double.parse(value);
                      setState(() {});
                      widget.heightChanged(_height);

>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
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
<<<<<<< HEAD
                      _weight = double.parse(value);
                      setState(() {});
                      widget.weightChanged(_weight);
=======
                        _weight= double.parse(value);
                        setState(() {});
                        widget.weightChanged(_weight);
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
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
<<<<<<< HEAD
=======

>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
