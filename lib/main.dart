import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:sharepdf/components/receipt_item.dart';
import 'package:sharepdf/data/dummy_data.dart';
import 'package:sharepdf/models/receipt.dart';

import 'package:pdf/widgets.dart' as pdf;
import 'package:share_extend/share_extend.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lista de Pagamentos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getAmount();
  }

  final List<Receipt> receipts = dummyReceipts;
  double amount = 0;

  void _getAmount() {
    for (int i = 0; i < receipts.length; i++) {
      amount = amount + receipts[i].price;
    }
  }

  Future<void> _createPDF(BuildContext context) async {
    final pdf.Document pdfDoc = pdf.Document(deflate: zlib.encode);

    pdfDoc.addPage(pdf.MultiPage(
        header: (context) => pdf.Container(
              child: pdf.Row(children: [
                pdf.Text('Lista de Pagamentos',
                    style: const pdf.TextStyle(
                        color: PdfColors.white, fontSize: 28))
              ]),
              padding:
                  const pdf.EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              height: 75,
              color: PdfColors.blue400,
            ),
        footer: (context) => pdf.Container(
            child: pdf.Row(
                mainAxisAlignment: pdf.MainAxisAlignment.end,
                children: [
                  pdf.Text(
                    'Total: R\$${amount.toString().replaceAll('.', ',')}',
                    style: const pdf.TextStyle(
                      fontSize: 27,
                      color: PdfColors.white,
                    ),
                  )
                ]),
            padding: const pdf.EdgeInsets.symmetric(horizontal: 20),
            height: 75,
            color: PdfColors.blue300),
        build: (context) => [
              pdf.Container(
                padding: const pdf.EdgeInsets.all(5),
                child: pdf.Column(
                    children: List.generate(receipts.length, (index) {
                  return pdf.Container(
                    padding: const pdf.EdgeInsets.all(5),
                    child: pdf.Column(
                      children: [
                        pdf.Divider(thickness: 0.5),
                        pdf.SizedBox(height: 2),
                        pdf.Row(
                            mainAxisAlignment:
                                pdf.MainAxisAlignment.spaceBetween,
                            children: [
                              pdf.Container(
                                child: pdf.Text(receipts[index].clientName,
                                    style: const pdf.TextStyle(fontSize: 22)),
                              ),
                              pdf.Column(children: [
                                pdf.Text(
                                    receipts[index]
                                        .price
                                        .toString()
                                        .replaceAll('.', ','),
                                    style: const pdf.TextStyle(fontSize: 23)),
                                pdf.Text(receipts[index].description,
                                    style: const pdf.TextStyle(fontSize: 17))
                              ]),
                            ]),
                        pdf.SizedBox(height: 2)
                      ],
                    ),
                  );
                })),
              ),
            ])
            );

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfFile.pdf';

    final File file = File(path);
    final bytes = await pdfDoc.save();

    file.writeAsBytesSync(bytes);

    ShareExtend.share(path, "file", sharePanelTitle: "Enviar PDF");
  }

  @override
  Widget build(BuildContext context) {
    final List<Receipt> receipts = dummyReceipts;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 10,
                padding: const EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      colors: [Colors.blueGrey.shade50, Colors.grey.shade300]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Valor total: ${amount.toString().replaceAll('.', ',')}',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Nº de pagamentos: ${receipts.length}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: receipts.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: ReceiptItem(receipts[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createPDF(
          context,
        ),
        child: const Icon(Icons.share),
      ),
    );
  }
}
