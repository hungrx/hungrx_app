abstract class DeleteDishCartState {}

class DeleteDishCartInitial extends DeleteDishCartState {}

class DeleteDishCartLoading extends DeleteDishCartState {}

class DeleteDishCartSuccess extends DeleteDishCartState {
  final String message;

  DeleteDishCartSuccess(this.message);
}

class DeleteDishCartError extends DeleteDishCartState {
  final String error;

  DeleteDishCartError(this.error);
}
