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
    uint256 constant deltax1 = 14784386233008920595048077630934558866623582586411442419884328384455364370206;
    uint256 constant deltax2 = 6290603912353949177270096577890711250425081775637348791274473469351769670156;
    uint256 constant deltay1 = 11167948527412530455970458333061862011172534158240288037990367063361950360819;
    uint256 constant deltay2 = 13185416231312492310470683918957975663311737621386061858158607715832283734869;

    
    uint256 constant IC0x = 21263619542713778996788860415398367608596813869337780657743924330185474368286;
    uint256 constant IC0y = 20016986896738437123542241581422521467585270135865628544771094475384975057014;
    
    uint256 constant IC1x = 21571198805623217150553519797365730486590088889675619388312667456900293011999;
    uint256 constant IC1y = 3678551958513361152025012592181477447432955332666539925072044466035056317965;
    
    uint256 constant IC2x = 3826203964938489334843652494383817850544017144219339541895430335436386080158;
    uint256 constant IC2y = 6393076789623250285412306028079931314426713083028711676124039565129253127517;
    
    uint256 constant IC3x = 21584447021606080565283967330346956849326136753802672422824192566068628153915;
    uint256 constant IC3y = 1261199723364638371668072957276424859509876825026847397248117933862343237041;
    
    uint256 constant IC4x = 3399569260784618407990621256153036638215540856855952853726597610058814968103;
    uint256 constant IC4y = 687404032594938248912548718190040022614310050624013027163241581893823783758;
    
    uint256 constant IC5x = 8817242174855800452959058327697277237932727273129982264823474259998886118899;
    uint256 constant IC5y = 745547990358815220304448569984726876247117265651197850018076755252885093559;
    
    uint256 constant IC6x = 9773950109559302870711673234338476620357989668698321824536457991633280420288;
    uint256 constant IC6y = 14533302925041308054648189747824349330580676247015117243079661877558842833788;
    
    uint256 constant IC7x = 3963682934613367021188873996000719544372782482540438980534549622426649176046;
    uint256 constant IC7y = 801536238462993076122494239659972870006991910467816286361457420946271474346;
    
    uint256 constant IC8x = 2487095520691476314470275136374330856545354854209705819692947704657070595979;
    uint256 constant IC8y = 10544300486381541309288460662341732749521370446034689659769841203729475371113;
    
    uint256 constant IC9x = 326620223728757596227554243421431251691981706620656788476938501573205907874;
    uint256 constant IC9y = 6986395496068774717839463105084280693949202689850695218356233568967446929488;
    
    uint256 constant IC10x = 5880021638199091415118842867224346924424495788206679177206313172707282749019;
    uint256 constant IC10y = 1166265341263191742371398321927281445397966036291598911375646997266647559564;
    
    uint256 constant IC11x = 18129931226992069541952142077123737860996417143560686057025609598128645485754;
    uint256 constant IC11y = 14131019629860420114163975580235773040024485558977397936691469038927144431536;
    
    uint256 constant IC12x = 12755744125857143978932600574922935751426162397594985634868876782885076156171;
    uint256 constant IC12y = 12418480364524499572581185629387446287279575899686303308439008205742001818196;
    
    uint256 constant IC13x = 7705798748509510362990708861510570607770482044434080903459814039525550811045;
    uint256 constant IC13y = 12294643682468101997655474763332459912297542715971809346745941183230862065886;
    
    uint256 constant IC14x = 4365016931665154092025767970436283666697558648385371311603353072458375464856;
    uint256 constant IC14y = 3378996817165894643714044072874502409910787564045196209333665714104967070968;
    
    uint256 constant IC15x = 12942639100973261241508418471433458313396910350707280055246165565361086272416;
    uint256 constant IC15y = 16883566451399483939940726048206736795207590921803163664190901956100912424203;
    
    uint256 constant IC16x = 16900951554610909140147222189479377967149563030075650494851922945848439154938;
    uint256 constant IC16y = 2831071635260980435010892774652225761318599214466436569746059908031333393104;
    
    uint256 constant IC17x = 21045086991208545832697470603723824632455411177388787997158483003944406740701;
    uint256 constant IC17y = 7611150055221725378329322250543425354507632193614430819455015631593956721665;
    
    uint256 constant IC18x = 4699176174916609937440413994793237802272916900741528238144061053102509322926;
    uint256 constant IC18y = 17692771579480506570623075391095404172551798163926917669587781147836847833334;
    
    uint256 constant IC19x = 2598215866876895961342026156016883715229099363462942736784529686949852145531;
    uint256 constant IC19y = 9099037230730879008428571127823686486146127341409596867149255497560502101570;
    
    uint256 constant IC20x = 6980795279209804044295589310984050515035792816859195213306659081972236138808;
    uint256 constant IC20y = 15627071611167565395787388508415046824182330376694046141037789063334945700484;
    
    uint256 constant IC21x = 19991318329169509054324908381118908733810989706554484682986656981087898608814;
    uint256 constant IC21y = 11151807388042712387799748332876052539247718759011571517468702168033854620333;
    
    uint256 constant IC22x = 7197786955835576310230622013863595572022456978202957664139282153387449765728;
    uint256 constant IC22y = 7307929232998432043303568215695279547080512060432597909299323422352066971346;
    
    uint256 constant IC23x = 21107038666325993398111883307057715881826929611399469086054570549123822967238;
    uint256 constant IC23y = 19358046509882604343296035735393686982343622871808723326223508506968704079350;
    
    uint256 constant IC24x = 21733425743886494354074785589259540093831519447981215111447931957177658740646;
    uint256 constant IC24y = 320378227520532747494170231505351389860899285148596547714153415229780896938;
    
    uint256 constant IC25x = 10807363486279526649522279602442296273796876163746157648463927482878729634814;
    uint256 constant IC25y = 1637998659150932502657930583239566566919439759060156510688537779402992343159;
    
    uint256 constant IC26x = 15757040111324664890702778276531602253630891387857810903715246887753778016641;
    uint256 constant IC26y = 6856013776266785793905331841857739093410009401943634715134261212915376925892;
    
    uint256 constant IC27x = 18553175766346853831692305237396483021145543868232800539672120632362275693195;
    uint256 constant IC27y = 14657550563005610536262461999604468583742581872657961609866691539824355348828;
    
    uint256 constant IC28x = 11307205585890781731407066743509582696655833995661404766510137435016538965344;
    uint256 constant IC28y = 2144099371502329678400131476622394151925768035082782314390950021415482758590;
    
    uint256 constant IC29x = 19863337319551832100103833561655376220229778657285914289628589118314859029630;
    uint256 constant IC29y = 19472338867331214938087160238447952612012239119574949450267961552410803459527;
    
    uint256 constant IC30x = 8371922207290736821290597463621858573798316984929092662306394953292053762525;
    uint256 constant IC30y = 14848518290051803848584558630923125749231759972312860015021014554436507470332;
    
    uint256 constant IC31x = 13570881902287311629614928096950362138730249575904851488233466324378922833172;
    uint256 constant IC31y = 18423779455926046216682826304198019248056507540857425043799964466957213586668;
    
    uint256 constant IC32x = 4759810453846148646280588932789014108299960602482129313376187206813298258954;
    uint256 constant IC32y = 12819422029154239643140464591644016635134303655591826988181005292616687182322;
    
    uint256 constant IC33x = 8225433101022329967503231819162786588654489274877868722142176993702085762867;
    uint256 constant IC33y = 5784915490119435870737229021171029732529240230987585350455092854185984360396;
    
    uint256 constant IC34x = 9421023559488812561399383302624803731724380132279383523742628428412583446117;
    uint256 constant IC34y = 20652759705519069352723256379975567044863836965792525966773816754785358072654;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[34] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
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
