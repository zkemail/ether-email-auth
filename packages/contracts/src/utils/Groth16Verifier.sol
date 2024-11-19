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
    uint256 constant deltax1 = 17321117490467991551004039976141713368755273259054816981094885308298257468746;
    uint256 constant deltax2 = 12206727395119032572075275407523163442640631937249159592734225098709365609525;
    uint256 constant deltay1 = 4417177391410880611353118834592763024626678905178826818545984339262284861270;
    uint256 constant deltay2 = 2880796425164205982474607914269871986813613330489984606315585308781367270397;

    
    uint256 constant IC0x = 19613578381454247848148468609153373990024337494801498093921075984524147080543;
    uint256 constant IC0y = 19679656485159147880034357576194217721231340550694429843056245208166780538462;
    
    uint256 constant IC1x = 20052449153036221687572299937401285311091266095435132578335153498340904649938;
    uint256 constant IC1y = 15764417163307122469614065240362232192291517572328697755027198294221542220380;
    
    uint256 constant IC2x = 4361517835180741166515344626308622049060007638001045593444587215635621996689;
    uint256 constant IC2y = 19201118643799061914335981039124676275112293983941093735550301860322607185724;
    
    uint256 constant IC3x = 8876661120575601408049826812959595719763878999267389038360460236791625333498;
    uint256 constant IC3y = 11408196638239702010260637829946753653272842440125670418009263038135112927486;
    
    uint256 constant IC4x = 4239144839679807249062740088136704318835964394268252599125355261839612326699;
    uint256 constant IC4y = 5305729015352955614096892880070008473514985516056595021878643414352723669327;
    
    uint256 constant IC5x = 6209359433845184752441518023754219467295768715213761781519952067601204069919;
    uint256 constant IC5y = 9300024374482983486251270877008817421099686830332198268743686751353681532955;
    
    uint256 constant IC6x = 12106352208806738559239844895709244585236125664695914715895703182907405752772;
    uint256 constant IC6y = 12169017124318029069947938293568830762109203408506294175081510718204143749505;
    
    uint256 constant IC7x = 20780394989550764148402256088161661630374493293607428046910806329309032750020;
    uint256 constant IC7y = 16341246603919770827395793332837619123496041758688559121949577020747410740066;
    
    uint256 constant IC8x = 15273319685285300222061403474341956813625975413923991163073854032157409432542;
    uint256 constant IC8y = 13934881112826992721068177636581665370208256355674730445070453023022897818665;
    
    uint256 constant IC9x = 269883730317641118471454602280297193522715547266189568215262161691355396617;
    uint256 constant IC9y = 10579523671127870981324428930871610698697199332504112952913935688156838061436;
    
    uint256 constant IC10x = 15111720043996775547713630069493963041953312032250805602669920240778353496821;
    uint256 constant IC10y = 17989754330060974481869521730703295915420829292748691869649062021951031371064;
    
    uint256 constant IC11x = 14309709138812924151496804149663234196517987779452581957826923427186324508466;
    uint256 constant IC11y = 837564419038165927572233024557522340451880222689623753927716929766721822671;
    
    uint256 constant IC12x = 10321198050713737286170261705402053793625935903140320789889366321292914251208;
    uint256 constant IC12y = 4524416596287920392675000779441485998355015958867826264807157325136243801801;
    
    uint256 constant IC13x = 8676292686822308711756028186506093866012138224700264771038267765026451550597;
    uint256 constant IC13y = 18969591884459718843910524676874201450616288035619279382729639384728200508616;
    
    uint256 constant IC14x = 15563542753094730123101169924291055479710918417215433030518219966471148128151;
    uint256 constant IC14y = 17111989507874615469628834743237220942801630385676523374878722472431595036581;
    
    uint256 constant IC15x = 5509158201572470332907095600723763909057186852110620187003814815954837361777;
    uint256 constant IC15y = 14311147044839837160066318525388156132525662071848030002355307403690774376097;
    
    uint256 constant IC16x = 14677743861372785820161151384220897789625254753896556246859891915913603504306;
    uint256 constant IC16y = 1429215591329653255001162130636255241911946736663016835912667541984025166977;
    
    uint256 constant IC17x = 8330186929780175733196396762124227608381163961173800695023464516247486333263;
    uint256 constant IC17y = 4597254121875995921390507919194438594696876097442425656270240724488166574710;
    
    uint256 constant IC18x = 14368983875670204746503693769930434933153164318252156418865233460373122990571;
    uint256 constant IC18y = 10680359054182279337819246384127370429967400645228614505289030767934830336475;
    
    uint256 constant IC19x = 2412714978665454349001966685910328283720162252476680242398512702173047691731;
    uint256 constant IC19y = 11885856244776875594242344088767217187536932814943264630115201914669944275197;
    
    uint256 constant IC20x = 18289231848126275227577863148521314660781498938707070617828304112905647968715;
    uint256 constant IC20y = 8513932016374398177043257859024450141574205800853362921137786684488025096959;
    
    uint256 constant IC21x = 11204496744439255005167888881955294182201674714572088918166576037933634669201;
    uint256 constant IC21y = 5954132986264800569399428708359117857207034336062600579463301755579456053780;
    
    uint256 constant IC22x = 1579436161381136948037312549427982862867142445956843001422244845405511915973;
    uint256 constant IC22y = 11270016119244540030245230838492838401037777449982924630237306346053235677476;
    
    uint256 constant IC23x = 19222425621733822408665255021639433191626781312130349499870495696798642594450;
    uint256 constant IC23y = 18626154357239088324211752510289613809361903867026572709226587397740785436454;
    
    uint256 constant IC24x = 9043465757034661879127749573004202958761045369253982299243691087808173452700;
    uint256 constant IC24y = 15858196034482479542868339952979980853295216375615500956111001748997632082783;
    
    uint256 constant IC25x = 6917402819437793636040222189729201861581384771715620553749805837959641939049;
    uint256 constant IC25y = 6041609440566157668537907200592715465452263725722577850002365652281187363646;
    
    uint256 constant IC26x = 20421907491566831010057929508425834000183320273949928342681253375534821855774;
    uint256 constant IC26y = 9233228711350515434396055181583836719834685746449974659541706695648528554673;
    
    uint256 constant IC27x = 1817862696055069434606208047668389481945798272780116639601259183341357367548;
    uint256 constant IC27y = 20474784378402300555574024310151799509654179572885655462796858927365879570596;
    
    uint256 constant IC28x = 20412382334653840408741372931822166569523675681492549089987127447923660099190;
    uint256 constant IC28y = 2615852020450208508170048463579025570053217852769146340153323228316693486419;
    
    uint256 constant IC29x = 19322897614335540496155566349033616210890856727051642283922882740789415044519;
    uint256 constant IC29y = 5329476994034592291783990066575595810349071013010990171460281424177145984403;
    
    uint256 constant IC30x = 14654941388315187356240834653008968740589619812848216128964007208951143921496;
    uint256 constant IC30y = 6842213503427756213451745362778229317550540666290695532745346632315605527377;
    
    uint256 constant IC31x = 19452447505252996167969632489303247089274474143229604415951002887777739336153;
    uint256 constant IC31y = 11755045308581471821100871107652961200377962670420150703890212992989408956552;
    
    uint256 constant IC32x = 16051822794119353044809709223388793424030383242597414626613716386341732708154;
    uint256 constant IC32y = 2563323817812875962821888876003755618429526614758447054208353391126076067627;
    
    uint256 constant IC33x = 19665898005128799077002736538398936679532383659852546423033234091085747243971;
    uint256 constant IC33y = 16872339203740752897816186177273626330644745948744098356754727104027249273282;
    
    uint256 constant IC34x = 2313636355664267900891158409780312400641397608951873414354429704076959945753;
    uint256 constant IC34y = 16242744344345043419668293386869828290431287925635551708181153382960812327795;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
