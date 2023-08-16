import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClearSearch;
  const SearchBar({Key? key, this.onSearch, this.onClearSearch})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set up a listener for the controller
    _controller.addListener(() {
      if (widget.onSearch != null && _controller.text.isEmpty) {
        widget.onSearch!(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (text) {
                  if (widget.onSearch != null) {
                    widget.onSearch!(text);
                  }
                },
                // controller: _controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.orange,
                  ),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  if (widget.onClearSearch != null) {
                    widget.onClearSearch!();
                  }
                },
              ),
            // IconButton(
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     if (widget.onSearch != null) {
            //       widget.onSearch!(_controller.text);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


 

// class SearchBar extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();
//   final Function(String)? onSearch;
//   final BuildContext parentContext;

//   SearchBar({Key? key, this.onSearch, required this.parentContext})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final eventProvider = Provider.of<EventProvider>(context, listen: false);

//     return TextField(
//       controller: _controller,
//       decoration: InputDecoration(
//         border: InputBorder.none,
//         hintText: 'Search',
//         hintStyle: const TextStyle(fontSize: 20),
//         suffixIcon: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(
//                 Icons.clear,
//                 color: Colors.orange,
//               ),
//               onPressed: () {
//                 // _controller.clear();
//                 onSearch!(''); // fetch all events when cleared
//               },
//             ),
//           ],
//         ),
//         prefixIcon: IconButton(
//           icon: const Icon(
//             Icons.search_sharp,
//             color: Colors.orange,
//             size: 33,
//           ),
//           onPressed: () {
//             FocusScope.of(parentContext).unfocus();
//             final eventProvider =
//                 Provider.of<EventProvider>(parentContext, listen: false);
//             eventProvider.filterEventsByName(_controller.text);
//           },
      
//         ),
//       ),
//     );
//   }
// }
