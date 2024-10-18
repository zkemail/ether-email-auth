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
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 843760952111502052158182922030134619853223950285133017055654799466206988717;
    uint256 constant deltax2 = 5451727309216008844440711320292037069866810494237222226568404966319988852381;
    uint256 constant deltay1 = 9397455591413948572249072911743076881664276476391938578421063289028906316788;
    uint256 constant deltay2 = 18109383802108609498108213024114274493555806515472453685713833244861561326319;

    
    uint256 constant IC0x = 4017015862318859143458146336807571442023478455584889838860300396069903614454;
    uint256 constant IC0y = 8554987190937552560038812851258650632016537521749780986505320889094758405710;
    
    uint256 constant IC1x = 10962353543179306682628955301200424359342843246319696985798769624289396112072;
    uint256 constant IC1y = 4948816665959748639342786912788732651675970015730818338551664637246676128061;
    
    uint256 constant IC2x = 4085946551204795040905251212200240168046583228897146839503547875917747484050;
    uint256 constant IC2y = 760559619380361824228664485961756290675668874058565607190715880431328992205;
    
    uint256 constant IC3x = 15955138510206015623967428225359842139414870172304414371624683237767202239772;
    uint256 constant IC3y = 12970494273819404159796812200099958842410712929061290472888179513316640392215;
    
    uint256 constant IC4x = 4882067230893614754797079878214312847278936375445012308177015093934356453382;
    uint256 constant IC4y = 19907109592526128245125073466082438150252618749532824069313171911099098885256;
    
    uint256 constant IC5x = 5401351015126883120480381728822821139210608932501683620221400962650233219504;
    uint256 constant IC5y = 3794525379880381885947151085319650186943206774724875800939212376711632757891;
    
    uint256 constant IC6x = 13947681306324139752857864299021247802571814860967415343826346670126788123197;
    uint256 constant IC6y = 19846654450327466530930267152540475822853951348673986107912373312857883865199;
    
    uint256 constant IC7x = 20577055680203526168774144374769256218496700573774973721620490174780807728519;
    uint256 constant IC7y = 17209806721502210618374200275053456085229222088728418124599259397636644742917;
    
    uint256 constant IC8x = 5702620594376565191650883779799867822765709307460552801288816567400694643012;
    uint256 constant IC8y = 6106489839287943233699759781980828664936333227829770736735934493374488571601;
    
    uint256 constant IC9x = 20641780541432476643112187441495281255435802480468585997271631375636983208164;
    uint256 constant IC9y = 6392003877895176152511879344287066089753033863661491605644691945807592188894;
    
    uint256 constant IC10x = 10811527815823470643854465697508846650836724700451514022879904967686728295097;
    uint256 constant IC10y = 16494823475410828853285446268375812590554194072904024097877318773388928330740;
    
    uint256 constant IC11x = 14352289154617306714609369038319490410428612050729200725262568361221608276104;
    uint256 constant IC11y = 12379802861038447823096741028682582401463750179316023507408697966299794565464;
    
    uint256 constant IC12x = 18698002565872252306566879562567307658502577004062569588269648112620007023153;
    uint256 constant IC12y = 20018629153183125100967674568859671492160997448377747939025313585721813374207;
    
    uint256 constant IC13x = 18543845204584403414748402932347599226465211782822240767877500652945746964634;
    uint256 constant IC13y = 132411133036696198836559687919358607473816917500093594769828362560893694224;
    
    uint256 constant IC14x = 12569499748502188056023798636417491488516109691122750071038827561005544399026;
    uint256 constant IC14y = 7462106999976129122745298528295246176913159815823778597137880208185057159168;
    
    uint256 constant IC15x = 16316880918429976808945509095259452751119863858977552343413662045865995949817;
    uint256 constant IC15y = 5884204726006996223600201084048586955248485633655907186469283752106938747949;
    
    uint256 constant IC16x = 16702635739317101074559138096385813199276032849383463376155692812930572697614;
    uint256 constant IC16y = 17021152060158497383306786394670520772701520956767836765058078518711251551404;
    
    uint256 constant IC17x = 20297164468875072135454455984585840918854065324311895932772783328880676139274;
    uint256 constant IC17y = 8732567502970152283371792885715644310305075196076547511141264223326157180810;
    
    uint256 constant IC18x = 12660717351248395051792072489685376076342093976678812711354517350466204559308;
    uint256 constant IC18y = 11571333968441701491127099021904566684360139589940408380538620470479500495457;
    
    uint256 constant IC19x = 7339751004023496876084350530303492430912658861140385757623799846747891121399;
    uint256 constant IC19y = 4044429999788620321250001763527566206880196497151891087980818317571366148304;
    
    uint256 constant IC20x = 15243643382317294627025954355942505736876627766110861699870810746324449682772;
    uint256 constant IC20y = 4104808491885461173983916699620315316843164670576268390788078618420067831356;
    
    uint256 constant IC21x = 10432310571960439276459116178525557929330491094163088587862213565274336548779;
    uint256 constant IC21y = 13545173814580078328279903164344064417533892679343118374405867116951192516232;
    
    uint256 constant IC22x = 21120598246702716049754823463772879020035249542542205175312138215196238679566;
    uint256 constant IC22y = 1291020220620511090462097394702948345337319961945264921209220570987701723548;
    
    uint256 constant IC23x = 588392376013822302437504031962534064297996895382255551698103348755980967129;
    uint256 constant IC23y = 10893430237725183977071462973191258073827810592491947931836968996743010144114;
    
    uint256 constant IC24x = 7764157293659293369660053366118932807496121954355651342511434885212719699218;
    uint256 constant IC24y = 8028527982561952702851233711380220376199059129046896676380167610429984358180;
    
    uint256 constant IC25x = 12032523864604534449350414565019332015852814215497378426708906631024004886827;
    uint256 constant IC25y = 15582481424500403147111468771921742729636891825512814169954096882717283199682;
    
    uint256 constant IC26x = 17582106115612569448873480731792198921997275436260078699622668185458503302334;
    uint256 constant IC26y = 2777430715045844323328275302786478938554066203810891589116650272051167537281;
    
    uint256 constant IC27x = 925523084366710631713853859359139102039643439230059617838016897741481608443;
    uint256 constant IC27y = 9519929145391137790482892923254952506176939811997537474175498317113413443966;
    
    uint256 constant IC28x = 9355725882732215512349623116616900626187305840714357653886117599101651450691;
    uint256 constant IC28y = 20810058590829990170519291167331464418670474290610889723712155133489419406725;
    
    uint256 constant IC29x = 5825910861473547355896514618604208822906908988451467284726996429430434216046;
    uint256 constant IC29y = 2535956286337242735726645595576814597905411631017904089205462003609600971010;
    
    uint256 constant IC30x = 2708040499404052797738135444842775294595116452623047343466544918306940971300;
    uint256 constant IC30y = 9806535586875942527143726239651802247960973264031385057623508807053153269477;
    
    uint256 constant IC31x = 3633362109859581914327339325949552754112721659390281896096201292698172367734;
    uint256 constant IC31y = 16821968476334727162700198344131744653567504149730433802594373287093502931086;
    
    uint256 constant IC32x = 12826983289079482719167384723662319730628661786385653158531630124676231021398;
    uint256 constant IC32y = 9092376557253558800663723403534893175165891223458784715163566495399436047601;
    
    uint256 constant IC33x = 10982666706008320143354658916431527904273150964116265556255803007169003046649;
    uint256 constant IC33y = 14429772676193160176344899886289521894840371462972179467282874386007342798288;
    
    uint256 constant IC34x = 15895573838715558957252059221101258871566360022733056662274566487782480589243;
    uint256 constant IC34y = 16904836891135821910991414754837195897407288078872269892198104242921997159940;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

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


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

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
