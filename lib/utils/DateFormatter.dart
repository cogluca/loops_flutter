
import 'package:googleapis/composer/v1.dart';
import 'package:loops/error_handling/Failure.dart';

class DateFormatter {


  static String fromDateTimeToIntendedFormat(DateTime pickedDate){


    String pickedMonth = pickedDate!.month.toString();
    String pickedDay = pickedDate!.day.toString();

    if(pickedMonth.length > 1 && pickedDay.length > 1) {
      return '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
    }

    if(pickedMonth.length > 1 && !(pickedDay.length > 1)){
      return '${pickedDate.year}-${pickedDate.month}-0${pickedDate.day}';
    }

    if(!(pickedMonth.length > 1) && pickedDay.length > 1){
      return '${pickedDate.year}-0${pickedDate.month}-${pickedDate.day}';
    }

    if(!(pickedMonth.length > 1) && !(pickedDay.length > 1)){
      return'${pickedDate.year}-0${pickedDate.month}-0${pickedDate.day}';
    }
    else{
      throw Failure('BAD DATE Exception encountered');
    }





  }









}