import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietspots/models/place_model.dart';
import 'package:vietspots/providers/place_provider.dart';
import 'package:vietspots/screens/detail/place_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    // Initialize with all places
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
      setState(() {
        _filteredPlaces = placeProvider.places;
      });
    });
  }

  void _filterPlaces(String query) {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    final places = placeProvider.places;

    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = places;
      } else {
        _filteredPlaces = places.where((place) {
          return place.name.toLowerCase().contains(query.toLowerCase()) ||
              place.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search places...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            onChanged: _filterPlaces,
          ),
        ),
      ),
      body: Container(
        color: Colors.red[50],
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filteredPlaces.length,
          itemBuilder: (context, index) {
            final place = _filteredPlaces[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    place.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 40),
                  ),
                ),
                title: Text(
                  place.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  place.location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(place: place),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
