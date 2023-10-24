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
// MARK: * NBK x Flexible Width x Exponentiation x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnExponentiationAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small Base
    //=------------------------------------------------------------------------=
    
    func testPowersOf0() {
        for exponent in 0 as Int ..< 10 {
            NBKAssertExponentiation(T.zero, exponent, exponent.isZero ? T.one : T.zero)
        }
    }
    
    func testPowersOf1() {
        for exponent in 0 as Int ..< 10 {
            NBKAssertExponentiation(T.one, exponent, T.one)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small Exponent
    //=------------------------------------------------------------------------=
    
    func testBaseRaisedTo0ReturnsOne() {
        func with(_ base: T) {
            NBKAssertExponentiation(base, Int(0), T.one)
        }
        
        for word in (-5 ... 5).lazy.map(UInt.init(bitPattern:)){
            with(T(words:[word                                 ] as W))
            with(T(words:[word, word &- 1                      ] as W))
            with(T(words:[word, word &- 1, word &+ 2           ] as W))
            with(T(words:[word, word &- 1, word &+ 2, word &* 3] as W))
        }
    }
    
    func testBaseRaisedTo1IsBase() {
        func with(_ base: T) {
            NBKAssertExponentiation(base, Int(1), base)
        }
        
        for word in (-5 ... 5).lazy.map(UInt.init(bitPattern:)){
            with(T(words:[word                                 ] as W))
            with(T(words:[word, word &- 1                      ] as W))
            with(T(words:[word, word &- 1, word &+ 2           ] as W))
            with(T(words:[word, word &- 1, word &+ 2, word &* 3] as W))
        }
    }
    
    func testBaseRaisedTo2IsBaseSquared() {
        func with(_ base: T) {
            NBKAssertExponentiation(base, Int(2), base * base)
        }
        
        for word in (-5 ... 5).lazy.map(UInt.init(bitPattern:)){
            with(T(words:[word                                 ] as W))
            with(T(words:[word, word &- 1                      ] as W))
            with(T(words:[word, word &- 1, word &+ 2           ] as W))
            with(T(words:[word, word &- 1, word &+ 2, word &* 3] as W))
        }
    }
    
    func testBaseRaisedTo3IsBaseCubed() {
        func with(_ base: T) {
            NBKAssertExponentiation(base, Int(3), base * base * base)
        }
        
        for word in (-5 ... 5).lazy.map(UInt.init(bitPattern:)){
            with(T(words:[word                                 ] as W))
            with(T(words:[word, word &- 1                      ] as W))
            with(T(words:[word, word &- 1, word &+ 2           ] as W))
            with(T(words:[word, word &- 1, word &+ 2, word &* 3] as W))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.power(0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Exponentiation x UIntXL x Primes
//*============================================================================*

final class NBKFlexibleWidthTestsOnExponentiationByPrimesAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=Power%5B2%2C1399%5D
    func test2RaisedToPrime222() {
        NBKAssertExponentiation(T(2), Int(1399), T("""
        0000000000000000000000000013834514851379060073245971093437442064\
        9160977983437969614705766643223075185306094487364790624541806526\
        1469876608299964693394277268648930360258831509072633846696053692\
        0615225071992089480779025598319909176616250787667116220112182629\
        2066306122745343237483669467464293469194680096834470280624398144\
        7140309400278171194198038370675489371535762220733644100930478390\
        9871197489979144724073675307870340798761005614290980492634226688
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=Power%5B3%2C2239%5D
    func test3RaisedToPrime333() {
        NBKAssertExponentiation(T(3), Int(2239), T("""
        0000000000000000000188143542653317364740047262022158266784428791\
        9275755434856235633416147929751345775198585370887106410700145660\
        6941136649945052148587729379215298759841906211465894489332805610\
        3754563980603820020778896725273833377637201111950279005112886290\
        8217517791462710719585984177457155945873475389047023763181890095\
        9473781620831209436384360444149350498181207507201081140457731667\
        8330429216786541702964381293439187677376199748692174845775469107\
        1970497833817135114559784314771606933781164789651479259636951051\
        1939631603190331045111418380453489110302905083967247056298476321\
        3031701771676257422898074561340984020468039563665625492587401150\
        2217805773793168451721091497379753074682133867791141932470210853\
        5500447924439317916852983725285062418604919143133304424502097997\
        8608095945569404820035699584592750436592636252055799816797294408\
        0379347764424614210540528598264992483071934555760511919452459358\
        8835641810301075822245153655314705395817134933252061409024669198\
        8059476349693766699090206318226803178343171280950787682695695659\
        6036250169540192297202679456092601217013126286587177412655204267
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=Power%5B5%2C4019%5D
    func test5RaisedToPrime555() {
        NBKAssertExponentiation(T(5), Int(4019), T("""
        0000001446929684346652712293854771363608770525967600083755404601\
        4957345870087500503487603669487412790514866287646265322998165123\
        7858490002304274433672147699570659505153044896486895393750640165\
        6928775867908279515437398191176238951828408573790734470345477155\
        5523461654011508905437448709888495365320237507108067589052329024\
        9150152007784011211339914449754828962361147846093684594339840255\
        4082090351870280593564461792533581515740009197746416184126376462\
        7513171712952497141572865808593203385483317716323751288867193425\
        4148468649640058864230675104524048186517447302082906408424956362\
        9758837840131897008299169989849297847761856730804217735049415782\
        9576164079541459773697263304564453838344036135321806166247311605\
        1583922759481958404593247769652134498168235251891967609838551519\
        6895367299027108368711330107798776358904935596791346512797789271\
        4896792453973244271314471709632569444905582089098918351559580722\
        6321106414034452179867244499118249751063342223759587453914686539\
        6908111618174630570000311233662035613887919737154518565754904733\
        3083185530695058035521254105752988609692725798470777630752530204\
        2599940027007370568347125202050752868479632687293640809602767930\
        3858816432201682904268147124008525621379120457219167772120301585\
        5924566379439864166360938720555906940258344296315856834431713110\
        9031510071399560194606949946938965200495181099854874459742836621\
        9452749381231066739863712410355985286770760288114233351958522528\
        9254720092509662470547270010401979793646249028556880781998508960\
        1361859999448519399006853526587504480164807765094325996443657804\
        1840647438579682202685556945086347285534115616913220314483186795\
        9505824453508868809675232062282535499100880724452941629449074254\
        8612182352672327327268400829255931466201932710759855981331047638\
        0373952548092040726975994716532293619257385003476756537912583205\
        3118439654075379854319335205290809944413949455014265873545253078\
        8330205282519080028427767192749459753122069080264973087241014307\
        2832496925258959405329022843928903214208568103866527037140713169\
        3604782550976252551168862593185575739685113169373933605227835303\
        0847072871335150103185467131343559638580148070154916235638591521\
        7551475263551504418572891033712157135476213809318196160948711372\
        5354715015499902615236138501149706494374571817673933121619689549\
        1190330835852177242160254166743595083040762847408006715353013832\
        8458452645210177792497777945236485562922497538842118636928202205\
        3232781215026991677078777075079415868972420095294308064034517889\
        5294513805950305684358059918968985264729204194891997038141044289\
        4523351216180823177725756322850045350978670133665384205423770116\
        2034072860275538780053702353667090377996048746658421230595438359\
        4351041626743397066325398137462696656196425405090145037319940783\
        4075423829513127773206584989704512568918200936953799420923277344\
        2116738501755407694565787324325611962194670923054218292236328125
        """))
    }
    
    ///  https://www.wolframalpha.com/input?i2d=true&i=Power%5B7%2C5903%5D
    func test7RaisedToPrime777() {
        NBKAssertExponentiation(T(7), Int(5903), T("""
        0004108943827532289998252241834161383961424609336721429562672973\
        5215518660156770969551613947438106226819575618431824632656548784\
        2443630744318409823032653940945721503598477652901203967391204332\
        3158222996451925544379097239021867537542941225033407598605764422\
        5626993205372457839766802826979647293572000260187726319652445485\
        9482777216365497907324653716024518534469506020670363036282940141\
        7345349149930883359235820343903927339761930696186308207677700409\
        7391771164922837159313352006942436230958342761245333909697097098\
        1962850117306746317942719737152987263783869529445450162201013093\
        7640979740872661278132106700453973743232978892847809183649542178\
        6386091024874014251100007758237318828196343521562370522840436333\
        9860937826427665567828847794223264241229145944928596285455954773\
        2336371045463929134249803534108451709651747011690640152682259071\
        7588531222847352542685069886646970884179932109354875736278011717\
        7049137345311907474904031124084012054229020837573682684449616986\
        1141963222206845750828398145035163722273565209503954216564277782\
        9345151605641026739460433186606694775097789988243538915830478736\
        2321105525900626126720677155472003434944779964774589232951904517\
        9476680111837682980783634668338283785251186754580916022872774476\
        8248487173769642087282206643072554696940829885901306725576309209\
        1743074872375459772452624462584335614850487024186238154804049698\
        4811375470004856107048221190933505123463191157187870352180325359\
        3741701718672664302615728918968015750489563267192890269446915173\
        1701093323994084381646062513005671630985001682866606254371387996\
        8024992986421373100014171354432561066598242954612339431648999137\
        9051435679527308334014939171040310771958013669805318524543112813\
        9957017193329249909184553798390058883185333407503584493257244158\
        3266967356357550201757284978687473572038818544870024112088525474\
        8571207645144242434181117672975231370371178492357391865766085377\
        3823840040081314628441473981477003917858676159209438834345026935\
        4779790020210041341578847715514924396711295298299953107848651502\
        3769622943601147847225941911366166628697715831218025798784981651\
        6594489454864735330027409414601808651740177800327884257547084972\
        2974937680043549927608417044479914400414576182906969146216064813\
        9797351302752302750367394658157006251127397997773654189941600295\
        7012943921820728784912336613928263599040635592438852410591446463\
        2206241342371241353735828614033633079948725931648022365152412010\
        6536877818941494267763684966615953104317136956765112250407063913\
        3623022142786314689201462019186500031543501414431154405127756671\
        2598842710382317599518208183440935184711587670120132882808742348\
        8411078298769546381717505913293931478168035555632794459447381827\
        1468641906416458172696166794340888092638284873221835454582235513\
        3898834466941889918244651488283379527147807349915745308667074963\
        7891453340202992598013755301769390340910183288640813995555377044\
        7223588515487024291479342125463949093313578539672841465173598174\
        6497929985814101267907129298071776716937287674794676561056646943\
        0732206345508882216332886917818007802132509658343825952463482298\
        4489495136960700641892386060280455771911594308242281539457704395\
        9524507677196150124432182309556548761806281803523338664967704979\
        3460861648738117020310880747550817881593881271702214461077779340\
        4287970525724476964313573471187561031001209171965777853627292097\
        8752509881640464168980655122431992653071443051558073785207534985\
        4321311390667792122896825769874659348335793677512574761787460891\
        0940419324785857595375679045664913268485224001615591380491428459\
        9770610934799452407468859548167516086051739430826568377985552353\
        5827900814770399339897945479367857446392755360019877423764266384\
        9102974526553855472041319878092661554915548899695716722333975665\
        7217654413703071682361274283821111835404123486866747021789194573\
        4534154982476166843306613439440924368550646996797997564717871253\
        9160649498393301802347586561673042384642389863462685684046394436\
        5346633812583044014990173666027640872684548673874459368061904085\
        1833388235372538302693052181739532042295454028340795279479946777\
        0998436672566006010388682401863627158348794580771807628351724156\
        9645262878014094496495419172431359232834857581736063818066222047\
        8022377634336210803408343245633680822509378298099363690965609414\
        4196836682956302330613169375496300657119374497326438865815833130\
        6641482714265346330788386216670657593653569569417576198111004914\
        1723667248154259119306662997353637860619174485149827167090042710\
        6471414747419591688508026916865700879769503331013550956729099212\
        7820605036546582266249968312554384036359924591010229549799331443\
        1457638460474955690746307230167670856667830295141891662843469167\
        0424763717677877513125882858810853633770618510938341766796723021\
        6826062464545717657085175787821109704957381106356345712265138323\
        0768347083961948674167484046428595865648150013889410250736872615\
        6529299656645514273099767510443083082596626167467582361833369755\
        6481100284602082844869451125548691905562882873118646312028536971\
        1732106406529921113787189197150818833289607479384389566344975672\
        7365338338792781072340541456248573682006539809213546535950220343
        """))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Exponentiation x Assertions
//*============================================================================*

private func NBKAssertExponentiation<T: IntXLOrUIntXL>(
_ base: T, _ exponent: Int, _ power: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(base.power(exponent), power, file: file, line: line)
}

#endif
