import AppKit
import CoreGraphics

// Rebuild on macOS: swift render.swift /path/to/rendered.png
// Keep build outputs and Swift's module cache in the run folder.
guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: swift render.swift <output.png>")
}
let destination = CommandLine.arguments[1]
let size = 1024
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
let base = NSGraphicsContext(bitmapImageRep: bitmap)!
let cg = base.cgContext
cg.translateBy(x: 0, y: CGFloat(size)); cg.scaleBy(x: 1, y: -1)
NSGraphicsContext.current = NSGraphicsContext(cgContext: cg, flipped: true)
cg.setShouldAntialias(true)
func color(_ hex: String) -> NSColor {
    let n = UInt32(hex, radix: 16)!
    return NSColor(srgbRed: CGFloat((n >> 16) & 255)/255, green: CGFloat((n >> 8) & 255)/255, blue: CGFloat(n & 255)/255, alpha: 1)
}
let ink = "142C39", paper = "F6F1E7", muted = "425561", teal = "286966", gold = "B77D2D", red = "B33D31"
func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: String, _ radius: CGFloat = 0) {
    color(c).setFill()
    NSBezierPath(roundedRect: NSRect(x:x,y:y,width:w,height:h), xRadius: radius,yRadius: radius).fill()
}
func ellipse(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: String) {
    color(c).setFill(); NSBezierPath(ovalIn: NSRect(x:x,y:y,width:w,height:h)).fill()
}
func line(_ points: [(CGFloat,CGFloat)], _ c: String, _ width: CGFloat = 3, close: Bool = false, fill: Bool = false) {
    let p = NSBezierPath(); p.move(to:NSPoint(x:points[0].0,y:points[0].1))
    for xy in points.dropFirst() { p.line(to:NSPoint(x:xy.0,y:xy.1)) }
    if close { p.close() }; p.lineWidth = width; p.lineJoinStyle = .round; p.lineCapStyle = .round
    color(c).setStroke(); color(c).setFill(); if fill { p.fill() } else { p.stroke() }
}
func text(_ value: String, _ x: CGFloat, _ y: CGFloat, _ fontSize: CGFloat, _ c: String = "142C39", bold: Bool = false, serif: Bool = false) {
    let f = serif ? NSFont(name: bold ? "Georgia-Bold" : "Georgia",size:fontSize)! : NSFont.systemFont(ofSize:fontSize,weight:bold ? .bold : .regular)
    let a: [NSAttributedString.Key: Any] = [.font:f,.foregroundColor:color(c)]
    (value as NSString).draw(at:NSPoint(x:x,y:y),withAttributes:a)
}
func star(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c: String) {
    let pts = (0..<10).map { i -> (CGFloat,CGFloat) in
        let a = CGFloat(i) * .pi / 5 - .pi/2, radius = i % 2 == 0 ? r : r*0.43
        return (x+cos(a)*radius,y+sin(a)*radius)
    }; line(pts,c,close:true,fill:true)
}
func panel(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat, _ tint: String, _ accent: String) {
    rect(x,y,480,h,tint,12); rect(x+20,y+19,5,24,accent,2)
}
func globe(_ x: CGFloat, _ y: CGFloat) {
    color(paper).setStroke(); let p = NSBezierPath(ovalIn:NSRect(x:x,y:y,width:64,height:64)); p.lineWidth=2.5; p.stroke()
    let q = NSBezierPath(ovalIn:NSRect(x:x+18,y:y,width:28,height:64)); q.lineWidth=2; q.stroke()
    line([(x+3,y+23),(x+61,y+23)],paper,2); line([(x+3,y+42),(x+61,y+42)],paper,2)
}
func shifted(_ dy: CGFloat, _ draw: () -> Void) {
    cg.saveGState()
    cg.translateBy(x: 0, y: dy)
    draw()
    cg.restoreGState()
}
rect(0,0,1024,1024,paper)
rect(0,0,1024,152,ink)
text("WORLD NEWS",24,12,66,paper,bold:true,serif:true)
text("Friday 20 November 2026",26,94,40,paper,bold:true)
globe(929,34)

// Lead one: a symbolic court and balanced scales, no invented scene.
panel(24,168,308,"E8E5D7",teal)
text("ASIA / LAW",60,185,24,teal,bold:true)
shifted(-22) {
line([(67,308),(146,260),(225,308)],"CFCCB8",close:true,fill:true)
rect(77,314,138,10,"CFCCB8"); rect(68,365,156,9,"CFCCB8")
for x in [84,122,160,198] { rect(CGFloat(x),326,10,35,"CFCCB8") }
line([(297,352),(297,242)],teal,7)
ellipse(287,231,20,20,gold)
line([(242,263),(352,263)],teal,6)
for x: CGFloat in [248,346] {
    line([(x,264),(x-25,309),(x+25,309),(x,264)],teal,3)
    let p = NSBezierPath(); p.move(to:NSPoint(x:x-28,y:309)); p.curve(to:NSPoint(x:x+28,y:309),controlPoint1:NSPoint(x:x-20,y:337),controlPoint2:NSPoint(x:x+20,y:337)); p.close(); color(teal).setFill(); p.fill()
}
rect(264,351,66,8,teal,3)
text("ICJ",386,281,34,teal,bold:true)
text("ICJ: Myanmar",44,376,38,ink,bold:true)
text("committed genocide",44,418,36,ink,bold:true)
text("Against the Rohingya · 9–6",44,462,28,ink)
}

