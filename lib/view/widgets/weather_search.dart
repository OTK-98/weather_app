// import 'package:flutter/material.dart';

// class WeatherSearch extends StatefulWidget {
//   final Function(String) onCitySelected;

//   const WeatherSearch({Key? key, required this.onCitySelected})
//       : super(key: key);

//   @override
//   _WeatherSearchState createState() => _WeatherSearchState();
// }

// class _WeatherSearchState extends State<WeatherSearch> {
//   final TextEditingController _controller = TextEditingController();
//   List<String> _citySuggestions = [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Autocomplete<String>(
//           optionsBuilder: (TextEditingValue textEditingValue) async {
//             // Fetch city suggestions based on the text input
//             return _citySuggestions;
//           },
//           onSelected: (String selection) {
//             widget.onCitySelected(selection);
//           },
//           fieldViewBuilder: (BuildContext context,
//               TextEditingController fieldTextEditingController,
//               FocusNode fieldFocusNode,
//               VoidCallback onFieldSubmitted) {
//             return TextField(
//               controller: fieldTextEditingController,
//               focusNode: fieldFocusNode,
//               decoration: InputDecoration(
//                 labelText: 'Enter City Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.1),
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//               ),
//               style: const TextStyle(color: Colors.white),
//               onChanged: (value) {
//                 // Fetch city suggestions when the text changes
//                 fetchCitySuggestions(value);
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> fetchCitySuggestions(String query) async {
//     // Simulated city suggestions; replace with actual implementation
//     setState(() {
//       _citySuggestions = [
//         'New York',
//         'Los Angeles',
//         'Chicago'
//       ]; // Example suggestions
//     });
//   }
// }
