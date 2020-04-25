interface Hashable
  """
  Anything with a hash method is hashable.
  """
  fun hash(): USize => Hashing.finish(hash_with(Hashing.begin()))

  fun hash_with(state': HashState): HashState

interface Hashable64
  """
  A version of Hashable that returns 64-bit hashes on every platform.
  """
  fun hash64(): U64 => Hashing.finish_64(hash_with64(Hashing.begin_64()))
  fun hash_with64(state': HashState64): HashState64

type HashState is SipHash24HashState
type HashState64 is SipHash24HashState64

primitive Hashing

  fun begin(): HashState => SipHash24Streaming.initial()
  fun update(m: U64, state: HashState): HashState =>
    SipHash24Streaming.update(m, state)
  fun update_usize(m: USize, state: HashState): HashState =>
    SipHash24Streaming.update_usize(m, state)
  fun update_bytes(pointer: Pointer[U8] box, size: USize, state: HashState): HashState =>
    SipHash24Streaming.update_bytes(pointer, size, state)
  fun finish(state: HashState): USize =>
    SipHash24Streaming.finish(state)

  fun begin_64(): HashState64 => SipHash24Streaming64.initial()
  fun update_64(m: U64, state: HashState64): HashState64 =>
    SipHash24Streaming64.update(m, state)
  fun update_bytes_64(pointer: Pointer[U8] box, size: USize, state: HashState64): HashState64 =>
    SipHash24Streaming64.update_bytes(pointer, size, state)
  fun finish_64(state: HashState64): U64 =>
    SipHash24Streaming64.finish(state)

  fun hash_bytes(bytes: ByteSeq box): USize =>
    (
      ifdef ilp32 then
        HalfSipHash24[ByteSeq box](bytes)
      else
        SipHash24[ByteSeq box](bytes)
      end
    ).usize()

  fun hash64_bytes(bytes: ByteSeq box): U64 =>
    SipHash24[ByteSeq box](bytes)

  fun hash_array[T: Hashable #read](arr: Array[T] box): USize =>
    iftype T <: U8 then
      hash_bytes(arr)
    else
      var state = SipHash24Streaming.initial()
      for elem in arr.values() do
        state = SipHash24Streaming.update_usize(elem.hash(), state)
      end
      SipHash24Streaming.finish(state)
    end

  fun hash64_array[T: Hashable64 #read](arr: Array[T] box): U64 =>
    iftype T <: U8 then
      hash64_bytes(arr)
    else
      var state = SipHash24Streaming64.initial()
      for elem in arr.values() do
        state = SipHash24Streaming64.update(elem.hash64(), state)
      end
      SipHash24Streaming64.finish(state)
    end

  fun hash_2(a: Hashable box, b: Hashable box): USize =>
    var state = SipHash24Streaming.initial()
    state = SipHash24Streaming.update_usize(a.hash(), state)
    state = SipHash24Streaming.update_usize(b.hash(), state)
    SipHash24Streaming.finish(state)

  fun hash_3(a: Hashable box, b: Hashable box, c: Hashable box): USize =>
    var state = SipHash24Streaming.initial()
    state = SipHash24Streaming.update_usize(a.hash(), state)
    state = SipHash24Streaming.update_usize(b.hash(), state)
    state = SipHash24Streaming.update_usize(c.hash(), state)
    SipHash24Streaming.finish(state)

  fun hash_4(a: Hashable box, b: Hashable box, c: Hashable box, d: Hashable box): USize =>
    var state = SipHash24Streaming.initial()
    state = SipHash24Streaming.update_usize(a.hash(), state)
    state = SipHash24Streaming.update_usize(b.hash(), state)
    state = SipHash24Streaming.update_usize(c.hash(), state)
    state = SipHash24Streaming.update_usize(d.hash(), state)
    SipHash24Streaming.finish(state)

  // TODO: add functions for up to 16 arguments

  fun hash64_2(a: Hashable64 box, b: Hashable64 box): U64 =>
    var state = SipHash24Streaming64.initial()
    state = SipHash24Streaming64.update(a.hash64(), state)
    state = SipHash24Streaming64.update(b.hash64(), state)
    SipHash24Streaming64.finish(state)

  fun hash64_3(a: Hashable64 box, b: Hashable64 box, c: Hashable64 box): U64 =>
    var state = SipHash24Streaming64.initial()
    state = SipHash24Streaming64.update(a.hash64(), state)
    state = SipHash24Streaming64.update(b.hash64(), state)
    state = SipHash24Streaming64.update(c.hash64(), state)
    SipHash24Streaming64.finish(state)

  fun hash64_4(a: Hashable64 box, b: Hashable64 box, c: Hashable64 box, d: Hashable64 box): U64 =>
    var state = SipHash24Streaming64.initial()
    state = SipHash24Streaming64.update(a.hash64(), state)
    state = SipHash24Streaming64.update(b.hash64(), state)
    state = SipHash24Streaming64.update(c.hash64(), state)
    state = SipHash24Streaming64.update(d.hash64(), state)
    SipHash24Streaming64.finish(state)

  // TODO: add functions for up to 16 arguments