// Lead two: broken bridge across a river, with a missile and drone silhouette.
panel(520,168,308,"E2E8EA",red)
text("EUROPE / CONFLICT",556,185,24,red,bold:true)
shifted(-22) {
rect(542,312,436,52,"B9CED5",5)
for y: CGFloat in [332,349] { line([(553,y),(642,y),(659,y+4),(737,y+4),(756,y),(968,y)],"829FAE",2) }
for x: CGFloat in [582,670,848,934] { rect(x,295,12,55,"687E88") }
line([(545,296),(706,296),(724,304)],ink,10)
line([(781,304),(800,296),(975,296)],ink,10)
line([(736,309),(759,321),(779,314)],ink,8)
line([(548,283),(701,283)],ink,3); line([(804,283),(973,283)],ink,3)
for x: CGFloat in [558,596,634,672,818,856,894,932,969] { line([(x,283),(x,295)],ink,3) }
line([(738,275),(725,258),(740,263),(747,243),(751,265),(770,255),(761,277)],gold,4)
line([(652,242),(681,259)],red,10); line([(651,241),(640,241),(647,251)],red,close:true,fill:true)
line([(683,260),(690,264),(685,253)],red,close:true,fill:true)
line([(877,239),(902,247),(927,239)],ink,5); line([(902,238),(902,255)],ink,4)
text("Russian attack",540,376,39,ink,bold:true)
text("kills at least 8",540,418,39,ink,bold:true)
text("Kyiv’s Dnipro bridges hit",540,462,28,ink)
}

// Climate: negotiations and an oil drop struck from a draft.
shifted(-22) {
panel(24,514,210,"DEE8DE",teal)
text("CLIMATE / ANTALYA",60,531,24,teal,bold:true)
text("COP31",44,574,40,ink,bold:true)
text("falters",44,618,40,ink,bold:true)
rect(352,569,108,104,"F6F1E7",5)
line([(370,587),(439,587)],"A9BAB0",4)
let drop = NSBezierPath(); drop.move(to:NSPoint(x:406,y:600)); drop.curve(to:NSPoint(x:390,y:638),controlPoint1:NSPoint(x:402,y:612),controlPoint2:NSPoint(x:382,y:624)); drop.curve(to:NSPoint(x:422,y:638),controlPoint1:NSPoint(x:395,y:653),controlPoint2:NSPoint(x:418,y:653)); drop.curve(to:NSPoint(x:406,y:600),controlPoint1:NSPoint(x:433,y:624),controlPoint2:NSPoint(x:412,y:611)); color(teal).setFill(); drop.fill()
line([(379,652),(436,606)],red,6)
text("Draft drops fossil-fuel language",44,675,27,ink)
}

// Diplomacy: Somalia's flag and a door with an outward arrow.
shifted(-22) {
panel(520,514,210,"E8E4D8",gold)
text("AFRICA / DIPLOMACY",556,531,24,"7D581D",bold:true)
text("Somalia expels",540,574,35,ink,bold:true)
text("UAE ambassador",540,616,35,ink,bold:true)
rect(879,574,81,53,"4E8BB0",3); star(919,600,16,"FFFFFF")
rect(886,639,35,35,ink,2); rect(894,645,23,29,"E8E4D8")
line([(911,654),(961,654),(950,644)],gold,5); line([(961,654),(950,664)],gold,5)
text("Ordered out within 72 hours",540,675,28,ink)
}

// Economy: integrated circuit and export growth.
shifted(-44) {
panel(24,762,196,"E0E8EB",teal)
text("ASIA / ECONOMY",60,779,24,teal,bold:true)
text("South Korea",44,821,38,ink,bold:true)
text("Exports pass $1T",44,865,35,ink,bold:true)
rect(385,824,66,66,teal,6); rect(397,836,42,42,"E0E8EB",3)
for i in 0..<4 {
    let p = CGFloat(i)*14
    line([(392+p,816),(392+p,824)],teal,4); line([(392+p,890),(392+p,898)],teal,4)
    line([(377,831+p),(385,831+p)],teal,4); line([(451,831+p),(459,831+p)],teal,4)
}
line([(393,864),(405,853),(415,859),(437,841)],teal,4)
line([(426,842),(437,841),(436,852)],teal,4)
text("First $1T year in goods exports",44,913,27,ink)
}

// Culture: an original symbolic tree miniature, not a reproduction of the painting.
shifted(-44) {
panel(520,762,196,"EADFD7",red)
text("AMERICAS / CULTURE",556,779,24,red,bold:true)
text("Van Gogh record",540,821,35,ink,bold:true)
text("$190.4m sale",540,863,39,ink,bold:true)
shifted(-16) {
rect(879,821,88,100,"9B733C",3); rect(886,828,74,86,"EBCE93")
rect(892,834,62,74,"B3C7BB"); rect(892,885,62,23,"7D9476")
line([(920,899),(920,863),(905,850)],"715B3C",4); line([(920,872),(938,850)],"715B3C",3)
for (x,y): (CGFloat,CGFloat) in [(903,849),(915,842),(926,845),(938,849),(905,860),(928,861),(938,859)] { ellipse(x-6,y-5,13,12,"F7EED8") }
}
text("“Chestnut Trees in Blossom”",540,913,27,ink)
}

// Two compact Europe briefs retain the main stories' original type sizes.
rect(24,930,976,78,ink,10)
text("EUROPE",42,954,24,paper,bold:true)
line([(164,944),(164,994)],"63818A",2)
text("EU–UK post-Brexit reset agreed · Brussels summit",184,937,28,paper,bold:true)
text("Italy: general strike against the budget",184,972,28,paper,bold:true)

let data = bitmap.representation(using:.png,properties:[:])!
try data.write(to:URL(fileURLWithPath:destination))
print("Rendered \(size) × \(size), \(data.count) bytes")
