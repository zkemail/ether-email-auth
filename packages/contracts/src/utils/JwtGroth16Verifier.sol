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

contract JwtGroth16Verifier {
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
    uint256 constant deltax1 = 10549777989399769958726389370849764963770472615831368230407664432103868982675;
    uint256 constant deltax2 = 14502498257060744023211073684244073105466434668316660619882397771907239253228;
    uint256 constant deltay1 = 15460511406384615559133697878851982197412588892070984182587282855147632409439;
    uint256 constant deltay2 = 15706936609177006543020474039293130526375576223590942516970433270916529663361;

    
    uint256 constant IC0x = 872606828030983860592300877698929270582888399564175612547068673523717109895;
    uint256 constant IC0y = 16143353238358547725255411752605729649296628753837782656658542933778396820583;
    
    uint256 constant IC1x = 12265908708087654954032743238562936502151179798171151633045588165431814781180;
    uint256 constant IC1y = 20317665727073110703491875492529167846517557655472268791286549375590586834011;
    
    uint256 constant IC2x = 13555038289040741270199070239156049732204714048225671298424430354385921312093;
    uint256 constant IC2y = 18539222167856683655951674285330072710179543682951086969104261442525466224858;
    
    uint256 constant IC3x = 778495765860799448817576490931323546943978689713790021372064878419020150316;
    uint256 constant IC3y = 494553016225160595577705461368517119685374103360884678008858848889200439064;
    
    uint256 constant IC4x = 12398343966874487415350396909198295847570025668003442383817332777601412219889;
    uint256 constant IC4y = 16714352332752650123918217255861075985654897229322373298154673955416867933218;
    
    uint256 constant IC5x = 20058113596528792487079709288155949888401927523962014818284928778921150266014;
    uint256 constant IC5y = 21332453060422800036059002226889090001149749843720594137048024105170372843905;
    
    uint256 constant IC6x = 8855582251881039453030124452784255483997420186795741415227250166780241788288;
    uint256 constant IC6y = 15468312935411647124754419121313227360803528182577025376722361384771576792597;
    
    uint256 constant IC7x = 2079462284470952561077330148838559378276804012441503877401058554283817803801;
    uint256 constant IC7y = 11056940595793292781403432345930717153138049622173232094082489064018377286041;
    
    uint256 constant IC8x = 12359566777632008687393557893922226564964238282511381687636166509778629553810;
    uint256 constant IC8y = 13535066563726494994452555914165886943395915356905247578846064476230962653611;
    
    uint256 constant IC9x = 12163413325655334444679547295647907810060532057025890248240324529909445916715;
    uint256 constant IC9y = 4338071106711357628319181403104692173120999800969585953325363233625163497378;
    
    uint256 constant IC10x = 21440733912063113684645321600087261009689201443963650698710232363987040828205;
    uint256 constant IC10y = 13039061739615000188505424099132138777355284028631872894854764583980793395824;
    
    uint256 constant IC11x = 19787220108554346544268814765120452370266605206707914319337059031217135416469;
    uint256 constant IC11y = 5597752880793288223814091166942773001663317295472390750958642344637104028920;
    
    uint256 constant IC12x = 14858146815035094200094281491646140482701820554036327258210557014243484514305;
    uint256 constant IC12y = 5892541671495102482183807536696566072802300515560462587307550046825210873586;
    
    uint256 constant IC13x = 8221849920624416593872695506953240866480850640379330710913793615308136324818;
    uint256 constant IC13y = 7745784026512692211241165911437749686430701650147778782437634989876571106983;
    
    uint256 constant IC14x = 17732322143027430212345955469649211088341821001767479930667911708469971167202;
    uint256 constant IC14y = 19960092666542822742374166372236746415442298531714271546003660888711688587103;
    
    uint256 constant IC15x = 16402148893814537562759607389844318916910409271647458313059610097463481680930;
    uint256 constant IC15y = 249648273105558663391245379487352565538865656524321081795915521092084807120;
    
    uint256 constant IC16x = 7988779306762924126313365403981356363536541596092425432570912165604859707105;
    uint256 constant IC16y = 13925220901161078130802861697545632068418900326879106225092741184405951835528;
    
    uint256 constant IC17x = 725947777039477123028298538226504453206421848139386625704712857149719502614;
    uint256 constant IC17y = 19363194562886607008835385215213876015529510742259848604367319864246400288753;
    
    uint256 constant IC18x = 13024863362326476504452743655782164875467871886576274249622182387213129519618;
    uint256 constant IC18y = 17400959071561873122317992031530664128374438607625173844796765150102347187029;
    
    uint256 constant IC19x = 20829495189101340618285759318336917939300086636158800249683709177064184437124;
    uint256 constant IC19y = 11764021894040816729882567419051957308954208213974822954783552658830042754115;
    
    uint256 constant IC20x = 19029438887117546008281965640537744497836433346842764388495665879920145129023;
    uint256 constant IC20y = 231249257769735443031836178461428220211275670614776518364124268003767444707;
    
    uint256 constant IC21x = 17652439817140328466955839239603697195109758087455386443678778613024044139017;
    uint256 constant IC21y = 11239780772121008173364749783927816127577868864487279447082268155801336450561;
    
    uint256 constant IC22x = 2565110039970180818767016133390668682923622378478033298258732840262413896219;
    uint256 constant IC22y = 7467000071585930486040421387204561503626158518910340225795894354637295685889;
    
    uint256 constant IC23x = 21714241639304687288913620472305736692608993986519324757161879017312825627118;
    uint256 constant IC23y = 2830575965824696341680224605948267820324810550159396460619767915398042832534;
    
    uint256 constant IC24x = 403119414448893587314787663875355242060508011977703696748226977119669177132;
    uint256 constant IC24y = 18899030463724229387506986110772957429104571614140492361744850192305881995795;
    
    uint256 constant IC25x = 3302097018001317843455587405027622933208258795282906920194148100469477523065;
    uint256 constant IC25y = 6244129777900445045320120857971061780485782433602979734156228911038790916687;
    
    uint256 constant IC26x = 8069966615364393574371924730938173379727114216975630144928950411352976588254;
    uint256 constant IC26y = 11148667217462571338135939510045978964169817059675428310090023257941682851365;
    
    uint256 constant IC27x = 4280584513388817687800819992741413300509629450219203110461303899658366758908;
    uint256 constant IC27y = 6377570450293890528389059875414063307025051226594147258022596703803353787295;
    
    uint256 constant IC28x = 1929892399375702318351689243746021783300189631002191311565897218693119891327;
    uint256 constant IC28y = 4355045708884409659650985273147369689565071946103991480833476739475691036270;
    
    uint256 constant IC29x = 2145294001901703374921853511109413567576578310613203520667349284762655376110;
    uint256 constant IC29y = 18561375458318728519666122108349456576334559552878246394841147883447979984777;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[29] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
