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
    uint256 constant deltax1 = 14137599133423807135782490399584092377749091501298939597920866162944520244436;
    uint256 constant deltax2 = 14978007254868208603199787958301705165537192974609940615923845103163843289642;
    uint256 constant deltay1 = 20866926135988308729900029756061807139052115776449961128367516123973492874132;
    uint256 constant deltay2 = 13313063679389223211741428584465992043666285070547834947574090177964352791211;

    
    uint256 constant IC0x = 5195936601868887585212421372510227978271676935057973899956702156349203234222;
    uint256 constant IC0y = 7962666133599308700300916998348077443104178691470750683750290264787523050083;
    
    uint256 constant IC1x = 3742958340223569504265649722106845322935941488002511232315317901779710961348;
    uint256 constant IC1y = 17830086392700490461575614924542539921010019218267138065309167838118767673071;
    
    uint256 constant IC2x = 4332752895886212961294524900538769962072739040734849994651204657950683289368;
    uint256 constant IC2y = 1377131541785679015417232044137700801378123208892271570382657073684395420024;
    
    uint256 constant IC3x = 16378292231478499838092155231627156354691178980041169284687330191005695577919;
    uint256 constant IC3y = 17984842151588713416158803141980876218634444020891506138402480465525181344342;
    
    uint256 constant IC4x = 11965323634630493035329899963690158132995308612106355950740136591993893219420;
    uint256 constant IC4y = 9036580198334173839201781041185265082225960680796419311264598509854480156749;
    
    uint256 constant IC5x = 8459630029068528580429553108101440945373189351254431332719199991450558544610;
    uint256 constant IC5y = 13651627208666641596882636276693872905868719669569331130223221844756480706355;
    
    uint256 constant IC6x = 11418680074014215462237476921106744160987769937545607863613880530479435852793;
    uint256 constant IC6y = 16741190989512051286515154593161715196784599987136091819768098700099951966060;
    
    uint256 constant IC7x = 13831043129703500407338686026967233166168634089065511597932358351098797730621;
    uint256 constant IC7y = 19654592342690178826154705309997596268116769282480108200974219537036779371791;
    
    uint256 constant IC8x = 12659402812760536946587000061651522239448406097114769091067522676195029124036;
    uint256 constant IC8y = 21366009070877925176882055259475055305247055854906963167825248279397450107409;
    
    uint256 constant IC9x = 11453150531242067834578895014844696195314287671155062571621601525155787106768;
    uint256 constant IC9y = 13537796031408580209437745696367565845966373090615194634642039101343542355153;
    
    uint256 constant IC10x = 20093354799903715012012153551878914128034578543732120460093003674569621900678;
    uint256 constant IC10y = 661654072208849854990960058973836491179251267828702406201676324115522183987;
    
    uint256 constant IC11x = 2199538106454983378702155262750677597934025323095042816965655834581602546305;
    uint256 constant IC11y = 938804879776828512825404167032359904154808938369573736543158236082744779065;
    
    uint256 constant IC12x = 13649643871438615401325195027458534071402773850754937857802795986898955350643;
    uint256 constant IC12y = 17385455189083877001780749863496820018757924419367993355210000166538058509504;
    
    uint256 constant IC13x = 3919806397462020476924320698720612586325131068555439014510154499929415231546;
    uint256 constant IC13y = 6950962750979275347308936684073542743916967713183550555287096414703303875072;
    
    uint256 constant IC14x = 21617074324876578460531149615625632094727390653686583753180981293116313336795;
    uint256 constant IC14y = 18288151827607067102645837618524429433655012118476234601055198996044031270225;
    
    uint256 constant IC15x = 4000708925527443807227241537033307583003447845797803803332356328626248705382;
    uint256 constant IC15y = 1154600183297897257070571574499276007915600103090707700994900568610839463180;
    
    uint256 constant IC16x = 11901100788061344866021032645161410354755351952030556105637534598729803434166;
    uint256 constant IC16y = 16804802892568449193466174693644238516033464302901967260235961561237161720026;
    
    uint256 constant IC17x = 586980697795044138033629480303267286923166292074979442828313193925002353539;
    uint256 constant IC17y = 11395515205673918388736502540392075651362432388102325564755713826093996896765;
    
    uint256 constant IC18x = 21684800601451717499401579708297162716967255721349906661409841794723254042516;
    uint256 constant IC18y = 7331868483392828521170991339808386563984066825046191241635252089006975585746;
    
    uint256 constant IC19x = 21071894109390133818432992111016597167186471742446860545799328494730067371036;
    uint256 constant IC19y = 2250746924642512539503116477183280832526559754318370335662599738970760735965;
    
    uint256 constant IC20x = 11699852834269224235393200438108093155076792134835482044354663066791001331547;
    uint256 constant IC20y = 7525060483340472166081962270247534971293407558771701860513236466676372605839;
    
    uint256 constant IC21x = 13333287753863763025811168578371672801299227240537901308851864510325527226990;
    uint256 constant IC21y = 20724330577948787851354022778185584810491007685540005337623531623343955873208;
    
    uint256 constant IC22x = 13369259828518535278412305903662476453129352590581315212761565315929926869744;
    uint256 constant IC22y = 20684227524142403196331960093377205173124833362046724169978464210156587312666;
    
    uint256 constant IC23x = 10149427005480696708705641408410624852074762916352315357866716257764403959452;
    uint256 constant IC23y = 1832744442234417278002382253284380678688397697648853103439247404860773988913;
    
    uint256 constant IC24x = 3238148721388181813909444794632491849221750829570437445443493977964140908904;
    uint256 constant IC24y = 12233471704075818623166919848035666804013719612676696733435515734260544369112;
    
    uint256 constant IC25x = 200568091563451069021824567798180732022741817480404781322352122251371029319;
    uint256 constant IC25y = 15968861848667517612536228852892590805607891756149176795583414595017493159240;
    
    uint256 constant IC26x = 7490905222606166621539734222169901612455935470396929579767614624709598347027;
    uint256 constant IC26y = 13589782990411027629285738142493427660936202498516751386142336953724617631041;
    
    uint256 constant IC27x = 10439372252188652023854930400256109919428790553015141301690987392583603819070;
    uint256 constant IC27y = 19645803372269710308802977570944089640204889280197417980290219376283875276427;
    
    uint256 constant IC28x = 4233175821966351360135101547096990171483511734573884288134490380124888438507;
    uint256 constant IC28y = 9168539599977681140669648043037625242577522004096295050291178007562663505044;
    
    uint256 constant IC29x = 17965415543572427008316038629737097163843488210247795863797767551914431062732;
    uint256 constant IC29y = 10022518030566331837515422454623442021051179479186636421545476748781258842331;
    
    uint256 constant IC30x = 16378790344935617687712615346664685876579757390713337666593356471997796161017;
    uint256 constant IC30y = 67087458735409640505180328942607635982826830406801168778526050991167929457;
    
    uint256 constant IC31x = 18787438292886868094803768863007679727944933879676129674529468477986797983883;
    uint256 constant IC31y = 9179663164408240683510141538256241224071171501322620226008520057824024561209;
    
    uint256 constant IC32x = 14050482524564003571938652642078944787042443917427102971495774411991650117059;
    uint256 constant IC32y = 10866596210798953641577421873214410091458533938602431334494585211834598482309;
    
    uint256 constant IC33x = 20241331693940333034832945020019302228846150232143935552741654484387312060214;
    uint256 constant IC33y = 10534185341170028606981516372307427513289433068554450644906839468082521965303;
    
    uint256 constant IC34x = 19479517211831911662095291764442113728434510877930437280064725446574700160265;
    uint256 constant IC34y = 3943207262523423297047778027342789058321444964686369874431308251582045263338;
    
 
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
