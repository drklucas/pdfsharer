import 'package:flutter/material.dart';
import 'package:sharepdf/models/receipt.dart';

class ReceiptItem extends StatelessWidget {
  final Receipt receipt;
  const ReceiptItem(this.receipt, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
            colors: [Colors.blueGrey.shade50, Colors.grey.shade300]
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            receipt.clientName,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('R\$${receipt.price.toString().replaceAll('.', ',')}',
                  style: const TextStyle(fontSize: 20, color: Colors.black87)),
              Text(
                receipt.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
