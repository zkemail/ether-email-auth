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
    uint256 constant deltax1 = 4858829669817347093182793857775974191320149144941367900620918889248420221405;
    uint256 constant deltax2 = 2349268651909297333656812175507747333482815372948808934398780108401386690052;
    uint256 constant deltay1 = 7694909852690402669806436882407880044159855145256384757904321211496345411627;
    uint256 constant deltay2 = 13049872237347108980489027279484885483262009497487624719762629191589932117577;

    
    uint256 constant IC0x = 4211770379362138903856219862840433796980213258757522697832886980405220081220;
    uint256 constant IC0y = 16262585275919937778121864217428161249107463864673038031276191032927839035906;
    
    uint256 constant IC1x = 7099677506678218566365066000867791810072476519608078822828837000682196003379;
    uint256 constant IC1y = 1769237770256153753400309038867357975549596116377652985313792522430343288331;
    
    uint256 constant IC2x = 5989178861683444195999731678542399733494487460212710973544093878608710847435;
    uint256 constant IC2y = 10156246898993882066916603426190751095589234851486847103233948255970437390810;
    
    uint256 constant IC3x = 8701085534366120999121767803730000480108589548341934333709782694649634498138;
    uint256 constant IC3y = 20207904803535365628311317895287771329626458055937586966862287833631465980028;
    
    uint256 constant IC4x = 19257046993352497958438805347329633592317088606922904557692449945390128748116;
    uint256 constant IC4y = 5642717832394244570923095827287647199707184086427776423070140911486420942150;
    
    uint256 constant IC5x = 6604323904530459929048657334218164572603930719021236138541907309311551582537;
    uint256 constant IC5y = 667334202447374705138407118596023814372319062185658187750378063436264762785;
    
    uint256 constant IC6x = 11535229849645627262504107788901033303442605130322605553360243142789060219891;
    uint256 constant IC6y = 1753637515299924092253195578151263987316263848401197118330774620194785401452;
    
    uint256 constant IC7x = 12498900101086841522232364634108467559129266406240189524513481987584483665932;
    uint256 constant IC7y = 6522787544636188304951805297375626750156218692922889853302930148319905013996;
    
    uint256 constant IC8x = 4480135903096772346095767872562588741670853664386331507867635466927934834572;
    uint256 constant IC8y = 9740988249152422840657218460324840065260226415481576126599811593594715176614;
    
    uint256 constant IC9x = 13047200366114718711781016004799503316506956688819476978254555611043342693901;
    uint256 constant IC9y = 21327932921959593729230545468282812265758180044612564454867095866299630965437;
    
    uint256 constant IC10x = 11376960835268614350741468735798253461118575948160086341424615959754701304513;
    uint256 constant IC10y = 15597725160474274737554011477863236677670609244381748129499328040573769169072;
    
    uint256 constant IC11x = 11897676789685363392905629453099957141626538123954346927380010313347510977576;
    uint256 constant IC11y = 14976898926642513604420099948648410196260761766527012733905356150374916695226;
    
    uint256 constant IC12x = 10705479672629199296499184819365013568112407645583263601648436909575260989231;
    uint256 constant IC12y = 12390312497516174890706591689640434215359848536333797411488857638700234635063;
    
    uint256 constant IC13x = 10425206092609858366454385791401502105148449847917106110284639721308273423342;
    uint256 constant IC13y = 18242461427611975897422440915025510015679040781015534582773251010854996692185;
    
    uint256 constant IC14x = 11621088052698567148182208253169607392578076249553939761613628597015195444595;
    uint256 constant IC14y = 15119973346566563544001441321483642551077279944021367457728450526874312644840;
    
    uint256 constant IC15x = 3694989447959615271598638846469075742941537980300757012006599339224930036765;
    uint256 constant IC15y = 487178526024236410205400392361688163591688252491455525243046863091215985874;
    
    uint256 constant IC16x = 16669637139480556591463812569837271645339702458271203139378127750199663899786;
    uint256 constant IC16y = 11468847616135016970306428034890939119283893821736516621097778930694598034368;
    
    uint256 constant IC17x = 20646878988470168748773935413431912831865041056289307593368304388393650557271;
    uint256 constant IC17y = 827193114932801528520304378867896633328368580526375365335905841178073708646;
    
    uint256 constant IC18x = 4577222939682608116020745394835385625247892951593517505220683292410177815398;
    uint256 constant IC18y = 10765337574159612429579250364168682791985126973462157564626769410830366049552;
    
    uint256 constant IC19x = 16900579915364382782288431773098063012424588757284168821410602152939194020713;
    uint256 constant IC19y = 11738154656092524268428495125430473218851117159241760691134137578260179802880;
    
    uint256 constant IC20x = 11996832114473654168748629667567805718029100992596193520375384097594749180474;
    uint256 constant IC20y = 12197415893184205400832380386631571921646216686696514881148128824205876592633;
    
    uint256 constant IC21x = 15435816395263292431589577655854586379711723538286423592496598199352674678507;
    uint256 constant IC21y = 3956826533992471850057897747896273349387738205446854556285072199021656279013;
    
    uint256 constant IC22x = 2369786813850488318339333825292479727059461567046452298062937914114006512850;
    uint256 constant IC22y = 8702809128002581488065613436002218443246042081672702355390958016356405185715;
    
    uint256 constant IC23x = 12544917895975488002718979866746556718640527177184601331286778090675734160803;
    uint256 constant IC23y = 20762606037448349006426374611439470865657289814864923932382439595956154228516;
    
    uint256 constant IC24x = 18070509509074045298484741399301403321599290579411825491326589798309140657770;
    uint256 constant IC24y = 14908226954766198674998803772409345388914316691588832258957223752963822069525;
    
    uint256 constant IC25x = 1455377095269715554036588252557915396492615334772309291658268748963880447163;
    uint256 constant IC25y = 21695770302288876875103069192766492099443844872634715589406822596784910309225;
    
    uint256 constant IC26x = 18613219484310502521758988950271293547469078219382742873978803855363453705478;
    uint256 constant IC26y = 7419340280200382320924952279013159868401557816307192454458858038789820660463;
    
    uint256 constant IC27x = 18221722127089340543801871525007420346953045418995248323716795830848226217684;
    uint256 constant IC27y = 4518866934267970863421444289696546796417801156895763030898263144973675489073;
    
    uint256 constant IC28x = 8713740537842015757942886815311011147495846836132469742940507937777153910750;
    uint256 constant IC28y = 507759461462870120720184674526204638315084668933834919940607138736119655185;
    
    uint256 constant IC29x = 283302323093706523579313567957122665840911228396951676438535928093564133804;
    uint256 constant IC29y = 1681450395436167902493762433691773009029447527073836310022859931574279357369;
    
    uint256 constant IC30x = 16950838007218899572417821069113886241538367930894435961520140881634945913229;
    uint256 constant IC30y = 10410906553155915588034406693304643554694784994338863360414506234348420922348;
    
    uint256 constant IC31x = 15417816420600085986651328121013448812960638931149808993527680134568703989148;
    uint256 constant IC31y = 9484856347328911531029755263457734804606312906741899150934772578024062114576;
    
    uint256 constant IC32x = 11858766527829566429424160488629201945623249625611951541306072004276901038428;
    uint256 constant IC32y = 4007102117738373297633201497667781324069297849570621583473924119854284231236;
    
    uint256 constant IC33x = 12559118066557596997926577412374612657226056310267908347444905822043727890778;
    uint256 constant IC33y = 2553701655642396735890628014783420975893274653453737050745275619913519841358;
    
    uint256 constant IC34x = 16444904695757501831607070919219388667670309184517024943507682426550207959491;
    uint256 constant IC34y = 5427016083642355586995705553257426712615569886823313935372042927851221733966;
    
 
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
