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
    uint256 constant deltax1 = 10954366828219920598275631511874109139704726399812948670801940368943621648319;
    uint256 constant deltax2 = 21324907562351316234232877683468151501516381985392872741645251279204064702931;
    uint256 constant deltay1 = 18482258673210683573944019122601559566291977892508024479883530881997647434509;
    uint256 constant deltay2 = 7722038556480149325085286096508221352261199536637674464951808613229560436306;

    
    uint256 constant IC0x = 16574539456559230992114437405247020869688093066008885296935800431598549754271;
    uint256 constant IC0y = 6582170259246930443472445853193936509612913397968208942995206335313256772669;
    
    uint256 constant IC1x = 4808179402447708287615521894566707949385656351330115478568410932828626133498;
    uint256 constant IC1y = 11192780342767924659813011397631422217139241141887946338221685389313294137055;
    
    uint256 constant IC2x = 18712536455113401242166725599926018227501537410696163371186150287407884159274;
    uint256 constant IC2y = 8226363004699024636907935712886376534070525223104886495035434945963431550677;
    
    uint256 constant IC3x = 5525728767826740479533632158517879343874633641133067193231828149796323926074;
    uint256 constant IC3y = 20216889476420837287462963482510441738183094399866480033686966677531230112199;
    
    uint256 constant IC4x = 19009979743068783710183513981562006201043554087798187683149723640538489369795;
    uint256 constant IC4y = 18380837042735451429820313470655035539984045901261307868989520583690420329553;
    
    uint256 constant IC5x = 11800021613302746315078345266979727253441303523217844358758776404934621284969;
    uint256 constant IC5y = 5552627847190879688690884947875949286679127676579489026263183051950936911049;
    
    uint256 constant IC6x = 20536313306009874074947145053719820749486870997381336862627487580013565559491;
    uint256 constant IC6y = 12711313804499722236550904237548158455754474168988617941571547442976063920096;
    
    uint256 constant IC7x = 4425936472530441395965884686031324525711609773170148186646244452200283229770;
    uint256 constant IC7y = 1061595758657853301857389925101009636892064733255307544748906042618704434338;
    
    uint256 constant IC8x = 10155875897728692253686193239509851911589650992390316926220239966489856356772;
    uint256 constant IC8y = 4676487083958629767906177287440562921261522549855724753069050267462738267779;
    
    uint256 constant IC9x = 18076733756169415004280419895754337255912979161476160233820383214343559136951;
    uint256 constant IC9y = 3377508909700546665496110592578574506519316225484513731414363569931925595195;
    
    uint256 constant IC10x = 11317008030217376109539821911712933985761704961144063824128630759333709243087;
    uint256 constant IC10y = 13668899703039526880112748721387422884601240691268823176766576494982141347695;
    
    uint256 constant IC11x = 11359204960157932631830970637444237245788114829005994332310082943451608645555;
    uint256 constant IC11y = 2334190495452324539987241351284112610318709408508174260330115582687913867496;
    
    uint256 constant IC12x = 2975987120379426805902369720367344369451564971704354145292338140239197186222;
    uint256 constant IC12y = 14594242469123473606225997914332954438390194577664627818897197983478341158452;
    
    uint256 constant IC13x = 4018148902220828220532669764290130744309563793380687826532671172447865135797;
    uint256 constant IC13y = 16217931666978126451653431812313879837567251770943153104246176239981507546120;
    
    uint256 constant IC14x = 15248815070804210837362123734509950517193128740321296376090017977229546434201;
    uint256 constant IC14y = 20874402362039288740322295432714768850415440595261420415136594386440000805472;
    
    uint256 constant IC15x = 184215137103263824927792083653151366961493141115507378570545194414115319597;
    uint256 constant IC15y = 7046461909096292801283414654130145780333111987651719245987730429663779545861;
    
    uint256 constant IC16x = 18080736123918754464230709936262206775388487854254198113766918476151341543386;
    uint256 constant IC16y = 446148367845068015717390166805552567927596132164836881761524550251826364135;
    
    uint256 constant IC17x = 1534340754187140859139685302587180628752162653552366187366374180697869637374;
    uint256 constant IC17y = 13731129709809544498945856186890414670098540609958232916278851992053826174420;
    
    uint256 constant IC18x = 21775370689754268902887177062346511347751941867300716036906435030907493997858;
    uint256 constant IC18y = 19301665077349083013097167335348111180470218240773113041527466425622049179892;
    
    uint256 constant IC19x = 11635940937217102712732048025733746892191325102263618279403588660770142333544;
    uint256 constant IC19y = 8576917688887871267170119763304876045314668502343805375889313573514080036228;
    
    uint256 constant IC20x = 20006996550547604082545176730384098459007628099012850949434822374546339451078;
    uint256 constant IC20y = 4597726399930358015865174544234916364474061025590422236723625434924206785636;
    
    uint256 constant IC21x = 3114468224969205430464146710478841067496946923476998513793771645186102267319;
    uint256 constant IC21y = 9742761368401377432169043503063016638695625132157325258951119245133312122816;
    
    uint256 constant IC22x = 10555368626644151934153186988613070223665152831331536461802480468633324065205;
    uint256 constant IC22y = 20624044651064953699623026914245314987310012387502388011971209808272542829304;
    
    uint256 constant IC23x = 5070128471248818670932373963274320409840160095469390573692364137256773403970;
    uint256 constant IC23y = 12110776441003724768993603161572065610467199076615091939124262227064046870129;
    
    uint256 constant IC24x = 5266755028714022754912427866871744256558467716512468087980728393513375234252;
    uint256 constant IC24y = 19316881479947876252903121663642174330739742638830832989972224412643455143650;
    
    uint256 constant IC25x = 19628930876339427854052779075324970269342889362578340399919157892524940741022;
    uint256 constant IC25y = 2088966831699507424008771862026864014133676222322627395317071588352669541963;
    
    uint256 constant IC26x = 20285762967755833379099368754997171672301375701365680387318890775289094404239;
    uint256 constant IC26y = 20993214094593506472331818213515185351280861846089320315513952592305315803407;
    
    uint256 constant IC27x = 10057583801221855541500288051363216180893138868799874225904852728382088360422;
    uint256 constant IC27y = 5386421598799472841467457846905224899181603094154111536494760519350528533278;
    
    uint256 constant IC28x = 16473463128623172053697682047994279770229908199497842325911299171923014826977;
    uint256 constant IC28y = 21288160761716596278540023630063748972307384453836431950624496039826334131669;
    
    uint256 constant IC29x = 21638131594863716614157629605463585179360468401086649311699156897876753941800;
    uint256 constant IC29y = 16427641097716660394929990103203425443660595164319793354629895015304577827072;
    
    uint256 constant IC30x = 15006616093026265455921487202440896059163943612341058809212643108696803693949;
    uint256 constant IC30y = 21639729012202301859145061736309269905820646014674250972917770681197873837674;
    
    uint256 constant IC31x = 5637017587583037775855444353964065840763219389682518196250998291229767189452;
    uint256 constant IC31y = 19708998051076531356994075801477289284024748787022499630790823127153597801746;
    
    uint256 constant IC32x = 11786412624601698177573137563308552293229122392470949009030209663634360959100;
    uint256 constant IC32y = 3525006067419153997466506573185539981981981404726200464981456451320393135138;
    
    uint256 constant IC33x = 8842915247240519087491681345580464704990637853851632260749029221862964993204;
    uint256 constant IC33y = 6912129862210202429284336963804844266574743113814701231899003687391563954678;
    
    uint256 constant IC34x = 11122508802234453254655719684600485291093997375492900313852970247412543996812;
    uint256 constant IC34y = 13743597114991162899240697983131925316352407102889585180432451035712663718087;
    
 
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
