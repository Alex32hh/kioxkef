import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kioxkef/models/database.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:kioxkef/views/detalhes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardCompras extends StatefulWidget {
  
  @override
  _CardComprasState createState() => _CardComprasState();
}

class _CardComprasState extends State<CardCompras> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List listFiles = new List();
  String totalPagarLabel;
  double totalPagar = 0;
  int qtd = 1;

  List<Map<String,dynamic>> queryRowsCard = new List<Map<String,dynamic>>();

  @override
  void initState() {
    //TODO: implement initState
    super.initState();

    setState(() {
      FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount:totalPagar);
      totalPagarLabel = precoProduto.output.nonSymbol;
      loadAsset();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        title: Text("Carrinho de Compras",
          textAlign: TextAlign.center,
            style: TextStyle(
            fontFamily: "cuyabra",
            fontWeight: FontWeight.w400,
            fontSize: 18,
            ),
          ),
            actions: [
             Icon(Icons.more_vert,color: Colors.white,)
          ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child:Text("Total: $totalPagarLabel AOA",style:optionStyle)
                ),
                FlatButton(
                  color:Colors.amber,
                  onPressed:(){},
                 child: Container(
                  width: 150,
                  height:40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child:Text("Terminar a Compra!")
                ),)
              ],
              )
            ),
            Container(
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height /1.24,
              child:ListView.builder(
            itemCount: queryRowsCard.length,
            itemBuilder: (BuildContext context, int index){
            return queryRowsCard[index]['tipo'] == 1?horisontal(titulo:queryRowsCard[index]['nome'], imageUrl:queryRowsCard[index]['imageUrl'], autor:"", likes:"0", urlBook:queryRowsCard[index]['urlBook'], preco:queryRowsCard[index]['preco'], descricao:queryRowsCard[index]['descricao'], id:queryRowsCard[index]['id'].toString()):SizedBox();
            },
      
      )
            )
          ],
        )
     )
    );
  }



 Widget horisontal({String titulo,String imageUrl,String autor,String likes,String urlBook,String preco,String descricao,String id,File fileACtual}){
  FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount: double.parse(preco));
  
  return 
  Card( 
  color: Colors.white,
  borderOnForeground:true,
  shadowColor:Colors.grey[100],
  child:CachedNetworkImage(
    imageUrl: "$imageUrl",
    imageBuilder: (context, imageProvider) => Container(
    width: MediaQuery.of(context).size.width,
    height: 180,
    child: Row(
      children: [
        Container(
          width: 130,
          height: 180,
         decoration: BoxDecoration(
           borderRadius:BorderRadius.all(Radius.circular(10)),
           image: DecorationImage(image: imageProvider,fit: BoxFit.cover,),
        ),
        ),
        
        Expanded(
          child:Container(
          width: 200,
          height: 200,
          padding:EdgeInsets.all(15),
          child:Column(
            children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child:RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style:subtitle,
                        text: "$titulo"),
                  ),
                ),

               SizedBox(
                 height: 10,
               ),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Text("$descricao",maxLines:3)
                ),
              
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [

                Text((precoProduto.output.nonSymbol != "0.00"?precoProduto.output.nonSymbol+"AOA":"Gratuito"),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: precoProduto.output.nonSymbol != "0.00"?primaryColor:Colors.green),),
              
       
                   ],
                 ),

                Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
               
                 Container(
                          height: 30,
                          child: IconButton(icon:Icon(Feather.plus_circle,size: 25, color:Colors.green,), onPressed: (){
                            setState(() {
                               qtd++;
                            });
                          })
                        ),

                  Container(
                          height: 30,
                          alignment: Alignment.bottomCenter,
                          child: Text("$qtd")
                        ),

                  Container(
                          height: 30,
                          child: IconButton(icon:Icon(Feather.minus_circle,size: 25, color:Colors.green,), onPressed: (){
                            setState(() {
                               qtd--;
                            });
                          })
                        ),
                  SizedBox(
                    width: 20,
                  ),
                   Container(
                          height: 30,
                          child: IconButton(icon:Icon(Feather.trash,size: 25, color:Colors.red,), onPressed: () async{
                           
                            final SharedPreferences prefs = await _prefs;
                            prefs.remove(titulo+"_carrinho");
                            int value = await DatabaseHelper.instance.delete(int.parse(id));
                            loadAsset();

                            setState(() {});
                          })
                        )
                   ],),
                  
         
            ],
          ),
        )

        )
      ],
    ),
  ),
  placeholder: (context, url) => shimerEfect(context),
    errorWidget: (context, url, error) => Icon(Icons.error),
  ));
 }



loadAsset() async {
     queryRowsCard = await DatabaseHelper.instance.queryAll(1);
     totalPagar = 0;
     for(int a=0;a < queryRowsCard.length;a++){
      if( queryRowsCard[a]['tipo'] == 1){
        String preco =  queryRowsCard[a]['preco'];
        totalPagar+= double.parse(preco);
      }

     }

    FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount:totalPagar);
    totalPagarLabel = precoProduto.output.nonSymbol;

     setState(() {});
}


}

