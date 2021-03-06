import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kioxkef/views/Login.dart';
import 'package:kioxkef/views/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatelessWidget {
    
  final String nomeUser,emailUser;
  final PageController pageviewController;
  DrawerPage(this.nomeUser,this.pageviewController,this.emailUser);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("images/pattner.jpg"),fit:BoxFit.cover)
            ),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.end,
              children: [

                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage("https://png.pngtree.com/png-vector/20191003/ourmid/pngtree-user-login-or-authenticate-icon-on-gray-background-flat-icon-ve-png-image_1786166.jpg"),
                ),
                 Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  alignment: Alignment.center,
                 
                    child:Text(nomeUser.replaceAll('"', ""),style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold))
                  )

                 ],
            ),

          ),
         listItem(Icons.person_outline,"Conta",Feather.arrow_down_circle,(){
             Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context)=> UserData(nomeUser,emailUser)));
            // Navigator.push(context,MaterialPageRoute(builder: (context) => Datalhes(urlBook,titulo,imageUrl,autor,likes,preco,descricao,id)));
         }),
           listItem(Feather.home,"Livros",Feather.arrow_down_circle,(){
             pageviewController.jumpToPage(2);
            Navigator.pop(context);
           }),
             listItem(Feather.book,"Jornais",Feather.arrow_down_circle,(){}),
               listItem(Feather.image,"Revistas",Feather.arrow_down_circle,(){}),
                 listItem(Feather.layout,"Banda Desenhada",Feather.arrow_down_circle,(){}),
                 listItem(Feather.settings,"Definicoes",Feather.arrow_down_circle,(){}),
                  listItem(Icons.power,"Sair",Feather.arrow_down_circle,()async{
                    showAlertDialog(context,() async{
                        logoff(context);
                    });
                  })
        ],

      ),

    );
  }
Widget listItem(IconData icon,String titulo,IconData iconPrefix,Function calback){
    return ListTile(
            leading: Icon(icon),
            title: Text("$titulo"),
            trailing:Icon(iconPrefix),
            onTap: (){
              calback();
            },
      );
  }

 void logoff(BuildContext context)async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   await preferences.remove('email');
   await preferences.remove('nome');
   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>  Login()),(Route<dynamic> route) => false);
 }

 showAlertDialog(BuildContext context,Function callBack) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Não"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Sim"),
    onPressed: (){
      callBack();
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Aviso"),
    content: Text("Tem a certeza que pretende terminar a Sessão"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



}