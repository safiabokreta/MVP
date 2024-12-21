import 'package:flutter/material.dart';
import 'package:zefeffete/presentation/views/themes/simpleStyle.dart/colors.dart';

class PriceInputs extends StatefulWidget {
  const PriceInputs({super.key, required this.onPriceChanged});

  final Function(double?, double?) onPriceChanged;

  @override
  _PriceInputsState createState() => _PriceInputsState();
}

class _PriceInputsState extends State<PriceInputs> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Min price',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    widget.onPriceChanged(
                      double.tryParse(value),
                      double.tryParse(_maxPriceController.text),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _maxPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Max price',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColors.primary1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    widget.onPriceChanged(
                      double.tryParse(_minPriceController.text),
                      double.tryParse(value),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
