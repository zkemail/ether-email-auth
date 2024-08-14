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
    uint256 constant deltax1 = 5983171936290598320468573252325674101461843419080005031855669286227012752780;
    uint256 constant deltax2 = 1616455936629881600780635131538431340402214347410274036558904480101243863530;
    uint256 constant deltay1 = 9037252648222713797878892810594666985531718121194247950539166049921289703377;
    uint256 constant deltay2 = 4699310388290815395355402566889302076410660474117673026312898239630925876457;

    
    uint256 constant IC0x = 9407504511932189814268448314538774648371854112366535174254096666136289432606;
    uint256 constant IC0y = 15773065854173729956819269320998414222835809639884295417478172220201303820957;
    
    uint256 constant IC1x = 6985539070039880864246447255250706177458015106391535312469654198765095854750;
    uint256 constant IC1y = 17062998596362777191471256370674214039456402764096613453821944763125567045775;
    
    uint256 constant IC2x = 19020341649247103618498582723726196065342309425040135678683839486438658162869;
    uint256 constant IC2y = 4315741755022855443489090834859807976978244839377166823290334638137245898290;
    
    uint256 constant IC3x = 17093237132206144833396515187087230091975791842317435926993271691118610931897;
    uint256 constant IC3y = 15750868566432120528685776084735309574202881351791740624529812527349619577725;
    
    uint256 constant IC4x = 13668963192470578576893999990888590086737214834397482256848383643618317807541;
    uint256 constant IC4y = 18005559521174791727165408444506070799039973406207142791359679570694524477841;
    
    uint256 constant IC5x = 5372919185721494222388657070416026378032695128310922361022445359206235598170;
    uint256 constant IC5y = 2621530188035105869739299798482359146115888177636651060143465580802716123502;
    
    uint256 constant IC6x = 11084751343646584076081209232796849106159754893156044955363754389038482370019;
    uint256 constant IC6y = 15106591532334690338930673204458049555832780313087710096547138551652894762223;
    
    uint256 constant IC7x = 4920990801447236411260429556114409053740494616743188966151205621295542264384;
    uint256 constant IC7y = 10430426520261658880825064851011990770541996474881180398173457205006121878768;
    
    uint256 constant IC8x = 6532583611084152671582069082486887867948037254640192025039838146654454351802;
    uint256 constant IC8y = 14360599294939330509564714784538832788999443205609015454262244797169105371846;
    
    uint256 constant IC9x = 16810796098722337783070594152585185309602060412375702111575489536339763727947;
    uint256 constant IC9y = 764752627817036381554363702242750170958302724638141684584122805043909079907;
    
    uint256 constant IC10x = 10125177737575906747569338002538395576751535972057983834301861779766066148208;
    uint256 constant IC10y = 6970008661333487824408933663000294551796839621756485854614195324297219018333;
    
    uint256 constant IC11x = 19658809891319388234378562226105486873494574154843706893665526511064587042474;
    uint256 constant IC11y = 20968647530567748674495897824421172870574908231334862366874825075706370276339;
    
    uint256 constant IC12x = 4409184799956051733665030855133957850434483822694049144490254953358642705573;
    uint256 constant IC12y = 12984929852881639975968371452038094393021146464589745536931791154801821657929;
    
    uint256 constant IC13x = 1530996942878614229833837858834208473626185990312513083718837420564320331048;
    uint256 constant IC13y = 2081180266350822119793835565469642153947751193989583639847436982962899104884;
    
    uint256 constant IC14x = 8364003527206749118437448779069048122896344675136993259752501562699118058279;
    uint256 constant IC14y = 889246113077499076683468805314145360746122376001415305068171390325583955798;
    
    uint256 constant IC15x = 13394915715595966016181547936414818788900373961165217401226601581522665920080;
    uint256 constant IC15y = 8155855328775561868098331039900661809411090888150286180245492962403401570075;
    
    uint256 constant IC16x = 13986741634841226592604722229438306344508205750311472339079406564221067411184;
    uint256 constant IC16y = 14432183430290861462669881121377256640018983245707556385641539098991289205295;
    
    uint256 constant IC17x = 13146649516994383500873381949823458282972644352101461944896694441697516885870;
    uint256 constant IC17y = 6626556591517742590136340049533891686997215967473542285624397424514993884917;
    
    uint256 constant IC18x = 3863138173864432435976379779421085725061616541196745642101738469088392364103;
    uint256 constant IC18y = 19186864428059916687999476093633579831727653436686864583005396291346224080208;
    
    uint256 constant IC19x = 712213179972584343362585715180921483147732100883413869792840054323870436018;
    uint256 constant IC19y = 1998151291173062593380872077086944911517247994732787684215653144496747692408;
    
    uint256 constant IC20x = 7035676731473059138146830721491837995229065590984636598649648413125488540644;
    uint256 constant IC20y = 9464215783670923114240566797484730597125750559246700741484092524063997513881;
    
    uint256 constant IC21x = 17278690783927308033883199376692416619045708474390534000294909803708405422302;
    uint256 constant IC21y = 19543241150022232866193773300982021765625228509861777460835515512598305611998;
    
    uint256 constant IC22x = 15786210896375988202763217348071534238372755088047066502855666225257589822775;
    uint256 constant IC22y = 18021507217646811109975974440698447811368843902333494011685710348607650964012;
    
    uint256 constant IC23x = 8557880797427037022056358139198673284704041903009130353923388385146496678271;
    uint256 constant IC23y = 11943025907855342792898508809354841282637550314033311771803029634222808962978;
    
    uint256 constant IC24x = 434882956880457764462677095218714094969599412028432170547289944011015680455;
    uint256 constant IC24y = 787545158484566995483677268758656557702723403276059228870072845558119269108;
    
    uint256 constant IC25x = 2494274568955424825630467655615375789297054114686569238313563663939307904691;
    uint256 constant IC25y = 19300290802955582425474220578591907903066069982997784732901215454321720906331;
    
    uint256 constant IC26x = 1476038310343413043339540643991768672806157153114615508738409005113798096478;
    uint256 constant IC26y = 2075947439218796741698866713361228759666422793692929168726821750697833998880;
    
    uint256 constant IC27x = 15794457602857488456935142363815672782662839841923267551462958755635180231972;
    uint256 constant IC27y = 1567502763877787532310264574291113969732693029877591200365742671407799354853;
    
    uint256 constant IC28x = 14711627135954781418604332967780226668688460785666695455298730232883272177580;
    uint256 constant IC28y = 688902860735296308663596375112540818814309326395007407984677575420629699703;
    
    uint256 constant IC29x = 7223889022157530761083478401371329501760565191049304117077613704780275104536;
    uint256 constant IC29y = 10157259099538833030261513540120019273828239497189095920344350575555105836584;
    
    uint256 constant IC30x = 18014245771005768845623951034410388449578384470998220842310150507763998995893;
    uint256 constant IC30y = 10423622140666649935345315459661097470993026550474050027341780643486155112518;
    
    uint256 constant IC31x = 14946096144418870058320487212838090411464028758454780589109788312257399810391;
    uint256 constant IC31y = 4666275353277632194000550402547989557329747163582665370216713082841506033936;
    
    uint256 constant IC32x = 1804129427254056203909122496898053698386098862729667781976473346837405943014;
    uint256 constant IC32y = 19912375498638074504909777192983016019550747330596839707484220699476152388906;
    
    uint256 constant IC33x = 12838150863887638696349596324441663677651806288505222170588608554290627468407;
    uint256 constant IC33y = 16507526718683075963409619093261884923363313028093855606861396493362871554478;
    
    uint256 constant IC34x = 20691563457521124502857354111416251576408742472370192178956592971354402750050;
    uint256 constant IC34y = 15320993618891202294653203554865594152589201242404032415709481693089534118338;
    
 
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
