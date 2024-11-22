class TimerService{
  DateTime startTime = DateTime.now();

  getElapsedTime(){
    final currentTime = DateTime.now();
    return currentTime.difference(startTime).inSeconds;
  }
  reset(){
      startTime = DateTime.now() ;
  }






}