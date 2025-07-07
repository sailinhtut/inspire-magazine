import 'package:flutter/material.dart';
import 'package:inspired_blog/entertainment/model/entertainment.dart';

class SeriesDetailScreen extends StatefulWidget {
  const SeriesDetailScreen({super.key, required this.series});

  final Series series;

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.series.name ?? "Series"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            
            ],
          ),
        ));
  }
}
