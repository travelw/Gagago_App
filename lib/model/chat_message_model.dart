class ChatModel{
  String title;
  String message;
  int type=1;
  String time;
  ChatModel({required this.message,required this.type,this.title="",this.time=""});
}