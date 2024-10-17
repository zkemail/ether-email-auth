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
        1982942008217893905885189510349159854617087377486889703948887608027291145743;
    uint256 constant deltax2 =
        3046126109074457974736946012433645737212173373530769004533533524129119094829;
    uint256 constant deltay1 =
        8660768413780049142450633924043537194348509048214280083243013978552735569730;
    uint256 constant deltay2 =
        314958893626491444181486351092565283657266891589639102232256803896776190640;

    uint256 constant IC0x =
        19047966889817667407040325838976119262787185338325749375279866150743329464693;
    uint256 constant IC0y =
        5481513224626262410343459095337257883498710338118498210228983302373757842492;

    uint256 constant IC1x =
        6547552994406677774120230203597341742079003525571102736473839274433733814731;
    uint256 constant IC1y =
        3546226137996977172582441159402825430514468823809570287102382446972310928026;

    uint256 constant IC2x =
        9483182796792014939878772802553112684868803450349748369256945649185966409868;
    uint256 constant IC2y =
        21289280233779060843618250489187539192655989211908760918078211630571006571422;

    uint256 constant IC3x =
        3300511692332656678732555844641802613862493816245867550829442984147946555826;
    uint256 constant IC3y =
        1971080407467651564342039229836025995961575246358643204421954292463738307363;

    uint256 constant IC4x =
        5076881834811537354733132734720012964319051253867552729853488216903484348467;
    uint256 constant IC4y =
        12059765192323183452694292669230698677380886079479980606693327641280824916933;

    uint256 constant IC5x =
        11920205771431995349674310504585834699548653342161845522112188721446093330979;
    uint256 constant IC5y =
        4966147484325622996348740749293560179108692742382296188162182558488862264390;

    uint256 constant IC6x =
        11575022714189027379493673619993991852175972246069730541594405807299402428757;
    uint256 constant IC6y =
        5469246825170423490804868618776749142395772056635304391736761887775314030883;

    uint256 constant IC7x =
        11778544235977348237370897740003061057461900492592358473201467441889713161718;
    uint256 constant IC7y =
        17562948133322478729434861755241082803506850894993486013668810841059543848608;

    uint256 constant IC8x =
        13500736423769990138184471108680575057177714294481462091652373294212652080107;
    uint256 constant IC8y =
        21450635859553454044136350935877813938579384490582757525180265086300528361636;

    uint256 constant IC9x =
        9726833695190406979444638309355867722763989727474040913655013942474448271553;
    uint256 constant IC9y =
        11736500636668100032525279565587787715710868637249135356831060837123184014358;

    uint256 constant IC10x =
        14707484062939362885877898611115626537830589916875059026863636289546169944877;
    uint256 constant IC10y =
        2379836074320437157935069033060974828538713793751969487110567123820016406784;

    uint256 constant IC11x =
        14616984340369158750977091241321834993251840167761807627242443021500430937567;
    uint256 constant IC11y =
        109063418896775484488346766955101678549093809554838550167553978108053698826;

    uint256 constant IC12x =
        18566635811605046122901946644144415314834061778111779155581959152202942863369;
    uint256 constant IC12y =
        1881920175527772853521324547702874092378481660436121035869892293622015248456;

    uint256 constant IC13x =
        6902456510072631716155991169730354116638403485867698351965012788132108761228;
    uint256 constant IC13y =
        10374374544686118102923789115677191019834498463027139993134803374840231724090;

    uint256 constant IC14x =
        15114530131870133737763597032669479041015608895691531430427806897406924593645;
    uint256 constant IC14y =
        5725751696626007100005409916792626332609551333357434854395155238053772876238;

    uint256 constant IC15x =
        13410330191637620005514802231156216070325206860975031088033343703342688752367;
    uint256 constant IC15y =
        19297830977176099252665893216106076985182433097818972525201792748361341438935;

    uint256 constant IC16x =
        12665465062681247270505839872144987584137900676520935181971545894859879771466;
    uint256 constant IC16y =
        6813427574080956452291166747900757124656946763427922636781021884658766562318;

    uint256 constant IC17x =
        5568834286464689417262133202732963025519715591783229013979138362436264502508;
    uint256 constant IC17y =
        19502138816064111610302879220834706373256328701664640310813984207435084383627;

    uint256 constant IC18x =
        12562800437010032353609978652997288573918592556398559317006943272181970644097;
    uint256 constant IC18y =
        16572324708438141710744942941960288305467188218637496333726291795212046514770;

    uint256 constant IC19x =
        20517299775997921497266471155790625497312768011883074436755336024823358157310;
    uint256 constant IC19y =
        20738852215750711697913968548397266354148579146310099890752066617479289601381;

    uint256 constant IC20x =
        14454171759999971052722888745267564607524567222901281517152029920437717991608;
    uint256 constant IC20y =
        10176390547132508423904720646001749041872920117080003241196585511369563820055;

    uint256 constant IC21x =
        18297459480063871855735389000986820919251383347048061806722869917058054490419;
    uint256 constant IC21y =
        16435026608525292480733608803182212537323293511149521860209096491055332767241;

    uint256 constant IC22x =
        9362329500646077654250077035395849371293788507747056365028878749983491195637;
    uint256 constant IC22y =
        12572544823599596229861440945450239260760212101039825645337694463418427470686;

    uint256 constant IC23x =
        21211693985715543098568759774747353373285964752736674675712153299741408315499;
    uint256 constant IC23y =
        18081503543336417393025972011708347100987227770600659957375458776896917544068;

    uint256 constant IC24x =
        13887290964992877749693827205383636357548252340980262883202751403269681467528;
    uint256 constant IC24y =
        166303761425074262525335646080616094197406637008421215431248837680241113267;

    uint256 constant IC25x =
        5701420021516568760200198670702836107645768069261371638680177303244477337360;
    uint256 constant IC25y =
        6934014054770074138744056466153315806439170982484586856812322842003435705557;

    uint256 constant IC26x =
        10234780112069101240476767839920234156735324632788974479961992234571065851310;
    uint256 constant IC26y =
        20082345244888981681099890887006664885035474345955550253345363978295477769100;

    uint256 constant IC27x =
        5464254993866784833651797874747586198615628841090434832777729158639062542406;
    uint256 constant IC27y =
        15393818814679968873285018739028136577190897813582872673623746467476825993527;

    uint256 constant IC28x =
        18935220284067436168697945200230328512277874065636186091602164527802804496214;
    uint256 constant IC28y =
        17831980545336628920872180642516779858302173095393403317747026526385767897553;

    uint256 constant IC29x =
        21073888671336583395963569371801208977775427904371839342663182598399868666016;
    uint256 constant IC29y =
        13334036714684746380941597834261271234355412042579880813646160215291155618579;

    uint256 constant IC30x =
        14619317188873280927135234544982341184982914451264157492831521965340302658159;
    uint256 constant IC30y =
        18074611515019963883431616306987226325832928594628279588629203336411498947989;

    uint256 constant IC31x =
        18211342756142801941364316562347020832043036589654881641725075351602214143812;
    uint256 constant IC31y =
        10485000437331048457068566387238310927445953288078163083505888024539078628848;

    uint256 constant IC32x =
        7667455361929335343558911895461243503234068772387524361690582031173833145849;
    uint256 constant IC32y =
        17826895954894577935330251763099372797819831656485829810196124246607936167344;

    uint256 constant IC33x =
        12768305488366063485248669896672597989113416310187458331383971374613610193705;
    uint256 constant IC33y =
        2390525148771102472051801627212619319487088439503149478537705678047420266235;

    uint256 constant IC34x =
        7604148294066821276102385897011586722561852437859676046279446675077975632266;
    uint256 constant IC34y =
        5581480696868410975288261308093734828900333534473783761488326840692062701878;

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
