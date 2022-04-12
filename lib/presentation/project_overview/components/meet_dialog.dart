import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';

class MeetDialog extends GetView<ProjectOverviewController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(shrinkWrap: true, children: [
        Container(
          alignment: Alignment.center,
          child: const Text(
            'Meet',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          child: Obx(() => DropdownButton<String>(
                value: controller.meetingType.value,
                onChanged: (String? newValue) {
                  controller.meetingType.value = newValue!;
                },
                items: <String>[
                  'Sprint Planning',
                  'Sprint Retrospective',
                  'Daily Meet',
                  'One-To-One',
                ]
                    .map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        ))
                    .toList(),
              )),
          padding: const EdgeInsets.only(left: 20.0, top: 20),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'What date does the meeting happen ?',
              hintText: 'yyyy/mm/dd',
              border: OutlineInputBorder(),
            ),
            controller: controller.meetingDate,
            onTap: () async {
              String pickedMonth = '';
              String pickedDay = '';
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.utc(2050));
              pickedMonth = pickedDate!.month.toString();
              pickedDay = pickedDate!.day.toString();
              if (pickedMonth.length > 1) {
                controller.meetingDate.text =
                    '${pickedDate.year}-${pickedDate.month}-';
              } else {
                controller.meetingDate.text =
                    '${pickedDate.year}-0${pickedDate.month}-';
              }
              if(pickedDay.length > 1){
                controller.meetingDate.text += '${pickedDate.day}';
              }
              else{
                controller.meetingDate.text += '0${pickedDate.day}';
              }
            },
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'When will the meeting start ?',
              hintText: 'e.g 14:30',
              border: OutlineInputBorder(),
            ),
            controller: controller.meetingStartTime,
            onTap: () async {
              TimeOfDay timenow = TimeOfDay.now();
              String hourOfTimePicked = '';
              String minuteOfTimePicked = '';
              TimeOfDay? timePicked =
                  await showTimePicker(context: context, initialTime: timenow);
              hourOfTimePicked = timePicked!.hour.toString();
              minuteOfTimePicked = timePicked.minute.toString();
              if (hourOfTimePicked.length > 1) {
                controller.meetingStartTime.text =
                    '${timePicked.hour}:';
              } else {
                controller.meetingStartTime.text =
                    '0${timePicked.hour}:';
              }
              if(minuteOfTimePicked.length > 1){
                controller.meetingStartTime.text += minuteOfTimePicked;
              }
              else{
                controller.meetingStartTime.text += '0$minuteOfTimePicked';
              }

            },
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'When will the meeting end ?',
              hintText: 'e.g 15:00',
              border: OutlineInputBorder(),
            ),
            controller: controller.meetingEndTime,
            onTap: () async {
              TimeOfDay timenow = TimeOfDay.now();
              String hourOfTimePicked = '';
              String minuteOfTimePicked = '';
              TimeOfDay? timePicked =
              await showTimePicker(context: context, initialTime: timenow);
              hourOfTimePicked = timePicked!.hour.toString();
              minuteOfTimePicked = timePicked.minute.toString();
              if (hourOfTimePicked.length > 1) {
                controller.meetingEndTime.text =
                '${timePicked.hour}:';
              } else {
                controller.meetingEndTime.text =
                '0${timePicked.hour}:';
              }
              if(minuteOfTimePicked.length > 1){
                controller.meetingEndTime.text += minuteOfTimePicked;
              }
              else{
                controller.meetingEndTime.text += '0$minuteOfTimePicked';
              }

            },
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Who will participate ?',
              hintText: 'List the emails with a ;',
              border: OutlineInputBorder(),
            ),
            controller: controller.emailsOnForm,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Event Description',
              hintText: 'Brief summary of event',
              border: OutlineInputBorder(),
            ),
            controller: controller.meetingDescription,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'On Google meet ? remote',
              border: OutlineInputBorder(),
            ),
            controller: controller.locationOfMeeting,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: Obx(() => Center(
                  child: SwitchListTile(
                onChanged: (bool value) {
                  controller.conferenceSupportState.value = value;
                },
                value: controller.conferenceSupportState.value,
                title: const Text('Google Meet'),
              ))),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: Obx(() => Center(
                  child: SwitchListTile(
                onChanged: (bool value) {
                  controller.notifyAttendantsState.value = value;
                },
                value: controller.notifyAttendantsState.value,
                title: const Text('Notify attendants'),
              ))),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextButton(
            child: const Text('Invite'),
            onPressed: () {
              controller.sendGoogleMeetInvite();
              Navigator.of(context).pop();
              Get.snackbar('Mission accomplished',
                  'Invite sent correctly, check calendar your calendar for the event info');
            },
          ),
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
        ),
      ]),
    );
  }
}
