import 'package:flutter/material.dart';
import 'package:mega_pro_planing_app/providers/data.dart';
import 'package:mega_pro_planing_app/providers/db.dart';
import 'package:mega_pro_planing_app/screens/selectMethod.dart';
import 'package:provider/provider.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {

  final TextEditingController _textEditingController = TextEditingController();
  DateTime savedDateTime = DateTime.now();


  loadSite()async {
    await Database.getSite().then((savedSite) {
      _textEditingController.text = savedSite;
    });
  }

  loadDate()async{

    // get date
    await Database.getDate().then((savedDate){
      print("============ DATE LOADED");
    setState(() {
      savedDateTime = savedDate; 
      
    });


    });
  }

  @override
  void initState() {
    super.initState();
    // load site
    loadSite();
    // save site
    _textEditingController.addListener(() {
      Database.saveSite(_textEditingController.text);
    },);

    // load date
    loadDate();
  }

  onDateChange(newDate){
    print("Changed =========");
    print(newDate);
    // save Date
    Database.saveDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(








      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Image.asset("assets/images/logo2.png",width: 60,),
           TextField(
            controller: _textEditingController,
            expands: false,
            decoration: const InputDecoration(
              
              labelText: "Site",
              hintText: "Enter Site Name",
              border: OutlineInputBorder(),
              
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: InputDatePickerFormField(
              
              onDateSubmitted: (newDate)=>onDateChange(newDate),firstDate: DateTime(2000), lastDate: DateTime(3000), fieldLabelText: "La Date",acceptEmptyDate: false,fieldHintText: "Le mois/ Le jour/ L'annee",initialDate: savedDateTime,),
          ),
          const Text("Planing", textAlign: TextAlign.center,style: TextStyle(fontSize: 40,fontStyle: FontStyle.italic),),
          const Divider(),

          // TABLE
          PlanningTable(),

          // buttons
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical:15.0),
          //   child: Expanded(child: ElevatedButton(onPressed: (){

          //     // partager function

          //     showDialog(context: context, builder: (context){return const SelectWidget(btn: "Partager",);});


        

          //   }, child: const Text("Partager"),)),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                
                // imprimer btn
          
                showDialog(context: context, builder: (context){return const SelectWidget(btn: "Imprimer",);});
          
              }, child: const Row(children: [
                Icon(Icons.print),
                Text(" Imprimer   "),
              ],),),
          
          
              IconButton(onPressed: (){
                  // add 
                  Provider.of<Data>(context, listen: false).addNewRow();
              },
              
              padding:const EdgeInsetsDirectional.all(15),
              
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((e) => Colors.green),
              ),
              icon: const Icon(Icons.add)),
          
            
              ElevatedButton(onPressed: (){
          
                showDialog(context: context, builder: (context) {
                  return  AlertDialog(
                    title: const Text("Attention !"),
                    content: const Text("Voulez vous vraiment supprimer tout le planning ?"),
                    icon: const Icon(Icons.warning, color: Colors.red,),
                    actions: [
                      
                      TextButton.icon(onPressed: (){
                        Navigator.of(context).pop();
                      },icon: const Icon(Icons.cancel),label: const Text("Annuler"),),
                      TextButton.icon(onPressed: (){
                        // remove all
                        Provider.of<Data>(context, listen: false).setData([]);
                        Navigator.of(context).pop();
                      },icon: const Icon(Icons.delete_forever),label: const Text("Supprimer"),),
                    
                    ]
                  );
                },);
          
          
              }, child: const Row(children: [
                Icon(Icons.delete_forever),
                Text("Supprimer tous")
              ],),),
            ],
          ),

        ],
      ),
    );
  }
}



class PlanningTable extends StatelessWidget {
  
  


  
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  PlanningTable({super.key});

  @override
  Widget build(BuildContext context) {

    Data dataProvider = Provider.of<Data>(context);  
    
    if (dataProvider.data.isEmpty){
      return SizedBox(height: MediaQuery.of(context).size.height * 0.6,child: const Center(child: Text("Appuyer sur + pour ajouter un Planning"),));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: true,
          
          child: Scrollbar(
            
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(

              controller: _vertical,
              child: SingleChildScrollView(

                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(),
                  columns:  <DataColumn>[
                    const DataColumn(label: Text('#')),
                    const DataColumn(label: Text('Nom')),
                    for (String day in dataProvider.Days)
                      DataColumn(label: Text(day)),
                      
                  ],
                  rows:
                    [
                      for (var info in dataProvider.data)
                      DataRow(
                        cells: [
                          // tools

                          DataCell(IconButton(onPressed: (){
                            dataProvider.removeRow(info);
                          },icon:const Icon(Icons.delete, color: Colors.red,))),
                          
                          // name

                          
                          DataCell(Text(info["name"]),onTap: (){
                            showDialog(context: context, builder: (builder){
                              return TextInputAlert(dataToEdit: info,whatToEdit: "name",);
                            });
                          }),
                          for (int i = 0;i < dataProvider.Days.length ;i++)
                            DataCell(
                              onTap: (){
                                showDialog(context: context, builder: (builder){
                                  return TextInputAlert(dataToEdit: info,whatToEdit: "plan",day: i,);
                                });
                              },
                              Container(
                              
                              constraints: const BoxConstraints.expand(),
                              alignment: Alignment.centerLeft,
                              
                              child: Text(info["plan"][i],textAlign: TextAlign.start, style: TextStyle(
                                color: (info["plan"][i] as String).toLowerCase() == "repos" ? Colors.red : Colors.black
                              ), ),
                              
                            )),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextInputAlert extends StatefulWidget {
  
  final Map dataToEdit;
  final String whatToEdit;
  final int day;

  
  const TextInputAlert({
    super.key,
    required this.dataToEdit,
    required this.whatToEdit,
    this.day = 0,
  });



  @override
  State<TextInputAlert> createState() => _TextInputAlertState();
}

class _TextInputAlertState extends State<TextInputAlert> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    
    return AlertDialog.adaptive(
      title: const Text("Modifier le champ"),
      content:TextField(
        controller: _controller,
        decoration:const InputDecoration(
          labelText: "Enter le text ..."
        ),
      ),
      actions: [
        
        TextButton.icon(onPressed: (){
          Navigator.pop(context);
        }, icon:const Icon(Icons.close, color: Colors.red,),label:const  Text("Annuler", style: TextStyle(color: Colors.red),),),
       
       

       
        TextButton.icon(onPressed: (){
          // sauvgarder
          if (_controller.text.trim().isNotEmpty){
            Data data = Provider.of<Data>(context, listen: false);
            // modify

            if (widget.whatToEdit == "name"){
               data.modifyName(widget.dataToEdit, _controller.text);
            }else {
              data.modifyPlan(widget.dataToEdit, _controller.text, widget.day);
            }
            
          }

          Navigator.of(context).pop();          
        }, 
        icon: const Icon(Icons.done, color: Colors.green,),label: const Text("Sauvgarder", style: TextStyle(color: Colors.green),),),
      ],
    );
  }
}