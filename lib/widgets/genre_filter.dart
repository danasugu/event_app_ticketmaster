import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/genre_provider.dart';

import '../providers/event_provider.dart';

class GenreFilter extends StatefulWidget {
  const GenreFilter({super.key});

  @override
  _GenreFilterState createState() => _GenreFilterState();
}

class _GenreFilterState extends State<GenreFilter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GenreProvider>(
      builder: (context, genreProvider, child) {
        return PopupMenuButton<String>(
          onSelected: (genre) {
            genreProvider.toggleGenreSelection(genre);
            Provider.of<EventProvider>(context, listen: false)
                .fetchEventsByGenres(genreProvider.selectedGenres);
          },
          itemBuilder: (BuildContext context) {
            return genreProvider.genres.map((String genre) {
              return CheckedPopupMenuItem<String>(
                value: genre,
                checked: genreProvider.isGenreSelected(genre),
                child: Text(genre),
              );
            }).toList();
          },
          child: const Row(
            children: [
              Text('All genres'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        );
      },
    );
  }
}

// class _GenreFilterState extends State<GenreFilter> {
//   // late List<String> selectedGenres;
//   List<String> selectedGenres = [];
//   @override
//   void initState() {
//     super.initState();
//     selectedGenres = [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final genreProvider = Provider.of<GenreProvider>(context);
//     final genres = genreProvider.genres;

//     return PopupMenuButton(
//       onSelected: (genre) {
//         genreProvider.toggleGenreSelection(genre);
//         context
//             .read<EventProvider>()
//             .fetchEventsByGenres(genreProvider.selectedGenres);
//       },
//       itemBuilder: (BuildContext context) {
//         return genres.map((genre) {
//           return PopupMenuItem(
//             value: genre,
//             child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return CheckboxListTile(
//                     title: Text(genre),
//                     value: genreProvider.isGenreSelected(genre),
//                     onChanged: (bool? value) {
//                       genreProvider.toggleGenreSelection(genre);
//                       context
//                           .read<EventProvider>()
//                           .fetchEventsByGenres(genreProvider.selectedGenres);
//                     }

//                     // onChanged: (bool? isChecked) {
//                     //   if (isChecked != null) {
//                     //     if (isChecked) {
//                     //       selectedGenres.add(genre);
//                     //     } else {
//                     //       selectedGenres.remove(genre);
//                     //     }
//                     //     setState(() {}); // Rebuild this specific menu item.
//                     //     Provider.of<EventProvider>(context, listen: false)
//                     //         .filterEventsByGenres(selectedGenres);
//                     //   }
//                     // },
//                     );
//               },
//             ),
//             onTap: () {
//               if (selectedGenres.contains(genre)) {
//                 selectedGenres.remove(genre);
//               } else {
//                 selectedGenres.add(genre);
//               }
//               Provider.of<EventProvider>(context, listen: false)
//                   .filterEventsByGenres(selectedGenres);
//               setState(() {});
//             },
//           );
//         }).toList();
//       },
//       child: const Row(
//         children: [
//           Text('Filter by genre'),
//           Icon(Icons.arrow_drop_down),
//         ],
//       ),
//     );
//   }
// }
