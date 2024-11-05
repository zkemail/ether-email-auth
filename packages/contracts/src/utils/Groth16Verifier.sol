// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax =
        20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay =
        9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1 =
        4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2 =
        6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1 =
        21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2 =
        10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 =
        11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 =
        10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 =
        4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 =
        8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 =
        5497488235179473826828684387336498481269856448745725476449758558899122533965;
    uint256 constant deltax2 =
        4003153155889817328460023080016930336723532885689205290620422457794938611877;
    uint256 constant deltay1 =
        18315354651962278644845506881891113119054778749068091769665326968932369037073;
    uint256 constant deltay2 =
        21098611876989822455957506930132954763752169279648301152081784213815758941363;

    uint256 constant IC0x =
        9170617522866991135920485929060945961251903707439116464009103514785703018722;
    uint256 constant IC0y =
        21464668013911866124563191908999294995464566429237314295942207031454516302123;

    uint256 constant IC1x =
        8036698806103763640351502391006481935487865878289833393815794668836536153167;
    uint256 constant IC1y =
        13596639679061071633812079299877222850807480030873626881735523275070865893057;

    uint256 constant IC2x =
        499506615085385319550600819547038712066288500371838317885514224486277713046;
    uint256 constant IC2y =
        18122501973397572280523052679560581860450255803082322647610830104242737040547;

    uint256 constant IC3x =
        16027020211893007538458223254125476146596225011320323167351093627291965558474;
    uint256 constant IC3y =
        20898438163660952821715072153405033904082580408391343581266941097136380340202;

    uint256 constant IC4x =
        17797428184725397522989067964088125681422143297689241282215813176727518015314;
    uint256 constant IC4y =
        4873693227630449792291352496013411166085222578702675914989902281431159727425;

    uint256 constant IC5x =
        12023745408722526643528949957434555547940449565910300230914721190107978063692;
    uint256 constant IC5y =
        7113510604640248866229327602140012470092520724668151899773219017541006499297;

    uint256 constant IC6x =
        15092867219733677231883227116417357592793695380712213807744179224782743690589;
    uint256 constant IC6y =
        14073738731917256064323792082179332493257848781058843897946309361960073327978;

    uint256 constant IC7x =
        3684741090613658947708742012848533383585720001368047937575886240445033851906;
    uint256 constant IC7y =
        12207747334874542453080362673676466829579409088542537082423635827245088128272;

    uint256 constant IC8x =
        19002324477985922167064744385878968732899209399143060380793149556026251592602;
    uint256 constant IC8y =
        4059961567391272264685529975466168592722724488333375025668990370066233646166;

    uint256 constant IC9x =
        18119862666587048057671133841224298259438630983276244986744261806380749837773;
    uint256 constant IC9y =
        11962479760502925616694601274223949055656714994982269820791207291024000632609;

    uint256 constant IC10x =
        4837987697990457908433233670645319075873778433938647361721602242125452738030;
    uint256 constant IC10y =
        15236268659498569797075030548022359846010902866726138387738164423503072310707;

    uint256 constant IC11x =
        2247396818182013430087036496942142214752772542649703327806617027071497917942;
    uint256 constant IC11y =
        7230776950211947694928844765804460712717757707661339065648508460015655104228;

    uint256 constant IC12x =
        12713866304006001178181591584880622511186107746653655885620366199651976233161;
    uint256 constant IC12y =
        8503403690339164684791321070468528510206988145312360891509303133763745413970;

    uint256 constant IC13x =
        18786348310700161544409631041798363545102509830963516511899026172253149396332;
    uint256 constant IC13y =
        21500707182197186213030353100630787487264113882577328681154515012353735900843;

    uint256 constant IC14x =
        19744710172151809333993281803386438409947096275265004935622878676630675470833;
    uint256 constant IC14y =
        2576981868538969889173351250763305912513432113413525575578065236377800875822;

    uint256 constant IC15x =
        3206564470727573087917372342973225125555287399342021084149838990642821371127;
    uint256 constant IC15y =
        5161383469468878225198418179083564775190127925714644111334764258425279357217;

    uint256 constant IC16x =
        19800719324327815136401634331189026968197343603735164559359238874592683083541;
    uint256 constant IC16y =
        15353409434530944340514132291821683791468326075312829060336930345885204539706;

    uint256 constant IC17x =
        3640440581565461755502514856833693195947470325337339914156654321867531155465;
    uint256 constant IC17y =
        18079282812947186632120156585970526079738045461684618442425751105696328516097;

    uint256 constant IC18x =
        10893763966492325670332807228126944020670778202517987145728964637567836758346;
    uint256 constant IC18y =
        10411790247488882499382877703586711529597727515468034179207752283364566985888;

    uint256 constant IC19x =
        4764427752328278744254518251166003976466653421436809959915751631447496050938;
    uint256 constant IC19y =
        19077753055984861715512342844683789209011005809457938960067599507730134463681;

    uint256 constant IC20x =
        19239217140206655417849511896762436383483680427288929636227826897033073930831;
    uint256 constant IC20y =
        325669322205419711078742210764058451859960204265448263589903725256769719908;

    uint256 constant IC21x =
        9046949632757385439211234657284735159060916785506782533392679376767484273311;
    uint256 constant IC21y =
        20044713591428591732634085797466932645663425416025585843668452500891354065874;

    uint256 constant IC22x =
        16596559512784641563136311168565033649965163504772478406283477546552735512444;
    uint256 constant IC22y =
        18774916477080192640977299596116488820879582886257295797472287704487118274582;

    uint256 constant IC23x =
        11065920011030170977088976300578864595621412015518607945690661420939547443287;
    uint256 constant IC23y =
        9783662703088180423518052023535664031839193609219041737685439910536024663110;

    uint256 constant IC24x =
        9425175894243140889465318007705005738526030710167099033209810247905244108455;
    uint256 constant IC24y =
        20108686730560795297992101621420823068690965693475885571800874269588037486848;

    uint256 constant IC25x =
        6609840993179990263963690359015759426724737820953411246704701817106482402765;
    uint256 constant IC25y =
        8229882515191225544586553421357621578418249956862953960306318915181230001321;

    uint256 constant IC26x =
        6217618480062881120509048997150849300692609908856364032921701274211185432605;
    uint256 constant IC26y =
        17797067728027591123982021819619850181346889026541414686916538486686336569724;

    uint256 constant IC27x =
        1167682482959817892490769846144428259164241510916012050018984311559474630505;
    uint256 constant IC27y =
        4288329427112040042914279815845143159445276063584132207380270762778849241945;

    uint256 constant IC28x =
        5415115331131793084519828832117894467078578382634776057559235045636691870013;
    uint256 constant IC28y =
        294500291396098324360741728286526924810064976792973340408461656451862732414;

    uint256 constant IC29x =
        14856578790154174007849553677467062531597996074804148901675028113916393017677;
    uint256 constant IC29y =
        6361029624624071755451013494330930602310752529446989393421427506813362412640;

    uint256 constant IC30x =
        17962991793243414860245089352956560187894972850467815106957643891422523715958;
    uint256 constant IC30y =
        18841505088866678579127925206390276772822034114801476039320216285471834301092;

    uint256 constant IC31x =
        13846860298119975507726775645108672548648502244874250861778555730227332305060;
    uint256 constant IC31y =
        657667593986857792918295730942299182651889534697927169554073515375088513619;

    uint256 constant IC32x =
        20870099023226942480166036035118260888733585326446307013318721811253039624277;
    uint256 constant IC32y =
        16200956906397254163030543075393672323548410478543768674895989718450369275888;

    uint256 constant IC33x =
        16368783358795172690167609997311543188986742122336668117233901650756123609986;
    uint256 constant IC33y =
        16566438916809530207078763106488760552869428102855514589370790379158565723484;

    uint256 constant IC34x =
        2230845793580325981748815021422651861534270868481069377891033264104263784264;
    uint256 constant IC34y =
        11702184962308460081167560437631611976965156120031396153640734755006168447805;

    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[34] calldata _pubSignals
    ) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x

                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))

                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))

                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))

                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))

                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))

                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))

                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))

                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))

                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))

                g1_mulAccC(
                    _pVk,
                    IC10x,
                    IC10y,
                    calldataload(add(pubSignals, 288))
                )

                g1_mulAccC(
                    _pVk,
                    IC11x,
                    IC11y,
                    calldataload(add(pubSignals, 320))
                )

                g1_mulAccC(
                    _pVk,
                    IC12x,
                    IC12y,
                    calldataload(add(pubSignals, 352))
                )

                g1_mulAccC(
                    _pVk,
                    IC13x,
                    IC13y,
                    calldataload(add(pubSignals, 384))
                )

                g1_mulAccC(
                    _pVk,
                    IC14x,
                    IC14y,
                    calldataload(add(pubSignals, 416))
                )

                g1_mulAccC(
                    _pVk,
                    IC15x,
                    IC15y,
                    calldataload(add(pubSignals, 448))
                )

                g1_mulAccC(
                    _pVk,
                    IC16x,
                    IC16y,
                    calldataload(add(pubSignals, 480))
                )

                g1_mulAccC(
                    _pVk,
                    IC17x,
                    IC17y,
                    calldataload(add(pubSignals, 512))
                )

                g1_mulAccC(
                    _pVk,
                    IC18x,
                    IC18y,
                    calldataload(add(pubSignals, 544))
                )

                g1_mulAccC(
                    _pVk,
                    IC19x,
                    IC19y,
                    calldataload(add(pubSignals, 576))
                )

                g1_mulAccC(
                    _pVk,
                    IC20x,
                    IC20y,
                    calldataload(add(pubSignals, 608))
                )

                g1_mulAccC(
                    _pVk,
                    IC21x,
                    IC21y,
                    calldataload(add(pubSignals, 640))
                )

                g1_mulAccC(
                    _pVk,
                    IC22x,
                    IC22y,
                    calldataload(add(pubSignals, 672))
                )

                g1_mulAccC(
                    _pVk,
                    IC23x,
                    IC23y,
                    calldataload(add(pubSignals, 704))
                )

                g1_mulAccC(
                    _pVk,
                    IC24x,
                    IC24y,
                    calldataload(add(pubSignals, 736))
                )

                g1_mulAccC(
                    _pVk,
                    IC25x,
                    IC25y,
                    calldataload(add(pubSignals, 768))
                )

                g1_mulAccC(
                    _pVk,
                    IC26x,
                    IC26y,
                    calldataload(add(pubSignals, 800))
                )

                g1_mulAccC(
                    _pVk,
                    IC27x,
                    IC27y,
                    calldataload(add(pubSignals, 832))
                )

                g1_mulAccC(
                    _pVk,
                    IC28x,
                    IC28y,
                    calldataload(add(pubSignals, 864))
                )

                g1_mulAccC(
                    _pVk,
                    IC29x,
                    IC29y,
                    calldataload(add(pubSignals, 896))
                )

                g1_mulAccC(
                    _pVk,
                    IC30x,
                    IC30y,
                    calldataload(add(pubSignals, 928))
                )

                g1_mulAccC(
                    _pVk,
                    IC31x,
                    IC31y,
                    calldataload(add(pubSignals, 960))
                )

                g1_mulAccC(
                    _pVk,
                    IC32x,
                    IC32y,
                    calldataload(add(pubSignals, 992))
                )

                g1_mulAccC(
                    _pVk,
                    IC33x,
                    IC33y,
                    calldataload(add(pubSignals, 1024))
                )

                g1_mulAccC(
                    _pVk,
                    IC34x,
                    IC34y,
                    calldataload(add(pubSignals, 1056))
                )

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(
                    add(_pPairing, 32),
                    mod(sub(q, calldataload(add(pA, 32))), q)
                )

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))

                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)

                let success := staticcall(
                    sub(gas(), 2000),
                    8,
                    _pPairing,
                    768,
                    _pPairing,
                    0x20
                )

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F

            checkField(calldataload(add(_pubSignals, 0)))

            checkField(calldataload(add(_pubSignals, 32)))

            checkField(calldataload(add(_pubSignals, 64)))

            checkField(calldataload(add(_pubSignals, 96)))

            checkField(calldataload(add(_pubSignals, 128)))

            checkField(calldataload(add(_pubSignals, 160)))

            checkField(calldataload(add(_pubSignals, 192)))

            checkField(calldataload(add(_pubSignals, 224)))

            checkField(calldataload(add(_pubSignals, 256)))

            checkField(calldataload(add(_pubSignals, 288)))

            checkField(calldataload(add(_pubSignals, 320)))

            checkField(calldataload(add(_pubSignals, 352)))

            checkField(calldataload(add(_pubSignals, 384)))

            checkField(calldataload(add(_pubSignals, 416)))

            checkField(calldataload(add(_pubSignals, 448)))

            checkField(calldataload(add(_pubSignals, 480)))

            checkField(calldataload(add(_pubSignals, 512)))

            checkField(calldataload(add(_pubSignals, 544)))

            checkField(calldataload(add(_pubSignals, 576)))

            checkField(calldataload(add(_pubSignals, 608)))

            checkField(calldataload(add(_pubSignals, 640)))

            checkField(calldataload(add(_pubSignals, 672)))

            checkField(calldataload(add(_pubSignals, 704)))

            checkField(calldataload(add(_pubSignals, 736)))

            checkField(calldataload(add(_pubSignals, 768)))

            checkField(calldataload(add(_pubSignals, 800)))

            checkField(calldataload(add(_pubSignals, 832)))

            checkField(calldataload(add(_pubSignals, 864)))

            checkField(calldataload(add(_pubSignals, 896)))

            checkField(calldataload(add(_pubSignals, 928)))

            checkField(calldataload(add(_pubSignals, 960)))

            checkField(calldataload(add(_pubSignals, 992)))

            checkField(calldataload(add(_pubSignals, 1024)))

            checkField(calldataload(add(_pubSignals, 1056)))

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
            return(0, 0x20)
        }
    }
}
