import 'package:chatapp_client/api/chat_api.dart';
import 'package:chatapp_client/helpers/sharedpreferences_helper.dart';
import 'package:chatapp_client/utils/color_themes.dart';
import 'package:chatapp_client/utils/focus_handler.dart';
import 'package:chatapp_client/widgets/heading_widget.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  static final routeName = "/schedulescreen";
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate;
  DateTime currentDate;
  TimeOfDay selectedTime;
  DateTime toSendAt;
  String selectedUserId;
  var token;
  TextEditingController textController = new TextEditingController();

  @override
  void initState() {
    currentDate = DateTime.now();
    currentDate = currentDate.add(Duration(days: 1));
    print(currentDate);
    selectedDate = currentDate;
    // selectedTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 00, 00);
    selectedTime = TimeOfDay(hour: 0, minute: 0);
    super.initState();
  }


  _resetPasswordSubmit() async {

    Map arguments = ModalRoute.of(context).settings.arguments as Map;
    selectedUserId = arguments['id'];
    token = await SharedPreferencesHelper.getToken();
    print("Selecteddddddddddddd");
    print(token);
    ChatApi.schedule(
      token,
      selectedUserId,
       textController.text.trim(),
       "2021-04-16"
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: currentDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        // _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        // _hour = selectedTime.hour.toString();
        // _minute = selectedTime.minute.toString();
        // _time = _hour + ' : ' + _minute;
        // _timeController.text = _time;
        // _timeController.text = formatDate(
        // DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
        // [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            // color: Colors.blue,
            child: GestureDetector(
              onTap: () {
                FocusHandler.unfocus(context);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        HeadingWidget("Scheduler"),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            RawMaterialButton(
                              shape: CircleBorder(),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorThemes.primary),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _selectDate(context);
                                // Navigator.pushNamed(context, ContactsScreen.routeName);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${selectedDate.day.toString()}/${selectedDate.month.toString()}/${selectedDate.year.toString()}"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            RawMaterialButton(
                              shape: CircleBorder(),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorThemes.primary),
                                child: Icon(
                                  Icons.alarm,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _selectTime(context);
                                // Navigator.pushNamed(context, ContactsScreen.routeName);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${selectedTime.hour}:${selectedTime.minute}"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter a valid Email' : null,
                        controller: textController,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        onPressed: () {
                          print("selected date");
                          print(selectedDate);
                          print("selected time");
                          print(selectedTime);
                          //  toSendAt=DateTime.of(selectedDate,selectedTime);
                          _resetPasswordSubmit();
                          Navigator.of(context).pop();
                        },
                        color: ColorThemes.primary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              // fontWeight: FontWeight.w500,
                              // letterSpacing: 3,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        // onPressed: _submit,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // child: Column(
            //   // mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     HeadingWidget("Profile"),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         CircleAvatar(
            //           radius: 30.0,
            //           backgroundImage: NetworkImage(user['profile_pic']),
            //           backgroundColor: Colors.transparent,
            //         )
            //       ],
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
