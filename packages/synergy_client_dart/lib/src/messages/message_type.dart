enum MessageType {
  // HelloBack messages
  helloBackSynergy('Synergy', '[Init] Hello Back Synergy'),
  helloBackBarrier('Barrier', '[Init] Hello Back Barrier'),

  // Commands
  cNoop('CNOP', '[Command] NoOp'),
  cClose('CBYE', '[Command] Close'),
  cEnter('CINN', '[Command] Enter'),
  cLeave('COUT', '[Command] Leave'),
  cClipboard('CCLP', '[Command] Clipboard'),
  cScreenSaver('CSEC', '[Command] Screensaver'),
  cResetOptions('CROP', '[Command] Reset Options'),
  cInfoAck('CIAK', '[Command] Info Ack'),
  cKeepAlive('CALV', '[Command] Keep Alive'),
  // Data
  dKeyDown('DKDN', '[Data] Key Down'),
  dKeyRepeat('DKRP', '[Data] Key Repeat'),
  dKeyUp('DKUP', '[Data] Key Up'),
  dMouseDown('DMDN', '[Data] Mouse Down'),
  dMouseUp('DMUP', '[Data] Mouse Up'),
  dMouseMove('DMMV', '[Data] Mouse Move'),
  dMouseRelMove('DMRM', '[Data] Mouse Relative Move'),
  dMouseWheel('DMWM', '[Data] Mouse Wheel'),
  dClipBoard('DCLP', '[Data] Clipboard'),
  dInfo('DINF', '[Data] Info'),
  dSetOptions('DSOP', '[Data] Set Options'),
  qInfo('QINF', '[Query] Info'),
  // Errors
  eIncompatible('EICV', '[Error] Incompatible'),
  eBusy('EBSY', '[Error] Busy'),
  eUnknown('EUNK', '[Error] Unknown'),
  eBad('EBAD', '[Error] Bad');

  final String value;
  final String commonName;
  const MessageType(this.value, this.commonName);

  static MessageType fromString(String messageValue) {
    try {
      return MessageType.values.firstWhere(
        (type) => type.value == messageValue,
      );
    } catch (e) {
      throw ArgumentError('No MessageType with value $messageValue');
    }
  }

  @override
  String toString() => commonName;
}
