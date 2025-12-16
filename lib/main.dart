import 'package:flutter/material.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

// --- CONSTANTS (GRADIENT COLORS) ---
const Color kColorOrange = Color(0xFFFF512F);
const Color kColorPink = Color(0xFFDD2476);
const LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kColorOrange, kColorPink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ---------------- MODELS ----------------
class Restaurant {
  final int id;
  final String name;
  final String category;
  final String image;
  final double rating;
  final String deliveryTime;
  final int deliveryFee;
  final String? discount;
  final List<MenuItem> items;

  Restaurant({
    required this.id, required this.name, required this.category, required this.image,
    required this.rating, required this.deliveryTime, required this.deliveryFee,
    this.discount, required this.items,
  });
}

class MenuItem {
  final String name;
  final int price;
  final String desc;
  final String image;

  MenuItem({required this.name, required this.price, required this.desc, required this.image});
}

class CartItem {
  final MenuItem item;
  int quantity;
  final Restaurant restaurant;
  CartItem({required this.item, required this.quantity, required this.restaurant});
}

class OrderModel {
  final String orderId;
  final String restaurantName;
  final double totalAmount;
  final String status;
  final int itemCount;

  OrderModel({required this.orderId, required this.restaurantName, required this.totalAmount, required this.status, required this.itemCount, required DateTime time});
}

// ---------------- APP WIDGET ----------------
class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Primary Swatch ko hatakar custom colors use karenge
        primaryColor: kColorOrange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// ---------------- CUSTOM GRADIENT BUTTON (New Addition) ----------------
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const GradientButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: kPrimaryGradient, // Buttons par Gradient apply kiya
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: kColorPink.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

// ---------------- IMAGE HELPER ----------------
class NetworkImageFixed extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const NetworkImageFixed(this.imageUrl, {super.key, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl, width: width, height: height, fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width, height: height, color: Colors.grey[300],
          child: const Icon(Icons.restaurant, color: Colors.grey, size: 30),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width, height: height, color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null, color: kColorPink)),
        );
      },
    );
  }
}

