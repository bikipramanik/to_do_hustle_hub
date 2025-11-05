import 'package:flutter/material.dart';
import 'package:to_do_hustle_hub/models/section_model.dart';
import 'package:to_do_hustle_hub/screens/create_section_screen.dart';

class HorizontalBarWidget extends SliverPersistentHeaderDelegate {
  final List<SectionModel> sections;
  final int selectedIndex;
  final Function(int) changeSection;
  final Function(int) deleteSection;
  HorizontalBarWidget({
    required this.sections,
    required this.selectedIndex,
    required this.changeSection,
    required this.deleteSection,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color.fromARGB(255, 43, 43, 43),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length + 1,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          if (index < sections.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => changeSection(index),
                onLongPress: () {
                  index < 2
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("This Section can not be deleted"),
                            duration: Duration(seconds: 1),
                          ),
                        )
                      : showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Section"),
                              content: Text(
                                "Are you sure you want to delete\"${sections[index].sectionName}\" section?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),

                                TextButton(
                                  onPressed: () {
                                    deleteSection(index);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "\"${sections[index].sectionName}\" is deleted",
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple : Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sections[index].sectionName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateSectionScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 4, 151, 196),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Text(
                        "New List",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant HorizontalBarWidget oldDelegate) => true;
}
