enum FromWho { me, hers }

class Message {
  final String text;
  final String? opcional;
  final FromWho fromWho;

  Message({required this.text, this.opcional, required this.fromWho});
}
