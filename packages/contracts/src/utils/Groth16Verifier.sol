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
        10433082117781289465772979793225448958552973147056379387107424694719430078183;
    uint256 constant deltax2 =
        7275826864108750902980191877201544327099639445097295071715716197584022501217;
    uint256 constant deltay1 =
        12045503589921692978672400276439014666986009309508030338062238114576580523348;
    uint256 constant deltay2 =
        5167266045144281780726036397587954855586209241615262341293096620571928275241;

    uint256 constant IC0x =
        14420976692606365609454257135434328632805959473973286981673284088060119898838;
    uint256 constant IC0y =
        3237727173942946479267676846429217525953135300179916547171195052204761246016;

    uint256 constant IC1x =
        11242243116165410418833602736488883618535128769898487771024836696023857465078;
    uint256 constant IC1y =
        3944125875514495469428761178435611665072101970023736373804875966482548972424;

    uint256 constant IC2x =
        13444687970779241874983655345748698054742845164432935489947273666155122460289;
    uint256 constant IC2y =
        21224652167029042637908968340315123408212528634456523234010312093840631034658;

    uint256 constant IC3x =
        6223278095306548402665889948737566703639314941454342116499455309193776009394;
    uint256 constant IC3y =
        3166189940732838088289487889047362887677679902266639433494062252267843006033;

    uint256 constant IC4x =
        10816631512908557343349023271022520591434729012608504881463056258162562470478;
    uint256 constant IC4y =
        7553268499036051315278338406042049999218595304176271777756017758867657854668;

    uint256 constant IC5x =
        4071416866028362268560008820862586961030580397814903526444213717756336978375;
    uint256 constant IC5y =
        5882120478213084184478310869582676016227773303131677302373100370040076790180;

    uint256 constant IC6x =
        11734717795004643123638327357128685172014034657612399074715429226722658631266;
    uint256 constant IC6y =
        16373602507399860749002874686406539840487965214428380629195095307329304471831;

    uint256 constant IC7x =
        17995242574665353969882544970809346971980578867255316834879417403787422177779;
    uint256 constant IC7y =
        19598869527810550137301357794896707958610742032745888008070796990675647167438;

    uint256 constant IC8x =
        15333007330168660247285804146177263702283991094081656975888675677742499858801;
    uint256 constant IC8y =
        3622983327849337081794030911901750861761088652919413360963959440884276356515;

    uint256 constant IC9x =
        14592598453216971911118910753077725013203270532742585163748407745719533451518;
    uint256 constant IC9y =
        1732486974024268892903158999835737802052796658580804609834621732126532847367;

    uint256 constant IC10x =
        9608760299311764957965020896382267062379773438090355782074251684342995171221;
    uint256 constant IC10y =
        18768971212393705710205169899071271227246850342771830091251994505002517649543;

    uint256 constant IC11x =
        18229713854414772793917571039862241859243290635273907596834836608693704592373;
    uint256 constant IC11y =
        1354957943711196195900175201625492118583365814055323140317564226352214552501;

    uint256 constant IC12x =
        4540048316384448988784022044695474025704244408393204872837050282034324974955;
    uint256 constant IC12y =
        12889131931011399139025112922332330923524276708703486137710524916145921772003;

    uint256 constant IC13x =
        10260170402680733092165416374102715050316461777911507389592209476741076666114;
    uint256 constant IC13y =
        10621497058496187206533851857372855187411269122792661496327887622312773096373;

    uint256 constant IC14x =
        4211461709999443083034879779565627271437397337531026812125070026750873693080;
    uint256 constant IC14y =
        18467608266766262084409632308104903215532489446465294776664019514313833622275;

    uint256 constant IC15x =
        9139115676316577941242771581653053080955401927531325123468615971408706509241;
    uint256 constant IC15y =
        9164313109700564988896172664560830764060639180869132590006516315434795315437;

    uint256 constant IC16x =
        8055062813885465561166049536110231123741745748861232693686007271655092618041;
    uint256 constant IC16y =
        4510221627106525233912238941858162972422084397106560474450183916928061274103;

    uint256 constant IC17x =
        1507186560667512546403688953670998250315628457214357234952217475451563331987;
    uint256 constant IC17y =
        17071593518480573061174595519667499531902707878706006270613337175041459137032;

    uint256 constant IC18x =
        16762847668396014973033660303062581513242379616013803571550493698889447450812;
    uint256 constant IC18y =
        17006420456782153650908127824637694821957086423954188936477697337268237314792;

    uint256 constant IC19x =
        17577663376594144399743129857840103856635877754916782842519048073412103543225;
    uint256 constant IC19y =
        21284834289036339572765424015780927653463792202070493220185327060720557536153;

    uint256 constant IC20x =
        16974417587802350668283436092050410822135612040525093207677793563266434898899;
    uint256 constant IC20y =
        10577911945362631640255946262746706583221370481437827188366150551549490701563;

    uint256 constant IC21x =
        7648089745961110787060572088126537400868566614244157722652493282774570897306;
    uint256 constant IC21y =
        5771535376772212949945259105932244016275600714895136777592719710059589930578;

    uint256 constant IC22x =
        14921736432665742630629608167623006910311804948046840596497195761330490353359;
    uint256 constant IC22y =
        14215720104074512767679668828223147475518903442603114867950535356580700634265;

    uint256 constant IC23x =
        14807951812496054917199644721274028450973199590549199626326743360499724939100;
    uint256 constant IC23y =
        13396573693115293914922022639761946049996991749562789764893885956377368829023;

    uint256 constant IC24x =
        946959077341401468258673477010661575493350299894729588837485560993685482032;
    uint256 constant IC24y =
        20570356357018532028601279688731350534146086904670254722628961938492868330345;

    uint256 constant IC25x =
        2148991523060877253038248533639729462350984432768284099241119419519252893539;
    uint256 constant IC25y =
        19770588615554020041636512722294181393662192009340177424932751009199907422519;

    uint256 constant IC26x =
        3747878854274778152623809873153099102641291773237420658483003597255752380852;
    uint256 constant IC26y =
        9101065225212227091551571514843375002653632703977216400939979268283954265300;

    uint256 constant IC27x =
        21031066699877095106651494566013301499428447799745230410837452349553101774320;
    uint256 constant IC27y =
        16064211054461593402319195858630318172586733205260338032143803066661211213772;

    uint256 constant IC28x =
        7134851187269606902216669356694699867879169670464902433281001074684321873924;
    uint256 constant IC28y =
        8200092285454074110879487215112662564626493123135666536713788988496182625169;

    uint256 constant IC29x =
        16783075251656600287266260045074464061567969583063942600473764372418413016777;
    uint256 constant IC29y =
        16335574261246374092454229631189633336308135807569085967237651070836039968818;

    uint256 constant IC30x =
        18767147382384409410413363730064028585638124996514027800481404559552256526;
    uint256 constant IC30y =
        5893729199256651364790555780931353184898130539524140758522955719432990189455;

    uint256 constant IC31x =
        16673100255008534170974248428282891797220989026129402665363975376767488775417;
    uint256 constant IC31y =
        11242595605003176651284733632654591951414346866379786815099235732235467678271;

    uint256 constant IC32x =
        14304354639208062657751514661745433699866474083874289024775056731428339652996;
    uint256 constant IC32y =
        21067499116906247821838563471313426612497479641552212451088084053907374443686;

    uint256 constant IC33x =
        14695351664477545562934225515932933391739717812930861530027307263509227127839;
    uint256 constant IC33y =
        13797285223976228908447726624003414144346497900738839904003106351418953773996;

    uint256 constant IC34x =
        16696383166685664550749463360579321447259768183797789828152025370318762267913;
    uint256 constant IC34y =
        5539498916849826447504399176766255291145081992895211478547376199843753155197;

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

            checkField(calldataload(add(_pubSignals, 1088)))

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
            return(0, 0x20)
        }
    }
}
