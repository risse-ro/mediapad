import 'package:flutter/material.dart';

class DashboardItemSummary extends StatefulWidget {
  const DashboardItemSummary({
    super.key,
    required this.mediaType,
    required this.amount,
    this.imageUrl,
  });

  final int amount;
  final String mediaType;
  final String? imageUrl;

  @override
  State<DashboardItemSummary> createState() => _DashboardItemSummaryState();
}

class _DashboardItemSummaryState extends State<DashboardItemSummary> {
  @override
  Widget build(BuildContext context) {
    var mediaString = widget.amount == 1
        ? widget.mediaType.substring(0, widget.mediaType.length - 1)
        : widget.mediaType;
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.imageUrl != null) Image.asset('${widget.imageUrl}'),
        Text(
          "You've read ${widget.amount} ${mediaString.toLowerCase()}",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
