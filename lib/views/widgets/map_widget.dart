import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/model/story.dart';

class MapWidget extends StatefulWidget {
  final Story story;

  const MapWidget({super.key, required this.story});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;

  // Default location (Dicoding office) as fallback
  final defaultLocation = const LatLng(-6.8957473, 107.6337669);

  LatLng get storyLocation {
    if (widget.story.lat != null && widget.story.lon != null) {
      return LatLng(widget.story.lat!, widget.story.lon!);
    }
    return defaultLocation;
  }

  @override
  void dispose() {
    if (mapController != null) {
      mapController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If story has no location data, show a message instead of map
    if (widget.story.lat == null || widget.story.lon == null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.noLocationData,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final storyLocation = LatLng(widget.story.lat!, widget.story.lon!);

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: storyLocation,
          zoom: 15.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('story_location'),
            position: storyLocation,
            infoWindow: InfoWindow(
              title:
                  widget.story.name ??
                  AppLocalizations.of(context)!.storyLocation,
              snippet: 'Lat: ${widget.story.lat}, Lon: ${widget.story.lon}',
            ),
          ),
        },
      ),
    );
  }
}
