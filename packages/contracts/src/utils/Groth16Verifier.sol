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
    uint256 constant deltax1 = 8669958621598211614523288487212013709697484330995020679718658681228237042515;
    uint256 constant deltax2 = 20454902724738874023254735802726569431511469610593615972101503188096009710272;
    uint256 constant deltay1 = 15734859514659546211155613710618764479812042975409274787015906938438731725279;
    uint256 constant deltay2 = 4568434731332300359441355722270230945101674782479620800555660846836059432281;

    
    uint256 constant IC0x = 11875865670464336529510676641721437876098964006709650423001784788588843034166;
    uint256 constant IC0y = 16137678121100851982275439365104546457591210158608430848366454549454652460230;
    
    uint256 constant IC1x = 4827084252931853015404871081543392682797109690290708013956605074078401157862;
    uint256 constant IC1y = 5313535737148106612723684226934760980575696941800304219006727963583986551446;
    
    uint256 constant IC2x = 12939843280123662448854475653417966128108494036643710697615938334025784298644;
    uint256 constant IC2y = 6212663643408226062196784892353088989815395412901426019761685471194238218387;
    
    uint256 constant IC3x = 5588684430119971779806790489406984554197499162937533906597038843081103529470;
    uint256 constant IC3y = 21045557159472855420082293162512796748596642015567381741886579379403292765059;
    
    uint256 constant IC4x = 11692606097652207027323215316953560908118471518587039539932335508887772193126;
    uint256 constant IC4y = 7211463440592774997835478707010737891603456297191986372737339129642695085204;
    
    uint256 constant IC5x = 7020128924556092059307587265214113388481885367097120172723958079384998148707;
    uint256 constant IC5y = 4702216076452200502169285085680400132747629794471877573469196997010210586571;
    
    uint256 constant IC6x = 17247606641296750795291001000095772266847904834032777232826759060553397099051;
    uint256 constant IC6y = 18982064952218365290508340265253336644372928105860058775894162654226687833249;
    
    uint256 constant IC7x = 1655268684850493216225768827179526362530128631440866141452047877697210246735;
    uint256 constant IC7y = 2981386395894198047801325444767199729468157266963593371813883280152558635164;
    
    uint256 constant IC8x = 4224289660187196793646709113279169676453732359277709549613912259617712080077;
    uint256 constant IC8y = 163654105015632728776167112648723868205684841451483162107094917968123723344;
    
    uint256 constant IC9x = 15378288645360746245859394231889535942100847408382710910413487510498976501205;
    uint256 constant IC9y = 11473236087166111756609953583451380097219445146507190752186567661343363102291;
    
    uint256 constant IC10x = 14012666742403047209912486061886572023696433885218091378226508871336056784439;
    uint256 constant IC10y = 20607879841609296748425389783323597203014698485607319575655627788123774822140;
    
    uint256 constant IC11x = 21645595812107841691010755376969821480143219116303674242558145970613369635910;
    uint256 constant IC11y = 8336787109223816505079412609353218747335690429808340633194187597172698206357;
    
    uint256 constant IC12x = 18856930472806929275201535503540819537794092291659265245656148255954314225735;
    uint256 constant IC12y = 15637437803476243351541596115026829623148594263068830645338422284462671879610;
    
    uint256 constant IC13x = 8736551344896455357258605649858140738886757463152167701917730663381853048207;
    uint256 constant IC13y = 7888960377893660524468378077282293688588832625974739631319496978906929943054;
    
    uint256 constant IC14x = 11632576853031225556992515647918958040419629545616612402152438703517442779661;
    uint256 constant IC14y = 7601268644842954429891974818154385293316642299700651884071643040024463493284;
    
    uint256 constant IC15x = 16196190911225721250470496868332237687904980857963761357326681229726363940680;
    uint256 constant IC15y = 4419335176558009240691487206948418886522710927984570543966704136128341472659;
    
    uint256 constant IC16x = 7794490396411587500012470339076900704472504717445853463438491509384011154429;
    uint256 constant IC16y = 2760909053525602125814145729803200163305321163458466216993828810383882142022;
    
    uint256 constant IC17x = 17682235773032190181589594467136477120377473987617616743326488186592203948742;
    uint256 constant IC17y = 11673557156619255646702258015942083089152893604329694432978179594445322293370;
    
    uint256 constant IC18x = 919238530661419346169420405798976377124082768153088146705698428022925256477;
    uint256 constant IC18y = 2347392298334646627587269703741560277698558843425328271210455113975963488360;
    
    uint256 constant IC19x = 10656038997862060920084416677039238177610761191119680888452295976051588105320;
    uint256 constant IC19y = 12556306217089867699805246866168508271126170052270721716454296559467559872021;
    
    uint256 constant IC20x = 20498964985603183122963982074121318219711985607067560384698359891276534581515;
    uint256 constant IC20y = 13496042739789720944442810254544373522682998906476050726613555593710980787546;
    
    uint256 constant IC21x = 1727988072294055175151179790638590583605553177538397482006580741486542490618;
    uint256 constant IC21y = 5133675445483550557911335515775703218690669707072659610957617241958214085036;
    
    uint256 constant IC22x = 4783818779177353997979238672709779651008545463087878108959607842235402141759;
    uint256 constant IC22y = 4630662116038721494102871416375170074899810119228613244356278106888821879029;
    
    uint256 constant IC23x = 2620849104533843290681067008468453342639120673401158591595089381577843901429;
    uint256 constant IC23y = 21460953024746195581963097980217501037196713464442160319970285866720124779104;
    
    uint256 constant IC24x = 208691507777362154252314641620490137999903704582751429047895939471961524612;
    uint256 constant IC24y = 19463720877024519729327156507274724666616423976727755242621574275649358473147;
    
    uint256 constant IC25x = 1644506210758699108935320230119772306793825029905190348998457339555509689218;
    uint256 constant IC25y = 6856037249097113263615385413791544533852922395039139720306913930375421971168;
    
    uint256 constant IC26x = 8385288299307878103288773912591361503198396449407567385291022753320367811814;
    uint256 constant IC26y = 21778913228536929018926634038878721905574399772884289103285859286925157838131;
    
    uint256 constant IC27x = 10656056442631751719315779780472213059577608674550910438934642644698037596166;
    uint256 constant IC27y = 12500484869206650651653341672264810335531380264986226270110906832948496532223;
    
    uint256 constant IC28x = 13231970973709147875726643785403359319178353828356595664076710915832678130021;
    uint256 constant IC28y = 11150380778368394090539347030917150044747221117923449511082940740772106724739;
    
    uint256 constant IC29x = 7078963581708837904076185319210125538581999608244945742138433861072763632104;
    uint256 constant IC29y = 15985986895325567095371542040401921046257428797130391365025267865792582325280;
    
    uint256 constant IC30x = 5953227206413222086562188347253171252696907223950805649948443128501213468125;
    uint256 constant IC30y = 1380708108661707371976375028115524292207935106827225326391926383851837481307;
    
    uint256 constant IC31x = 13685012233467467158403865509955568618584643742588980179944452884446291671851;
    uint256 constant IC31y = 6557906954635585130020251952271300884244156108456970953478042179352192668648;
    
    uint256 constant IC32x = 2557723071359152527413869884981627728963755418937225507646514384424014429516;
    uint256 constant IC32y = 2806606509947776722490769153860970687598700754241594830943813203856440909896;
    
    uint256 constant IC33x = 18448483745906068212950029408618147718953536975906530964072443682762895517693;
    uint256 constant IC33y = 783337660681947157068228082244109172414063181574813108022324142765452472031;
    
    uint256 constant IC34x = 5337320016358980687399645222432364934292563274053641680327804198024459147326;
    uint256 constant IC34y = 15258644568204812480823224419002223273779441698639296945076294085811308664875;
    
 
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
