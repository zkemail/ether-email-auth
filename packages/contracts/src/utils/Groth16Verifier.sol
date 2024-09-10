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
        520994677997493400810773541476499788644902082984396453075685762761831850120;
    uint256 constant deltax2 =
        10213897956116323293360574495863850733565743032313310303301962890191828600579;
    uint256 constant deltay1 =
        7932164237875706492467150825847531456461165832347520966415283522471937964900;
    uint256 constant deltay2 =
        13933167949481980812622491915190180689983098052228504440538951968850456401091;

    uint256 constant IC0x =
        5535234085311902579901349478459196637795058221120958134445592343488246156733;
    uint256 constant IC0y =
        5306640240432430234979242614873688760288740315547161616274789884917660992367;

    uint256 constant IC1x =
        10707387490009252629078273089029959904307706408726467155680696001386854048915;
    uint256 constant IC1y =
        17653533518649258839749460334216534095963029303372459441511113120126665109653;

    uint256 constant IC2x =
        20865571486499188594003814476515099918525806346210086833881258772408663191533;
    uint256 constant IC2y =
        7888240421702647837386220931474009495401756148617371230939296514314837098271;

    uint256 constant IC3x =
        1912978194609077207430131695891867170745002253126750956906023142956794841865;
    uint256 constant IC3y =
        17615941814906629303790964184866269246906472609406726939478790210268313990051;

    uint256 constant IC4x =
        15066418251539359853074143581365946179824576559935306245174822608350324474776;
    uint256 constant IC4y =
        3268372113574542796802111569975146953310662150883456386537997506424333670939;

    uint256 constant IC5x =
        16726903819494555062907147643613770035747444680904544904305313872617709937814;
    uint256 constant IC5y =
        17101225626470597533777593163737774333478931604126018373298094394038436070638;

    uint256 constant IC6x =
        20641928936490067347238549514729636898746687294162031430805590421560903783440;
    uint256 constant IC6y =
        67121451455228913817899520547955848577485738949760740559721896890970176103;

    uint256 constant IC7x =
        14545357897180104829942737321629647336974601349904876305377785895976088498628;
    uint256 constant IC7y =
        16314295394308016823245804523460668622871621620058982289202172672703214642909;

    uint256 constant IC8x =
        21739153088746313904366793933727782582174946747904879487285317254557443015329;
    uint256 constant IC8y =
        3132175803297520185172383705548796916566539464602625887509031362173771022843;

    uint256 constant IC9x =
        20333233803298528081912583132659619517672056679176472634300802350468027326361;
    uint256 constant IC9y =
        6238837794343377502421946404928002513039151091738403488064287245988205748593;

    uint256 constant IC10x =
        16418874123357333544592669082833232850459535832174384729993255430764462500486;
    uint256 constant IC10y =
        21771971202968985066744191573424980335377073332855742387685123535002522571529;

    uint256 constant IC11x =
        19451975215864606845692411747435064359921385769371233821650301822958164252383;
    uint256 constant IC11y =
        20892514595722901078388943250566322962503399436888984708776669059327181439790;

    uint256 constant IC12x =
        7890932830092388862341624941690789312256479754725115142819338325966740669428;
    uint256 constant IC12y =
        4418832493543398820840947134519317894746836913806654901909239755962388809991;

    uint256 constant IC13x =
        8199473712814016100135467002253188985688335051507321176911775440880532334952;
    uint256 constant IC13y =
        15997818842062211202600134971063758566999644777722172606469491329666812258276;

    uint256 constant IC14x =
        12137522381148387733238329761055359894311504591070198713455315089652636842402;
    uint256 constant IC14y =
        21339188004338495042416918774038965889032101950904198621697204175535425843091;

    uint256 constant IC15x =
        20499263784776697905943622542054972660913496529317877469532325036659142860841;
    uint256 constant IC15y =
        11428736355199483131940447330380125032711949052439215155046658645463458617674;

    uint256 constant IC16x =
        5754299204496299424940297228286983528858894010778459654161035126221861884425;
    uint256 constant IC16y =
        184143361306450555375946116665530361251584344793605929804900169497536069657;

    uint256 constant IC17x =
        6863685095405518858940222663610976520118803865048723755871419028593531099958;
    uint256 constant IC17y =
        18102099448859799403953336894017457656590279241400870825068223761138751757204;

    uint256 constant IC18x =
        11617180898926442769507234462139371394680677212983320064407531026440672878535;
    uint256 constant IC18y =
        4231987035195694511291113860396316866846277265956849978459149363401736899419;

    uint256 constant IC19x =
        6338405922510297847509581085618085787266710988385331069423772530751893351108;
    uint256 constant IC19y =
        2369188132617549234166848605509335807620667833570812871717711881712251941471;

    uint256 constant IC20x =
        6534724304493884898998457959752744402731711456639277994605971968266824841921;
    uint256 constant IC20y =
        3616930696544290755224333216672259977980824937811778199173736509869170686624;

    uint256 constant IC21x =
        18296109485859597664201013922077450611537275721380521453297622562810889903055;
    uint256 constant IC21y =
        3895545879384074505865915948837152152498358964611960941429309095904181030693;

    uint256 constant IC22x =
        12343813894528681582898501974195928908758133920463632788058140152731464749914;
    uint256 constant IC22y =
        21505758529614139837798769683411075306857597005036383220173003789253857347751;

    uint256 constant IC23x =
        16230461810715823239242025482008567032302510218301798998030587563164759203923;
    uint256 constant IC23y =
        1994949152609869198152052650904921912838643069265165983919780834335733459441;

    uint256 constant IC24x =
        373995982353912590050571385234870501485812926774804412495284185340492728591;
    uint256 constant IC24y =
        4424414072575513799911234230042788376840811362954861538886070866583770853757;

    uint256 constant IC25x =
        73053181031153871276946499443822334078747902352960726679539712950424139587;
    uint256 constant IC25y =
        1540570167066699022838327597833448980761202822749917678465275227142577692420;

    uint256 constant IC26x =
        19743666564083954842724375605301868007217803605683850153936265256536005058028;
    uint256 constant IC26y =
        17989815625617579036436769970865806048561975460718195347202285390279820435349;

    uint256 constant IC27x =
        8021544724659208314956854536191758170410161794829262652377062879718582077619;
    uint256 constant IC27y =
        11242343205078067027061957056593092382351538151124811098324850161004134673555;

    uint256 constant IC28x =
        3078234746564587714000443808454353377587938001919200323959521327347201776344;
    uint256 constant IC28y =
        2745006783235117142840024866060647109576786923760899534870847030757937709480;

    uint256 constant IC29x =
        5964844476592478242407630507799027172948004079052748175556332403023505609276;
    uint256 constant IC29y =
        12768841436519508981792953013446512028720534352691237119399120037998541137224;

    uint256 constant IC30x =
        15371609663317589294806761513526368989695520686639615266578243336031459611909;
    uint256 constant IC30y =
        16994646314587748959724789317702812017993403087486552388242926535433658915883;

    uint256 constant IC31x =
        6683739596768676873248624858087923536398042926812221220245863544486923422711;
    uint256 constant IC31y =
        12457051898274801033654726559510059327583138828424088437950360209133530872938;

    uint256 constant IC32x =
        12960094561130886505165854876806731618571707898820633243029947918452735526807;
    uint256 constant IC32y =
        6820833146511263887962056926524443259150994889983748875463240028627107473405;

    uint256 constant IC33x =
        996044632338712992107340240713239518089208404641712342335139731510181571935;
    uint256 constant IC33y =
        273204942495896233059800495345764298864994985906625498267135262620807809339;

    uint256 constant IC34x =
        1813777432174456228797740790983800618055554859202869474902366329763076454717;
    uint256 constant IC34y =
        18263062241351175416183473322099225631153099284041729083414647404711496873274;

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
