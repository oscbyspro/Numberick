//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x FibonacciXL
//*============================================================================*

final class NBKFibonacciXLTests: XCTestCase {
    
    typealias T = NBKFibonacciXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        XCTAssertEqual(T().index,   0 as UInt)
        XCTAssertEqual(T().element, 0 as UIntXL)
        XCTAssertEqual(T().next,    1 as UIntXL)
    }
    
    func testStartSequence() {
        NBKAssertFibonacciSequenceElement(0 as UInt, 0 as UIntXL)
        NBKAssertFibonacciSequenceElement(1 as UInt, 1 as UIntXL)
        NBKAssertFibonacciSequenceElement(2 as UInt, 1 as UIntXL)
        NBKAssertFibonacciSequenceElement(3 as UInt, 2 as UIntXL)
        NBKAssertFibonacciSequenceElement(4 as UInt, 3 as UIntXL)
        NBKAssertFibonacciSequenceElement(5 as UInt, 5 as UIntXL)
    }
    
    func testEachElementInUInt256() {
        self.continueAfterFailure = false
        
        var fibonacci = T(); while fibonacci.next <= UIntXL.max256 {
            NBKAssertFibonacciSequenceElement(fibonacci.index, fibonacci.element)
            fibonacci.increment()
        }
        
        XCTAssertEqual(fibonacci.index,   370 as UInt)
        XCTAssertEqual(fibonacci.element, UIntXL("094611056096305838013295371573764256526437182762229865607320618320601813254535"))
        XCTAssertEqual(fibonacci.next,    UIntXL("153083904475345790698149223310665389766178449653686710164582374234640876900329"))
    }
}

//*============================================================================*
// MARK: * NBK x FibonacciXL x Primes
//*============================================================================*

final class NBKFibonacciXLTestsOnPrimes: XCTestCase {
    
    typealias T = NBKFibonacciXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+1399
    func testPrime222() {
        NBKAssertFibonacciSequenceElement(UInt(1399), UIntXL("""
        0000000000000000000000000001057362022138877586442790693627392471\
        4349424343122542609372806319825783387389898145491654340696207977\
        9703100859330541842708747836587076026853149515123668038994257349\
        6825711057526259113835863240488302877201171798455616630015796594\
        0742927387906176446848324713233936084752836275187153808643885101
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+2239
    func testPrime333() {
        NBKAssertFibonacciSequenceElement(UInt(2239), UIntXL("""
        0000000000000000000000000000000000000000000037483619230023616383\
        1556956012890801755635223834456440078068598512042225565858378705\
        2775478508439311765008270803174379457823903626436917896144175108\
        1812500769712739265577812142790633886426904029644292656072176594\
        5442661544462371162680745392064002681693236118751836449122772276\
        7869284859173664595855541705821814253059049650198752630703006217\
        8339242653834274827433371972683579086589883072059016299647032544\
        7184786711538554743189201957494849217103385151192357985565557661
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+4019
    func testPrime555() {
        NBKAssertFibonacciSequenceElement(UInt(4019), UIntXL("""
        0000000000000000000000000000000000000000000000000000000037311367\
        1412705742029424968910639277549742521996080310155045098365714482\
        4104908347036042361244599159615512769990330987960639730865498130\
        8072433775788325161992682362256795449665494209753670942172171272\
        2203967369999425701889153758837814681835559585933723133751806881\
        8496872580801685513615393162520513116429805804142523379378342551\
        4441029659216936210529080660370851401177631514342389875828339972\
        6614842546459415022870946655707302191026328812740600578177639873\
        3039042717454551010941945840815871118048005931668653125862093108\
        8958611234123487217337182078176768683790720523395222453566084951\
        4492498420355556195880899437692737868135183556431736743842980245\
        8400475635400414549626879469797956177065259238066131421408862659\
        3874545400735945578330890239131064772372045179036218495472538674\
        0316671667949438060397052349819774423263628326505983968411352681
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=fibonnaci+5903
    func testPrime777() {
        NBKAssertFibonacciSequenceElement(UInt(5903), UIntXL("""
        0000000000000000000000000000000000000000000000201630112973699547\
        8467033798246231765802235127399927076436839763410065672009048903\
        1282893541236712535277172854664465524821928062556461511462472243\
        6645751603027750072868408113686717270843656386576571239706531613\
        8832607318277041589340170938439083061589073645207050078640037387\
        3930944738614316892092679585355923400727053939446917720844859420\
        8475286500719315637423740931654098191825715510224786132537906089\
        2798464444270756081302801050898869097388615552432632699803372579\
        5006266664207612795271656344222004200834104891232199115031529879\
        2703171846839972134549632698690061406266150782100519904238693642\
        7990494803652598109479923921411786233223630306244612906702729633\
        0936722357821751129503986058477775784943438980499220967251871125\
        8907675708863225870261545152179027647035709552484493259087293234\
        3560027918334679621500613235053762398727366706896356186229959919\
        9113456220990739086184934440183082123185220867952003388928951448\
        6862918684679538218518939139423048219131427786458175412165472787\
        2317940678177228138520687104044551650142781207251510823550422463\
        0550656054019863500046679727553797345950068888003234780117695468\
        5001758459948949898864934140668770688345102830949505991111324318\
        0359205788328847352554207256070124136434254282285393279119106977
        """))
    }
}

//*============================================================================*
// MARK: * NBK x FibonacciXL x Assertions
//*============================================================================*

private func NBKAssertFibonacciSequenceElement(
_ index: UInt, _ element: UIntXL,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let x0 = NBKFibonacciXL(index + 0)
    let x1 = NBKFibonacciXL(index + 1)
    //=------------------------------------------=
    XCTAssertEqual(x0.element, element,  file: file, line: line)
    XCTAssertEqual(x0.next, x1.element,  file: file, line: line)
    XCTAssertEqual(x1.next, x0.element + x1.element, file: file, line: line)
    //=------------------------------------------=
    increment1: do  {
        var x = x0; x.increment()
        XCTAssertEqual(x.index,   x1.index,   file: file, line: line)
        XCTAssertEqual(x.element, x1.element, file: file, line: line)
        XCTAssertEqual(x.next,    x1.next,    file: file, line: line)
    }
    
    decrement1: do  {
        var x = x1; x.decrement()
        XCTAssertEqual(x.index,   x0.index,   file: file, line: line)
        XCTAssertEqual(x.element, x0.element, file: file, line: line)
        XCTAssertEqual(x.next,    x0.next,    file: file, line: line)
    }
}

#endif
