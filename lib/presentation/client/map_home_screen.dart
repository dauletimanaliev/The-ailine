

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gghgggfsfs/presentation/client/_mapView.dart';
import 'map_bloc.dart';
import 'package:gghgggfsfs/presentation/client/location.dart';

class MapHomeScreen extends StatelessWidget {
  const MapHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(LocationService()),
      child: Scaffold(
        body: MapView(),
      ),
    );
  }
}