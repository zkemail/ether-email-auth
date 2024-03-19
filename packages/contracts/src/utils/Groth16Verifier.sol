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
    uint256 constant deltax1 = 19378677032800300253321765128070207344114232849596143606479382519857822848179;
    uint256 constant deltax2 = 960493340684006291780639907740521128124066371578611670456259231950112608856;
    uint256 constant deltay1 = 707321561242641502318247120686044129733961936778425747245592502022561588706;
    uint256 constant deltay2 = 906648798918687791528309058870559612016450056396136091661128832168522104024;

    
    uint256 constant IC0x = 11403395364844092073898287051441590269639035349832801575305448956555898189485;
    uint256 constant IC0y = 7987377098002512490363489065894235810124910190689297467975733407897650124274;
    
    uint256 constant IC1x = 19970349493151374875793850465364756216296859365106448163304043498653868948396;
    uint256 constant IC1y = 7354947324833629681703491741404690151441837591196879347510104098513538563939;
    
    uint256 constant IC2x = 6601321659792123150661728200330654029751433638096639327003776678899256405065;
    uint256 constant IC2y = 5787025801944802546755634709739964131395447580769563006453319565215699737152;
    
    uint256 constant IC3x = 14786441504972962102595252435524938360766818272311031519783302127874034635598;
    uint256 constant IC3y = 7263574437900534125825733162428932803295530168406366964719997184009491498667;
    
    uint256 constant IC4x = 19375830445311358980282436806871584323322276448079881638691559240245282530721;
    uint256 constant IC4y = 17318811088837838309059961808619142218183737694662955481260362152107708083062;
    
    uint256 constant IC5x = 3908227178212770389553921608205338222911059589553208283649167492849523282345;
    uint256 constant IC5y = 8243748932599724059484995795741695102111754510915071330829401474670457928650;
    
    uint256 constant IC6x = 15439278021703347151433503379992310851576978215602018333651893780355077291845;
    uint256 constant IC6y = 21638430297043622123317246766715330304056281051508740200264186302710354377616;
    
    uint256 constant IC7x = 12614103461207067723818290400900871937981485144306233479485282703564757523327;
    uint256 constant IC7y = 2737120747640126912662625084039805926692259047896278598795372237156151273318;
    
    uint256 constant IC8x = 15301183870052143551620186414376410062664451990889671784420365756444494392325;
    uint256 constant IC8y = 4650698488466967485773224735285319520384787418399204639031566674273247603131;
    
    uint256 constant IC9x = 21754156616385732298740390360467956414568776103529844468119786993545110783064;
    uint256 constant IC9y = 16184446846961693609726275447321514238507287886109687792410351138135250274144;
    
    uint256 constant IC10x = 244135444354636500241781120121461553791792444355025240108322368710180522317;
    uint256 constant IC10y = 2502520855082041491808837191614596123009056536282647176762486196242326912440;
    
    uint256 constant IC11x = 21775882581895783644266592948550034589672533233069670861804731728949339352238;
    uint256 constant IC11y = 11881400815743694635896824745111667035477824478303686605652795964490344532799;
    
    uint256 constant IC12x = 3312179889940052232204751898979833097517557003027876142751774737404346769486;
    uint256 constant IC12y = 21374632894304888129661426640165240436413284427338075262260399838612492997131;
    
    uint256 constant IC13x = 7528626507625376052925073583344030864021221821172063769053410245035129716312;
    uint256 constant IC13y = 9166096334755065092764176720997273246795251892031153588688410906044526198171;
    
    uint256 constant IC14x = 6369530737509876846946090390455741937023125890510750661735149513809418509605;
    uint256 constant IC14y = 9280745716541780368193317986861227250950780074033868300480845563855753398269;
    
    uint256 constant IC15x = 12558224684088018750215250798503126445875846848169703467438387530529151184093;
    uint256 constant IC15y = 6438447722525942451152734025293335130203657459750071579867825017750662264543;
    
    uint256 constant IC16x = 21760172767678989053712974210946185954416464325269741202502365558511569730969;
    uint256 constant IC16y = 14328555534854937419599307487887607109383935995961943164869104475259737674952;
    
    uint256 constant IC17x = 12721450965857647842653598818060523209655807544582142503114340239875644094169;
    uint256 constant IC17y = 509291315940844110919310141621160761306967491284754194278419723289372915824;
    
    uint256 constant IC18x = 11821091968722472223052893420629266585896381860398218548505450239066680784138;
    uint256 constant IC18y = 637629613665587078024011533283160236803183532182389013399718830046110157867;
    
    uint256 constant IC19x = 15171686905454021445617486794000410115298497039166377603938555414739376699278;
    uint256 constant IC19y = 9367860372950551907843497084251870484664401058060747979299880821479072333651;
    
    uint256 constant IC20x = 13453885302087699738578768621050293444980598938635823846236227865376091470051;
    uint256 constant IC20y = 4114932099627848758644340520348411173109495028640015773993131575914340470444;
    
    uint256 constant IC21x = 7816164550596800024128197318709984983746028547286775312210385941824772819678;
    uint256 constant IC21y = 11907598145362082980231488040519763420460629270042988114575694207123419480799;
    
    uint256 constant IC22x = 7026291121711518717885133396634431504702598004699717987639781623426372406068;
    uint256 constant IC22y = 2934217034199305782699570943807041161901569272146498895183569827812876684414;
    
    uint256 constant IC23x = 5696885153673563482639795878703782890060885577257079837208380543842190305806;
    uint256 constant IC23y = 17677490074850382391167178977789148501419703191123700226733359751191884925088;
    
    uint256 constant IC24x = 2611683639773662474624629722305165059188459747093556135898769696357331487500;
    uint256 constant IC24y = 10044388249493140225865522073559488567982324265722702513571966586506538669872;
    
    uint256 constant IC25x = 5214009542610232932442041067813113650632680623992721376070046067376709227182;
    uint256 constant IC25y = 10185071351439460276090510663428745483434923234173869867480387557540646341686;
    
    uint256 constant IC26x = 4636491635078988706441689757212385869973641936706839840615699323767584705656;
    uint256 constant IC26y = 5385588163483057776915996860882717516859067158972572817291591123171461874905;
    
    uint256 constant IC27x = 18705809007834830886982817327652431135135881045537983411955656556286258722805;
    uint256 constant IC27y = 15760086357718846365304413904138098736915444207916507230376426657348004828234;
    
    uint256 constant IC28x = 19182077652075606448764076721233989088126556417897799020951367435544174328839;
    uint256 constant IC28y = 9136270306453077808755194696108953703001292400385038364957275580855848746843;
    
    uint256 constant IC29x = 18485427693577943108144538953927906684343832918965223721720202393052827398914;
    uint256 constant IC29y = 18575738887044959080624252642810238700989315891377197214187365412313209252763;
    
    uint256 constant IC30x = 4223202583040339035072354022171586822138322889663701017950037645370876520845;
    uint256 constant IC30y = 11856130485182396243929365545262884496878630681794480179341681754292009988063;
    
    uint256 constant IC31x = 19407812422219942955336266485712702970841716137575998392385328696244122346627;
    uint256 constant IC31y = 6785055681044554372605737518388942189987917619986273461429790568638918699867;
    
    uint256 constant IC32x = 14993212179101104565462829595748725448512808800293815566424165418121053284398;
    uint256 constant IC32y = 4083889862604497566428910703229716185418233528250337149121364790918693829394;
    
    uint256 constant IC33x = 19535193266806328470942118649012700164578795620538913542594738691400891335098;
    uint256 constant IC33y = 12775783114117041065841750751628812939076814753172334426229780042733013690673;
    
    uint256 constant IC34x = 3062181060286810160747070144635312664862371094982947559639250577939387406466;
    uint256 constant IC34y = 4596414785886448742196272188716315360063739806767099479393366426606524993331;
    
 
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
