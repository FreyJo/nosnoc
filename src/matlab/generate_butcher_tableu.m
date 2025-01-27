% BSD 2-Clause License

% Copyright (c) 2022, Armin Nurkanović, Jonathan Frey, Anton Pozharskiy, Moritz Diehl

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:

% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.

% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% This file is part of NOSNOC.

%
%
function [A,b,c,order] = generate_butcher_tableu(n_s,irk_scheme)

% currently supported schmes are: Radau-IA, Radau-IIA, Gauss-Legendre, Lobatto-IIIA, Lobatto-IIIB, Lobatto-IIIC
%  if radau is passed then Radau-IIA is used
%  if legendre is passed then Gauss-Legendre is used
%  if Lobatto is passed then Lobatto-IIIC is used

order = [];
A = [];
b = [];
c = [];

if isequal(irk_scheme,'radau')
    irk_scheme = 'Radau-IIA';
end
if isequal(irk_scheme,'legendre')
    irk_scheme = 'Gauss-Legendre';
end
if isequal(irk_scheme,'Lobatto')
    irk_scheme = 'Lobatto-IIIC';
end

%% Butcher tabelus
switch irk_scheme
    case 'Radau-I'
        order = 2*n_s-1;
        switch n_s
            case 2
                A = [0 0;...
                    1/3 1/3];
                b = [1/4 3/4];
                c = [0 2/3];
            case 3
                A = [0 0 0; ...
                    (9+sqrt(6))/75 (24+sqrt(6))/120 (168-73*sqrt(6))/600;...
                    (9-sqrt(6))/74 (168+73*sqrt(6))/600 (24-sqrt(6))/120];
                b = [1/9 (16+sqrt(6))/36 (16-sqrt(6))/36];
                c = [0 (6-sqrt(6))/10 (6+sqrt(6))/10];
            otherwise
                error('Radau-I IRK schemes avilable only for n_s =  {2,3}');
        end

    case 'Radau-IA'
        order = 2*n_s-1;
        switch n_s
            case 1
                A = [1];
                b = [1];
                c = [0];
            case 2
                A = [1/4 -1/4;...
                    1/4 5/12];
                b = [1/4 3/4];
                c = [0 2/3];
            case 3
                A = [1/9  (-1-sqrt(6))/18 (-1+sqrt(6))/18;...
                    1/9  (88+7*sqrt(6))/360 (88-43*sqrt(6))/360;...
                    1/9  (88+43*sqrt(6))/360 (88-7*sqrt(6))/360;...
                    ];
                b = [1/9 (16+sqrt(6))/36 (16-sqrt(6))/36];
                c = [0 (6-sqrt(6))/10 (6+sqrt(6))/10];
            otherwise
                error('Radau I-A IRK schemes avilable only for n_s =  {1,2,3}');
        end

    case 'Radau-IIA'
        order = 2*n_s-1;
        switch n_s
            case 1
                A = [1];
                b = [1];
                c = [1];
            case 2
                A = [0.4166666666666666   -0.08333333333333334;
                    0.75                   0.25];
                b = [0.75                   0.25];
                c = [0.3333333333333334                      1];
            case 3
                A = [0.1968154772236605   -0.06553542585019846    0.02377097434822016;
                    0.3944243147390872     0.2920734116652279   -0.04154875212599807;
                    0.3764030627004673     0.5124858261884206     0.1111111111111105];
                b = [0.3764030627004673     0.5124858261884206     0.1111111111111105];
                c = [0.1550510257216822     0.6449489742783179                      1];
            case 4
                A = [0.1129994793231566   -0.04030922072352246    0.02580237742033653   -0.00990467650726647;
                    0.2343839957474005     0.2068925739353582   -0.04785712804854048    0.01604742280651619;
                    0.2166817846232507     0.4061232638673717     0.1890365181700563   -0.02418210489983277;
                    0.2204622111767693     0.3881934688431694      0.328844319980059    0.06250000000000028];
                b = [0.2204622111767693     0.3881934688431694      0.328844319980059    0.06250000000000028];
                c = [0.08858795951270421     0.4094668644407347      0.787659461760847                      1];
            case 5
                A = [0.07299886431790423   -0.02673533110794614    0.01867692976398469   -0.01287910609330667   0.005042839233882096;
                    0.1537752314791832     0.1462148678474922   -0.03644456890512726    0.02123306311930417  -0.007935579902728565;
                    0.1400630456848102      0.298967129491284     0.1675850701352491   -0.03396910168661771    0.01094428874419229;
                    0.1448943081095353     0.2765000687601611     0.3257979229104171     0.1287567532549083   -0.01570891737880586;
                    0.143713560791225     0.2813560151494707     0.3118265229757338     0.2231039010835687    0.03999999999999915];
                b = [0.143713560791225     0.2813560151494707     0.3118265229757338     0.2231039010835687    0.03999999999999915];
                c = [0.05710419611451822     0.2768430136381237     0.5835904323689168     0.8602401356562193                      1];
            case 6
                A = [0.05095001099464115   -0.01890730655429245    0.01368607143308841   -0.01037003876604619   0.007360656396639898  -0.002909536452561747;
                    0.1082216589190592     0.1069755199373315   -0.02753902335539171    0.01749674714122762   -0.01165372189119518   0.004512237122576632;
                    0.09777967009264588     0.2231722506368956     0.1363146792730516   -0.02964696598819594    0.01635857884343794  -0.006003402610448072;
                    0.102122375612935     0.2029759573730932     0.2763991363807392     0.1310060231360506   -0.02487630319982248   0.007837084050642984;
                    0.1003310013849603     0.2102473085533347     0.2560853720503218     0.2533659347045774    0.09243053433570125   -0.01099523682773107;
                    0.1007941926267399     0.2084506671559652      0.260463391594751     0.2426935942345132     0.1598203766102531    0.02777777777778034];
                b = [0.1007941926267399     0.2084506671559652      0.260463391594751     0.2426935942345132     0.1598203766102531    0.02777777777778034];
                c = [0.03980985705146906     0.1980134178736079     0.4379748102473862      0.695464273353636     0.9014649142011735                      1];
            case 7
                A = [0.03754626499392188   -0.01403933455646073    0.01035278960074254   -0.00815832254027519   0.006388413879534827  -0.004602326779148755   0.001828942561470681;
                    0.08014759651561951    0.08106206398589107   -0.02123799212071062     0.0140002912388166   -0.01023418573008994   0.007153465151364446  -0.002812639372406667;
                    0.07206384694188284     0.1710683549838863      0.109614564040073   -0.02461987172898539    0.01476037704395017  -0.009575259396791047    0.00367267839713814;
                    0.07570512581982491     0.1540901551421676     0.2271077366732079     0.1174781870370154   -0.02381082715304217    0.01270998553366809  -0.004608844281289493;
                    0.07391234216319376     0.1613556076159313     0.2068672415521462     0.2370071153426636     0.1030867935337909   -0.01885413915255185   0.005858900974892833;
                    0.07470556205981183     0.1583072238724412     0.2141534232671916     0.2198778470318246     0.1987521216806272    0.06926550160554257  -0.008116008197745828;
                    0.07449423555603119     0.1591021157336172     0.2123518895030543       0.22355491450719     0.1904749368220564     0.1196137446127068    0.02040816326527306];
                b = [0.07449423555603119     0.1591021157336172     0.2123518895030543       0.22355491450719     0.1904749368220564     0.1196137446127068    0.02040816326527306];
                c = [0.02931642715978522     0.1480785996684844     0.3369846902811542     0.5586715187715502     0.7692338620300545      0.926945671319741                      1];
            case 8
                A = [0.02880282389261767   -0.01082169805201619   0.008069010203851772  -0.006493073596536045   0.005300041017295372  -0.004223309650010058   0.003069413349141069  -0.001223820725630499;
                    0.06168082621295073    0.06330790543528464   -0.01676616762130101    0.01127657596317949  -0.008575400848082754   0.006607056898422475  -0.004723817373991565   0.001872074494442391;
                    0.05528556326723533      0.134572019854444     0.0888301818991315   -0.02032248583700946    0.01263102222042356  -0.008970025754043154   0.006180900917007182  -0.002417353782599219;
                    0.05830068605754146     0.1204776614773424      0.186414284318503     0.1014309041574135    -0.0211961963985523    0.01224727429540229   -0.00779863777791201   0.002970397539714509;
                    0.05668200898480436     0.1270431614834191     0.1680883704193885      0.209202248763793    0.09918700574473149   -0.01927530881047712    0.01006964650507669  -0.003621850204030386;
                    0.05754303201726074     0.1237409922393375     0.1759515522840047     0.1908198137469839     0.1994568889429313    0.08243702475778036   -0.01472479575820618   0.004534800032807595;
                    0.05714697155929294     0.1252206947381822     0.1726433131883667      0.197414436139205     0.1852107846960571     0.1586212874745829    0.05371248744594759  -0.006232535779285175;
                    0.05725440737217014     0.1248239506649291     0.1735073978179251     0.1957860837255012     0.1882587726942226     0.1520653103238772    0.09267907740070136     0.0156249999999889];
                b = [0.05725440737217014     0.1248239506649291     0.1735073978179251     0.1957860837255012     0.1882587726942226     0.1520653103238772    0.09267907740070136     0.0156249999999889];
                c = [0.02247938643871306     0.1146790531609042     0.2657898227845895     0.4528463736694446     0.6473752828868304     0.8197593082631076     0.9437374394630773                      1];
            case 9
                A = [0.02278837879345955  -0.008589639752939473   0.006451029176995528  -0.005257528699750402   0.004388833809361613  -0.003651215553690662   0.002940488213752773  -0.002149274163882668  0.0008588433240576702;
                    0.04890795244750009     0.0507020504808275   -0.01352380719602086   0.009209373774304624  -0.007155713317536588   0.005747246699431968  -0.004542582976394292   0.003288161681791267  -0.001309073694109343;
                    0.04374276009157185     0.1083018929027399    0.07291956593742799   -0.01687987721001605    0.01070455184480235  -0.007901946479238919   0.005991406942180255  -0.004248024439986731   0.001678149806149554;
                    0.04624923745394938    0.09656073072680016     0.1542987697900351     0.0867193693031183   -0.01845163964361518    0.01103665872982518  -0.007673280940270644   0.005228224999886066  -0.002035905836478058;
                    0.04483443658689623     0.1023068496859594     0.1382176341923866     0.1812639346821072    0.09043360059945371   -0.01808506336681148    0.01019338790388247  -0.006405265418862882   0.002427169938414409;
                    0.04565875571930178    0.09914547048936129     0.1457470404972128     0.1636482812336908      0.185944587344693    0.08361326023157289   -0.01580993614606996   0.008138252693868253  -0.002910469207819233;
                    0.0452006001876839     0.1008537067189081     0.1419422367941934     0.1711894718378062     0.1697833861703657     0.1677682911731608    0.06707903432220519   -0.01179223053645728   0.003609246288590384;
                    0.04541651665726931     0.1000604024461609     0.1436528409872153     0.1680190809788655     0.1755607684185634     0.1558862704519015      0.128893913517004    0.04281082602437891  -0.004934574771255029;
                    0.04535725246159927     0.1002766490119029     0.1431933481790111      0.168846983486219     0.1741365013886025     0.1584218878360844     0.1235946891019921    0.07382700952257437    0.01234567901224182];
                b = [0.04535725246159927     0.1002766490119029     0.1431933481790111      0.168846983486219     0.1741365013886025     0.1584218878360844     0.1235946891019921    0.07382700952257437    0.01234567901224182];
                c = [0.01777991514736393    0.09132360789979432     0.2143084793956304     0.3719321645832724     0.5451866848034266     0.7131752428555695     0.8556337429578544     0.9553660447100301                      1];
            otherwise
                error('Radau-IIA IRK schemes avilable only for n_s =  {1,...,9}.');
        end
        %% GAUSS
    case 'Gauss-Legendre'
        order = 2*n_s;
        switch n_s
            case 1
                A = [0.5];
                b = [1];
                c = [0.5];
            case 2
                A = [0.2500000000000001   -0.03867513459481287;
                    0.5386751345948129     0.2500000000000001];
                b = [0.5                    0.5];
                c = [0.2113248654051871     0.7886751345948129];
            case 3
                % GL 6
                A = [5/36 2/9-sqrt(15)/15 5/36-sqrt(15)/30;...
                    5/36+sqrt(15)/24 2/9 5/36-sqrt(15)/24;...
                    5/36+sqrt(15)/30 2/9+sqrt(15)/15 5/36];
                b = [5/18 4/9 5/18];
                c = [1/2-sqrt(15)/10 1/2 1/2+sqrt(15)/10];

            case 4
                A = [0.0869637112843632   -0.02660418008499865    0.01262746268940467  -0.003555149685795666;
                    0.1881181174998679      0.163036288715637     -0.027880428602471   0.006735500594538226;
                    0.1671919219741889      0.353953006033745     0.1630362887156362   -0.01419069493114095;
                    0.1774825722545217     0.3134451147418718     0.3526767575162704    0.08696371128436398];
                b = [0.1739274225687264     0.3260725774312778     0.3260725774312716     0.1739274225687275];
                c = [0.06943184420297355     0.3300094782075719     0.6699905217924282     0.9305681557970262];
            case 5
                A = [0.05923172126404738   -0.01957036435907611    0.01125440081864301  -0.005593793660812207   0.001588112967866006;
                    0.1281510056700454     0.1196571676248418   -0.02459211461964225    0.01031828067068334  -0.002768994398769584;
                    0.1137762880042244     0.2600046516806416      0.142222222222221   -0.02069031643095837   0.004687154523870043;
                    0.1212324369268624     0.2289960545789982     0.3090365590640829      0.119657167624843  -0.009687563141950295;
                    0.1168753295602256     0.2449081289104935     0.2731900436257924     0.2588846996087639    0.05923172126404808];
                b = [0.1184634425280908     0.2393143352496772     0.2844444444444356     0.2393143352496843     0.1184634425280957];
                c = [0.04691007703066807     0.2307653449471586     0.4999999999999999     0.7692346550528415     0.9530899229693319];
            case 6
                A = [0.04283112309479176   -0.01476372599719691    0.00932505070647744  -0.005668858049483336   0.002854433315099251 -0.0008127801712647408;
                    0.09267349143037801    0.09019039326203543   -0.02030010229323999    0.01036315624024675  -0.004887192928037833   0.001355561055485118;
                    0.08224792261284275      0.196032162333246      0.116978483643174   -0.02048252774565654   0.007989991899662277  -0.002075625784866395;
                    0.08773787197445049     0.1723907946244138     0.2544394950320052     0.1169784836431695   -0.01565137580917408   0.003414323576740631;
                    0.08430668513410233     0.1852679794521174     0.2235938110461082     0.2542570695795783    0.09019039326203809  -0.007011245240794502;
                    0.08647502636085025     0.1775263532090016      0.239625825335853     0.2246319165798513     0.1951445125212775     0.0428311230947899];
                b = [0.08566224618958573     0.1803807865241011       0.23395696728635     0.2339569672863439     0.1803807865240639    0.08566224618958009];
                c = [0.03376524289842348     0.1693953067668674     0.3806904069584017     0.6193095930415985     0.8306046932331324     0.9662347571015758];
            case 7
                A = [0.03237124154221699   -0.01145101728318363   0.007633203872423399  -0.005133733563225245   0.003175058773685578  -0.001606819037046078  0.0004581095237494474;
                    0.07004354137872559    0.06992634787231972   -0.01659000657884821   0.009349622783443638  -0.005397091931896289   0.002645843866730124 -0.0007438501901719536;
                    0.06215393578734907       0.15200552205783    0.09545751262627866   -0.01837524421545217   0.008712562598475318  -0.003953580158810935    0.00107671561562793;
                    0.06633292861767826      0.133595769223878     0.2077018807659664      0.104489795918363   -0.01678685551340997   0.006256926520753006  -0.001590445533250384;
                    0.06366576746879105     0.1438062759034302     0.1822024626540605     0.2273548360521615    0.09545751262628183   -0.01215282631321023   0.002588547297082029;
                    0.06548633327456188     0.1372068518778939     0.1963121171844139     0.1996299690531887     0.2075050318314396    0.06992634787227447  -0.005301058294295898;
                    0.06428437356061711     0.1414595147815465     0.1877399664788717     0.2141133253997449     0.1832818213801396      0.151303713027731    0.03237124154220898];
                b = [0.0647424830843597     0.1398526957445457     0.1909150252524643     0.2089795918366266     0.1909150252525775     0.1398526957445209    0.06474248308442854];
                c = [0.02544604382862048     0.1292344072003029     0.2970774243113013                    0.5     0.7029225756886985     0.8707655927996973      0.974553956171379];
            case 8
                A = [0.02530713407259356  -0.009105943305969781   0.006280831147030319  -0.004483015613054645   0.003078491368326703  -0.001917675254636903  0.0009727576640592404 -0.0002775083271169136;
                    0.05475932176755399    0.05559525861334469   -0.01363979623578232    0.00814970885836086  -0.005215352089147446   0.003139752985463831  -0.001564934910949028  0.0004428023043422605;
                    0.04858753599891286     0.1208595249971733    0.07842666146947086   -0.01597510336187913   0.008371732720225511  -0.004643465862104401   0.002225714775284854   -0.00061880569525051;
                    0.05186552097058206     0.1061934901483497     0.1706711342745484    0.09067094584458424   -0.01602104132103044   0.007241206561224622  -0.003197814310361813  0.0008592365842650662;
                    0.04975503156092653     0.1143883315370484      0.149612116377682     0.1973629330101723    0.09067094584459845   -0.01381781133558402   0.004997027078331273  -0.001251252825390958;
                    0.05123307384044651     0.1089648024513998     0.1614967888009193     0.1729701589687913     0.1973169950509845    0.07842666146959942  -0.009669007770489291   0.002026732146281129;
                    0.05017146584088472      0.112755452137506     0.1537135699531262     0.1865572437778606     0.1731921828309755     0.1704931191750099    0.05559525861335057  -0.004145053622349293;
                    0.05089177647223053     0.1102177595625342     0.1587709981928001     0.1782634003203007     0.1858249073020861     0.1505724917923938     0.1202964605326016    0.02530713407263407];
                b = [0.05061426814526016     0.1111905172265963     0.1568533229381508     0.1813418916882945     0.1813418916891845     0.1568533229394999     0.1111905172266145    0.05061426814524528];
                c = [0.01985507175123158     0.1016667612931869     0.2372337950418356     0.4082826787521751     0.5917173212478248     0.7627662049581645     0.8983332387068135      0.980144928248768];
            case 9
                A = [0.02031859709039379  -0.007397868566148903   0.005222003592100137  -0.003873451291745052   0.002831369450069885  -0.001962194188391251   0.001226609788812583 -0.0006229640916489282  0.0001777784627448029;
                    0.04396552722652858    0.04516204017371401   -0.01133546401233495   0.007034766801734607  -0.004788276131016548     0.0032033601519848   -0.00196440573995347  0.0009871721036659369 -0.0002802742376409376;
                    0.03900865339628465    0.09818151195984827     0.0651526741007335   -0.01377083398660861   0.007664175624642625  -0.004713586467798804    0.00277082889275898  -0.001361671983073028  0.0003825321129180968;
                    0.04164508702732636    0.08625547277250323      0.141795216041138    0.07808676926000024    -0.0146189578759095   0.007300428262182135  -0.003932839915038344   0.001852686200821019 -0.0005105734749282498;
                    0.03994037286986041    0.09294337227272464     0.1242571104107402     0.1700004452552939    0.08255983875032058   -0.01382690673521836   0.006048237790677646  -0.002619291925299194  0.0006968213109548316;
                    0.04114776765582562    0.08847139414673677     0.1342381881161714     0.1488731102581085     0.1797386353763102    0.07808676926012481   -0.01148986783981343   0.004068607574950533  -0.001007892846526914;
                    0.0402546620681079    0.09168575233098863     0.1275345193082558     0.1608871249882213     0.1574555018756882     0.1699443725068477    0.06515267410031811  -0.007857431612421806   0.001628540784537336;
                    0.04091746841902477     0.0893369082443769     0.1322697539405908     0.1529701783683777     0.1699079536319914     0.1491387717182988     0.1416408122131543    0.04516204017340897  -0.003328333045658383;
                    0.0404594157188285    0.09094704444032686     0.1290787384114083     0.1581357327095247     0.1622883080499378     0.1600469898116899     0.1250833446083561    0.09772194891343133    0.02031859709046557];
                b = [0.04063719418161327    0.09032408034818218     0.1303053481997267      0.156173538521216     0.1651196775001154      0.156173538521216     0.1303053482006362    0.09032408034750006    0.04063719418104483];
                c = [0.01591988024618707    0.08198444633668212      0.193314283649705     0.3378732882980954     0.4999999999999999     0.6621267117019045     0.8066857163502952     0.9180155536633177     0.9840801197538126];
            otherwise
                error('Gauss-Legendre IRK schemes avilable only for n_s =  {1,...,9}.');
        end
        %% Lobatto
    case 'Lobatto-III'
        order = 2*n_s-2;
        switch n_s
            case 1
                error('Lobatto-III with n_s = 1 does not exist.')
            case 2
                c = [0 1];
                b = [0.5 0.5];
                A = [ 0 0;...
                    1 0];
            case 3
                c = [0 1/2 1];
                b = [1/6 2/3 1/6];
                A = [0 0 0;...
                    1/4 1/4 0;...
                    0 1 0];
            case 4
                c = [0 1/2-sqrt(5)/10 1/2+sqrt(5)/10 1];
                b = [1/12 5/12 5/12 1/12];
                A = [0 0 0 0 ;...
                    (5+sqrt(5))/60 1/6 (15-7*sqrt(5))/60 0;...
                    (5-sqrt(5))/60 (15+7*sqrt(5))/60 1/6 0;...
                    1/6 (5-sqrt(5))/12 (5+sqrt(5))/12  0];
            case 5
                c = [0 (7-sqrt(21)/14) 1/2 (7+sqrt(21)/14) 1];
                b = [1/20 49/180 16/45 49/180 1/20];
                A = [0 0 0 0 0;...
                    1/14 1/9 (13-3*sqrt(21))/63 (14-3*sqrt(21))/126 0;...
                    1/32 (91+21*sqrt(21))/576 11/72 (91-21*sqrt(21))/576 0;...
                    1/14 (14+3*sqrt(21))/126 (13+3*sqrt(21))/63 1/9 0;...
                    0 7/18 2/9 7/18 0];
            otherwise
                error('Lobatto-III IRK schemes avilable only for n_s =  {2,3,4,5}.');
        end
    case 'Lobatto-IIIA'
        order = 2*n_s-2;
        switch n_s
            case 1
                error('Lobatto-IIIA IRK scheme does not exist for n_s =1.');
            case 2
                c = [0 1];
                b = [1/2 1/2];
                A = [ 0 0; ...
                    1/2 1/2];
            case 3
                c = [0 1/2 1];
                b = [1/6 2/3 1/6];
                A = [0 0 0;...
                    5/24 1/3 -1/24;...
                    1/6 2/3 1/6];
            case 4
                c = [0 1/2-sqrt(5)/10 1/2+sqrt(5)/10 1];
                b = [1/12 5/12 5/12 1/12];
                A = [0 0 0 0 ;...
                    (11+sqrt(5))/120 (25-sqrt(5))/120 (25-13*sqrt(5))/120 (-1+sqrt(5))/120;...
                    (11-sqrt(5))/120 (25+13*sqrt(5))/120 (25+sqrt(5))/120 (-1-sqrt(5))/120;...
                    1/12 5/12 5/12 1/12];
            case 5
                c = [0 (7-sqrt(21)/14) 1/2 (7+sqrt(21)/14) 1];
                b = [1/20 49/180 16/45 49/180 1/20];
                A = [0 0 0 0 0;...
                    (119+3*sqrt(21))/1960 (343-9*sqrt(21))/2520 (392-96*sqrt(21))/2205 (343-69*sqrt(21))/2520 (-21+3*sqrt(21))/1960;...
                    13/320 (392+105*sqrt(21))/2880 8/45 (392-105*sqrt(21))/2880 3/320;...
                    (119-3*sqrt(21))/1960 (343+69*sqrt(21))/2520 (392+96*sqrt(21))/2205 (343+9*sqrt(21))/2520 (-21-3*sqrt(21))/1960;...
                    1/20 49/180 16/45 49/180 1/20];

            otherwise
                error('Lobatto-IIIA IRK schemes avilable only for n_s =  {2,3,4,5}');
        end


    case 'Lobatto-IIIB'
        order = 2*n_s-2;
        switch n_s
            case 1
                error('Lobatto-IIIB IRK scheme does not exist for n_s =1.');
            case 2
                % Accoriding to Butcher book this does not exist, but a table can be found in Hairers book.
                c =[0 1];
                b = [1/2 1/2];
                A = [1/2 0;...
                    1/2 0];
            case 3
                c = [0 1/2 1];
                b = [1/6 2/3 1/6];
                A = [1/6 -1/6 0;...
                    1/6 1/3 0;...
                    1/6 5/6 0];
            case 4
                c = [0 1/2-sqrt(5)/10 1/2+sqrt(5)/10 1];
                b = [1/12 5/12 5/12 1/12];
                A = [1/12 (-1-sqrt(5))/24       (-1+sqrt(5))/24      0; ...
                     1/12 (25+sqrt(5))/120      (25-13*sqrt(5))/120  0; ...
                     1/12 (25+13*sqrt(5))/120   (25-sqrt(5))/120     0; ...
                     1/12 (11-sqrt(5))/24       (11+sqrt(5))/24    0];
            case 5
                c = [0 1/2-sqrt(21)/14 1/2 1/2+sqrt(21)/14 1];
                b = [1/20 49/180 16/45 49/180 1/20];
                A = [1/20    (-7-sqrt(21))/120       1/15                        (-7+sqrt(21))/120       0;...
                     1/20    (343+9*sqrt(21))/2520   (56-15*sqrt(21))/315        (343-69*sqrt(21))/2520  0;...
                     1/20    (49+12*sqrt(21))/360     8/45                       (49-12*sqrt(21))/360     0;...
                     1/20    (343+69*sqrt(21))/2520  (56+15*sqrt(21))/315        (343-9*sqrt(21))/2520   0;...
                     1/20    (119-3*sqrt(21))/360     13/45                      (119+3*sqrt(21))/360    0;...
                    ];

            otherwise
                error('Lobatto-IIIB IRK schemes avilable only for n_s =  {2,3,4,5}.');
        end

    case 'Lobatto-IIIC'
        order = 2*n_s-2;
        switch n_s
            case 2
                c =[0 1];
                b = [1/2 1/2];
                A = [1/2 -1/2;...
                    1/2 1/2];
            case 3
                c = [0 1/2 1];
                b = [1/6 2/3 1/6];
                A = [1/6 -1/3 1/6;...
                    1/6 5/12 -1/12;...
                    1/6 2/3 1/6];
            case 4
                c = [0 (5-sqrt(5))/10 (5+sqrt(5))/10 1];
                b = [1/12 5/12 5/12 1/12];
                A = [1/12  (-sqrt(5))/12    (sqrt(5))/12        -1/12; ...
                    1/12  1/4              (10-7*sqrt(5))/60   (sqrt(5))/60; ...
                    1/12  (10+7*sqrt(5))/60 1/4                -(sqrt(5))/60; ...
                    1/12  5/12              5/12               1/12; ...
                    ];
            case 5
                c = [0 (7-sqrt(21)/14) 1/2 (7+sqrt(21)/14) 1];
                b = [1/20 49/180 16/45 49/180 1/20];
                A = [1/20   -7/60 2/15 -7/60 1/20;...
                    1/20     29/180 (47-15*sqrt(21))/315 (203-30*sqrt(21))/1260 -3/140;...
                    1/20    (329+105*sqrt(21))/2880 73/360 (329-105*sqrt(21))/2880 3/160;...
                    1/20    (203+30*sqrt(21))/1260  (47+15*sqrt(21))/315 29/180 -3/140;...
                    1/20 49/180 16/45 49/180 1/20];

            otherwise
                error('Lobatto-IIIC IRK schemes avilable only for n_s =  {2,3,4,5}.');
        end

    case 'Explicit-RK'
        switch n_s
            case 1
                % explicit Euler
                A = [0];
                c = [0];
                b = [1];
                order = 1;
            case 2
                % Heuns 2nd order
                A  = [0 0; 1 0];
                b = [1/2 1/2];
                c = [0 1];
                order = 2;
            case 3
                % Strong stability presserving Runge-Kutta
                                  A = [0 0 0; 1 0 0; 1/4 1/4 0];
                                  b = [1/6 1/6 2/3];
                                  c = [0 1 1/2];
                % Kutta's 3rd oder method
