import 'package:flutter/material.dart';
import 'package:mega_pro_planing_app/providers/pdf.dart';

class SelectWidget extends StatefulWidget {

  final String btn;
  const SelectWidget({super.key, required this.btn});

  @override
  State<SelectWidget> createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.btn),
      content: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("${widget.btn} en :"),
          Wrap(
            children: [
              IconButton(onPressed: (){
                // partage as pdf
                PdfManager.generatePDFFile(context, "pdf", widget.btn.toLowerCase());
              }, icon:const Icon(Icons.picture_as_pdf)),

              // IconButton(onPressed: (){
              //   // partage as image
              //   PdfManager.generatePDFFile(context, "image", widget.btn.toLowerCase());
              // }, icon: Icon(Icons.image)),


            ],
          )
        ],
      ),
    );
  }
}