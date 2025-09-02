import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddMapWidget extends StatefulWidget {
  const AddMapWidget({super.key});

  @override
  State<AddMapWidget> createState() => _AddMapWidgetState();
}

class _AddMapWidgetState extends State<AddMapWidget> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;
  late final Set<Marker> markers = {};

  geo.Placemark? placemark;

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 18,
              target: dicodingOffice,
            ),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              final info = await geo.placemarkFromCoordinates(
                dicodingOffice.latitude,
                dicodingOffice.longitude,
              );
              final place = info[0];
              final street = place.street!;
              final address =
                  '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
              setState(() {
                placemark = place;
              });
              defineMarker(dicodingOffice, street, address);
              setState(() {
                mapController = controller;
              });
            },
            onLongPress: (LatLng latLng) {
              onLongPressGoogleMap(latLng);
            },
            myLocationEnabled: true,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                onMyLocationButtonPress();
              },
            ),
          ),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: PlacemarkWidget(placemark: placemark!),
            ),
        ],
      ),
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({super.key, required this.placemark});
  final geo.Placemark placemark;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