// ---------------- MAIN SCREEN ----------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<CartItem> cart = [];
  Set<int> favoriteIds = {};
  List<OrderModel> myOrders = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // User Data
  final String userName = "Qirat Nasir";
  final String userPhone = "03173712789";
  final String userAddress = "House 123, DHA Phase 6, Karachi";

  // ---------------- FULL RESTAURANT DATA ----------------
  final List<Restaurant> allRestaurants = [
    // === BURGERS ===
    Restaurant(
      id: 1, name: 'Burger Lab', category: 'Burger', 
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500', 
      rating: 4.5, deliveryTime: '35-45', deliveryFee: 99, discount: '20% OFF',
      items: [
        MenuItem(name: 'The Boss', price: 1150, desc: 'Quadra patty beef stack', image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200'),
        MenuItem(name: 'Big Bang', price: 850, desc: 'Classic double beef', image: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=200'),
        MenuItem(name: 'Dynamite', price: 650, desc: 'Spicy crispy chicken', image: 'https://images.unsplash.com/photo-1619250907718-202d6b245d80?w=200'),
      ]
    ),
    Restaurant(
      id: 2, name: 'Ranchers', category: 'Burger', 
      image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=500', 
      rating: 4.3, deliveryTime: '30-40', deliveryFee: 50,
      items: [
        MenuItem(name: 'Cowboy Burger', price: 699, desc: 'BBQ sauce special', image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=200'),
        MenuItem(name: 'Mighty Rancher', price: 899, desc: 'Double fillet crunch', image: 'https://images.unsplash.com/photo-1596626726549-b1f2e99a3f3e?w=200'),
        MenuItem(name: 'Big Ben', price: 750, desc: 'Crispy thigh fillet', image: 'https://images.unsplash.com/photo-1610440042657-612c34d95e9f?w=200'),
      ]
    ),
    Restaurant(
      id: 3, name: 'KFC', category: 'Burger', 
      image: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=500', 
      rating: 4.7, deliveryTime: '25-35', deliveryFee: 100, discount: 'Free Delivery',
      items: [
        MenuItem(name: 'Zinger Burger', price: 590, desc: 'Original crispy burger', image: 'https://images.unsplash.com/photo-1513639776629-7b611594e29b?w=200'),
        MenuItem(name: 'Twister', price: 450, desc: 'Chicken wrap', image: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=200'),
        MenuItem(name: 'Hot Wings', price: 390, desc: '6 pcs spicy wings', image: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=200'),
      ]
    ),
    Restaurant(
      id: 4, name: 'McDonalds', category: 'Burger', 
      image: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=500', 
      rating: 4.6, deliveryTime: '20-30', deliveryFee: 120,
      items: [
        MenuItem(name: 'Big Mac', price: 750, desc: 'Two beef patties', image: 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d?w=200'),
        MenuItem(name: 'McChicken', price: 450, desc: 'Classic chicken burger', image: 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=200'),
        MenuItem(name: 'McFlurry', price: 350, desc: 'Oreo ice cream', image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200'),
      ]
    ),

    // === DESI ===
    Restaurant(
      id: 17, name: 'Kolachi', category: 'Desi', 
      image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=500', 
      rating: 4.9, deliveryTime: '45-60', deliveryFee: 150, discount: 'Premium',
      items: [
        MenuItem(name: 'Mutton Karahi', price: 2200, desc: 'Half kg special', image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200'),
        MenuItem(name: 'Malai Boti', price: 950, desc: 'Melt in mouth skewers', image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=200'),
        MenuItem(name: 'Garlic Naan', price: 120, desc: 'Butter garlic naan', image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=200'),
      ]
    ),
    Restaurant(
      id: 18, name: 'Hot N Spicy', category: 'Desi', 
      image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500', 
      rating: 4.6, deliveryTime: '30-40', deliveryFee: 80,
      items: [
        MenuItem(name: 'Chicken Biryani', price: 450, desc: 'Spicy Sindhi biryani', image: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200'),
        MenuItem(name: 'Seekh Kabab', price: 600, desc: 'Beef kabab 4 pcs', image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=200'),
        MenuItem(name: 'Zinger Roll', price: 400, desc: 'Crispy chicken roll', image: 'https://images.unsplash.com/photo-1513639776629-7b611594e29b?w=200'),
      ]
    ),
    Restaurant(
      id: 19, name: 'Javed Nihari', category: 'Desi', 
      image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500', 
      rating: 4.8, deliveryTime: '20-30', deliveryFee: 50,
      items: [
        MenuItem(name: 'Beef Nihari', price: 800, desc: 'Special nalli nihari', image: 'https://images.unsplash.com/photo-1547592166-23acbe3a624b?w=200'),
        MenuItem(name: 'Maghaz Masala', price: 900, desc: 'Fry brain masala', image: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=200'),
        MenuItem(name: 'Khameeri Roti', price: 60, desc: 'Soft tandoori roti', image: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=200'),
      ]
    ),
    Restaurant(
      id: 20, name: 'BBQ Tonight', category: 'Desi', 
      image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500', 
      rating: 4.7, deliveryTime: '40-50', deliveryFee: 100,
      items: [
        MenuItem(name: 'Mutton Ribs', price: 2500, desc: 'Grilled chops', image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=200'),
        MenuItem(name: 'Reshmi Kabab', price: 900, desc: 'Creamy chicken kabab', image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=200'),
      ]
    ),

    // === PIZZA ===
    Restaurant(
      id: 9, name: 'Cheezious', category: 'Pizza', 
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500', 
      rating: 4.9, deliveryTime: '45-55', deliveryFee: 99, discount: 'Flash Deal',
      items: [
        MenuItem(name: 'Crown Crust', price: 1600, desc: 'Kabab stuffed edges', image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200'),
        MenuItem(name: 'Chicken Tikka', price: 1300, desc: 'Desi flavor', image: 'https://images.unsplash.com/photo-1571407970349-bc16b4774309?w=200'),
        MenuItem(name: 'Pepperoni', price: 1400, desc: 'Beef pepperoni slices', image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=200'),
      ]
    ),
    Restaurant(
      id: 10, name: 'Broadway Pizza', category: 'Pizza', 
      image: 'https://images.unsplash.com/photo-1590947132387-155cc02f3212?w=500', 
      rating: 4.4, deliveryTime: '40-50', deliveryFee: 70,
      items: [
        MenuItem(name: 'Wicked Blend', price: 1500, desc: 'Spicy ranch sauce', image: 'https://images.unsplash.com/photo-1590947132387-155cc02f3212?w=200'),
        MenuItem(name: 'Dancing Fajita', price: 1400, desc: 'Smoky chicken', image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200'),
        MenuItem(name: 'West Side', price: 1450, desc: 'Garlic mayo base', image: 'https://images.unsplash.com/photo-1618213837799-24d556834357?w=200'),
      ]
    ),
    Restaurant(
      id: 11, name: 'Pizza Hut', category: 'Pizza', 
      image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500', 
      rating: 4.2, deliveryTime: '30-40', deliveryFee: 80,
      items: [
        MenuItem(name: 'Super Supreme', price: 1700, desc: 'Loaded with veggies', image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=200'),
        MenuItem(name: 'Fajita Sicilian', price: 1500, desc: 'Spicy jalapenos', image: 'https://images.unsplash.com/photo-1595854341625-f33ee10d8e7b?w=200'),
        MenuItem(name: 'Cheese Lover', price: 1200, desc: 'Extra mozzarella', image: 'https://images.unsplash.com/photo-1589187151053-5ec8818e661b?w=200'),
      ]
    ),
    Restaurant(
      id: 12, name: 'California Pizza', category: 'Pizza', 
      image: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500', 
      rating: 4.6, deliveryTime: '45-55', deliveryFee: 100,
      items: [
        MenuItem(name: 'Creamy Tikka', price: 1600, desc: 'White sauce special', image: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=200'),
        MenuItem(name: 'Ranch Pizza', price: 1700, desc: 'Ranch dressing', image: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=200'),
        MenuItem(name: 'Sriracha', price: 1650, desc: 'Hot sriracha sauce', image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200'),
      ]
    ),

    // === ASIAN ===
    Restaurant(
      id: 13, name: 'Chop Chop Wok', category: 'Asian', 
      image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500', 
      rating: 4.8, deliveryTime: '35-45', deliveryFee: 120,
      items: [
        MenuItem(name: 'Chowmein', price: 850, desc: 'Stir fried noodles', image: 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=200'),
        MenuItem(name: 'Kung Pao', price: 950, desc: 'Peanuts and chili', image: 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=200'),
        MenuItem(name: 'Dynamite Prawns', price: 1200, desc: 'Crispy prawns', image: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=200'),
      ]
    ),
    Restaurant(
      id: 14, name: 'Ginsoy', category: 'Asian', 
      image: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=500', 
      rating: 4.7, deliveryTime: '40-50', deliveryFee: 150,
      items: [
        MenuItem(name: 'Cherry Chilli', price: 1300, desc: 'Sweet and spicy', image: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=200'),
        MenuItem(name: 'Egg Fried Rice', price: 600, desc: 'Classic rice', image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=200'),
      ]
    ),
    Restaurant(
      id: 15, name: 'Bamboo Union', category: 'Asian', 
      image: 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500', 
      rating: 4.6, deliveryTime: '45-55', deliveryFee: 100,
      items: [
        MenuItem(name: 'Pad Thai', price: 950, desc: 'Thai flat noodles', image: 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=200'),
        MenuItem(name: 'Beef Chilli Dry', price: 1200, desc: 'Spicy beef strips', image: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=200'),
      ]
    ),
    Restaurant(
      id: 16, name: 'Cocochan', category: 'Asian', 
      image: 'https://images.unsplash.com/photo-1560717845-968823efbee1?w=500', 
      rating: 4.9, deliveryTime: '50-60', deliveryFee: 200, discount: 'Fancy Dining',
      items: [
        MenuItem(name: 'Wasabi Prawns', price: 1800, desc: 'Creamy wasabi sauce', image: 'https://images.unsplash.com/photo-1535591273668-578e31182c4f?w=200'),
        MenuItem(name: 'Mandarin Chicken', price: 1400, desc: 'Orange glaze', image: 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=200'),
        MenuItem(name: 'Thai Curry', price: 1500, desc: 'Green curry coconut', image: 'https://images.unsplash.com/photo-1560717845-968823efbee1?w=200'),
      ]
    ),

    // === SWEETS ===
    Restaurant(
      id: 5, name: 'Kaybees', category: 'Sweet', 
      image: 'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=500', 
      rating: 4.8, deliveryTime: '30-40', deliveryFee: 60,
      items: [
        MenuItem(name: 'Special Falooda', price: 450, desc: 'Rich kulfi falooda', image: 'https://images.unsplash.com/photo-1572357176061-70e8106852d8?w=200'),
        MenuItem(name: 'Vanilla Cone', price: 150, desc: 'Soft serve vanilla', image: 'https://images.unsplash.com/photo-1560008581-09826d1de69e?w=200'),
        MenuItem(name: 'Pineapple Split', price: 550, desc: '3 scoops with pineapple', image: 'https://images.unsplash.com/photo-1505394033641-40c6ad1178d7?w=200'),
      ]
    ),
    Restaurant(
      id: 6, name: 'Soft Swirl', category: 'Sweet', 
      image: 'https://images.unsplash.com/photo-1549395156-e0c1fe6fc7a5?w=500', 
      rating: 4.5, deliveryTime: '20-30', deliveryFee: 40,
      items: [
        MenuItem(name: 'Dip Cone', price: 200, desc: 'Chocolate dipped vanilla', image: 'https://images.unsplash.com/photo-1549395156-e0c1fe6fc7a5?w=200'),
        MenuItem(name: 'Oreo Blast', price: 350, desc: 'Crushed oreo mix', image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=200'),
      ]
    ),
    Restaurant(
      id: 7, name: 'Flavorado', category: 'Sweet', 
      image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500', 
      rating: 4.7, deliveryTime: '30-45', deliveryFee: 80, discount: '10% OFF',
      items: [
        MenuItem(name: 'Italian Gelato', price: 400, desc: 'Premium fruit scoop', image: 'https://images.unsplash.com/photo-1580915411954-282cb1b0d780?w=200'),
        MenuItem(name: 'Belgian Waffle', price: 650, desc: 'With nutella topping', image: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=200'),
        MenuItem(name: 'Mango Shake', price: 300, desc: 'Fresh mango pulp', image: 'https://images.unsplash.com/photo-1546173159-315724a31696?w=200'),
      ]
    ),
    Restaurant(
      id: 8, name: 'Baskin Robbins', category: 'Sweet', 
      image: 'https://images.unsplash.com/photo-1560008581-09826d1de69e?w=500', 
      rating: 4.9, deliveryTime: '25-35', deliveryFee: 100,
      items: [
        MenuItem(name: 'Praline Cream', price: 450, desc: 'Single scoop premium', image: 'https://images.unsplash.com/photo-1560008581-09826d1de69e?w=200'),
        MenuItem(name: 'Chocolate Mousse', price: 450, desc: 'Rich chocolate', image: 'https://images.unsplash.com/photo-1579954115567-dff2eeb6fdeb?w=200'),
      ]
    ),
  ];

  // Logic
  void addToCart(MenuItem item, Restaurant restaurant) {
    setState(() {
      if (cart.isNotEmpty && cart.first.restaurant.id != restaurant.id) {
        cart.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New restaurant selected. Cart cleared.")));
      }
      final index = cart.indexWhere((c) => c.item.name == item.name);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(item: item, quantity: 1, restaurant: restaurant));
      }
    });
  }

  void removeFromCart(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        cart.remove(item);
      }
    });
  }

  void toggleFavorite(int id) {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
  }

  void placeOrder() {
    if (cart.isEmpty) return;
    
    final newOrder = OrderModel(
      orderId: "#${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      restaurantName: cart.first.restaurant.name,
      totalAmount: getCartTotal(),
      time: DateTime.now(),
      status: "Preparing",
      itemCount: cart.fold(0, (sum, item) => sum + item.quantity),
    );

    setState(() {
      myOrders.insert(0, newOrder); 
      cart.clear();
      _selectedIndex = 1; 
    });
  }

  double getCartTotal() => cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity)) + (cart.isEmpty ? 0 : cart.first.restaurant.deliveryFee.toDouble());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(),
            _buildOrdersTab(),
            _buildFavoritesTab(),
            ProfileTab(name: userName, phone: userPhone, address: userAddress),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kColorPink, // Pink for selected tab
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: (cart.isNotEmpty && _selectedIndex == 0)
          ? Container(
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: kColorPink.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _showCartSheet(context),
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text('${cart.length} items | Rs ${getCartTotal().toInt()}'),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // --- HOME TAB ---
  Widget _buildHomeTab() {
    final displayRestaurants = allRestaurants.where((r) {
      final matchesSearch = r.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || r.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        // GRADIENT HEADER
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          decoration: const BoxDecoration(
            gradient: kPrimaryGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivering to', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const Text('Home • Karachi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 3),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search food or restaurants...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true, fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Categories
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _buildCatItem('All', '🍽️', Colors.blue),
              _buildCatItem('Burger', '🍔', Colors.orange),
              _buildCatItem('Pizza', '🍕', Colors.red),
              _buildCatItem('Desi', '🥘', Colors.brown),
              _buildCatItem('Asian', '🍜', Colors.teal),
              _buildCatItem('Sweet', '🍩', Colors.pink),
            ],
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: displayRestaurants.length,
            itemBuilder: (context, index) => _buildRestaurantCard(displayRestaurants[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Restaurant r) {
    bool isFav = favoriteIds.contains(r.id);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(
        restaurant: r, 
        onAddToCart: addToCart, 
        isFav: isFav, 
        onToggleFav: toggleFavorite
      ))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: NetworkImageFixed(r.image, height: 160, width: double.infinity)),
                if (r.discount != null)
                  Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: kColorOrange, borderRadius: BorderRadius.circular(4)), child: Text(r.discount!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: () => toggleFavorite(r.id),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? kColorPink : Colors.grey, size: 20),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(r.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Divider(),
                  Row(children: [const Icon(Icons.star, size: 16, color: Colors.amber), Text(' ${r.rating} • ${r.deliveryTime} min • Rs ${r.deliveryFee} fee', style: const TextStyle(color: Colors.grey, fontSize: 12))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    if (myOrders.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 10),
        const Text("No active orders", style: TextStyle(color: Colors.grey, fontSize: 16))
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myOrders.length,
      itemBuilder: (context, index) {
        final order = myOrders[index];
        return Card(
          elevation: 2, margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: kColorPink.withOpacity(0.1), child: const Icon(Icons.fastfood, color: kColorPink)),
            title: Text(order.restaurantName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${order.itemCount} Items • Rs ${order.totalAmount.toInt()}"),
            trailing: Chip(label: Text(order.status), backgroundColor: Colors.green[100], labelStyle: TextStyle(color: Colors.green[800])),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    final favList = allRestaurants.where((r) => favoriteIds.contains(r.id)).toList();
    if (favList.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 10),
        const Text("No favorites yet", style: TextStyle(color: Colors.grey, fontSize: 16))
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favList.length,
      itemBuilder: (context, index) => _buildRestaurantCard(favList[index]),
    );
  }

  Widget _buildCatItem(String name, String icon, Color color) {
    final isSelected = _selectedCategory == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = name),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 60, width: 60,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 5),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  void _showCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.all(20), child: Text('Your Cart (${cart.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: NetworkImageFixed(cart[i].item.image, width: 60, height: 60)),
                      title: Text(cart[i].item.name),
                      subtitle: Text('Rs ${cart[i].item.price} x ${cart[i].quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                            removeFromCart(cart[i]);
                            setSheetState((){}); setState((){}); // Update both
                          }),
                          Text('${cart[i].quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.add_circle, color: kColorOrange), onPressed: () {
                            addToCart(cart[i].item, cart[i].restaurant);
                            setSheetState((){}); setState((){}); // Update both
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GradientButton(
                    text: 'Checkout - Rs ${getCartTotal().toInt()}',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(total: getCartTotal(), name: userName, phone: userPhone, address: userAddress, onPlaceOrder: placeOrder)));
                    },
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

// ---------------- RESTAURANT DETAIL SCREEN ----------------
class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  final Function(MenuItem, Restaurant) onAddToCart;
  final bool isFav;
  final Function(int) onToggleFav;

  const RestaurantDetailScreen({super.key, required this.restaurant, required this.onAddToCart, required this.isFav, required this.onToggleFav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () => onToggleFav(restaurant.id),
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? kColorPink : Colors.white),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(restaurant.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(1, 1))])),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageFixed(restaurant.image, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...restaurant.items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    child: Row(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: NetworkImageFixed(item.image, width: 70, height: 70)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(item.desc, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text("Rs ${item.price}", style: const TextStyle(color: kColorOrange, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onAddToCart(item, restaurant);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added"), duration: Duration(milliseconds: 500)));
                          },
                          icon: const Icon(Icons.add_circle, color: kColorOrange, size: 28),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ---------------- PROFILE TAB ----------------
class ProfileTab extends StatelessWidget {
  final String name, phone, address;
  const ProfileTab({super.key, required this.name, required this.phone, required this.address});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: kPrimaryGradient),
            child: const CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Icon(Icons.person, size: 50, color: Colors.grey)),
          ),
          const SizedBox(height: 15),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(phone, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildTile(Icons.location_on, "Address", address),
                _buildTile(Icons.history, "Order History", "Check your past orders"),
                _buildTile(Icons.payment, "Payment Methods", "Cash on Delivery"),
                const Divider(),
                _buildTile(Icons.logout, "Logout", "", isRed: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, String sub, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red : kColorOrange),
      title: Text(title, style: TextStyle(color: isRed ? Colors.red : Colors.black, fontWeight: FontWeight.bold)),
      subtitle: sub.isNotEmpty ? Text(sub) : null,
    );
  }
}

// ---------------- CHECKOUT SCREEN ----------------
class CheckoutScreen extends StatelessWidget {
  final double total;
  final String name, phone, address;
  final VoidCallback onPlaceOrder;

  const CheckoutScreen({super.key, required this.total, required this.name, required this.phone, required this.address, required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: kColorOrange),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("$phone\n$address"),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(leading: Icon(Icons.money, color: Colors.green), title: Text("Cash on Delivery"), trailing: Icon(Icons.check_circle, color: kColorOrange)),
            const Spacer(),
            GradientButton(
              text: 'Confirm Order - Rs ${total.toInt()}',
              onPressed: () {
                onPlaceOrder();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Placed Successfully!"), backgroundColor: Colors.green));
              },
            ),
          ],
        ),
      ),
    );
  }
}