import 'dart:io';



import 'package:flutter/material.dart' as fltr;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mega_pro_planing_app/providers/data.dart';
import 'package:mega_pro_planing_app/providers/db.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' ;
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:provider/provider.dart';


class PdfManager{



  


  static generatePDFFile(fltr.BuildContext context, String method, String btn ) async {

    var fontData = await rootBundle.load("assets/fonts/arabic.ttf");

    final ttf = Font.ttf(fontData);


    final Document document = Document(
      theme: ThemeData.withFont(base: ttf,)

    );
    Data data = Provider.of<Data>(context, listen: false);
    
    final dynamic logo = MemoryImage(
    (await rootBundle.load('assets/images/logo2.png')).buffer.asUint8List(),
    );
    
    
    String day;
    String date = "";
    String site = "";

    await Database.getDate().then((savedDate) async {
      final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(savedDate);
      date = formatted;
      day = data.Days[savedDate.weekday -1];
      await Database.getSite().then((savedSite) {
        site = savedSite;
      }).then((e) {
          document.addPage(Page(
              build: (context)  {
                return Column(
                  children: [

                      // header
                    
                      Image(logo,width: 300,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Mega Pro Planing'),
                          Column(
                            children: [
                              Text("Date: $date $day"),
                              Text("Site: $site"),
                            ]
                          )
                        ]
                      ),
                      Divider(),

                      // table
                        Table(
                          border: TableBorder.all(),
                          children: [
                            
                            TableRow(
                              
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 250,
                                  ),
                                  child: Text("Nom"),
                                ),
                                
                                for (String day in data.Days)
                                  ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 250,
                                  ),
                                  child: Text(day),
                                ),
                              ]
                            ),
                            
                            // load users
                            for (dynamic user in data.data)
                              TableRow(children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 250,
                                  ),
                                  child: Text(user["name"].replaceAll("clicker pour modifier ..", ""), textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center),
                                ),



                                
                                for (int day = 0; day < data.Days.length; day++)

                                  ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 250,
                                  ),
                                  child: Text((user["plan"][day] as String).replaceAll("clicker pour modifier ..", ""), style: TextStyle(
                                    color: user["plan"][day].toLowerCase() == "repos" ? PdfColors.red : null
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center
                                  
                                  ),
                                 ),

                                  
                                  
                              ])

                          ]
                        ),
                  ]
                ); 
                
              },
            ));
      });
    });



    

     final output = await getTemporaryDirectory();


 
      final file = File("${output.path}/planning.pdf");
      await file.writeAsBytes(await document.save()).then((res) async{
        if (btn == "imprimer"){

          if (method == "pdf"){
            OpenFile.open("${output.path}/planning.pdf");
          }
        }
      }).onError((err,tr){
        fltr.ScaffoldMessenger.of(context).showSnackBar(const  fltr.SnackBar(
          content: fltr.Text("On peut pas partager le fichier !"),
        ));
      });

  


    if (context.mounted){
      fltr.Navigator.of(context).pop();
    }
  }  



static Future<List<File>> convertPdfToImages(File pdfFile) async {
  final List<File> images = [];
  final document = await pdfrx.PdfDocument.openFile(pdfFile.path);
  final tempDir = await getTemporaryDirectory();

  for (int i = 1; i <= document.pages.length; i++) {
    final page = document.pages[i];
    final pageImage = await page.render(
      width: page.width.toInt(),
      height: page.height.toInt(),
      
    );

    final imagePath = '${tempDir.path}/page_$i.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(pageImage!.pixels);
    images.add(imageFile);
  }

  return images;
}

  

}