class Constantclass{
  static final List<String> paymentMethod = ['qris','transfer','cash'];
  static final List<String> paymentType = ['Lunas','Dp'];

  
}
enum BookingStep{
  initial,
  loading,
  error,
  loaded,
  tahap1,
  tahap2,
  tahap3,
  submitted
}


enum RequestState{
  init,
  loading,
  error,
  loaded
}

enum TransactionPayType{
  lunas,
  pelunasan,
  dp
}