import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets.dart';

class Taskpage extends StatefulWidget {

  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId=0;
  String _tasktitle="";
  String _taskDescription="";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible=false;

  @override
  void initState() {

    if(widget.task !=null){
      //set visibility to true
      _contentVisible=true;


      _tasktitle =widget.task.title;
      _taskDescription=widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus =FocusNode();
    _descriptionFocus=FocusNode();
    _todoFocus=FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
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
                             focusNode: _titleFocus,
                             onSubmitted: (value) async{
                               //check if the field is not empty
                               if(value != ""){
                                 //check if the task is null
                                 if(widget.task==null){
                                   Task _newTask = Task(title : value);
                                   _taskId =await _dbHelper.insertTask(_newTask);
                                   setState(() {
                                     _contentVisible=true;
                                     _tasktitle=value;
                                   });
                                   print("New Task id: $_taskId");
                                 }else{
                                  await _dbHelper.updateTaskTitle(_taskId, value);
                                  print("Task updated");
                                 }
                                 _descriptionFocus.requestFocus();
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
                 Visibility(
                   visible: _contentVisible,
                   child: Padding(
                   padding:EdgeInsets.only(bottom: 12.0),
                   child: TextField(
                     focusNode: _descriptionFocus,
                     onSubmitted: (value) async{
                       if(value !=""){
                         if(_taskId != 0){
                          await _dbHelper.updateTaskDescription(_taskId, value);
                          _taskDescription=value;
                         }
                       }
                       _todoFocus.requestFocus();
                     },
                     controller: TextEditingController()..text =_taskDescription,
                     decoration: InputDecoration(
                       hintText: "Enter description for the task...",
                       border: InputBorder.none,
                       contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                     ),
                   ),
                 ),),

                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTodo(_taskId),
                  builder: (context,snapshot){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder:(context,index) {
                          return GestureDetector(
                            onTap: () async{

                              if(snapshot.data[index].isDone == 0){
                                await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                              }else{
                               await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                              }
                              setState(() {});
                              print("Todo Done: ${snapshot.data[index].isDone}");

                            },

                            child: TodoWidget(
                              text: snapshot.data[index].title,
                              isDone: snapshot.data[index].isDone ==0
                                  ? false
                                  :true,
                            ),
                          );
                          },
                      ),
                    );
                  },
                   ),),
                 Visibility(
                   visible: _contentVisible,
                   child:Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                   child: Row(
                     children: [
                         Container(
                           width: 20.0,
                           height: 20.0,
                           margin: EdgeInsets.only(right:15.0),
                           decoration: BoxDecoration(
                             color: Colors.transparent,
                             borderRadius: BorderRadius.circular(6.0),
                             border: Border.all(color: Color(0xFF86829D), width: 1.5),
                           ),
                           child: Image(
                             image: AssetImage("assets/images/check_icon.png"),
                           ),
                         ),
                       Expanded(
                         child: TextField(
                           focusNode: _todoFocus,
                           controller: TextEditingController()..text="",
                           onSubmitted: (value) async{
                             if(value != ""){
                               //check if the task is not null
                               if(_taskId != 0){
                                 DatabaseHelper _dbHelper = DatabaseHelper();
                                 Todo _newTodo = Todo(
                                   title : value,
                                   isDone: 0,
                                   taskId: _taskId,
                                 );
                                 await _dbHelper.insertTodo(_newTodo);
                                 setState(() {});
                                 _todoFocus.requestFocus();
                               }
                             }

                           },
                           decoration: InputDecoration(
                             hintText: "Enter Todo item...",
                             border:  InputBorder.none,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),),
               ],
             ),
             Visibility(
               visible: _contentVisible,
               child: Positioned(
               bottom: 24.0,
               right: 24.0,
               child: GestureDetector(
                 onTap: () async{
                   if(_taskId!=0){
                     await _dbHelper.deleteTask(_taskId);
                     Navigator.pop(context);
                   }
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
             ),),
           ],
         ),
        ),
      ),
    );
  }
}
