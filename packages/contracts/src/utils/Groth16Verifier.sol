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
    uint256 constant deltax1 = 15418110080820013669253107675502128654698572053997173593082714834865051606257;
    uint256 constant deltax2 = 1907622746412844211136981063070839497406918328510253002973298620002308469569;
    uint256 constant deltay1 = 18021385501379474150804291241916330981274711364980042203707535194096814020132;
    uint256 constant deltay2 = 4675550816637672277457419416573240521810401248222250227030288018021716768433;

    
    uint256 constant IC0x = 21167307464475671874013002756245468935398515148601438589567763893982720136960;
    uint256 constant IC0y = 7024058235119571004939830099328225475326040462557034617021365965245177947848;
    
    uint256 constant IC1x = 2917168322535615343088284066609491759669212139081874681431451943083023819401;
    uint256 constant IC1y = 7834178885454333307686062000784381972358143950744457717732995958756940419575;
    
    uint256 constant IC2x = 20985719459731195122067639554602249641474335644800996707139634478215499200505;
    uint256 constant IC2y = 4840755432593512271235806944075870070494931150560596779728262101126783363900;
    
    uint256 constant IC3x = 9863176849453454523553454591527036776295526705849193856035704268644260418321;
    uint256 constant IC3y = 15988944397563863251685108782791095089784809484285107530334538324782995729055;
    
    uint256 constant IC4x = 7150467324482097261961571573166229420592338734952074421011633735036781690343;
    uint256 constant IC4y = 4073501758766231994566024724408997357009326596918658666742180844507530014728;
    
    uint256 constant IC5x = 8137107517985860846340912460637531656361251331399661063987811857602927347524;
    uint256 constant IC5y = 18009423066529618811353730893101416960757658741376989612934800382291897276334;
    
    uint256 constant IC6x = 15822993618073754668874592563602669001263638794763594379361882244716461772369;
    uint256 constant IC6y = 13352025913938049524857362741537330682893711220580555680546622975228742427879;
    
    uint256 constant IC7x = 2150711989834635188731549933641409661353000602551685813193603066979927915962;
    uint256 constant IC7y = 11119612139530139299692208774889555776695426648050651266404691560598589227207;
    
    uint256 constant IC8x = 18353508560338581349324589440868058444002383638610172170788420913943317168270;
    uint256 constant IC8y = 7435302855249054035269599144885680076144716199724493839457377895995476986678;
    
    uint256 constant IC9x = 15470854241868090175155441166586593966589374956329776173601928506054017284952;
    uint256 constant IC9y = 18291654047613286945062178431556453256829204709301816313618745181409962010852;
    
    uint256 constant IC10x = 9801249309915609356254255833080173331946274922977717793115867293839652411588;
    uint256 constant IC10y = 10131345070658619773896504460812661465756493285525650172458158027855506810447;
    
    uint256 constant IC11x = 17051844936014060939718660970613090680713611793282396550636428432372593446701;
    uint256 constant IC11y = 1847685659613431943580096332254078272284550550131499555506017089808537285571;
    
    uint256 constant IC12x = 3290853360254342480202099051598100130278741080593615813918514826061170717267;
    uint256 constant IC12y = 15945563174693984348572177702834788962739334087934594608192985274390362633897;
    
    uint256 constant IC13x = 217414821401153782666289898920214169325330675447014170403144229782635835687;
    uint256 constant IC13y = 18187408036241428586583192436785681998659433376439532026056457261289827694473;
    
    uint256 constant IC14x = 10684640670872248326064593474046089437456177960231383384749963483361268012764;
    uint256 constant IC14y = 13993354803966948101309494913071610641523447131516412867437648882019262359109;
    
    uint256 constant IC15x = 18824653024177637837936260842521919269170554255392691472329333946465685684241;
    uint256 constant IC15y = 15280998300637072917541229218107591145394909003831291141545611614794500750000;
    
    uint256 constant IC16x = 5841817183432778892116566214909776794957525098491324008580212323382534277980;
    uint256 constant IC16y = 9123127468667569390660480705805974209748369916619110987539488099526792598217;
    
    uint256 constant IC17x = 2745295557786003153688949655123918702304089783435859975138032300924424232840;
    uint256 constant IC17y = 5972024509835396647235892733057670256519029044114986877983928317261289561847;
    
    uint256 constant IC18x = 11388542804764558771539683127142959431357171899243372456187209672963346685779;
    uint256 constant IC18y = 7067261223106587728796481111520383337197550207578059019530075418400211061290;
    
    uint256 constant IC19x = 18002646508514180405749354510934847907473891163158920067692478435281908143425;
    uint256 constant IC19y = 2881018920069765458374239637942483224774540044911459390530548215130590276100;
    
    uint256 constant IC20x = 15777318372698160810711984562191101151713104255250438816852723288374347259557;
    uint256 constant IC20y = 17523137405458044012528829388573152110232807258444646137469888359098695825122;
    
    uint256 constant IC21x = 2324641844557361309726699407516874951598217842108149208901308012884928776249;
    uint256 constant IC21y = 18890162658433408212094457829650785572409796560495476829279734367817223298633;
    
    uint256 constant IC22x = 1825843805909986520406980743655526232544840215319561644118799108356538208263;
    uint256 constant IC22y = 4682170578154339380837745524904155757268384889860807802332181062246036056347;
    
    uint256 constant IC23x = 2181672592380713270375481814113052247028890701997198148797535275504690095977;
    uint256 constant IC23y = 17928713068330727890239964752172426959236890007053319146594208654737655431454;
    
    uint256 constant IC24x = 19045967991695407259948811602252114011978029331734665544219748878530895691135;
    uint256 constant IC24y = 3709929870510248828484015083130944798531666964020659222217613285868129205826;
    
    uint256 constant IC25x = 11075939636488366465863239863942780148604248873540731824777800672028217752818;
    uint256 constant IC25y = 16635814103338980450821541956519701824275599418477197915764677402920119355653;
    
    uint256 constant IC26x = 6141866532404771755465956197418293159908232564425045299562970401067189226818;
    uint256 constant IC26y = 678500410474935056434139987201289882386568524780583806551515583268687906826;
    
    uint256 constant IC27x = 13514210614925698099903522448134806959846175552203750289741464044523339152931;
    uint256 constant IC27y = 13051271190938665919801929203261149838459958292125731104158072137638081552711;
    
    uint256 constant IC28x = 2810228106304490702670158814694490344745189111042049913893780660277997614968;
    uint256 constant IC28y = 20244593883764474703750424047806330152452214525726262335191767942769762651099;
    
    uint256 constant IC29x = 10233785591127094254722857777612808855709453482647856535454259046269766728295;
    uint256 constant IC29y = 14060391642441762013833572736414840037116831510033338920468983233522435698088;
    
    uint256 constant IC30x = 18353100300482409116536628643657718911560240490475999818185489739753217445983;
    uint256 constant IC30y = 6690523102212014656680724789891611529773005463886770889917517078146090196749;
    
    uint256 constant IC31x = 913175095153042500599413881705677262042201465101645127498680953802531439216;
    uint256 constant IC31y = 7268413806863811774527289545995986270489642909137639896921410839750616951182;
    
    uint256 constant IC32x = 589729423959579079459294554300990051260162047281990042324154173207244106754;
    uint256 constant IC32y = 12930960968925038848180702689001363981572139548922303089977868892676190196807;
    
    uint256 constant IC33x = 19165919906273778324815196523308804156329072830087776244387883512957330842328;
    uint256 constant IC33y = 12185796481863431953373221127079879559807012258325090248760879628729381612543;
    
    uint256 constant IC34x = 17200277971154844558795152972305030598825544262989507243870426175345494329533;
    uint256 constant IC34y = 13245378736717227505280905840466588681621373751130811528368986104264297516492;

    address constant ecAddAddr = 0x4cc3aa31951FADa114cBAd54686E2A082Df6C4fa;
    address constant ecMulAddr = 0x2abE798291c05B054475BDEB017161737A6A1b4F;
    address constant ecPairingAddr = 0x9F7D2961D2E522D5B1407dD1e364A520DdC8a77F;    
 
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

                success := staticcall(sub(gas(), 2000), ecMulAddr, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), ecAddAddr, mIn, 128, pR, 64)

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


                let success := staticcall(sub(gas(), 2000), ecPairingAddr, _pPairing, 768, _pPairing, 0x20)

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
