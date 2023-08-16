import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/genre_filter.dart';
import '../providers/event_provider.dart';
import 'package:intl/intl.dart';
import '../widgets/search_bar.dart' as CustomWidgets;
import '../providers/genre_provider.dart';
import 'event_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the initial events and set them in the provider.
      Provider.of<EventProvider>(context, listen: false).fetchAllEvents();
      // Fetch genres when the HomePage widget is initialized.
      Provider.of<GenreProvider>(context, listen: false).fetchGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Events',
                      style: GoogleFonts.merriweather(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1.0, color: Colors.orange)),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomWidgets.SearchBar(
                            onSearch: (query) {
                              Provider.of<EventProvider>(context, listen: false)
                                  .fetchEventsByName(query);
                            },
                            onClearSearch: () {
                              Provider.of<EventProvider>(context, listen: false)
                                  .resetEvents();
                            },
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            '|',
                            style:
                                TextStyle(color: Colors.black26, fontSize: 33),
                          ),
                        ),
                        const Expanded(flex: 2, child: GenreFilter()),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<EventProvider>(
                  builder: (context, eventProvider, child) {
                    return ListView.builder(
                      itemCount: eventProvider.events.length,
                      itemBuilder: (context, index) {
                        final event = eventProvider.events[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(event.imageUrl,
                                      width: 80, height: 80, fit: BoxFit.cover),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(event.name),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month_outlined,
                                                color: Color(0xff8c8c8c),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                DateFormat('dd MMM yyyy')
                                                    .format(DateTime.parse(
                                                        event.startDate)),
                                                style: const TextStyle(
                                                    color: Color(0xff8c8c8c)),
                                              ),

                                              // Text('${event.startDate} - ${event.endDate}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsPage(event: event),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(event.isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                  onPressed: () {
                                    eventProvider.toggleWishlist(event.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
