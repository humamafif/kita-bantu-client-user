import 'package:donasiinapp/model/program/program_model.dart';
import 'package:flutter/material.dart';

class ProgramGrid extends StatefulWidget {
  final List<ProgramModel> programs;

  ProgramGrid({required this.programs});

  @override
  _ProgramGridState createState() => _ProgramGridState();
}

class _ProgramGridState extends State<ProgramGrid> {
  late List<bool> _isHoveredList;

  @override
  void initState() {
    super.initState();
    _initializeHoveredList();
  }

  @override
  void didUpdateWidget(covariant ProgramGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.programs.length != widget.programs.length) {
      _initializeHoveredList();
    }
  }

  void _initializeHoveredList() {
    _isHoveredList = List<bool>.filled(widget.programs.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth < 600) {
      crossAxisCount = 1;
      childAspectRatio = 1.2;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
      childAspectRatio = 1.5;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 1.6;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.programs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final program = widget.programs[index];
        return MouseRegion(
          onEnter: (_) => setState(() => _isHoveredList[index] = true),
          onExit: (_) => setState(() => _isHoveredList[index] = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(program.image),
                fit: BoxFit.cover,
                colorFilter: _isHoveredList[index]
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.darken)
                    : null,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isHoveredList[index] ? 120 : 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Goal Amount: ${program.goalAmount}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Dana terkumpul: ${program.danaTerkumpul}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              program.status,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
