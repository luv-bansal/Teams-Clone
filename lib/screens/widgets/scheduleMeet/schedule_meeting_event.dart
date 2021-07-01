import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/event.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/services/calendar_event_provider.dart';

class ScheduleMeetingEvent extends StatefulWidget {
  final Event? event;
  const ScheduleMeetingEvent({Key? key, this.event}) : super(key: key);

  @override
  _ScheduleMeetingEventState createState() => _ScheduleMeetingEventState();
}

class _ScheduleMeetingEventState extends State<ScheduleMeetingEvent> {
  final _formKey = GlobalKey<FormState>();
  late DateTime toDate;
  late DateTime fromDate;
  TextEditingController titleControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleControler.addListener(() {setState(() {

    });});
    if(widget.event == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 1));
    }else{
      final event = widget.event;
      fromDate = event!.from;
      toDate = event.to;
      titleControler.text = event.title;
    }

  }

  @override
  void dispose() {
    titleControler.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: CloseButton(),
        actions: [
          ElevatedButton.icon(onPressed: () async {
            await saveForm();
          },
            icon: Icon(Icons.done),
            label: Text('Save'),
            style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, primary: Colors.transparent) ,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              builtTitle(),
              SizedBox(height: 16,),
              builtDateTimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget builtTitle(){
    return TextFormField(
      controller: titleControler,
      style: TextStyle(fontSize: 24, color: Colors.white),
      decoration: InputDecoration(
        hintText: "Add Title",
        hintStyle: TextStyle(color: Colors.white54),
        border: UnderlineInputBorder(),
      ),
      validator: (title) {
        if((title == null || title.isEmpty)){
          return 'Title cannot be empty';
        }else{
          return null;
        }

      } ,


    );
  }

  Widget builtDateTimePicker(){
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('From', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),),
        Row(
          children: [
            Expanded(
              child: builtDropDownField(
                text: toDateFunc(fromDate),
                onClick : () async => await pickFromDateTime(pickDate : true)
                ),
              flex: 2,
            ),
            Expanded(child: builtDropDownField(
                text: toTimeFunc(fromDate),
                onClick :  () async => await pickFromDateTime(pickDate: false)

            )),
          ],
        ),
      ],
    );
  }

  Widget buildTo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('To', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 19),),
        Row(
          children: [
            Expanded(
              child: builtDropDownField(
                  text: toDateFunc(toDate),
                  onClick : () async => await pickToDateTime(pickDate : true)
              ),
              flex: 2,
            ),
            Expanded(child: builtDropDownField(
                text: toTimeFunc(toDate),
                onClick : () async => await pickToDateTime(pickDate : false)

            )),

          ],
        ),
      ],
    );
  }

  Widget builtDropDownField( { required String text , required VoidCallback onClick} ){
    return ListTile(
      title: Text(text, style: TextStyle(color: Colors.white, fontSize: 18),),
      trailing: Icon(Icons.arrow_drop_down, color: Colors.white70,),
      onTap: onClick,

    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(pickDate: pickDate, initialDate: fromDate);
    if(date == null){
      return ;
    }
    if(date.isAfter(toDate)){
      toDate = date;
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(pickDate: pickDate,
        initialDate: toDate,
        firstDate: pickDate ? fromDate : null);
    if(date == null){
      return ;
    }

    if(date.isAfter(toDate)){
      toDate = date;
    }
    setState(() {
      toDate = date;
    });
  }

  Future pickDateTime({required bool pickDate, required DateTime initialDate, DateTime? firstDate}) async {
    if(pickDate){
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015,8),
        lastDate: DateTime(2101),
      );
      if(date == null){
        return null;
      }
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);

    }else{
      final timeOfDate = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if(timeOfDate == null){
        return null;
      }

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDate.hour, minutes: timeOfDate.minute);


      return date.add(time);


    }
  }

  Future saveForm() async{
    final isvalid =  _formKey.currentState!.validate();
    if(isvalid){
      final event = Event(title: titleControler.text, discription: 'discription', to: toDate, from: fromDate,  );
 
      final provider = Provider.of<EventProvider>(context, listen: false);
      setState(() {
        provider.addEvent(event);
      });

      Navigator.of(context).pop();
    }
  }


}

