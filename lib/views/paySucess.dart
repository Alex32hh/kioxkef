import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:kioxkef/components/download_alert.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PaySucess extends StatefulWidget {

  @override
  _PaySucessState createState() => _PaySucessState();

  final String url,nome,id,capa,preco,titulo;
  PaySucess(this.url,this.nome,this.id,this.capa,this.preco,this.titulo,);
}

class _PaySucessState extends State<PaySucess> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _path;

  bool concluido = false;
  String precolabel;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
        FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount: double.parse(widget.preco));
        precolabel = precoProduto.output.nonSymbol;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryColor,
       title: Text("Pagamento Concluido"),
         actions: [
             Icon(Icons.more_vert,color: Colors.white,)
          ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
      child:Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

           SizedBox(height: 100,),
          Text("Pagemto Efectuado!"),
           SizedBox(height: 50,),
          Text("Obrigado!",style: TextStyle(fontSize:30),),
            SizedBox(height: 50,),
            Text(precolabel+" AOA",style: TextStyle(fontSize:30,color: primaryColor),),
             SizedBox(height: 50,),
          Text("Ordem, N #234-234-234",),
           SizedBox(height: 25,),
          Text("Aos,25 de Julho de 2020 (13:29)",),
           SizedBox(height: 25,),
           Text("Os detalhes dav sua compra foram enviados para o email registrado na sua conta.",textAlign:TextAlign.center, style: TextStyle(fontSize:15)),
            SizedBox(height: 60,),
           Text("Adicione Fundos a Sua Carteira", style: TextStyle(fontSize:15,color: primaryColor)),
            Expanded(
              child:Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                loginButton("Abrir",Colors.green,true)
              ],
            )
          )
          
        ],
       )
      ),
    );
  }

Widget cardList(Color cor,String label,String email){
  return Card(
    elevation:0.5,
    shadowColor:Colors.grey[800],
    child: ListTile(
      title: Text("$label"),
      subtitle: Text("$email"),
      trailing: Icon(Icons.add_circle_outline,color: cor,),
      onTap: (){

      },
    ),
  
  );
}


Widget loginButton(String labelText,Color cor,bool isSubmited){
  return Padding(padding: EdgeInsets.all(10),
  child:SizedBox(
          width: MediaQuery.of(context).size.width-20, //Full width
          height: 60,
    child:FlatButton(
       color: cor,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed:() async{
       openBook(widget.url);
    },
   padding:EdgeInsets.all(0.0),
   child:
   Text("$labelText",style: TextStyle(color:Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
 )
   ));
}
  
  openBook(String src) async{
    if (src.isNotEmpty) {
        EpubViewer.setConfig(
                identifier: 'androidBook',
                themeColor: Theme.of(context).accentColor,
                scrollDirection: EpubScrollDirection.HORIZONTAL,
                enableTts: false,
                allowSharing: true,
              );

            EpubViewer.open(
            src,lastLocation:EpubLocator.fromJson({
              "bookId": "2239",
              "href": "/OEBPS/ch06.xhtml",
              "created": 1539934158390,
              "locations": {
                "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
              }
            }), // first page will open up if the value is null
          );
    }

  }


}
