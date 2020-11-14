
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:kioxkef/components/download_alert.dart';
import 'package:kioxkef/models/functions.dart';
import 'package:kioxkef/models/viewStyles.dart';
import 'package:kioxkef/util/const.dart';
import 'package:kioxkef/views/pagamento.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Datalhes extends StatefulWidget {
  @override
  _DatalhesState createState() => _DatalhesState();
   
   final String url,titulo,capa,autor,like,preco,descricao,id;

   Datalhes(this.url,this.titulo,this.capa,this.autor,this.like,this.preco,this.descricao,this.id);
}

class _DatalhesState extends State<Datalhes> {

   bool downloading = false;
   bool idDownloaded = false;
   double progressInt = 0;
   bool isFavorite = false;
   bool isonCard = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _path;
  Future<bool> _favorite,_isonCard;

  String fileSystem ="";
  String precoProd = "";
   @override
  void initState() {
    super.initState();

    updateview(int.parse(widget.id));

    checkDownload(widget.id+"book");
    getfavorite(widget.titulo+"_favorite");
    getCart(widget.titulo+'_carrinho');
    FlutterMoneyFormatter precoProduto = FlutterMoneyFormatter(amount: double.parse(widget.preco));
    precoProd = precoProduto.output.nonSymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryColor,
        centerTitle: true,
       title: Text("Detalhes"),
        actions: [
           IconButton(icon: isFavorite?Icon(Icons.favorite,color: Colors.red):Icon(Icons.favorite_border), onPressed: () => setfavorite()),
           !idDownloaded?IconButton(icon:!isonCard?Icon(Icons.add_shopping_cart, size: 30):Icon(Feather.shopping_bag,color: Colors.red, size: 30), onPressed: () =>setCarrinho()):
           IconButton(icon: Icon(Feather.share_2), onPressed: () => {}),
        ]
      ),
       body: SingleChildScrollView( child:Column(
         mainAxisSize: MainAxisSize.max,
         children: [
    Padding(padding: EdgeInsets.all(10), 
    child:CachedNetworkImage(
    imageUrl: widget.capa,
    imageBuilder: (context, imageProvider) => Container(
    width: MediaQuery.of(context).size.width,
    height: 190,
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
          height: 210,
          padding:EdgeInsets.all(10),
          child:Column(
            children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child:RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style:subtitle,
                        text: widget.titulo),
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top:5,bottom:5),
                  child:RichText(
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                        style: TextStyle(fontSize:15,color: primaryColor),
                        text: "by "+widget.autor),
                  ),
                ),

               Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: Text( ( int.parse(widget.preco) <= 0?"Gratuito":precoProd+" AOA"),
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                ),
             
                 Column(
                   children: [
                  Container(
                   width: double.infinity,
                   child:
                  idDownloaded==false?
                  FlatButton(
                   padding: EdgeInsets.zero,
                   color:primaryColor,
                   onPressed: () async{
                     PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
                    if (permission != PermissionStatus.granted) {
                      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                        // startDownload(context,widget.url,widget.id+"book");
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Pay(widget.url,widget.id+"book",widget.id,widget.capa,widget.preco,widget.titulo,widget.descricao)));
                    } else {
                        // startDownload(context,widget.url,widget.id+"book");
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Pay(widget.url,widget.id+"book",widget.id,widget.capa,widget.preco,widget.titulo,widget.descricao)));
                    }
                    
                   },
                   child:Text("Comprar",style: TextStyle(color:Colors.white),)
                  ):
                   FlatButton(
                   padding: EdgeInsets.zero,
                   color: Colors.green,
                   onPressed: () async{
                      final SharedPreferences prefs = await _prefs;
                      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
                    if (permission != PermissionStatus.granted) {
                      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                      openBook(prefs.getString(widget.id+"book"));
                    } else {
                      openBook(prefs.getString(widget.id+"book"));
                    }
                      
                   },
                   child:Text("Abrir",style: TextStyle(color:Colors.white),)
                  )
                )
               
                   ],
                 )

            ],
          ),
        )

        )
      ],
    ),
  ),
  placeholder: (context, url) => shimerEfect(context),
    errorWidget: (context, url, error) => Icon(Icons.error),
   )
  ),
  pageTitle("Descrição",context),
     Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
         child:RichText(
            overflow: TextOverflow.fade,
            text: TextSpan(
            style: TextStyle(fontSize:15, color: Colors.black),
                text: widget.descricao),
          ),
        ),
    pageTitle("Comentários",context),
      cardComments(),
      cardComments(),
        cardComments(),
        cardComments(),
  
    ]),

  ));

  }

  startDownload(BuildContext context, String url, String filename) async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (Platform.isAndroid) {
      Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
    }

    String path = Platform.isIOS
        ? appDocDir.path + '/$filename.epub'
        : appDocDir.path.split('Android')[0] +
            '${Constants.appName}/$filename.epub';

    print(path);
    File file = File(path);
    if (!await file.exists()) {
      await file.create();
       
       idDownloaded = true;

    } else {
      await file.delete();
      await file.create();

       idDownloaded = true;
       
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) async {

     final SharedPreferences prefs = await _prefs;
     final String pathaved = path;
     fileSystem =  path;
      if (v != null) {
        idDownloaded = true;
        setState(() {
       _path = prefs.setString(filename, pathaved).then((bool success) {
        return pathaved;
        });
      });
     }
    });
  }

  checkDownload(String filename) async {
     final SharedPreferences prefs = await _prefs;
     if(prefs.getString(filename) != null)
    if (prefs.getString(filename).isNotEmpty) {
      // check if book has been deleted
      String path = prefs.getString(filename);
      print(path);
      if(await File(path).exists()){
         idDownloaded = true;
      }else{
          idDownloaded = false;
      }
    } else {
        idDownloaded = false;
     }
   }


  void setfavorite() async{
  final SharedPreferences prefs = await _prefs;
   setState(() {
       saveList(widget.id,widget.titulo,widget.descricao,widget.preco,widget.capa,widget.url,"desejos","desejos",0);
       isFavorite =  !isFavorite;

        _favorite = prefs.setBool(widget.titulo+'_favorite', isFavorite).then((bool success) {
        return isFavorite;
        });

   });
  }


  void setCarrinho() async{
  final SharedPreferences prefs = await _prefs;
   setState(() {
       saveList(widget.id,widget.titulo,widget.descricao,widget.preco,widget.capa,widget.url,"carrinho","carrinho",1);
       isonCard =  !isonCard;
        _isonCard = prefs.setBool(widget.titulo+'_carrinho', isonCard).then((bool success) {
        return isonCard;
       
        });

   });
  }

  void getfavorite(String nomeBook) async{
     final SharedPreferences prefs = await _prefs;
    setState(() {
       isFavorite = prefs.getBool(nomeBook)==null?false: prefs.getBool(nomeBook);
    });
  }

  void getCart(String nomeBook) async{
     final SharedPreferences prefs = await _prefs;
    setState(() {
       isonCard = prefs.getBool(nomeBook)==null?false: prefs.getBool(nomeBook);
    });
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