import 'package:flutter/material.dart';
import 'package:curiosityclash/theme.dart';
import 'package:curiosityclash/models/ItemModel.dart';

import '../models/ItemModel.dart';

class SectionTitleWidget extends StatelessWidget {
  final String titleImage;

  const SectionTitleWidget({required this.titleImage, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Image.asset(
        titleImage,
        fit: BoxFit.contain,
      ),
    );
  }
}

// SectionContentWidget for displaying items in each section
class SectionContentWidget extends StatelessWidget {
  final List<ItemModel> items;
  final int coins;
  final Function(int) onItemClick;
  final List<bool> purchasedItems;

  const SectionContentWidget({
    required this.items,
    required this.coins,
    required this.onItemClick,
    required this.purchasedItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    final theme = Theme.of(context); // Access theme

    // Create rows of 3 items each
    for (int i = 0; i < items.length; i += 3) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.skip(i).take(3).map((item) {
            int index = items.indexOf(item);
            return GestureDetector(
              onTap: purchasedItems[index] ? null : () => onItemClick(index), // Disable tap if purchased
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding for spacing
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        color: purchasedItems[index]
                            ? AppTheme.lightTheme.colorScheme.primary // Background when purchased
                            : AppTheme.lightTheme.primaryColor, // Default background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 2.0,
                                  color: theme.primaryColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                item.title,
                                width: 80,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                item.image,
                                width: 80,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: const Color.fromARGB(255, 127, 117, 25), // Set icon color to gold
                                ),
                                SizedBox(width: 5),
                                Text(
                                  purchasedItems[index]
                                      ? '✔' // Display checkmark if purchased
                                      : '${item.value}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: purchasedItems[index]
                                        ? AppTheme.lightTheme.colorScheme.surface // Text color when purchased (light theme)
                                        : AppTheme.darkTheme.colorScheme.primary, // Text color when not purchased (dark theme)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      children: rows,
    );
  }
}