%                 A = [0 0 0; 1/2 0 0;-1 2 0];
%                 b = [1/6 2/3 1/6];
%                 c = [0 1/2 1];
                    % Heun's 3rd order
                A = [0  0  0;...
                     1/3 0 0;...
                     0 2/3 0];
                b = [1/4 0 3/4];
                c = [0 1/3 2/3];
                order = 3;
            case 4
                %  "The" Runge-Kutta Method
                A = [0 0 0 0;...
                    1/2 0 0 0;...
                    0 1/2 0 0;...
                    0 0 1 0];
                b = [1/6 1/3 1/3 1/6];
                c = [0 1/2 1/2 1];
                order = 4;
            case 5
                error('noting implemented.')
            case 6
                % Nystrom(1925), Butcher's book pg 192
                A = [0      0       0       0   0  0;...
                    1/3     0       0       0   0  0;...
                    4/25    6/25    0       0   0  0;...
                    1/4     -3      15/5    0   0  0;...
                    2/27     10/9   -50/81  8/81   0  0;...
                    2/25     12/25   2/15  8/75   0  0;...
                    ];
                b = [23/192 0 125/192 0 -27/64 125/192];
                c = [0 1/3 2/5 1 2/4 4/5];
            otherwise
                error('not implemented yet')
        end
        % SEMI-EXPLICIT RK
    case 'Semi-Explicit-RK'
        error('not implemented yet')
        % INDEX2 TAILORED RK
        % BUTCHER METHODS
    otherwise
        error('Option does not exist. Please pick some of the following options: IRK scheme: Radau-IA, Radau-IIA, Gauss-Legendre, Lobatto-IIIA, Lobatto-IIIB, Lobatto-IIIC')
end

end

