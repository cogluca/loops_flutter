import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';
import 'package:get/get.dart';

class SprintDialog extends GetView<ProjectOverviewController> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(
          bottom: 400, top: 140, left: 20, right: 20),
      child: Column(children: [
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Sprint start date',
              hintText: 'Enter sprint start date',
              border: OutlineInputBorder(),
            ),
            controller: controller.sprintStartDate,
            onTap: () async {

              DateTime projectWideStartDateConstraint = DateTime.parse(controller.projectStartDateConstraint);
              DateTime projectWideEndDateConstraint = DateTime.parse(controller.projectEndDateConstraint);


              String pickedMonth = '';
              DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: projectWideStartDateConstraint, lastDate: projectWideEndDateConstraint);
              pickedMonth = pickedDate!.month.toString();
              if(pickedMonth.length > 1) {
                controller.sprintStartDate.text =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
              }
              else{
                controller.sprintStartDate.text = '${pickedDate.year}-0${pickedDate.month}-${pickedDate.day}';
              }
            },
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Sprint end date',
              hintText: 'Enter sprint end date',
              border: OutlineInputBorder(),
            ),
            controller: controller.sprintEndDate,
            onTap: () async {
              String pickedMonth = '';
              DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2025));
              pickedMonth = pickedDate!.month.toString();
              if(pickedMonth.length > 1) {
                controller.sprintEndDate.text =
                '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
              }
              else{
                controller.sprintEndDate.text = '${pickedDate.year}-0${pickedDate.month}-${pickedDate.day}';
              }
            },
          ),
          padding: const EdgeInsets.all(8.0),
        ),
        Card(
          child: TextButton(
            child: const Text(
              'Start Sprint',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.startSprint();
              Navigator.pop(context);
            },
          ),
          color: Colors.blue,
        )
      ]),
    );
  }

}