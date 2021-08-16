import 'package:flutter/material.dart';
import 'package:mobilelabelimg/widgets/polygon.dart';
import 'package:mobilelabelimg/widgets/polygon_provider.dart';
import 'package:provider/provider.dart';

class PolygonWorkboard extends StatelessWidget {
  const PolygonWorkboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: Scaffold(
          body: PolygonDemo(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => DrawingProvicer()),
          ChangeNotifierProvider(create: (_) => MovePolygonProvider()),
          // ChangeNotifierProvider(create: (_) => AddOrRemovePolygonProvider()),
        ]);
  }
}
