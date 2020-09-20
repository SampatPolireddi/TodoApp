import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets.dart';

class Taskpage extends StatefulWidget {

  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  String _tasktitle="";

  @override
  void initState() {

    if(widget.task !=null){
      _tasktitle =widget.task.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
         child: Stack(
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(top: 24.0, bottom: 6.0),
                   child: Row(
                     children: [
                       InkWell(
                         onTap:(){
                           Navigator.pop(context);
                         },
                         child: Padding(
                           padding: const EdgeInsets.all(24.0),
                           child: Image(image: AssetImage("assets/images/back_arrow_icon.png")),
                         ),
                       ),

                       Expanded(
                           child: TextField(
                             onSubmitted: (value) async{

                               //check if the field is not empty
                               if(value != ""){
                                 //check if the task is null
                                 if(widget.task==null){
                                   DatabaseHelper _dbHelper = DatabaseHelper();
                                   Task _newTask = Task(title : value);
                                   await _dbHelper.insetTask(_newTask);
                                   print("New Task has been created");
                                 }else{
                                   print("update the existing task");
                                 }
                               }
                             },
                             controller:  TextEditingController()..text = _tasktitle,
                             decoration: InputDecoration(
                               hintText: "Enter Task Title",
                               border: InputBorder.none,
                             ),
                             style: TextStyle(
                               fontSize: 26.0,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF211551),
                             ),
                           ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding:EdgeInsets.only(bottom: 12.0),
                   child: TextField(
                     decoration: InputDecoration(
                       hintText: "Enter description for the task...",
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                     ),
                   ),
                 ),
                 TodoWidget(
                   text:"Create your first task",
                   isDone: false,
                 ),
                 TodoWidget(
                   isDone: true,
                 ),
                 TodoWidget(
                   isDone: false,
                 ),
                 TodoWidget(
                   isDone: true,
                 ),
               ],
             ),
             Positioned(
               bottom: 24.0,
               right: 24.0,
               child: GestureDetector(
                 onTap: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context)=> Taskpage()
                     ),
                   );
                 },
                 child: Container(
                   width: 50.0,
                   height: 50.0,
                   decoration: BoxDecoration(
                     color: Color(0xFFFE3577),
                     borderRadius: BorderRadius.circular(50.0),
                   ),
                   child: Image(
                     image: AssetImage(
                         "assets/images/delete_icon.png"
                     ),
                   ),
                 ),
               ),
             ),
           ],
         ),
        ),
      ),
    );
  }
}
