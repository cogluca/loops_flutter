import 'package:flutter/cupertino.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

class CalendarClient {
  cal.CalendarApi calendar;

   CalendarClient({required this.calendar});


   ///Creates an Event object with the function parameters, specifies according to [hasConferenceSupport] the Conference Request, specifies the timing and subsequently inserts the event
  ///on the attendees' calendar with relative links to Google Meet if [hasConferenceSupport] is present as true
  Future<Map<String, String>> insert({
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    required bool hasConferenceSupport,
    required DateTime startTime,
    required DateTime endTime,
  }) async {

    late Map<String, String> eventData;

    String calendarId = "primary";
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    if (hasConferenceSupport) {
      ConferenceData conferenceData = ConferenceData();
      CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId =
          "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    EventDateTime start = EventDateTime(dateTime: startTime);
    start.dateTime = startTime;
    start.timeZone = "GMT+2";
    event.start = start;

    EventDateTime end = EventDateTime(dateTime: endTime);
    end.timeZone = "GMT+2";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar.events
          .insert(event, calendarId,
              conferenceDataVersion: hasConferenceSupport ? 1 : 0,
              sendUpdates: shouldNotifyAttendees ? "all" : "none")
          .then((value) {
        print("Event Status: ${value.status}");
        if (value.status == "confirmed") {
          String joiningLink;
          String eventId;

          eventId = value.id!;

          joiningLink = "https://meet.google.com/${value.conferenceData?.conferenceId}";

          eventData = {'id': eventId, 'link': joiningLink};

          print('Event added to Google Calendar');
        } else {
          print("Unable to add event to Google Calendar");
        }
      });
    } catch (e) {
      print('Error creating event $e');
    }

    return eventData;
  }
}
