<<<<<<< HEAD
class TimerService {
  DateTime startTime = DateTime.now();

  getElapsedTime() {
    final currentTime = DateTime.now();
    return currentTime.difference(startTime).inMinutes;
  }

  reset() {
    startTime = DateTime.now();
  }
}
=======
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
>>>>>>> b10974087543cc26a57c782b182d3b8052c9a07b
