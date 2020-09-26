class Todo{
  final int id;
  final String title;
  final int taskId;
  final int isDone;
  Todo({this.id,this.title,this.isDone,this.taskId});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'title': title,
      'isDone': isDone,
      'taskId': taskId,
    };
  }
}