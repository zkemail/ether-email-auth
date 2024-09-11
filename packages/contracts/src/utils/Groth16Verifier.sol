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
    uint256 constant deltax1 = 15319578088144148433870292454392579210531397678084258888038350512286180645447;
    uint256 constant deltax2 = 1086199161593118582719091177042876064789126336461297231728792628701689859806;
    uint256 constant deltay1 = 4446519589909698948619442693220675737896467901545229603388595770900353019149;
    uint256 constant deltay2 = 8139820593384559533426709059696820531467462438480254791000622464992960199684;

    
    uint256 constant IC0x = 13986287304781811629818135937460078168318260622373795543277096066372223143543;
    uint256 constant IC0y = 15894331243762149015069486145475096510770522826153695662065578862511865498937;
    
    uint256 constant IC1x = 6657352747838160193290269178909503517423918732593479650799343149184802404227;
    uint256 constant IC1y = 17531545371284544846757265261390554928852673143570772606416106283932089249579;
    
    uint256 constant IC2x = 16051798939592501067339450771812211828093389728707303947187369590196641845613;
    uint256 constant IC2y = 10642771260914469864609917257305668847488863380437098896048772227333105938215;
    
    uint256 constant IC3x = 11516771157572865390427149046363199727462471754207638386939698647160647244244;
    uint256 constant IC3y = 17750959699385211687017966515706019664346563638845176389048062816482362876919;
    
    uint256 constant IC4x = 16585945905928734303656632207622552215825428661762022954125060983592130784974;
    uint256 constant IC4y = 3229598948329671362480222913836846699152815669479715539731783730018250763823;
    
    uint256 constant IC5x = 2735854243292750270201823836486550894787960439689214123103674588113028210303;
    uint256 constant IC5y = 10229313779238541038726274141671860314069645438049912809508167509745776241686;
    
    uint256 constant IC6x = 14190416281134666159920819160995974222908686549823480648732091214431137294963;
    uint256 constant IC6y = 9029501137578433593499338927272434967030906660585173877815017333537018567602;
    
    uint256 constant IC7x = 12170260117675309582350267080302912575028682087359352382893089877455951772473;
    uint256 constant IC7y = 20464605792252479349840655650760617496046593314952148684746613675335058350942;
    
    uint256 constant IC8x = 4668263935738216597600035713072363446560555431149535779407481594748353348299;
    uint256 constant IC8y = 6761669100053229151181201776369124528384949481913373501345799877551671442490;
    
    uint256 constant IC9x = 17613426733350227864491099426537059832375604576663256857363196285633689216670;
    uint256 constant IC9y = 5805908718695762877817749042508472227770796644334990955096436485320700026010;
    
    uint256 constant IC10x = 1007270225032823010989311002543641079754257589690234134844035082768426542620;
    uint256 constant IC10y = 21475642872129196888302396594264201358769263783216674834698667474324214197953;
    
    uint256 constant IC11x = 15081923087373370787973554347749696256252721214961183946262805192094431665288;
    uint256 constant IC11y = 16680069154888020053830495566095733479743182649643804408659380808462437769348;
    
    uint256 constant IC12x = 7353920573820203673864179902327357836943865465363806932276427158533966054007;
    uint256 constant IC12y = 4906960257966631805968560571985842137400392165080887614941226783003180438368;
    
    uint256 constant IC13x = 4533862304475638755375693106780349782380565190034231050848543922795764879802;
    uint256 constant IC13y = 598446044155555715891219562107384479652732465225600288479065093170075495657;
    
    uint256 constant IC14x = 7122480915086391928930945426177923412929688778313549168236076125436940484112;
    uint256 constant IC14y = 9038961138446510912414783948801197218570794393245280448178371602457294281632;
    
    uint256 constant IC15x = 6714101981980268884481533101476229027015190942378292707659542820827021193397;
    uint256 constant IC15y = 11272887771609959733703167827323622301549783063678829277178890525700670890129;
    
    uint256 constant IC16x = 20437112715761765707147148391773769986470432308919910067302657232573395960162;
    uint256 constant IC16y = 15321179474484971518132512130588191553678751040283340303685576790320739150657;
    
    uint256 constant IC17x = 19219092435091423465633523463253249487338506702794487406401643619518191650129;
    uint256 constant IC17y = 17282626638553680622130806938296519057489422178618812871701640691501519771672;
    
    uint256 constant IC18x = 16606183112206685785600995921349860405026995817135601022134279364752803469536;
    uint256 constant IC18y = 16043499772242927375270363061004003839285471350971879635887182974533742603287;
    
    uint256 constant IC19x = 1210707359308302969770163002263119043614552129675869248158635495219906105852;
    uint256 constant IC19y = 12680511356057658336130187063160473463083334743891046286452211277763548137276;
    
    uint256 constant IC20x = 11086125674217491500739269827053901222271696690174050254374133368712953243088;
    uint256 constant IC20y = 6053103800204978405773186514845086084032005357588363656542377416178871564775;
    
    uint256 constant IC21x = 14748494146527412772741859783064786419256684299339014876234608950795174044510;
    uint256 constant IC21y = 8712883247211066789641782294202642212131980591356063435892043611448376329402;
    
    uint256 constant IC22x = 11839379700336717343079420809622942111687375327897345508451774961872673770316;
    uint256 constant IC22y = 8895701596719783222411291561512126156358240424160295697039536555088618180915;
    
    uint256 constant IC23x = 18344723580640218566078573334781871542714315793755378650476142891258578517167;
    uint256 constant IC23y = 6037447496975377303076282689670453476478799098316334507779292520966118416141;
    
    uint256 constant IC24x = 1219018687863146079804927794790349811713233524506071692145203043151155579912;
    uint256 constant IC24y = 12259329329644691804803466046583012104373647543094116751541858451574329049339;
    
    uint256 constant IC25x = 18616266469772173270024938497854580018451184027620595567381348061717260755876;
    uint256 constant IC25y = 13657793433977158706390923089623450140219483127718023788044217038622204508743;
    
    uint256 constant IC26x = 12727423626475319557504848343871689884624000795573098126755145386839939527511;
    uint256 constant IC26y = 2938262592563768549228983305699572862280081061292424052023446347112367143549;
    
    uint256 constant IC27x = 21487591408762398705234938070547673395123973173141617628201773263097079121694;
    uint256 constant IC27y = 12720246748523909661755448585533297402316709697570936404470276522191359637563;
    
    uint256 constant IC28x = 16467178226026300059831605377943086050334723191464668213518101445484504783848;
    uint256 constant IC28y = 9139131916495414634537516523354727831542697092324217153640571950935058484467;
    
    uint256 constant IC29x = 11813394657812788297263465566473337219295871229603907247462957762987163286727;
    uint256 constant IC29y = 2333466569019313289053951330259295038552214976343543633683510156531235807982;
    
    uint256 constant IC30x = 5758319522107086585563855735449863655068464994393372981823525634565012585161;
    uint256 constant IC30y = 281303738559625778766939028867621386494750433481191839742375920626126152406;
    
    uint256 constant IC31x = 10766255441893413771043297335573055973288564739850120191905483233382630740246;
    uint256 constant IC31y = 8012588191039935342856190453376510257080197619321852273994553617995812833773;
    
    uint256 constant IC32x = 13740647652203492799542105246627141268848155986372129145815588390071245063824;
    uint256 constant IC32y = 12989805147963975539185412669782613149167981050611353053030652178298637898321;
    
    uint256 constant IC33x = 11678473503165871308190682100052535955722167524502187482920769926720343167599;
    uint256 constant IC33y = 13548393914151182724283386224251830133662331816742832947222699249802146353834;
    
    uint256 constant IC34x = 20746424191835410865488887203537015077703505567964632145891041247460534632431;
    uint256 constant IC34y = 14888985375914925013094608784755252069956164909406628467775584250729953169513;
    
 
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
