import 'dart:typed_data';
import 'dart:convert';

class ClipboardChunk {
  static const int kDataStart = 0;
  static const int kDataChunk = 1;
  static const int kDataEnd = 2;
  static const int kError = -1;
  static const int kNotFinish = -2;
  static const int kStart = 0;
  static const int kFinish = 1;
  static int sExpectedSize = 0;

  late Uint8List mChunk;
  late int mDataSize;

  ClipboardChunk(int size) {
    mChunk = Uint8List(size);
    mDataSize = size - 6; // Assuming CLIPBOARD_CHUNK_META_SIZE is 6
  }

  static ClipboardChunk start(int id, int sequence, String size) {
    var sizeLength = size.length;
    var start = ClipboardChunk(sizeLength + 6);
    var chunk = start.mChunk;

    chunk[0] = id;
    chunk.buffer.asByteData().setInt32(1, sequence, Endian.big);
    chunk[5] = kDataStart;
    chunk.setAll(6, utf8.encode(size));
    chunk[sizeLength + 6 - 1] = 0;

    return start;
  }

  static ClipboardChunk data(int id, int sequence, String data) {
    var dataSize = data.length;
    var chunk = ClipboardChunk(dataSize + 6);
    var chunkData = chunk.mChunk;

    chunkData[0] = id;
    chunkData.buffer.asByteData().setInt32(1, sequence, Endian.big);
    chunkData[5] = kDataChunk;
    chunkData.setAll(6, utf8.encode(data));
    chunkData[dataSize + 6 - 1] = 0;

    return chunk;
  }

  static ClipboardChunk end(int id, int sequence) {
    var end = ClipboardChunk(6);
    var chunk = end.mChunk;

    chunk[0] = id;
    chunk.buffer.asByteData().setInt32(1, sequence, Endian.big);
    chunk[5] = kDataEnd;
    chunk[6 - 1] = 0;

    return end;
  }

  static int assemble(
    Uint8List stream,
    StringBuffer dataCached,
    int id,
    int sequence,
  ) {
    var mark = stream[5];
    var data = utf8.decode(stream.sublist(6));

    if (mark == kDataStart) {
      sExpectedSize = int.parse(data);
      print('start receiving clipboard data');
      dataCached.clear();
      return kStart;
    } else if (mark == kDataChunk) {
      dataCached.write(data);
      return kNotFinish;
    } else if (mark == kDataEnd) {
      if (sExpectedSize != dataCached.length) {
        print(
            'corrupted clipboard data, expected size=$sExpectedSize actual size=${dataCached.length}');
        return kError;
      }
      return kFinish;
    }

    print('clipboard transmission failed: unknown error');
    return kError;
  }

  void send(Uint8List stream) {
    print('sending clipboard chunk');

    var id = mChunk[0];
    var sequence = mChunk.buffer.asByteData().getInt32(1, Endian.big);
    var mark = mChunk[5];
    var dataChunk = utf8.decode(mChunk.sublist(6, mDataSize));

    switch (mark) {
      case kDataStart:
        print('sending clipboard chunk start: size=$dataChunk');
        break;

      case kDataChunk:
        print('sending clipboard chunk data: size=${dataChunk.length}');
        break;

      case kDataEnd:
        print('sending clipboard finished');
        break;
    }

    // Assuming ProtocolUtil::writef is equivalent to the following:
    stream[0] = id;
    stream.buffer.asByteData().setInt32(1, sequence, Endian.big);
    stream[5] = mark;
    stream.setAll(6, utf8.encode(dataChunk));
  }
}
