# zap-fix — FIX 4.4 / 5.0 trading channel over ZAP.
#
# One FIX message = one ZAP frame. The hot routing fields
# (sender/target/seqnum/msgtype) are lifted from the SOH body into the
# envelope so a router can dispatch without parsing the FIX text. The
# raw FIX body remains in `payload` so existing FIX engines accept it
# unchanged.
#
# Optional binary mode: when `body` is set instead of `payload`, the
# pre-parsed structured fields ride directly in the frame, eliminating
# SOH walk on the receiver. Either mode preserves SeqNum monotonicity.

struct Envelope
  senderCompId Text
  targetCompId Text
  msgSeqNum    UInt64
  msgType      Text
  sendingTime  UInt64    # unix nanos
  body         Body

struct Body
  union
    payload Data           # raw SOH-delimited FIX message
    binary  StructuredBody # parsed fields in ZAP-binary form

struct StructuredBody
  symbol     Text
  side       Side
  ordType    OrdType
  price      Float64
  quantity   Float64
  clOrdId    Text
  account    Text
  tags       List(Tag)

struct Tag
  num   UInt32
  value Text

enum Side
  buy
  sell
  buyMinus
  sellPlus
  sellShort
  sellShortExempt
  cross

enum OrdType
  market
  limit
  stop
  stopLimit
  marketOnClose
  pegged
