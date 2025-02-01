import 'package:flutter/material.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class RestaurantItem extends StatelessWidget {
  final VoidCallback ontap;
  final String name;
  final String? imageUrl;
  final String? rating;
  final String? address;
  final String distance;

  const RestaurantItem({
    super.key,
    required this.ontap,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final padding = screenWidth * 0.04;
    
    // Calculate image size based on screen width
    final imageSize = isSmallScreen ? 70.0 : 90.0;
    
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding * 0.375,
        ),
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Padding(
              padding: EdgeInsets.all(padding * 0.3),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildRestaurantImage(imageSize),
                ),
              ),
            ),
            // Restaurant Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding * 0.75),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant Name
                        Expanded(
                          flex: 3,
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (rating != null) ...[
                          SizedBox(width: padding * 0.5),
                          // Rating Container
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 0.5,
                              vertical: padding * 0.25,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.black,
                                  size: isSmallScreen ? 14 : 16,
                                ),
                                SizedBox(width: padding * 0.25),
                                Text(
                                  rating.toString().trim(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (address != null) ...[
                      SizedBox(height: padding * 0.5),
                      Text(
                        address ?? "",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildRestaurantImage(double size) {
  // Return placeholder immediately if URL is null
  if (imageUrl == null || imageUrl!.isEmpty) {
    return _buildPlaceholderImage(size);
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.network(
      imageUrl!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholderImage(size);
      },
    ),
  );
}

  Widget _buildPlaceholderImage(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.restaurant,
        color: Colors.grey,
        size: size * 0.4,
      ),
    );
  }
}