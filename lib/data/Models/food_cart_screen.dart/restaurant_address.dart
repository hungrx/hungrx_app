class CartRestaurantAddress {
  final String restaurantName;
  final String address;
  final double latitude;
  final double longitude;

  CartRestaurantAddress({
    required this.restaurantName,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // factory CartRestaurantAddress.fromCart(Cart cart) {
  //   return CartRestaurantAddress(
  //     restaurantName: cart.restaurantName,
  //     address: cart.address,
  //     latitude: cart.latitude,
  //     longitude: cart.longitude,
  //   );
  // }
}