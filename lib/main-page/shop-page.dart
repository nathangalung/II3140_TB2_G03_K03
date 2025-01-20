import 'package:flutter/material.dart';
import 'package:curiosityclash/theme.dart';
import 'package:curiosityclash/widgets/playerCard.dart';
import 'package:curiosityclash/widgets/shop-widget.dart';
import 'package:curiosityclash/services/api.dart';
import 'package:curiosityclash/models/UserModel.dart';
import 'package:curiosityclash/models/ItemModel.dart';

class ShopPage extends StatefulWidget {
  final String? sessionId;

  const ShopPage({super.key, this.sessionId});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<bool> purchasedShieldItems =
      List.generate(6, (_) => false); // For shield items
  List<bool> purchasedSwordItems =
      List.generate(6, (_) => false); // For sword items
  List<bool> purchasedBuffItems =
      List.generate(4, (_) => false); // For buff items

  Future<UserModel>? _userFuture;
  Future<List<ItemModel>>? _shieldItemsFuture;
  Future<List<ItemModel>>? _swordItemsFuture;
  Future<List<ItemModel>>? _buffItemsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _userFuture = ApiService().fetchUserById(widget.sessionId!);
      _shieldItemsFuture = ApiService().fetchItemsByType('shield');
      _swordItemsFuture = ApiService().fetchItemsByType('sword');
      _buffItemsFuture = ApiService().fetchItemsByType('buff');
    } else {
      _userFuture = Future.error('No session ID provided');
    }
  }

  // This function is called when an item is clicked
  void _onItemClicked(
      int index, List<ItemModel> items, List<bool> purchasedItems, int coins) {
    // Show confirmation dialog and handle purchase
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.primary,
          title: Text(
            'Confirm Purchase',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          content: Text(
            'Do you want to buy this item for ${items[index].value} coins?',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel purchase
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Proceed with purchase
                if (coins >= items[index].value) {
                  try {
                    await ApiService()
                        .purchaseItem(widget.sessionId!, items[index]);

                    setState(() {
                      coins -= items[index].value;
                      purchasedItems[index] =
                          true; // Update purchase status for the specific section
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Purchase successful!',
                          style: TextStyle(
                            color: AppTheme.darkTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                      ),
                    );
                  } catch (e) {
                    // Handle any errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: $e',
                          style: TextStyle(
                            color: AppTheme.darkTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                      ),
                    );
                  }
                } else {
                  // Show a message if not enough coins
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Not enough coins!',
                        style: TextStyle(
                          color: AppTheme.darkTheme.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var user = snapshot.data!;
          return _buildShopPage(context, user);
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildShopPage(BuildContext context, UserModel user) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg2Page.png',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              // Player Card
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: PlayerCard(sessionId: widget.sessionId),
              ),
              const SizedBox(height: 16),

              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleWidget(
                          titleImage: 'assets/img/shield/title-shield.png'),
                      FutureBuilder<List<ItemModel>>(
                        future: _shieldItemsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            var shieldItems = snapshot.data!;
                            return SectionContentWidget(
                              items: shieldItems,
                              coins: user.coins,
                              onItemClick: (index) => _onItemClicked(
                                  index,
                                  shieldItems,
                                  purchasedShieldItems,
                                  user.coins),
                              purchasedItems: purchasedShieldItems,
                            );
                          } else {
                            return Text('No items available');
                          }
                        },
                      ),

                      // Sword Section with 6 items
                      SectionTitleWidget(
                          titleImage: 'assets/img/title-sword.png'),
                      FutureBuilder<List<ItemModel>>(
                        future: _swordItemsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            var swordItems = snapshot.data!;
                            return SectionContentWidget(
                              items: swordItems,
                              coins: user.coins,
                              onItemClick: (index) => _onItemClicked(index,
                                  swordItems, purchasedSwordItems, user.coins),
                              purchasedItems: purchasedSwordItems,
                            );
                          } else {
                            return Text('No items available');
                          }
                        },
                      ),

                      // Buff Section with 4 items
                      SectionTitleWidget(
                          titleImage: 'assets/img/title-buff.png'),
                      FutureBuilder<List<ItemModel>>(
                        future: _buffItemsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            var buffItems = snapshot.data!;
                            return SectionContentWidget(
                              items: buffItems,
                              coins: user.coins,
                              onItemClick: (index) => _onItemClicked(index,
                                  buffItems, purchasedBuffItems, user.coins),
                              purchasedItems: purchasedBuffItems,
                            );
                          } else {
                            return Text('No items available');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),

          // Positioning the Coin Bar
          Positioned(
            top: 10,
            right: 10,
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/img/koin-bar.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Center(
                      child: Text(
                        user.coins.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 19,
                  right: -2,
                  child: GestureDetector(
                    onTap: () {
                      // Action for button "+"
                    },
                    child: const Icon(
                      Icons.add,
                      size: 23,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
