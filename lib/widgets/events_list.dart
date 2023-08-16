import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventsList extends StatefulWidget {
  final List<EventModel> events;
  const EventsList({super.key, required this.events});
  @override
  _EventsListState createState() => _EventsListState();
}

// class _EventsListState extends State<EventsList> {
//   final TicketmasterApi _api = TicketmasterApi();
//   late List<EventModel> _events;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchEvents();
//   }

//   _fetchEvents() async {
//     List<dynamic> eventsData = await _api.fetchEvents(page: _currentPage);
//     List<EventModel> events =
//         eventsData.map((e) => EventModel.fromJson(e)).toList();
//     setState(() {
//       _events.addAll(events);
//       _currentPage++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: _events.length + 1,
//       itemBuilder: (context, index) {
//         if (index == _events.length) {
//           // Display a loading indicator at the end of the list
//           _fetchEvents();
//           return const CircularProgressIndicator();
//         }
//         return ListTile(
//           leading: Image.network(_events[index].imageUrl),
//           title: Text(_events[index].name),
//           subtitle: Text('${_events[index].startDate} '),
//           trailing: Icon(_events[index].isInWishlist
//               ? Icons.favorite
//               : Icons.favorite_border),
//         );
//       },
//     );
//   }
// }

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        print("EventsList rebuilt. IsLoading: ${eventProvider.isLoading}");
        if (eventProvider.isLoading) {
          return const CircularProgressIndicator();
        } else if (eventProvider.events.isEmpty) {
          return const Text('No events found');
        } else {
          return ListView.builder(
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              final event = eventProvider.events[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text(event.startDate),
              );
            },
          );
        }
      },
    );
  }
}
