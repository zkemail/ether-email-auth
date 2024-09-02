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
    uint256 constant deltax1 = 7512310166790179922504683523654316114051222191831169356747444038269967648305;
    uint256 constant deltax2 = 14358591220354673294638423548838009163329059984271248943224595375523946440844;
    uint256 constant deltay1 = 10945165491323316120158090062372436583843822551186653547350912773785745492908;
    uint256 constant deltay2 = 12977491133002118873088909332652159965708924468719154246248274593582873461934;

    
    uint256 constant IC0x = 13963177540950809295782204463516277073432173625654096650299395551650393709604;
    uint256 constant IC0y = 15602945741766824338761981015932856359177200661747787110583509305519171311689;
    
    uint256 constant IC1x = 13901364820478321928616223034286870916279818972373410460098510478160011053099;
    uint256 constant IC1y = 14236131152778024758629670193607195289980506228078730330692122051313154306570;
    
    uint256 constant IC2x = 9230583203032536232829062152692285477328633564550620828795526551927932673258;
    uint256 constant IC2y = 12823968485634865433296790678185713696956177429058503916497795155602629992619;
    
    uint256 constant IC3x = 17639740392526803545767112437667038900196736383732820044731439393404104455892;
    uint256 constant IC3y = 185489738400311207281216872971624070048902329723183825977411360815457155921;
    
    uint256 constant IC4x = 12069519432129553376683732542057521791951300837387868001349505113926238600603;
    uint256 constant IC4y = 5179805167216122560022161376021253470175122378869865440572964817206688034995;
    
    uint256 constant IC5x = 13341741969026085479452747303102949204889069730043799331450553531777313415027;
    uint256 constant IC5y = 12622154326191207141879122439134936928996883243183804472561540303328627402611;
    
    uint256 constant IC6x = 5524249138004641558839056031282734507960291855160204994698994244702630374695;
    uint256 constant IC6y = 2838545179481365224586078663128105413457151412717798861182352117115080523068;
    
    uint256 constant IC7x = 19554330184893289081351857198918890940131287920028938901123258851925997091096;
    uint256 constant IC7y = 21187120635590833154352478658750104019492268925659795328629826170424237790467;
    
    uint256 constant IC8x = 7760862852091446869454661318724098439035438362089550104244769932517916868839;
    uint256 constant IC8y = 19254393654613960117332409830738981805954756960359620518017135829429172873772;
    
    uint256 constant IC9x = 15564940155024906142999107362340815858137284449493640983339345075622293100658;
    uint256 constant IC9y = 1617046506300089432116787730161816212709927386986013437340513810060016149022;
    
    uint256 constant IC10x = 8761289037800026614344829900088226723021361306934107788103479929938837644308;
    uint256 constant IC10y = 18887041123828916694468022436722879291739062402223689213701674861638998067598;
    
    uint256 constant IC11x = 15078796297798212555417977593995358910740633024789147595871485081022877594688;
    uint256 constant IC11y = 8470804935050612973272335097844258163084303298699216060651895502152836140266;
    
    uint256 constant IC12x = 13148554463252000159734437740750147355285467799702838626674782427621833651862;
    uint256 constant IC12y = 4154912502683952848865244880904626773017467395251182073432201348576612338512;
    
    uint256 constant IC13x = 9971258020291304535684934520409197417844738102841933849336209194551684387260;
    uint256 constant IC13y = 11597854766455209249051872024659116726914370916348872165676874573511692371038;
    
    uint256 constant IC14x = 2930562317584608077941323563288223695503253706485531251156544883634158242043;
    uint256 constant IC14y = 9240840788488657599771118100535077289767006523619812853863860241862442262419;
    
    uint256 constant IC15x = 16422784168814990015933552338417309538225820837997155930682270086046353015844;
    uint256 constant IC15y = 19869469930650174203989020181864562320111438711593759069952187898326610664818;
    
    uint256 constant IC16x = 13790631431800806141462691434744099435298278652239216597838090515088257481073;
    uint256 constant IC16y = 5970741811988419030089819655471571807951451817787149436342954581604814989654;
    
    uint256 constant IC17x = 14976736427051209441599895542115651186815700359766023720088346036777288255538;
    uint256 constant IC17y = 12852402101788491586826305692493329786060447274461406286947282250831762004864;
    
    uint256 constant IC18x = 4280125422602481644778681032156727291998269141310669530728230860253156845126;
    uint256 constant IC18y = 16682143429272254699133459970696787349636739657860469986526142128107512434480;
    
    uint256 constant IC19x = 10147951062270258918013679058779577570351008390025368069146440787810065746771;
    uint256 constant IC19y = 5090148640187367354670039734538337475397977849830533292031088125570710070678;
    
    uint256 constant IC20x = 578255745441773075639210078803617950558342577360305877996037440974850723995;
    uint256 constant IC20y = 12520655905142699409929405181761549544517927774724036032382536924347165049220;
    
    uint256 constant IC21x = 3355415877559605146458275122957543229539987007795496380499840576047274644423;
    uint256 constant IC21y = 20476643636313926200244212968226317708756519977425220516640115874928427933331;
    
    uint256 constant IC22x = 21449378479565844466348985747983272828741700435723692245161366305682834816693;
    uint256 constant IC22y = 506562745742676866252077181735736358296299192584367348641528429905789575988;
    
    uint256 constant IC23x = 20726751273737403605532121718064449872454430937365235084763999011467146824138;
    uint256 constant IC23y = 2569317581613789680208520789013703218069888753995406910612291831117799394742;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[23] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
