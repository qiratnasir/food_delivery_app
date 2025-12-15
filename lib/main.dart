// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<CartItem> cart = [];
  Set<int> favorites = {};

  final List<Restaurant> restaurants = [
    Restaurant(
      id: 1,
      name: 'Pizza Paradise',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      rating: 4.5,
      deliveryTime: '25-35',
      cuisine: 'Italian, Fast Food',
      minOrder: 300,
      deliveryFee: 50,
      discount: '20% OFF',
      items: [
        MenuItem(id: 101, name: 'Margherita Pizza', price: 599, category: 'Pizza', image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=200'),
        MenuItem(id: 102, name: 'Pepperoni Special', price: 799, category: 'Pizza', image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=200'),
        MenuItem(id: 103, name: 'Garlic Bread', price: 199, category: 'Sides', image: 'https://images.unsplash.com/photo-1573140401552-3fab0b24f2de?w=200'),
      ],
    ),
    Restaurant(
      id: 2,
      name: 'Biryani House',
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400',
      rating: 4.7,
      deliveryTime: '30-40',
      cuisine: 'Pakistani, Desi',
      minOrder: 400,
      deliveryFee: 60,
      discount: '15% OFF',
      items: [
        MenuItem(id: 201, name: 'Chicken Biryani', price: 450, category: 'Main', image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200'),
        MenuItem(id: 202, name: 'Mutton Karahi', price: 850, category: 'Main', image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200'),
      ],
    ),
    Restaurant(
      id: 3,
      name: 'Burger Hub',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      rating: 4.3,
      deliveryTime: '20-30',
      cuisine: 'Fast Food, American',
      minOrder: 250,
      deliveryFee: 40,
      discount: '25% OFF',
      items: [
        MenuItem(id: 301, name: 'Classic Beef Burger', price: 399, category: 'Burgers', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200'),
        MenuItem(id: 302, name: 'Chicken Burger', price: 350, category: 'Burgers', image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=200'),
      ],
    ),
  ];

  void addToCart(MenuItem item, Restaurant restaurant) {
    setState(() {
      final existingIndex = cart.indexWhere((c) => c.item.id == item.id);
      if (existingIndex != -1) {
        cart[existingIndex].quantity++;
      } else {
        cart.add(CartItem(item: item, quantity: 1, restaurant: restaurant));
      }
    });
  }

  void removeFromCart(int itemId) {
    setState(() {
      final index = cart.indexWhere((c) => c.item.id == itemId);
      if (index != -1) {
        if (cart[index].quantity > 1) {
          cart[index].quantity--;
        } else {
          cart.removeAt(index);
        }
      }
    });
  }

  void toggleFavorite(int restaurantId) {
    setState(() {
      if (favorites.contains(restaurantId)) {
        favorites.remove(restaurantId);
      } else {
        favorites.add(restaurantId);
      }
    });
  }

  double getCartTotal() {
    double subtotal = cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
    double deliveryFee = cart.isNotEmpty ? cart[0].restaurant.deliveryFee.toDouble() : 0;
    return subtotal + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showCartBottomSheet(context),
              icon: Icon(Icons.shopping_cart),
              label: Text('${cart.length} Items - Rs ${getCartTotal().toInt()}'),
              backgroundColor: Colors.orange,
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deliver to', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('Home - Karachi, DHA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () => _showCartBottomSheet(context),
                  ),
                  if (cart.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text('${cart.length}', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for restaurants or dishes',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        _buildCategories(),
        _buildOfferBanner(),
        _buildRestaurantsList(),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Pizza', 'icon': '🍕'},
      {'name': 'Burger', 'icon': '🍔'},
      {'name': 'Biryani', 'icon': '🍛'},
      {'name': 'Chinese', 'icon': '🥡'},
      {'name': 'Dessert', 'icon': '🍰'},
      {'name': 'Drinks', 'icon': '🥤'},
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(categories[index]['icon']!, style: TextStyle(fontSize: 28))),
                      ),
                      SizedBox(height: 4),
                      Text(categories[index]['name']!, style: TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Special Offers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          Text('Get up to 50% off on selected restaurants', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Restaurants Near You', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 12),
          ...restaurants.map((restaurant) => _buildRestaurantCard(restaurant)).toList(),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurant: restaurant,
              onAddToCart: addToCart,
              onToggleFavorite: toggleFavorite,
              isFavorite: favorites.contains(restaurant.id),
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(restaurant.image, height: 160, width: double.infinity, fit: BoxFit.cover),
                ),
                if (restaurant.discount != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: Text(restaurant.discount!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(restaurant.id),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        favorites.contains(restaurant.id) ? Icons.favorite : Icons.favorite_border,
                        color: favorites.contains(restaurant.id) ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(restaurant.cuisine, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('${restaurant.rating}', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${restaurant.deliveryTime} min', style: TextStyle(fontSize: 12)),
                      Spacer(),
                      Text('Min Rs ${restaurant.minOrder}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          double subtotal = cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
          double deliveryFee = cart.isNotEmpty ? cart[0].restaurant.deliveryFee.toDouble() : 0;
          double total = subtotal + deliveryFee;

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text('Your Cart (${cart.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Spacer(),
                      IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: cart.isEmpty
                      ? Center(child: Text('Your cart is empty'))
                      : ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final cartItem = cart[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(cartItem.item.image, width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              title: Text(cartItem.item.name),
                              subtitle: Text('Rs ${cartItem.item.price}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      removeFromCart(cartItem.item.id);
                                      setModalState(() {});
                                      setState(() {});
                                    },
                                  ),
                                  Text('${cartItem.quantity}'),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, color: Colors.orange),
                                    onPressed: () {
                                      addToCart(cartItem.item, cartItem.restaurant);
                                      setModalState(() {});
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                if (cart.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[100]),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal'), Text('Rs ${subtotal.toInt()}')]),
                        SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Delivery Fee'), Text('Rs ${deliveryFee.toInt()}')]),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('Rs ${total.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order Placed Successfully!')),
                              );
                            },
                            child: Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Restaurant Detail Screen
class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final Function(MenuItem, Restaurant) onAddToCart;
  final Function(int) onToggleFavorite;
  final bool isFavorite;

  RestaurantDetailScreen({
    required this.restaurant,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(restaurant.image, fit: BoxFit.cover),
            ),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white),
                onPressed: () => onToggleFavorite(restaurant.id),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(restaurant.cuisine, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('${restaurant.rating}', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${restaurant.deliveryTime} min'),
                      SizedBox(width: 16),
                      Icon(Icons.delivery_dining, size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Rs ${restaurant.deliveryFee}'),
                    ],
                  ),
                  if (restaurant.discount != null) ...[
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                      child: Text(restaurant.discount!, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  ],
                  SizedBox(height: 24),
                  Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  ...restaurant.items.map((item) => Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(item.image, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.category} • Rs ${item.price}'),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            onPressed: () {
                              onAddToCart(item, restaurant);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${item.name} added to cart'), duration: Duration(seconds: 1)),
                              );
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class Restaurant {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String deliveryTime;
  final String cuisine;
  final int minOrder;
  final int deliveryFee;
  final String? discount;
  final List<MenuItem> items;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.cuisine,
    required this.minOrder,
    required this.deliveryFee,
    this.discount,
    required this.items,
  });
}

class MenuItem {
  final int id;
  final String name;
  final int price;
  final String category;
  final String image;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;
  final Restaurant restaurant;

  CartItem({
    required this.item,
    required this.quantity,
    required this.restaurant,
  });
}