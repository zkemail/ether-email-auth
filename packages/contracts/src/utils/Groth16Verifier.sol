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
    uint256 constant deltax1 = 12348375662783824431360707906202475009449369812921990201376235771680861701966;
    uint256 constant deltax2 = 1390621091717691233659791897033569945783127756008503250856151404215287127098;
    uint256 constant deltay1 = 21545653682963288007472972452138234474169143155774752223643789231933860474340;
    uint256 constant deltay2 = 10610549897370405036411988417557836327116891506639515374316821127902275605593;

    
    uint256 constant IC0x = 5901406458595327327953646561359621442218448144107991955344827840671354857930;
    uint256 constant IC0y = 21253883398616811363937453025480398551698716152192802899988370991179418894921;
    
    uint256 constant IC1x = 1112924942971302135990579038492068551965379862222416146684206705079782572000;
    uint256 constant IC1y = 6845816202276549205403237603547410855545803354942552863847676397548741086071;
    
    uint256 constant IC2x = 14146397086704743317768846126489596483634956428235300380826232977310804058751;
    uint256 constant IC2y = 19618883007025739156467626277666586024401705866552606313791444982720962403992;
    
    uint256 constant IC3x = 3901572409202614942721645284047738923242593674037512752046910139604415193490;
    uint256 constant IC3y = 20492449392704526941468738279820790768424887146903635663987211396806301809154;
    
    uint256 constant IC4x = 18540181064351079043471661082110994395960833330341135578479476830087776228683;
    uint256 constant IC4y = 11176005255132390129621080493002450161350701375862520723126575901394028996036;
    
    uint256 constant IC5x = 19561918792572579721654605669351975749853953476158354443105355794367963998057;
    uint256 constant IC5y = 8218678694141104830016990002861269810060858478661593498963178088127632633272;
    
    uint256 constant IC6x = 9430924798221081020093287735191121193795036835461664479209198319741867653703;
    uint256 constant IC6y = 8320455794218847878770580093897658145962468495286236900439725456006531945699;
    
    uint256 constant IC7x = 5026847283727041400632489144741052290976729570767028644525050581059876916251;
    uint256 constant IC7y = 18709603090338372683001965035561848282369713676288357172691730209331905334650;
    
    uint256 constant IC8x = 17783950150020738154914534833285662833687830065154708170534593149023190841571;
    uint256 constant IC8y = 6711670108831861054349992265875143708175087706665287716580642850559233815182;
    
    uint256 constant IC9x = 6456809683101221239825536925658971026995917443342977471616457395354933010826;
    uint256 constant IC9y = 2014292748365982904981992383163603273504856743882959093701478470668783800522;
    
    uint256 constant IC10x = 6628245325000975286546535223213930648454767286000819266622720989919128655736;
    uint256 constant IC10y = 14513751619334179776611945559238333965209884013883320491822197554011245102668;
    
    uint256 constant IC11x = 18570424159211943648550772570282559547250130191621494465657111355378707354500;
    uint256 constant IC11y = 3142881938352899028782850032628554749777583832256141371247984173352247988131;
    
    uint256 constant IC12x = 5223991002378260090449510454796281831282905631623677469960113091483024319301;
    uint256 constant IC12y = 9427018011817145184335218137442223127741016816822775509206816206494077869941;
    
    uint256 constant IC13x = 17733384847564503082934979078550596341075160377145956961996412508907155849602;
    uint256 constant IC13y = 15345500273986785785979010183753446192836470842052033037545791683924216389909;
    
    uint256 constant IC14x = 6541603162653988673614876540286498610416711433782997011446804048984497507717;
    uint256 constant IC14y = 9471585496716317833911101487553454694761435169521054429602533117895220539092;
    
    uint256 constant IC15x = 6574110840837190171512762164893486105535576711656029901056739039814628526912;
    uint256 constant IC15y = 12107221022070295505274408663667253928323650746131661962928553805430682213730;
    
    uint256 constant IC16x = 2983775925467162306639671044788352921278318217335490557023737802970494396161;
    uint256 constant IC16y = 15155657642358487296835454918514213311356981076876734700573166757257484354564;
    
    uint256 constant IC17x = 8967042914633055089306636825844718647849951037719728238537295360572488150548;
    uint256 constant IC17y = 16316365584620447093615538375124020157614277415345119540410103156547686499616;
    
    uint256 constant IC18x = 10539075382040152021577786214341262536565753081943101851679620745620126843721;
    uint256 constant IC18y = 4734602432159888257161632785059762380496749946015675717019228118945872853040;
    
    uint256 constant IC19x = 16904274081002162388173688128412241495718571792446724759784404749590000812400;
    uint256 constant IC19y = 10801084318813806801902242112307629808119029411792686266329164737317751231217;
    
    uint256 constant IC20x = 15575787937775277998941372228242544347460724933647624890935023166333401850163;
    uint256 constant IC20y = 7296638718677056910701470329118855562874930285186351569007798599358833717218;
    
    uint256 constant IC21x = 4551313941391400232712859196059035637265126775160423752556164701565012171961;
    uint256 constant IC21y = 21401656423982733211718420214626338184514587667446979844631973864641456629261;
    
    uint256 constant IC22x = 2935540066773152386094450378156329519379475479888931777862603161088003692041;
    uint256 constant IC22y = 3754706265995206762948051647660125270465347882441656302776943004798594006627;
    
    uint256 constant IC23x = 14941485327978437375521006241254634444037644973379906367567115351627139641414;
    uint256 constant IC23y = 10702407562034274430221897944829443699402512693373259167588271091307663372710;
    
    uint256 constant IC24x = 8275896680177260146907953439805305572759478043924598922328323793281943403370;
    uint256 constant IC24y = 4247674182996730416195978445155055073549714994568066175487529509583649388873;
    
    uint256 constant IC25x = 5689003246975774737588871342271076456426408075813318043434367952407244465697;
    uint256 constant IC25y = 5331139184498747881817447962895230742876804067387026910085264060106931675015;
    
    uint256 constant IC26x = 9133389296516422045582607363916275184958302548102626374643142889003044665947;
    uint256 constant IC26y = 21212127989644328313744743046359043793974008456261367858588476558007302881330;
    
    uint256 constant IC27x = 1846381662521291690941661313906009843371539776920831630929177290350683400816;
    uint256 constant IC27y = 14037588365801936321970551415842797526891505906435930017587651178284699267713;
    
    uint256 constant IC28x = 9781100104817210330466721014252420484088695894046800561845749556748658092046;
    uint256 constant IC28y = 5247283488585909287681175111965979900241094426050812131890410213638115643151;
    
    uint256 constant IC29x = 2601884709396729070900092103586635418201773412881087270429648554918650589212;
    uint256 constant IC29y = 9908981325212548797939830108274909156521241172863051558205007650971279318517;
    
    uint256 constant IC30x = 9939266818987304280716292846681442246091197219658249578844451051169120630547;
    uint256 constant IC30y = 2572015044563341438903424542575536095020061887469225890988354903901552937232;
    
    uint256 constant IC31x = 13118893670705126645185968274218628155008227884751114852720068135196260630881;
    uint256 constant IC31y = 6230722867526865558981774022287077378574474669760549030286133277816703673143;
    
    uint256 constant IC32x = 17212407207955414163237618089196466668701707894128397707051726962337098549169;
    uint256 constant IC32y = 8404846513505663468605283225980364311579458231305844344066234966448248022846;
    
    uint256 constant IC33x = 11738484603497709502459820489878480711987723990943728339865918189223648597498;
    uint256 constant IC33y = 4876663067150136827802187921986818211983158246723787276826534383019800886864;
    
    uint256 constant IC34x = 10388736566666345681097260475847864743327046424517259125467497894377198799740;
    uint256 constant IC34y = 18058504066267363666256588143336895545386092144245446448007719752461244713629;
    
 
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
