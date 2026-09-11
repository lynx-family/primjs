#ifdef ENABLE_COMPATIBLE_MM
#include <cinttypes>
#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <map>
#include <mutex>
#if defined(APPLE) || defined(__APPLE__) || defined(OS_IOS)
#include <mach/thread_act.h>
#include <mach/thread_policy.h>
#include <sys/sysctl.h>
#endif
#include <sys/types.h>

#include "gc/collector.h"
#include "gc/collector_ms.h"
#include "gc/ros_allocator_inlined.h"
#include "gc/structs.h"

namespace ROS_GC {

namespace {
#ifdef FUTURE_OPTIMIZE
inline bool are_types_equal(ContinuousPageTypes a, ContinuousPageTypes b) {
#if defined(__ARM_NEON)
  ContinuousPageTypes result = vceqq_u8(a, b);
  return vminvq_u8(result) == 0xFF;
#else
  return a == b;
#endif  // defined(__ARM_NEON)
}
#endif  // FUTURE_OPTIMIZE
}  // namespace

uint8_t RosAllocImpl::kRunMagic = 0;

// REMEMBER TO CHANGE kRunConfigs WHEN YOU ADD/REMOVE CONFIGS
// this stores a config for each kind of run (represented by an index)
const RunConfigType RunConfig::kCfgs[kRunConfigs] = {
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 16},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 24},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 32},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 40},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 48},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 56},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 64},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 72},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 80},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 88},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 96},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 104},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 112},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 120},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 128},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 136},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 144},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 152},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 160},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 168},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 176},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 184},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 192},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 200},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 208},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 216},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 224},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 232},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 240},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 248},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 256},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 264},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 272},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 280},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 288},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 296},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 304},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 312},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 320},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 328},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 336},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 344},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 352},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 360},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 400},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 448},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 504},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 576},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 672},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 800},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 1008},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 1344},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 2016},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 2688},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 4032},
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 5376},
    // this size must be the same with kROSAllocLargeSize
    {kRosimplDefaultMaxCacheRun, kRosimplDefaultPagePerRun, 8064}};
// this map maps a size ((size >> 3 - 1) to be precise) to a run config
// this map takes 4 * kMaxRunConfigs == 4KB
// REMEMBER TO UPDATE THESE WHEN `kRunConfigs` CHANGES.
// static
const uint32_t RunConfig::size2idx[kMaxRunConfigs] = {
    /*[0] = */ 0,
    /*[1] = */ 0,
    /*[2] = */ 1,
    /*[3] = */ 2,
    /*[4] = */ 3,
    /*[5] = */ 4,
    /*[6] = */ 5,
    /*[7] = */ 6,
    /*[8] = */ 7,
    /*[9] = */ 8,
    /*[10] = */ 9,
    /*[11] = */ 10,
    /*[12] = */ 11,
    /*[13] = */ 12,
    /*[14] = */ 13,
    /*[15] = */ 14,
    /*[16] = */ 15,
    /*[17] = */ 16,
    /*[18] = */ 17,
    /*[19] = */ 18,
    /*[20] = */ 19,
    /*[21] = */ 20,
    /*[22] = */ 21,
    /*[23] = */ 22,
    /*[24] = */ 23,
    /*[25] = */ 24,
    /*[26] = */ 25,
    /*[27] = */ 26,
    /*[28] = */ 27,
    /*[29] = */ 28,
    /*[30] = */ 29,
    /*[31] = */ 30,
    /*[32] = */ 31,
    /*[33] = */ 32,
    /*[34] = */ 33,
    /*[35] = */ 34,
    /*[36] = */ 35,
    /*[37] = */ 36,
    /*[38] = */ 37,
    /*[39] = */ 38,
    /*[40] = */ 39,
    /*[41] = */ 40,
    /*[42] = */ 41,
    /*[43] = */ 42,
    /*[44] = */ 43,
    /*[45] = */ 44,
    /*[46] = */ 44,
    /*[47] = */ 44,
    /*[48] = */ 44,
    /*[49] = */ 44,
    /*[50] = */ 45,
    /*[51] = */ 45,
    /*[52] = */ 45,
    /*[53] = */ 45,
    /*[54] = */ 45,
    /*[55] = */ 45,
    /*[56] = */ 46,
    /*[57] = */ 46,
    /*[58] = */ 46,
    /*[59] = */ 46,
    /*[60] = */ 46,
    /*[61] = */ 46,
    /*[62] = */ 46,
    /*[63] = */ 47,
    /*[64] = */ 47,
    /*[65] = */ 47,
    /*[66] = */ 47,
    /*[67] = */ 47,
    /*[68] = */ 47,
    /*[69] = */ 47,
    /*[70] = */ 47,
    /*[71] = */ 47,
    /*[72] = */ 48,
    /*[73] = */ 48,
    /*[74] = */ 48,
    /*[75] = */ 48,
    /*[76] = */ 48,
    /*[77] = */ 48,
    /*[78] = */ 48,
    /*[79] = */ 48,
    /*[80] = */ 48,
    /*[81] = */ 48,
    /*[82] = */ 48,
    /*[83] = */ 48,
    /*[84] = */ 49,
    /*[85] = */ 49,
    /*[86] = */ 49,
    /*[87] = */ 49,
    /*[88] = */ 49,
    /*[89] = */ 49,
    /*[90] = */ 49,
    /*[91] = */ 49,
    /*[92] = */ 49,
    /*[93] = */ 49,
    /*[94] = */ 49,
    /*[95] = */ 49,
    /*[96] = */ 49,
    /*[97] = */ 49,
    /*[98] = */ 49,
    /*[99] = */ 49,
    /*[100] = */ 50,
    /*[101] = */ 50,
    /*[102] = */ 50,
    /*[103] = */ 50,
    /*[104] = */ 50,
    /*[105] = */ 50,
    /*[106] = */ 50,
    /*[107] = */ 50,
    /*[108] = */ 50,
    /*[109] = */ 50,
    /*[110] = */ 50,
    /*[111] = */ 50,
    /*[112] = */ 50,
    /*[113] = */ 50,
    /*[114] = */ 50,
    /*[115] = */ 50,
    /*[116] = */ 50,
    /*[117] = */ 50,
    /*[118] = */ 50,
    /*[119] = */ 50,
    /*[120] = */ 50,
    /*[121] = */ 50,
    /*[122] = */ 50,
    /*[123] = */ 50,
    /*[124] = */ 50,
    /*[125] = */ 50,
    /*[126] = */ 51,
    /*[127] = */ 51,
    /*[128] = */ 51,
    /*[129] = */ 51,
    /*[130] = */ 51,
    /*[131] = */ 51,
    /*[132] = */ 51,
    /*[133] = */ 51,
    /*[134] = */ 51,
    /*[135] = */ 51,
    /*[136] = */ 51,
    /*[137] = */ 51,
    /*[138] = */ 51,
    /*[139] = */ 51,
    /*[140] = */ 51,
    /*[141] = */ 51,
    /*[142] = */ 51,
    /*[143] = */ 51,
    /*[144] = */ 51,
    /*[145] = */ 51,
    /*[146] = */ 51,
    /*[147] = */ 51,
    /*[148] = */ 51,
    /*[149] = */ 51,
    /*[150] = */ 51,
    /*[151] = */ 51,
    /*[152] = */ 51,
    /*[153] = */ 51,
    /*[154] = */ 51,
    /*[155] = */ 51,
    /*[156] = */ 51,
    /*[157] = */ 51,
    /*[158] = */ 51,
    /*[159] = */ 51,
    /*[160] = */ 51,
    /*[161] = */ 51,
    /*[162] = */ 51,
    /*[163] = */ 51,
    /*[164] = */ 51,
    /*[165] = */ 51,
    /*[166] = */ 51,
    /*[167] = */ 51,
    /*[168] = */ 52,
    /*[169] = */ 52,
    /*[170] = */ 52,
    /*[171] = */ 52,
    /*[172] = */ 52,
    /*[173] = */ 52,
    /*[174] = */ 52,
    /*[175] = */ 52,
    /*[176] = */ 52,
    /*[177] = */ 52,
    /*[178] = */ 52,
    /*[179] = */ 52,
    /*[180] = */ 52,
    /*[181] = */ 52,
    /*[182] = */ 52,
    /*[183] = */ 52,
    /*[184] = */ 52,
    /*[185] = */ 52,
    /*[186] = */ 52,
    /*[187] = */ 52,
    /*[188] = */ 52,
    /*[189] = */ 52,
    /*[190] = */ 52,
    /*[191] = */ 52,
    /*[192] = */ 52,
    /*[193] = */ 52,
    /*[194] = */ 52,
    /*[195] = */ 52,
    /*[196] = */ 52,
    /*[197] = */ 52,
    /*[198] = */ 52,
    /*[199] = */ 52,
    /*[200] = */ 52,
    /*[201] = */ 52,
    /*[202] = */ 52,
    /*[203] = */ 52,
    /*[204] = */ 52,
    /*[205] = */ 52,
    /*[206] = */ 52,
    /*[207] = */ 52,
    /*[208] = */ 52,
    /*[209] = */ 52,
    /*[210] = */ 52,
    /*[211] = */ 52,
    /*[212] = */ 52,
    /*[213] = */ 52,
    /*[214] = */ 52,
    /*[215] = */ 52,
    /*[216] = */ 52,
    /*[217] = */ 52,
    /*[218] = */ 52,
    /*[219] = */ 52,
    /*[220] = */ 52,
    /*[221] = */ 52,
    /*[222] = */ 52,
    /*[223] = */ 52,
    /*[224] = */ 52,
    /*[225] = */ 52,
    /*[226] = */ 52,
    /*[227] = */ 52,
    /*[228] = */ 52,
    /*[229] = */ 52,
    /*[230] = */ 52,
    /*[231] = */ 52,
    /*[232] = */ 52,
    /*[233] = */ 52,
    /*[234] = */ 52,
    /*[235] = */ 52,
    /*[236] = */ 52,
    /*[237] = */ 52,
    /*[238] = */ 52,
    /*[239] = */ 52,
    /*[240] = */ 52,
    /*[241] = */ 52,
    /*[242] = */ 52,
    /*[243] = */ 52,
    /*[244] = */ 52,
    /*[245] = */ 52,
    /*[246] = */ 52,
    /*[247] = */ 52,
    /*[248] = */ 52,
    /*[249] = */ 52,
    /*[250] = */ 52,
    /*[251] = */ 52,
    /*[252] = */ 53,
    /*[253] = */ 53,
    /*[254] = */ 53,
    /*[255] = */ 53,
    /*[256] = */ 53,
    /*[257] = */ 53,
    /*[258] = */ 53,
    /*[259] = */ 53,
    /*[260] = */ 53,
    /*[261] = */ 53,
    /*[262] = */ 53,
    /*[263] = */ 53,
    /*[264] = */ 53,
    /*[265] = */ 53,
    /*[266] = */ 53,
    /*[267] = */ 53,
    /*[268] = */ 53,
    /*[269] = */ 53,
    /*[270] = */ 53,
    /*[271] = */ 53,
    /*[272] = */ 53,
    /*[273] = */ 53,
    /*[274] = */ 53,
    /*[275] = */ 53,
    /*[276] = */ 53,
    /*[277] = */ 53,
    /*[278] = */ 53,
    /*[279] = */ 53,
    /*[280] = */ 53,
    /*[281] = */ 53,
    /*[282] = */ 53,
    /*[283] = */ 53,
    /*[284] = */ 53,
    /*[285] = */ 53,
    /*[286] = */ 53,
    /*[287] = */ 53,
    /*[288] = */ 53,
    /*[289] = */ 53,
    /*[290] = */ 53,
    /*[291] = */ 53,
    /*[292] = */ 53,
    /*[293] = */ 53,
    /*[294] = */ 53,
    /*[295] = */ 53,
    /*[296] = */ 53,
    /*[297] = */ 53,
    /*[298] = */ 53,
    /*[299] = */ 53,
    /*[300] = */ 53,
    /*[301] = */ 53,
    /*[302] = */ 53,
    /*[303] = */ 53,
    /*[304] = */ 53,
    /*[305] = */ 53,
    /*[306] = */ 53,
    /*[307] = */ 53,
    /*[308] = */ 53,
    /*[309] = */ 53,
    /*[310] = */ 53,
    /*[311] = */ 53,
    /*[312] = */ 53,
    /*[313] = */ 53,
    /*[314] = */ 53,
    /*[315] = */ 53,
    /*[316] = */ 53,
    /*[317] = */ 53,
    /*[318] = */ 53,
    /*[319] = */ 53,
    /*[320] = */ 53,
    /*[321] = */ 53,
    /*[322] = */ 53,
    /*[323] = */ 53,
    /*[324] = */ 53,
    /*[325] = */ 53,
    /*[326] = */ 53,
    /*[327] = */ 53,
    /*[328] = */ 53,
    /*[329] = */ 53,
    /*[330] = */ 53,
    /*[331] = */ 53,
    /*[332] = */ 53,
    /*[333] = */ 53,
    /*[334] = */ 53,
    /*[335] = */ 53,
    /*[336] = */ 54,
    /*[337] = */ 54,
    /*[338] = */ 54,
    /*[339] = */ 54,
    /*[340] = */ 54,
    /*[341] = */ 54,
    /*[342] = */ 54,
    /*[343] = */ 54,
    /*[344] = */ 54,
    /*[345] = */ 54,
    /*[346] = */ 54,
    /*[347] = */ 54,
    /*[348] = */ 54,
    /*[349] = */ 54,
    /*[350] = */ 54,
    /*[351] = */ 54,
    /*[352] = */ 54,
    /*[353] = */ 54,
    /*[354] = */ 54,
    /*[355] = */ 54,
    /*[356] = */ 54,
    /*[357] = */ 54,
    /*[358] = */ 54,
    /*[359] = */ 54,
    /*[360] = */ 54,
    /*[361] = */ 54,
    /*[362] = */ 54,
    /*[363] = */ 54,
    /*[364] = */ 54,
    /*[365] = */ 54,
    /*[366] = */ 54,
    /*[367] = */ 54,
    /*[368] = */ 54,
    /*[369] = */ 54,
    /*[370] = */ 54,
    /*[371] = */ 54,
    /*[372] = */ 54,
    /*[373] = */ 54,
    /*[374] = */ 54,
    /*[375] = */ 54,
    /*[376] = */ 54,
    /*[377] = */ 54,
    /*[378] = */ 54,
    /*[379] = */ 54,
    /*[380] = */ 54,
    /*[381] = */ 54,
    /*[382] = */ 54,
    /*[383] = */ 54,
    /*[384] = */ 54,
    /*[385] = */ 54,
    /*[386] = */ 54,
    /*[387] = */ 54,
    /*[388] = */ 54,
    /*[389] = */ 54,
    /*[390] = */ 54,
    /*[391] = */ 54,
    /*[392] = */ 54,
    /*[393] = */ 54,
    /*[394] = */ 54,
    /*[395] = */ 54,
    /*[396] = */ 54,
    /*[397] = */ 54,
    /*[398] = */ 54,
    /*[399] = */ 54,
    /*[400] = */ 54,
    /*[401] = */ 54,
    /*[402] = */ 54,
    /*[403] = */ 54,
    /*[404] = */ 54,
    /*[405] = */ 54,
    /*[406] = */ 54,
    /*[407] = */ 54,
    /*[408] = */ 54,
    /*[409] = */ 54,
    /*[410] = */ 54,
    /*[411] = */ 54,
    /*[412] = */ 54,
    /*[413] = */ 54,
    /*[414] = */ 54,
    /*[415] = */ 54,
    /*[416] = */ 54,
    /*[417] = */ 54,
    /*[418] = */ 54,
    /*[419] = */ 54,
    /*[420] = */ 54,
    /*[421] = */ 54,
    /*[422] = */ 54,
    /*[423] = */ 54,
    /*[424] = */ 54,
    /*[425] = */ 54,
    /*[426] = */ 54,
    /*[427] = */ 54,
    /*[428] = */ 54,
    /*[429] = */ 54,
    /*[430] = */ 54,
    /*[431] = */ 54,
    /*[432] = */ 54,
    /*[433] = */ 54,
    /*[434] = */ 54,
    /*[435] = */ 54,
    /*[436] = */ 54,
    /*[437] = */ 54,
    /*[438] = */ 54,
    /*[439] = */ 54,
    /*[440] = */ 54,
    /*[441] = */ 54,
    /*[442] = */ 54,
    /*[443] = */ 54,
    /*[444] = */ 54,
    /*[445] = */ 54,
    /*[446] = */ 54,
    /*[447] = */ 54,
    /*[448] = */ 54,
    /*[449] = */ 54,
    /*[450] = */ 54,
    /*[451] = */ 54,
    /*[452] = */ 54,
    /*[453] = */ 54,
    /*[454] = */ 54,
    /*[455] = */ 54,
    /*[456] = */ 54,
    /*[457] = */ 54,
    /*[458] = */ 54,
    /*[459] = */ 54,
    /*[460] = */ 54,
    /*[461] = */ 54,
    /*[462] = */ 54,
    /*[463] = */ 54,
    /*[464] = */ 54,
    /*[465] = */ 54,
    /*[466] = */ 54,
    /*[467] = */ 54,
    /*[468] = */ 54,
    /*[469] = */ 54,
    /*[470] = */ 54,
    /*[471] = */ 54,
    /*[472] = */ 54,
    /*[473] = */ 54,
    /*[474] = */ 54,
    /*[475] = */ 54,
    /*[476] = */ 54,
    /*[477] = */ 54,
    /*[478] = */ 54,
    /*[479] = */ 54,
    /*[480] = */ 54,
    /*[481] = */ 54,
    /*[482] = */ 54,
    /*[483] = */ 54,
    /*[484] = */ 54,
    /*[485] = */ 54,
    /*[486] = */ 54,
    /*[487] = */ 54,
    /*[488] = */ 54,
    /*[489] = */ 54,
    /*[490] = */ 54,
    /*[491] = */ 54,
    /*[492] = */ 54,
    /*[493] = */ 54,
    /*[494] = */ 54,
    /*[495] = */ 54,
    /*[496] = */ 54,
    /*[497] = */ 54,
    /*[498] = */ 54,
    /*[499] = */ 54,
    /*[500] = */ 54,
    /*[501] = */ 54,
    /*[502] = */ 54,
    /*[503] = */ 54,
    /*[504] = */ 55,
    /*[505] = */ 55,
    /*[506] = */ 55,
    /*[507] = */ 55,
    /*[508] = */ 55,
    /*[509] = */ 55,
    /*[510] = */ 55,
    /*[511] = */ 55,
    /*[512] = */ 55,
    /*[513] = */ 55,
    /*[514] = */ 55,
    /*[515] = */ 55,
    /*[516] = */ 55,
    /*[517] = */ 55,
    /*[518] = */ 55,
    /*[519] = */ 55,
    /*[520] = */ 55,
    /*[521] = */ 55,
    /*[522] = */ 55,
    /*[523] = */ 55,
    /*[524] = */ 55,
    /*[525] = */ 55,
    /*[526] = */ 55,
    /*[527] = */ 55,
    /*[528] = */ 55,
    /*[529] = */ 55,
    /*[530] = */ 55,
    /*[531] = */ 55,
    /*[532] = */ 55,
    /*[533] = */ 55,
    /*[534] = */ 55,
    /*[535] = */ 55,
    /*[536] = */ 55,
    /*[537] = */ 55,
    /*[538] = */ 55,
    /*[539] = */ 55,
    /*[540] = */ 55,
    /*[541] = */ 55,
    /*[542] = */ 55,
    /*[543] = */ 55,
    /*[544] = */ 55,
    /*[545] = */ 55,
    /*[546] = */ 55,
    /*[547] = */ 55,
    /*[548] = */ 55,
    /*[549] = */ 55,
    /*[550] = */ 55,
    /*[551] = */ 55,
    /*[552] = */ 55,
    /*[553] = */ 55,
    /*[554] = */ 55,
    /*[555] = */ 55,
    /*[556] = */ 55,
    /*[557] = */ 55,
    /*[558] = */ 55,
    /*[559] = */ 55,
    /*[560] = */ 55,
    /*[561] = */ 55,
    /*[562] = */ 55,
    /*[563] = */ 55,
    /*[564] = */ 55,
    /*[565] = */ 55,
    /*[566] = */ 55,
    /*[567] = */ 55,
    /*[568] = */ 55,
    /*[569] = */ 55,
    /*[570] = */ 55,
    /*[571] = */ 55,
    /*[572] = */ 55,
    /*[573] = */ 55,
    /*[574] = */ 55,
    /*[575] = */ 55,
    /*[576] = */ 55,
    /*[577] = */ 55,
    /*[578] = */ 55,
    /*[579] = */ 55,
    /*[580] = */ 55,
    /*[581] = */ 55,
    /*[582] = */ 55,
    /*[583] = */ 55,
    /*[584] = */ 55,
    /*[585] = */ 55,
    /*[586] = */ 55,
    /*[587] = */ 55,
    /*[588] = */ 55,
    /*[589] = */ 55,
    /*[590] = */ 55,
    /*[591] = */ 55,
    /*[592] = */ 55,
    /*[593] = */ 55,
    /*[594] = */ 55,
    /*[595] = */ 55,
    /*[596] = */ 55,
    /*[597] = */ 55,
    /*[598] = */ 55,
    /*[599] = */ 55,
    /*[600] = */ 55,
    /*[601] = */ 55,
    /*[602] = */ 55,
    /*[603] = */ 55,
    /*[604] = */ 55,
    /*[605] = */ 55,
    /*[606] = */ 55,
    /*[607] = */ 55,
    /*[608] = */ 55,
    /*[609] = */ 55,
    /*[610] = */ 55,
    /*[611] = */ 55,
    /*[612] = */ 55,
    /*[613] = */ 55,
    /*[614] = */ 55,
    /*[615] = */ 55,
    /*[616] = */ 55,
    /*[617] = */ 55,
    /*[618] = */ 55,
    /*[619] = */ 55,
    /*[620] = */ 55,
    /*[621] = */ 55,
    /*[622] = */ 55,
    /*[623] = */ 55,
    /*[624] = */ 55,
    /*[625] = */ 55,
    /*[626] = */ 55,
    /*[627] = */ 55,
    /*[628] = */ 55,
    /*[629] = */ 55,
    /*[630] = */ 55,
    /*[631] = */ 55,
    /*[632] = */ 55,
    /*[633] = */ 55,
    /*[634] = */ 55,
    /*[635] = */ 55,
    /*[636] = */ 55,
    /*[637] = */ 55,
    /*[638] = */ 55,
    /*[639] = */ 55,
    /*[640] = */ 55,
    /*[641] = */ 55,
    /*[642] = */ 55,
    /*[643] = */ 55,
    /*[644] = */ 55,
    /*[645] = */ 55,
    /*[646] = */ 55,
    /*[647] = */ 55,
    /*[648] = */ 55,
    /*[649] = */ 55,
    /*[650] = */ 55,
    /*[651] = */ 55,
    /*[652] = */ 55,
    /*[653] = */ 55,
    /*[654] = */ 55,
    /*[655] = */ 55,
    /*[656] = */ 55,
    /*[657] = */ 55,
    /*[658] = */ 55,
    /*[659] = */ 55,
    /*[660] = */ 55,
    /*[661] = */ 55,
    /*[662] = */ 55,
    /*[663] = */ 55,
    /*[664] = */ 55,
    /*[665] = */ 55,
    /*[666] = */ 55,
    /*[667] = */ 55,
    /*[668] = */ 55,
    /*[669] = */ 55,
    /*[670] = */ 55,
    /*[671] = */ 55,
    /*[672] = */ 56,
    /*[673] = */ 56,
    /*[674] = */ 56,
    /*[675] = */ 56,
    /*[676] = */ 56,
    /*[677] = */ 56,
    /*[678] = */ 56,
    /*[679] = */ 56,
    /*[680] = */ 56,
    /*[681] = */ 56,
    /*[682] = */ 56,
    /*[683] = */ 56,
    /*[684] = */ 56,
    /*[685] = */ 56,
    /*[686] = */ 56,
    /*[687] = */ 56,
    /*[688] = */ 56,
    /*[689] = */ 56,
    /*[690] = */ 56,
    /*[691] = */ 56,
    /*[692] = */ 56,
    /*[693] = */ 56,
    /*[694] = */ 56,
    /*[695] = */ 56,
    /*[696] = */ 56,
    /*[697] = */ 56,
    /*[698] = */ 56,
    /*[699] = */ 56,
    /*[700] = */ 56,
    /*[701] = */ 56,
    /*[702] = */ 56,
    /*[703] = */ 56,
    /*[704] = */ 56,
    /*[705] = */ 56,
    /*[706] = */ 56,
    /*[707] = */ 56,
    /*[708] = */ 56,
    /*[709] = */ 56,
    /*[710] = */ 56,
    /*[711] = */ 56,
    /*[712] = */ 56,
    /*[713] = */ 56,
    /*[714] = */ 56,
    /*[715] = */ 56,
    /*[716] = */ 56,
    /*[717] = */ 56,
    /*[718] = */ 56,
    /*[719] = */ 56,
    /*[720] = */ 56,
    /*[721] = */ 56,
    /*[722] = */ 56,
    /*[723] = */ 56,
    /*[724] = */ 56,
    /*[725] = */ 56,
    /*[726] = */ 56,
    /*[727] = */ 56,
    /*[728] = */ 56,
    /*[729] = */ 56,
    /*[730] = */ 56,
    /*[731] = */ 56,
    /*[732] = */ 56,
    /*[733] = */ 56,
    /*[734] = */ 56,
    /*[735] = */ 56,
    /*[736] = */ 56,
    /*[737] = */ 56,
    /*[738] = */ 56,
    /*[739] = */ 56,
    /*[740] = */ 56,
    /*[741] = */ 56,
    /*[742] = */ 56,
    /*[743] = */ 56,
    /*[744] = */ 56,
    /*[745] = */ 56,
    /*[746] = */ 56,
    /*[747] = */ 56,
    /*[748] = */ 56,
    /*[749] = */ 56,
    /*[750] = */ 56,
    /*[751] = */ 56,
    /*[752] = */ 56,
    /*[753] = */ 56,
    /*[754] = */ 56,
    /*[755] = */ 56,
    /*[756] = */ 56,
    /*[757] = */ 56,
    /*[758] = */ 56,
    /*[759] = */ 56,
    /*[760] = */ 56,
    /*[761] = */ 56,
    /*[762] = */ 56,
    /*[763] = */ 56,
    /*[764] = */ 56,
    /*[765] = */ 56,
    /*[766] = */ 56,
    /*[767] = */ 56,
    /*[768] = */ 56,
    /*[769] = */ 56,
    /*[770] = */ 56,
    /*[771] = */ 56,
    /*[772] = */ 56,
    /*[773] = */ 56,
    /*[774] = */ 56,
    /*[775] = */ 56,
    /*[776] = */ 56,
    /*[777] = */ 56,
    /*[778] = */ 56,
    /*[779] = */ 56,
    /*[780] = */ 56,
    /*[781] = */ 56,
    /*[782] = */ 56,
    /*[783] = */ 56,
    /*[784] = */ 56,
    /*[785] = */ 56,
    /*[786] = */ 56,
    /*[787] = */ 56,
    /*[788] = */ 56,
    /*[789] = */ 56,
    /*[790] = */ 56,
    /*[791] = */ 56,
    /*[792] = */ 56,
    /*[793] = */ 56,
    /*[794] = */ 56,
    /*[795] = */ 56,
    /*[796] = */ 56,
    /*[797] = */ 56,
    /*[798] = */ 56,
    /*[799] = */ 56,
    /*[800] = */ 56,
    /*[801] = */ 56,
    /*[802] = */ 56,
    /*[803] = */ 56,
    /*[804] = */ 56,
    /*[805] = */ 56,
    /*[806] = */ 56,
    /*[807] = */ 56,
    /*[808] = */ 56,
    /*[809] = */ 56,
    /*[810] = */ 56,
    /*[811] = */ 56,
    /*[812] = */ 56,
    /*[813] = */ 56,
    /*[814] = */ 56,
    /*[815] = */ 56,
    /*[816] = */ 56,
    /*[817] = */ 56,
    /*[818] = */ 56,
    /*[819] = */ 56,
    /*[820] = */ 56,
    /*[821] = */ 56,
    /*[822] = */ 56,
    /*[823] = */ 56,
    /*[824] = */ 56,
    /*[825] = */ 56,
    /*[826] = */ 56,
    /*[827] = */ 56,
    /*[828] = */ 56,
    /*[829] = */ 56,
    /*[830] = */ 56,
    /*[831] = */ 56,
    /*[832] = */ 56,
    /*[833] = */ 56,
    /*[834] = */ 56,
    /*[835] = */ 56,
    /*[836] = */ 56,
    /*[837] = */ 56,
    /*[838] = */ 56,
    /*[839] = */ 56,
    /*[840] = */ 56,
    /*[841] = */ 56,
    /*[842] = */ 56,
    /*[843] = */ 56,
    /*[844] = */ 56,
    /*[845] = */ 56,
    /*[846] = */ 56,
    /*[847] = */ 56,
    /*[848] = */ 56,
    /*[849] = */ 56,
    /*[850] = */ 56,
    /*[851] = */ 56,
    /*[852] = */ 56,
    /*[853] = */ 56,
    /*[854] = */ 56,
    /*[855] = */ 56,
    /*[856] = */ 56,
    /*[857] = */ 56,
    /*[858] = */ 56,
    /*[859] = */ 56,
    /*[860] = */ 56,
    /*[861] = */ 56,
    /*[862] = */ 56,
    /*[863] = */ 56,
    /*[864] = */ 56,
    /*[865] = */ 56,
    /*[866] = */ 56,
    /*[867] = */ 56,
    /*[868] = */ 56,
    /*[869] = */ 56,
    /*[870] = */ 56,
    /*[871] = */ 56,
    /*[872] = */ 56,
    /*[873] = */ 56,
    /*[874] = */ 56,
    /*[875] = */ 56,
    /*[876] = */ 56,
    /*[877] = */ 56,
    /*[878] = */ 56,
    /*[879] = */ 56,
    /*[880] = */ 56,
    /*[881] = */ 56,
    /*[882] = */ 56,
    /*[883] = */ 56,
    /*[884] = */ 56,
    /*[885] = */ 56,
    /*[886] = */ 56,
    /*[887] = */ 56,
    /*[888] = */ 56,
    /*[889] = */ 56,
    /*[890] = */ 56,
    /*[891] = */ 56,
    /*[892] = */ 56,
    /*[893] = */ 56,
    /*[894] = */ 56,
    /*[895] = */ 56,
    /*[896] = */ 56,
    /*[897] = */ 56,
    /*[898] = */ 56,
    /*[899] = */ 56,
    /*[900] = */ 56,
    /*[901] = */ 56,
    /*[902] = */ 56,
    /*[903] = */ 56,
    /*[904] = */ 56,
    /*[905] = */ 56,
    /*[906] = */ 56,
    /*[907] = */ 56,
    /*[908] = */ 56,
    /*[909] = */ 56,
    /*[910] = */ 56,
    /*[911] = */ 56,
    /*[912] = */ 56,
    /*[913] = */ 56,
    /*[914] = */ 56,
    /*[915] = */ 56,
    /*[916] = */ 56,
    /*[917] = */ 56,
    /*[918] = */ 56,
    /*[919] = */ 56,
    /*[920] = */ 56,
    /*[921] = */ 56,
    /*[922] = */ 56,
    /*[923] = */ 56,
    /*[924] = */ 56,
    /*[925] = */ 56,
    /*[926] = */ 56,
    /*[927] = */ 56,
    /*[928] = */ 56,
    /*[929] = */ 56,
    /*[930] = */ 56,
    /*[931] = */ 56,
    /*[932] = */ 56,
    /*[933] = */ 56,
    /*[934] = */ 56,
    /*[935] = */ 56,
    /*[936] = */ 56,
    /*[937] = */ 56,
    /*[938] = */ 56,
    /*[939] = */ 56,
    /*[940] = */ 56,
    /*[941] = */ 56,
    /*[942] = */ 56,
    /*[943] = */ 56,
    /*[944] = */ 56,
    /*[945] = */ 56,
    /*[946] = */ 56,
    /*[947] = */ 56,
    /*[948] = */ 56,
    /*[949] = */ 56,
    /*[950] = */ 56,
    /*[951] = */ 56,
    /*[952] = */ 56,
    /*[953] = */ 56,
    /*[954] = */ 56,
    /*[955] = */ 56,
    /*[956] = */ 56,
    /*[957] = */ 56,
    /*[958] = */ 56,
    /*[959] = */ 56,
    /*[960] = */ 56,
    /*[961] = */ 56,
    /*[962] = */ 56,
    /*[963] = */ 56,
    /*[964] = */ 56,
    /*[965] = */ 56,
    /*[966] = */ 56,
    /*[967] = */ 56,
    /*[968] = */ 56,
    /*[969] = */ 56,
    /*[970] = */ 56,
    /*[971] = */ 56,
    /*[972] = */ 56,
    /*[973] = */ 56,
    /*[974] = */ 56,
    /*[975] = */ 56,
    /*[976] = */ 56,
    /*[977] = */ 56,
    /*[978] = */ 56,
    /*[979] = */ 56,
    /*[980] = */ 56,
    /*[981] = */ 56,
    /*[982] = */ 56,
    /*[983] = */ 56,
    /*[984] = */ 56,
    /*[985] = */ 56,
    /*[986] = */ 56,
    /*[987] = */ 56,
    /*[988] = */ 56,
    /*[989] = */ 56,
    /*[990] = */ 56,
    /*[991] = */ 56,
    /*[992] = */ 56,
    /*[993] = */ 56,
    /*[994] = */ 56,
    /*[995] = */ 56,
    /*[996] = */ 56,
    /*[997] = */ 56,
    /*[998] = */ 56,
    /*[999] = */ 56,
    /*[1000] = */ 56,
    /*[1001] = */ 56,
    /*[1002] = */ 56,
    /*[1003] = */ 56,
    /*[1004] = */ 56,
    /*[1005] = */ 56,
    /*[1006] = */ 56,
    /*[1007] = */ 56,
};

const size_t RunSlots::maxSlots[RunConfig::kRunConfigs] = {
    /*[0] = */ 1021,
    /*[1] = */ 681,
    /*[2] = */ 510,
    /*[3] = */ 408,
    /*[4] = */ 340,
    /*[5] = */ 291,
    /*[6] = */ 255,
    /*[7] = */ 227,
    /*[8] = */ 204,
    /*[9] = */ 185,
    /*[10] = */ 170,
    /*[11] = */ 157,
    /*[12] = */ 145,
    /*[13] = */ 136,
    /*[14] = */ 127,
    /*[15] = */ 120,
    /*[16] = */ 113,
    /*[17] = */ 107,
    /*[18] = */ 102,
    /*[19] = */ 97,
    /*[20] = */ 92,
    /*[21] = */ 88,
    /*[22] = */ 85,
    /*[23] = */ 81,
    /*[24] = */ 78,
    /*[25] = */ 75,
    /*[26] = */ 72,
    /*[27] = */ 70,
    /*[28] = */ 68,
    /*[29] = */ 65,
    /*[30] = */ 63,
    /*[31] = */ 61,
    /*[32] = */ 60,
    /*[33] = */ 58,
    /*[34] = */ 56,
    /*[35] = */ 55,
    /*[36] = */ 53,
    /*[37] = */ 52,
    /*[38] = */ 51,
    /*[39] = */ 49,
    /*[40] = */ 48,
    /*[41] = */ 47,
    /*[42] = */ 46,
    /*[43] = */ 45,
    /*[44] = */ 40,
    /*[45] = */ 36,
    /*[46] = */ 32,
    /*[47] = */ 28,
    /*[48] = */ 24,
    /*[49] = */ 20,
    /*[50] = */ 16,
    /*[51] = */ 12,
    /*[52] = */ 8,
    /*[53] = */ 6,
    /*[54] = */ 4,
    /*[55] = */ 3,
    /*[56] = */ 2};

// max number of pages for a single parallel task.
constexpr size_t kMaxPagesPerTask = 256;  // 4K * 256 = 1M

// FreeList
void FreeList::Init(address_t baseAddr, size_t slotSize, size_t slotCount) {
  ROSIMPL_ASSERT(slotCount > 0, "cannot init free list with 0 slot");
  SetHead(baseAddr);
  Slot *lastSlot = reinterpret_cast<Slot *>(baseAddr);
  address_t currAddr = baseAddr;
  for (size_t ind = 1; ind < slotCount; ++ind) {
    currAddr += slotSize;
    lastSlot->SetNext(currAddr);
    lastSlot = reinterpret_cast<Slot *>(currAddr);
  }

  SetTail(currAddr);
  lastSlot->SetNext(0);
}

// the memory used by RunSlots have already cleared by its constructor&Init
// so the metadata and each allocatedBit is guaranteed implicitly.
// so we no longer need to check the metadata
// and if we encounter uaf issue, just open ENABLE_RTS_GC_DEBUG to deal with it
// which will zap freed memory
RunSlots::RunSlots(uint32_t idx) {
  magic = RosAllocImpl::kRunMagic;
  mIdx = static_cast<uint8_t>(idx);
  flags = 0;
  SetNext(nullptr);
  SetPrev(nullptr);

  ROSIMPL_ASSERT(((address_t) & ((static_cast<RunSlots *>(0))->magic)) == 0x3,
                 "obj header size must be aligned");
}

void RunSlots::Init() {
  size_t slotsCount = GetMaxSlots();
  address_t slotAddr = GetBaseAddress();

  freeList.Init(slotAddr, GetRunSize(), slotsCount);
  nFree = static_cast<uint32_t>(slotsCount);
  SetInit();
}

void RunSlots::ForEachObj(HeapAliveObjsVisitor &visitor, size_t hint) {
  size_t runUnitSize = GetRunSize();
  size_t slotsCount = GetMaxSlots();
  address_t slotAddr = GetBaseAddress();

  if (UNLIKELY(slotsCount == 0)) {
    return;
  }

  for (size_t idx = 0; idx < slotsCount; ++idx) {
    address_t objAddr = ROSIMPL_GET_OBJ_FROM_ADDR(slotAddr);
    if (IsAllocatedByAllocator(objAddr)) {
      visitor(kHeapObjTypeRun, objAddr);
    }
    slotAddr += runUnitSize;
  }
}

// return true if the given address represents a live object
bool RunSlots::IsLiveObjAddr(address_t objAddr) const {
  // since there is no lock, a mutator might be allocating/freeing from this run
  // at the same time, so there is a slight inaccuracy that the caller should be
  // aware of
  address_t slotAddr = ROSIMPL_GET_ADDR_FROM_OBJ(objAddr);
  address_t firstSlotAddr = GetBaseAddress();
  size_t slotsCount = GetMaxSlots();
  address_t lastSlot = firstSlotAddr + (slotsCount - 1) * GetRunSize();
  if (!(slotAddr <= lastSlot && slotAddr >= firstSlotAddr)) {
    return false;
  }
  if (((slotAddr - firstSlotAddr) % GetRunSize()) != 0) return false;

  return IsAllocatedByAllocator(objAddr);
}

void RunSlots::TryToRecordValidObjAddr(RootSet *rootSet,
                                       address_t objAddr) const {
  address_t slotAddr = ROSIMPL_GET_ADDR_FROM_OBJ(objAddr);
  address_t firstSlotAddr = GetBaseAddress();
  size_t slotsCount = GetMaxSlots();
  size_t runSize = GetRunSize();
  address_t lastSlot = firstSlotAddr + slotsCount * runSize;
  if (!(slotAddr < lastSlot && slotAddr >= firstSlotAddr)) return;
  slotAddr = firstSlotAddr + ((slotAddr - firstSlotAddr) / runSize) * runSize;
  if (IsAllocatedByAllocator(slotAddr)) rootSet->push_back(slotAddr);
}

#ifdef ALLOC_ENABLE_LOCK_CONTENTION_STATS
uint32_t RosAllocImpl::pageLockContentionRec = 0;
uint64_t RosAllocImpl::pageLockWaitTimeRec = 0U;
#endif

FragmentationRecord fragRec;

RosAllocImpl::RosAllocImpl(LEPUSRuntime *rt, bool enable_concurrent)
    : Allocator(),
      allocSpace("ROS memory space", "std_alloc_ros", true),
      rt_(rt),
      enable_concurrent_(enable_concurrent),
      gcPauseSuppressionMode(false) {  // managed space
  GetGCTracer()->SetAllocator(this);
  InterceptSigbusAsan(this);
#if !defined(ANDROID) && !defined(__ANDROID__) && !defined(OS_IOS)
  struct sched_param sched;
  sched.sched_priority = sched_get_priority_max(2);
  pthread_setschedparam(pthread_self(), SCHED_OTHER, &sched);
#endif
}

void RosAllocImpl::Init(const VMHeapParam &vmHeapParam) {
  InitkRunMagicIfNeeded();
  allocSpace.SetHeapStartSize(vmHeapParam.heapStartSize);
  allocSpace.SetHeapSize(vmHeapParam.heapStartSize);
  allocSpace.SetHeapGrowthLimit(
      std::min(vmHeapParam.heapGrowthLimit, kMaxHeap));
  // We should use this one in future
  allocSpace.SetHeapMinFree(vmHeapParam.heapMinFree);
  allocSpace.SetHeapMaxFree(vmHeapParam.heapMaxFree);
  allocSpace.SetHeapTargetUtilization(vmHeapParam.heapTargetUtilization);
  allocSpace.Init();
  // ptr_handles = new PtrHandles(this);
  SetHeapGrowthLimitForAsan();
}

std::vector<address_t> RosAllocImpl::DumpHeap() {
  std::vector<address_t> aliveObjs;
  return aliveObjs;
}

RosAllocImpl::~RosAllocImpl() {}

address_t RosAllocImpl::AllocPagesInternal(size_t reqSize, size_t &actualSize,
                                           int forceLevel, uint32_t &idx) {
  if ((forceLevel == kEagerLevelMin) &&
      GetGCTracer()->TryTriggerConcurrentPhases()) {
    return 0;
  }
  actualSize = ALLOCUTIL_PAGE_RND_UP(reqSize);
  // we allow extension, assuming that concurrent gc has done
  // everything it can to reduce footprint
  if (unlikely(concurrent_sweep_is_running)) {
    ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD globalLock);
    return allocSpace.Alloc(actualSize, true, idx, allocatedInternalSize);
  } else {
    return allocSpace.Alloc(actualSize, true, idx, allocatedInternalSize);
  }
}

address_t RosAllocImpl::AllocHugeInternal(size_t reqSize) {
  return allocSpace.NewHugeGroup(reqSize);
}

address_t RosAllocImpl::AllocateObj(LEPUSRuntime *rt, size_t size,
                                    int alloc_tag) {
  auto ros = rt->ros_;
#ifdef ROS_FORCE_GC
  static int cc = 0;
  int step = 1;
  if (cc % step == 0 && !ros->collector->IsForbidGC() && ros->gc_cnt < 10000) {
    ros->GetGCTracer()->SetGCTaskType(GCTaskType::kDoConMark);
    ros->collector->RunFullCollection();
  }
  cc++;
#endif
  JS_UpdateGCInfo(rt, size);
  size_t allocSize = AllocUtilRndUp(size + kHeaderSize, kAllocAlign);
  if (UNLIKELY(ros->NeedTriggerConcurrentPhases(allocSize))) {
    ros->collector->TryTriggerConcurrentPhases(allocSize);
  }
  address_t ret = ros->NewObjInternal(allocSize);
  if (UNLIKELY(ret == 0)) return 0;

  void *ptr = (void *)(ret + kHeaderSize);
  memset(ptr, 0, size);
  init_obj_header(ptr, size, alloc_tag);
  return (address_t)ptr;
}

address_t RosAllocImpl::ReallocateObj(LEPUSRuntime *rt, void *ptr, size_t size,
                                      int alloc_tag) {
  if (size == 0) return 0;
  auto ros = rt->ros_;
#ifdef ROS_FORCE_GC
  static int cc = 0;
  int step = 1;
  if (cc % step == 0 && !ros->collector->IsForbidGC() && ros->gc_cnt < 10000) {
    ros->GetGCTracer()->SetGCTaskType(GCTaskType::kDoConMark);
    ros->collector->RunFullCollection();
  }
  cc++;
#endif
  JS_UpdateGCInfo(rt, size);
  size_t allocSize = AllocUtilRndUp(size + kHeaderSize, kAllocAlign);
  if (UNLIKELY(ros->NeedTriggerConcurrentPhases(allocSize))) {
    ros->collector->TryTriggerConcurrentPhases(allocSize);
  }
  if (!ptr) {
    address_t ret = ros->NewObjInternal(allocSize);
    if (UNLIKELY(ret == 0)) return 0;
    void *ptr = (void *)(ret + kHeaderSize);
    memset(ptr, 0, size);
    init_obj_header(ptr, size, alloc_tag);
    return (address_t)ptr;
  }
  auto old_size = get_obj_size(ptr);
  if (old_size >= size) {
    memset((uint8_t *)ptr + size, 0, old_size - size);
    init_obj_header(ptr, size, alloc_tag);
    return (address_t)ptr;
  }
  address_t ret = ros->NewObjInternal(allocSize);
  if (UNLIKELY(ret == 0)) return 0;
  void *new_ptr = (void *)(ret + kHeaderSize);
  memcpy(new_ptr, ptr, old_size);
  memset((uint8_t *)new_ptr + old_size, 0, size - old_size);
  init_obj_header(new_ptr, size, alloc_tag);
  return (address_t)new_ptr;
}

// used for concurrent step2
bool RosAllocImpl::SweepHugeObjs(
    std::function<bool(address_t, ROS_GC::Bitmap *)> shouldFree) {
  auto &groups = allocSpace.page_groups.GetGroupArray();
  bool released = false;
  for (auto &group : groups) {
    if (!group.IsInitialized()) continue;
    if (UNLIKELY(group.IsHugeObj())) {
      bool isGroupMarked = group.GetBitmap()->IsObjectMarked(group.GetBegin());
      if (isGroupMarked) continue;
      // address_t memAddr = group.GetBegin();
      size_t freedBytes = 0U;
      SweepHugeObj(group, freedBytes);
      RecordTotalReleasedBytesForGCLog(freedBytes);
      released = true;
    }
  }
  return released;
}

void RosAllocImpl::SweepRunForConSweepPrologue(
    RunSlots &run, std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree,
    PageGroups &groups) {
  address_t runAddr = (address_t)(&run);
  int32_t gIdx = groups.GetGroupIdx(runAddr);
  Bitmap *markBitmap = groups.GetBitMap(gIdx);

  size_t releasedBytes = 0;
  auto ros = this;
  run.FreeIterator([&releasedBytes, &markBitmap, &shouldFree, &ros, &run](
                       address_t objAddr, address_t slotAddr, size_t slotSize) {
    if (shouldFree(objAddr, markBitmap)) {
      LOG(LEVEL_1) << "ros, SweepLocalRuns: " << (void *)(objAddr);
      ros->SweepSlot(run, slotAddr);
      ClearAllocatedBit(objAddr);
      releasedBytes += slotSize;
    }
  });

  RecordTotalReleasedBytesForGCLog(releasedBytes);

  allocatedInternalSize -= releasedBytes;

  // set as swept to prevent resweeping by concurrent-sweep thread
  groups.GetPageMapById(gIdx)->SetSweptReleaseInConcurrent(runAddr);
}

// used for concurrent step2
void RosAllocImpl::SweepLocalRuns(
    std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree) {
  auto &groups = allocSpace.page_groups;
  for (size_t i = 0; i < RunConfig::kRunConfigs; i++) {
    RunSlots *run = globalMutator.localRuns[i];
    if (run && !groups.GetGroup((address_t)run).ShouldSkipCollect())
      SweepRunForConSweepPrologue(*globalMutator.localRuns[i], shouldFree,
                                  groups);
  }
}

void RosAllocImpl::SweepNonFullRuns(
    std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree) {
  auto &groups = allocSpace.page_groups;
  for (size_t i = 0; i < RunConfig::kRunConfigs; i++) {
    int counter = 0;
    RunSlots *run = nonFullRuns[i].GetList();
    while (run != nullptr) {
      RunSlots *next = run->GetNext();
      if (true) {
        if (!groups.GetGroup((address_t)run).ShouldSkipCollect())
          SweepRunForConSweepPrologue(*run, shouldFree, groups);
        counter++;
      } else {
        address_t runAddr = (address_t)(run);
        groups.GetPageMapById(groups.GetGroupIdx(runAddr))
            ->SetSweptReleaseInConcurrent(runAddr);
      }
      run = next;
    }
  }
}

class BaseFreeTask : public MplTask {
 protected:
  BaseFreeTask(RosAllocImpl &allocatorVal, size_t pageIndexVal, size_t deltaVal,
               PageGroup &pageGroupVal)
      : allocator(allocatorVal),
        pageStartIndex(pageIndexVal),
        delta(deltaVal),
        pageGroup(pageGroupVal) {}
  __attribute__((always_inline)) void FreeLargeObj(PageMap *pageMap,
                                                   size_t pageIndex,
                                                   size_t pageGroupIdx) {
    address_t memAddr = pageMap->GetPageAddr(pageIndex);
    address_t lrgAddr = ROSIMPL_GET_OBJ_FROM_ADDR(memAddr);
    if (!pageGroup.GetBitmap()->IsObjectMarked(lrgAddr)) {
      size_t freedBytes = 0U;
      size_t pageIdxWithHeader = ROSIMPL_GET_PAGE_IDX(pageGroupIdx, pageIndex);
      allocator.SweepLargeObj(lrgAddr, freedBytes, pageIdxWithHeader);
    }
  }

  __attribute__((always_inline)) void RunSlotsCheck(RunSlots *runSlots) {
    ROSIMPL_ASSERT(runSlots->HasInit(), "run not initialised");
    ROSIMPL_DEBUG(allocator.CheckRunMagic(*runSlots));
    ROSIMPL_ASSERT(runSlots->mIdx < RosAllocImpl::kNumberROSRuns,
                   "runSlots returned has wrong index");
  }

  RosAllocImpl &allocator;
  size_t pageStartIndex{0};
  size_t delta{0};
  PageGroup &pageGroup;

 public:
#ifdef FUTURE_OPTIMIZE
  static ContinuousPageTypes kContinuousReleasedPageTypes;
  static ContinuousPageTypes kContinuousFreePageTypes;
#endif  // FUTURE_OPTIMIZE
};

#ifdef FUTURE_OPTIMIZE
#if defined(__ARM_NEON)
ContinuousPageTypes BaseFreeTask::kContinuousReleasedPageTypes =
    vdupq_n_u8(0x00);
ContinuousPageTypes BaseFreeTask::kContinuousFreePageTypes = vdupq_n_u8(0x01);
#else
ContinuousPageTypes BaseFreeTask::kContinuousReleasedPageTypes = 0x0;
ContinuousPageTypes BaseFreeTask::kContinuousFreePageTypes = 0x0101010101010101;
#endif  // defined(__ARM_NEON)
#endif  // FUTURE_OPTIMIZE

class FreeTask : public BaseFreeTask {
 public:
  FreeTask(RosAllocImpl &allocatorVal, size_t pageIndexVal, size_t deltaVal,
           PageGroup &pageGroupVal)
      : BaseFreeTask(allocatorVal, pageIndexVal, deltaVal, pageGroupVal) {}
  virtual ~FreeTask() {}
  void Execute(size_t workerID __attribute__((unused))) override {
    size_t pageGroupIdx = pageGroup.GetGroupIdx();
    PageMap *pageMap = pageGroup.GetPageMap();
    size_t end = std::min(pageStartIndex + delta, pageMap->GetMaxMapSize());
#ifdef FUTURE_OPTIMIZE
    ROSIMPL_ASSERT(pageStartIndex % kDeltaAlign == 0,
                   "pageStartIndex should be aligned");
    ContinuousPageTypes types;
    size_t step;
#endif  // FUTURE_OPTIMIZE
    size_t releasedSize = 0;
    for (size_t pageIndex = pageStartIndex; pageIndex < end; ++pageIndex) {
#ifdef FUTURE_OPTIMIZE
      if (pageIndex % kDeltaAlign == 0) {
        types = pageMap->GetTypes(pageIndex);
        step = kDeltaAlign - 1;
      }
      if (are_types_equal(types, kContinuousReleasedPageTypes) ||
          are_types_equal(types, kContinuousFreePageTypes)) {
        pageIndex += step;
        continue;
      }
#ifdef __ARM_NEON
      PageLabel pageType = (PageLabel)vgetq_lane_u8(types, 0);
      types = vextq_u8(types, kContinuousReleasedPageTypes, 1);
#else
      // This will save 7 'ldrb' instructions.
      PageLabel pageType = (PageLabel)(types & 0xFF);
      types >>= 8;
#endif  // __ARM_NEON
      --step;
#else
      PageLabel pageType = pageMap->GetType(pageIndex);
#endif  // FUTURE_OPTIMIZE
      if (LIKELY(pageType == kPRun)) {
        address_t runAddr = pageMap->GetPageAddr(pageIndex);
        RunSlots *runSlots = reinterpret_cast<RunSlots *>(runAddr);
        RunSlotsCheck(runSlots);
        allocator.SweepRun(*runSlots, pageGroup.GetBitmap(), releasedSize);
      } else if (UNLIKELY(pageType == kPLargeObj)) {
        FreeLargeObj(pageMap, pageIndex, pageGroupIdx);
      } else {
        ROSIMPL_ASSERT(pageType != kPRunRem, "wrong pagelabel");
      }
    }
    // avoid atomic-operation
    allocator.DecreaseAllocatedInternalSize(releasedSize);
  }
};

class ConcurrentFreeTask : public BaseFreeTask {
 public:
  ConcurrentFreeTask(RosAllocImpl &allocatorVal, size_t pageIndexVal,
                     size_t deltaVal, PageGroup &pageGroupVal)
      : BaseFreeTask(allocatorVal, pageIndexVal, deltaVal, pageGroupVal) {}
  virtual ~ConcurrentFreeTask() {}
  void Execute(size_t workerID __attribute__((unused))) override {
    PageLabel pageType = kPReleased;
    size_t start = pageStartIndex;
    size_t end = pageStartIndex + delta;
    size_t pageGroupIdx = pageGroup.GetGroupIdx();
    PageMap *pageMap = pageGroup.GetPageMap();
    for (size_t pageIndex = start; pageIndex < end; ++pageIndex) {
      pageType = pageMap->GetTypeInConcurrent(pageIndex);
      if (LIKELY(pageType == kPRun)) {
        address_t runAddr = pageMap->GetPageAddr(pageIndex);
        RunSlots *runSlots = reinterpret_cast<RunSlots *>(runAddr);
        RunSlotsCheck(runSlots);
        allocator.ConcurrentSweepRun(*runSlots, pageGroup.GetBitmap());
      } else if (UNLIKELY(pageType == kPLargeObj)) {
        FreeLargeObj(pageMap, pageIndex, pageGroupIdx);
      } else {
        ROSIMPL_ASSERT(pageType != kPRunRem, "wrong pagelabel");
      }
    }
  }
};

void RosAllocImpl::ConSweepPrologue() {
  concurrent_sweep_is_running = true;
  auto &groups = allocSpace.page_groups.GetGroupArray();
  std::for_each(groups, groups + kRosDefaultPageGroupNums,
                [](PageGroup &group) {
                  if (!group.IsInitialized() || group.IsHugeObj()) return;
                  group.GetPageMap()->PrepareForConcurrentSweep();
                });
  GetGCTracer()->StartCurrentSweeping();
  std::atomic_thread_fence(std::memory_order_seq_cst);
}

void RosAllocImpl::ConMarkPrologue() {
  // all the new allocated objects will be marked during con-mark
  SetConcurrentMarkState(true);
  GetGCTracer()->StartCurrentMarking();

  // init each group's con-marking state, write-barrier will work when this
  // state is enabled
  auto &groups = allocSpace.page_groups.GetGroupArray();
  std::for_each(groups, groups + kRosDefaultPageGroupNums,
                [](PageGroup &group) {
                  // should not skip non-initialized or huge group, or the new
                  // create group will lost cm state
                  group.SetConcurrentMark(true);
                });
  std::atomic_thread_fence(std::memory_order_seq_cst);
  MarkPrologue();
}

void RosAllocImpl::ConSweepEpilogue() {
  auto &groups = allocSpace.page_groups.GetGroupArray();
  std::for_each(groups, groups + kRosDefaultPageGroupNums,
                [](PageGroup &group) {
                  if (!group.IsInitialized() || group.IsHugeObj()) return;
                  group.GetPageMap()->ClearForConcurrentSweep();
                });
  concurrent_sweep_is_running = false;
  GetGCTracer()->StopCurrentSweeping(true);
  std::atomic_thread_fence(std::memory_order_seq_cst);
}

void RosAllocImpl::ConMarkEpilogue() {
  SetConcurrentMarkState(false);
  auto &groups = allocSpace.page_groups.GetGroupArray();
  std::for_each(groups, groups + kRosDefaultPageGroupNums,
                [](PageGroup &group) {
                  // should not skip non-initialized or huge group, or the new
                  // create group will lost cm state
                  group.SetConcurrentMark(false);
                });
  std::atomic_thread_fence(std::memory_order_seq_cst);

  MarkEpilogue();
  SetConMarkFinishedState(false);
  GetGCTracer()->StopCurrentMarking(true);
}

bool RosAllocImpl::ParallelFreeAllIf(MplThreadPool &threadPool) {
  const int32_t threadCount = threadPool.GetMaxThreadNum() + 1;
  auto &page_groups = allocSpace.page_groups;
  auto &groups = page_groups.GetGroupArray();
  int task_count = 0;
  for (auto &group : groups) {
    if (!group.IsInitialized()) continue;
    if (UNLIKELY(group.IsHugeObj())) {
      bool isGroupMarked = group.GetBitmap()->IsObjectMarked(group.GetBegin());
      if (isGroupMarked) continue;
      address_t memAddr = group.GetBegin();
      address_t lrgAddr = ROSIMPL_GET_OBJ_FROM_ADDR(memAddr);
      size_t objSize = PreObjFree(lrgAddr);
      size_t freedBytes = 0U;
      SweepHugeObj(group, freedBytes);
      PostObjFree(lrgAddr, objSize, freedBytes);
      // ClearAllocatedBit(lrgAddr);
      continue;
    }
    PageMap *pageMap = group.GetPageMap();
    size_t begin = 0;
    size_t end = pageMap->GetPageIndex(pageMap->GetEndAddr());
    ROSIMPL_ASSERT(group.GetGroupIdx() < kRosDefaultPageGroupNums,
                   "group_idx is overflow");
    const size_t chunkSize =
        std::min(end / static_cast<size_t>(threadCount) + 1, kMaxPagesPerTask);
    for (size_t pageIndex = begin; pageIndex < end;) {
      task_count++;
      // The alignment operation is applicable only in parallel, it may touch
      // some unused pagelabel at the end of pagegroup. this is guaranted by
      // pagelabel's page-alignment allocation(init with kPReleased).
      // Concurrent-sweep is not applicable because it may touch some pages
      // beyond the sweep target
      const size_t delta =
          AllocUtilRndUp(std::min(end - pageIndex, chunkSize), kDeltaAlign);
      threadPool.AddTask(new FreeTask(*this, pageIndex, delta, group));
      pageIndex += delta;
    }
  }
  if (task_count != 0) {
    threadPool.Start();
    threadPool.WaitFinish(true);
  }
  return true;
}

void RosAllocImpl::ReleaseAllPageGroups() {
  auto &page_groups = allocSpace.page_groups;
  auto &groups = page_groups.GetGroupArray();
  for (auto &group : groups) {
    if (!group.IsInitialized()) continue;
    group.ReleaseMemory();
  }
}

bool RosAllocImpl::ConcurrentSweep(MplThreadPool &threadPool) {
  const int32_t threadCount = threadPool.GetMaxThreadNum() + 1;
  auto &page_groups = allocSpace.page_groups;
  auto &groups = page_groups.GetGroupArray();
  int task_count = 0;
  for (auto &group : groups) {
    if (!group.IsInitialized() || group.IsHugeObj()) {
      continue;
    }
    if (group.ShouldSkipCollect()) {
      group.ConfigShouldSkipCollect(false);
      continue;
    }
    PageMap *pageMap = group.GetPageMap();
    size_t begin = 0;
    size_t end = pageMap->GetPageIndex(pageMap->GetEndAddr());
    ROSIMPL_ASSERT(group.GetGroupIdx() < kRosDefaultPageGroupNums,
                   "group_idx is overflow");
    const size_t chunkSize =
        std::min(end / static_cast<size_t>(threadCount) + 1, kMaxPagesPerTask);
    for (size_t pageIndex = begin; pageIndex < end;) {
      task_count++;
      const size_t delta = std::min(end - pageIndex, chunkSize);
      threadPool.AddTask(
          new ConcurrentFreeTask(*this, pageIndex, delta, group));
      pageIndex += delta;
    }
  }
  if (task_count != 0) {
    threadPool.Start();
  }
  return true;
}

class ForEachTask : public MplTask {
 public:
  struct Stats {
    size_t pagesVisited = 0;
    size_t pagesSkipped = 0;
    size_t totalFinalizable = 0;
  };
  ForEachTask(RosAllocImpl &allocatorVal, PageMap *pageMapVal, size_t beginVal,
              size_t endVal, HeapAliveObjsVisitor &visitorVal,
              const function<void(Stats &)> &onFinishVal)
      : allocator(allocatorVal),
        pageMap(pageMapVal),
        begin(beginVal),
        end(endVal),
        visitor(visitorVal),
        onFinish(onFinishVal) {}

  ~ForEachTask() { onFinish(stats); }

  void Execute(size_t workerID __attribute__((unused))) override {
    PageLabel pageType = kPReleased;
    for (size_t pageIndex = begin; pageIndex < end; ++pageIndex) {
      pageType = pageMap->GetType(pageIndex);
      if (LIKELY(pageType == kPRun)) {
        address_t runAddr = pageMap->GetPageAddr(pageIndex);
        size_t cnt = pageMap->RunPageCount(runAddr);
        RunSlots *runSlots = reinterpret_cast<RunSlots *>(runAddr);
        ROSIMPL_ASSERT(runSlots->HasInit(), "run not initialised");
        ROSIMPL_ASSERT(cnt > 0, "incorrect run page count");
        if (ShouldSkipThisRun(pageIndex)) {
          stats.pagesSkipped += cnt;
          pageIndex += cnt - 1;  // skip all the kPRunRem
          continue;
        }
        ROSIMPL_DEBUG(allocator.CheckRunMagic(*runSlots));
        ROSIMPL_ASSERT(runSlots->mIdx < RosAllocImpl::kNumberROSRuns,
                       "runSlots returned has wrong index");
        // Limit the number of object to be visited.
        size_t hint = numeric_limits<size_t>::max();
        allocator.ForEachObjInRun(*runSlots, visitor, hint);
        stats.pagesVisited += cnt;
        pageIndex += cnt - 1;  // skip all the kPRunRem
      } else if (UNLIKELY(pageType == kPLargeObj)) {
        if (ShouldSkipThisPage(pageIndex)) {
          continue;
        }
        address_t memAddr = pageMap->GetPageAddr(pageIndex);
        address_t lrgAddr = ROSIMPL_GET_OBJ_FROM_ADDR(memAddr);
        visitor(kHeapObjTypeLarge, lrgAddr);
      }
    }
  }

 private:
  inline bool ShouldSkipThisPage(size_t pageIndex) {
    ++stats.pagesVisited;
    return false;
  }
  inline bool ShouldSkipThisRun(size_t pageIndex) { return false; }

  RosAllocImpl &allocator;
  PageMap *pageMap;
  size_t begin;
  size_t end;
  HeapAliveObjsVisitor visitor;
  Stats stats;
  function<void(Stats &)> onFinish;
};

bool RosAllocImpl::ParallelForEachObj(MplThreadPool &threadPool,
                                      VisitorFactory visitorFactory) {
  // ROSIMPL_ASSERT(WorldStopped(), "ParallelForEachObj can only be invoked
  // while world stopped");

#ifdef CONFIG_JSAN
  auto originalVisitorFactory = visitorFactory;
  visitorFactory = [&originalVisitorFactory]() {
    auto originalVisitor = originalVisitorFactory();
    auto visitor = [originalVisitor](
                       address_t obj) {  // NOTE: intentionally capture by value
      if (JSANGetObjStatus(obj) != kObjStatusQuarantined) {
        originalVisitor(obj);
      }
    };
    // NOTE: The variable originalVisitor goes out of scope here.
    return visitor;
  };
#endif
  auto &groups = allocSpace.page_groups.GetGroupArray();
  for (auto &group : groups) {
    if (!group.IsInitialized()) continue;
    if (UNLIKELY(group.IsHugeObj())) {
      visitorFactory()(kHeapObjTypeHuge, group.GetBegin());
      continue;
    }
    mutex statsMutex;
    ForEachTask::Stats overallStats;
    auto page_map = group.GetPageMap();

    function<void(ForEachTask::Stats &)> onFinish =
        [&statsMutex, &overallStats](const ForEachTask::Stats &taskStats) {
          lock_guard<mutex> lg(statsMutex);
          overallStats.pagesVisited += taskStats.pagesVisited;
          overallStats.pagesSkipped += taskStats.pagesSkipped;
          overallStats.totalFinalizable += taskStats.totalFinalizable;
        };

    const int32_t threadCount = threadPool.GetMaxThreadNum() + 1;
    const size_t lastPageIndex = page_map->GetPageIndex(page_map->GetEndAddr());
    const size_t chunkSize = std::min(
        lastPageIndex / static_cast<size_t>(threadCount) + 1, kMaxPagesPerTask);
    for (size_t pageIndex = 0; pageIndex < lastPageIndex;) {
      const size_t delta = std::min(lastPageIndex - pageIndex, chunkSize);
      threadPool.AddTask(new ForEachTask(*this, page_map, pageIndex,
                                         pageIndex + delta, visitorFactory(),
                                         onFinish));
      pageIndex += delta;
    }
    threadPool.Start();
    threadPool.WaitFinish(true);
  }
  return true;
}

void RosAllocImpl::ForEachObj(HeapAliveObjsVisitor &visitor) {
  PageLabel pageType = kPReleased;
  auto &groups = allocSpace.page_groups.GetGroupArray();
  for (auto &group : groups) {
    if (!group.IsInitialized()) continue;
    if (UNLIKELY(group.IsHugeObj())) {
      auto objAddr = group.GetBegin();
      visitor(kHeapObjTypeHuge, objAddr);
      continue;
    }
    auto page_map = group.GetPageMap();
    size_t endIndex = page_map->GetPageIndex(page_map->GetEndAddr());
    for (size_t index = 0; index < endIndex; ++index) {
      pageType = page_map->GetType(index);
      if (LIKELY(pageType == kPRun)) {
        address_t runAddr = page_map->GetPageAddr(index);
        RunSlots &run = *reinterpret_cast<RunSlots *>(runAddr);
        ForEachObjInRun(run, visitor, std::numeric_limits<size_t>::max());
      } else if (pageType == kPLargeObj) {
        address_t pageAddr = page_map->GetPageAddr(index);
        address_t largeObjAddr = ROSIMPL_GET_OBJ_FROM_ADDR(pageAddr);
        visitor(kHeapObjTypeLarge, largeObjAddr);
      }
    }
  }
  return;
}

// AccurateIsValidObjAddr and AccurateIsValidObjAddrConcurrent are used in
// conservative stack scan to identify valid obj addresses from random numbers
//
// in other times, we can theoretically assume non-heap objs do not share the
// same address range with heap objs, so we can just use a range-based check
// to distinguish them (FastIsValidObjAddr)
//
// check if an address is of an valid obj, only used in stw (parallel gc)
bool RosAllocImpl::AccurateIsValidObjAddr(address_t addr) {
  // ROSIMPL_ASSERT(WorldStopped(), "AccurateIsValidObjAddr invoked at
  // non-STW");
  if (!FastIsValidObjAddr(addr)) {
    return false;
  }
  CheckHasAddressGCedForAsan(addr);
  if (allocSpace.page_groups.HasAddressSerious(addr)) return true;
  return AccurateIsValidObjAddrUnsafe(addr);
}

// check if an address is of an valid obj, used during concurrent marking
// (concurrent gc)
bool RosAllocImpl::AccurateIsValidObjAddrConcurrent(address_t addr) {
  if (!FastIsValidObjAddr(addr)) {
    return false;
  }
  ALLOC_LOCK_TYPE guard(globalLock);
  return AccurateIsValidObjAddrUnsafe(addr);
}

void RosAllocImpl::TryToRecordValidObjAddr(RootSet *rootSet, address_t addr) {
  if ((addr & (kAllocAlign - 1)) != 0) return;
  if (!allocSpace.page_groups.TryToRecordValidObjAddrAndCheckValid(rootSet,
                                                                   addr)) {
    return;
  }
  address_t pageAddr = ALLOCUTIL_PAGE_ADDR(addr);
  auto group_idx = allocSpace.page_groups.GetGroupIdx(addr);
  PageLabel pageType = allocSpace.page_groups.GetTypeForAddr(addr, group_idx);
  if (LIKELY(pageType == kPRun)) {
    RunSlots *run = reinterpret_cast<RunSlots *>(pageAddr);
    if (!run->HasInit()) return;
    // run obj
    ROSIMPL_DEBUG(CheckRunMagic(*run));
    run->TryToRecordValidObjAddr(rootSet, addr);
    return;
  } else if (pageType == kPLargeObjRem) {
    pageAddr = allocSpace.page_groups.GetLargeObjStartFromAddr(addr, group_idx);
  } else if (pageType == kPLargeObj) {
  } else
    return;
  if (IsAllocatedByAllocator(pageAddr)) rootSet->push_back(pageAddr);
}

// this is called by mutator before free a large object when concurrent sweep is
// running.
void RosAllocImpl::SweepLargeObj(address_t objAddr, size_t &internalSize,
                                 uint32_t pageIdx) {
  LOG(LEVEL_1) << "ros, SweepLargeObj ing: " << (void *)(objAddr);
  FreeLargeObj(objAddr, internalSize, pageIdx);
  RecordTotalReleasedBytesForGCLog(internalSize);
  allocatedInternalSize -= internalSize;
  LOG(LEVEL_1) << "ros, SweepLargeObj end: " << (void *)(objAddr);
}

void RosAllocImpl::FreeLargeObj(address_t objAddr, size_t &internalSize,
                                uint32_t pageIdx) {
  address_t memAddr = ROSIMPL_GET_ADDR_FROM_OBJ(objAddr);
  ROSIMPL_ASSERT((memAddr & 0xfff) == 0, "big obj addr is not page aligned");
  DCHECK_OBJ_IS_ALLOCATED_BY_ALLOCATOR(memAddr);
  CheckObjHasValidKlassForDebug(memAddr);
  size_t pageCnt =
      allocSpace.page_groups.ClearLargeObjPageAndCount(memAddr, false);
  size_t totalObjSize = ALLOCUTIL_PAGE_CNT2BYTE(pageCnt);

  // ensure header is cleared in 8 bytes
  *reinterpret_cast<uint64_t *>(memAddr) = 0;
  ClearAllocatedBit(memAddr);

  while (true) {
    if (globalLock.try_lock()) {
      if (!TryToFreeRegionForAsan(memAddr, pageCnt, pageIdx)) {
#ifdef ROSIMPL_MEMSET_AT_FREE
        ROSALLOC_MEMSET_S(memAddr, totalObjSize, 0, totalObjSize);
#endif
        allocSpace.FreeRegion(memAddr, pageCnt, pageIdx);
      }
      globalLock.unlock();
      break;
    } else {
      sched_yield();
    }
  }
  ResetCurDealtObjAddrIsInAsanObjAddrSetAndEarlyReturnIfNeedForAsan();
  internalSize += totalObjSize;
}

void RosAllocImpl::SweepHugeObj(PageGroup &group, size_t &internalSize) {
  FreeHugeObj(group, internalSize);
  allocatedInternalSize -= internalSize;
}

void RosAllocImpl::FreeHugeObj(PageGroup &group, size_t &internalSize) {
  EarlyReturnIfGroupIsGCed(group);
  address_t memAddr = group.GetBegin();
  DCHECK_OBJ_IS_ALLOCATED_BY_ALLOCATOR(memAddr);
  CheckObjHasValidKlassForDebug(memAddr);
  ClearAllocatedBit(memAddr);
  // ensure header is cleared in 8 bytes
  *reinterpret_cast<uint64_t *>(memAddr) = 0;
  size_t totalObjSize = group.GetCurrSize();
  // hugeobj's memory will munmap directly, can check uaf naturally
  if (!TryToReleaseHugeMemForAsan(group)) allocSpace.ReleaseHugeMem(group);
  ResetCurDealtObjAddrIsInAsanObjAddrSetAndEarlyReturnIfNeedForAsan();
  internalSize += totalObjSize;
}

address_t RosAllocImpl::AllocLargeObject(size_t &allocSize, int forceLevel) {
  if (UNLIKELY(allocSize > kHugeObjSize)) return AllocHugeObject(allocSize);
  size_t actualSize = 0U;
  uint32_t page_idx = 0U;
  address_t objAddr =
      AllocPagesInternal(allocSize, actualSize, forceLevel, page_idx);
  if (LIKELY(objAddr != 0U)) {
    allocSize = actualSize;
    size_t pgCnt = ALLOCUTIL_PAGE_BYTE2CNT(actualSize);
    size_t converted =
        allocSpace.page_groups.SetAsLargeObjPage(page_idx, objAddr, pgCnt);
    // record the number of pages fetched from the kernel (previously released)
    allocSpace.RecordReleasedToNonReleased(converted);
  }
  return objAddr;
}

address_t RosAllocImpl::AllocHugeObject(size_t &allocSize) {
  allocSize = ALLOCUTIL_PAGE_RND_UP(allocSize);
  return AllocHugeInternal(allocSize);
}

void RosAllocImpl::FreeRun(RunSlots &runSlots, bool delayFree) {
  size_t pgCnt = static_cast<size_t>(GetPagesPerRun(runSlots.mIdx));
  size_t totalRunSize = ALLOCUTIL_PAGE_CNT2BYTE(pgCnt);
  address_t memAddr = reinterpret_cast<address_t>(&runSlots);

#ifdef ALLOC_ENABLE_LOCK_CONTENTION_STATS
  // this run is going to be deleted; we retrieve its lock stats first
  RosAllocImpl::pageLockContentionRec += runSlots.lock.GetContentionCount();
  RosAllocImpl::pageLockWaitTimeRec += runSlots.lock.GetWaitTime();
#endif
  // runSlots is created by placement new, we should explicity call
  // destructor to ensure resources (such as mutex) are properly released.
  runSlots.~RunSlots();
  (void)totalRunSize;
  // page map need not be cleared in lock:
  // this assumes that all unsafe heap visit is during concurrent marking,
  // where there can be no freeing of anything
  allocSpace.page_groups.ClearRunPage(memAddr, pgCnt, false);
  if (!delayFree) {
    while (true) {
      if (globalLock.try_lock()) {
        size_t pageIdx = allocSpace.page_groups.GetPageIdx(memAddr);
#ifdef ROSIMPL_MEMSET_AT_FREE
        ROSALLOC_MEMSET_S(memAddr, totalRunSize, 0, totalRunSize);
#endif
        allocSpace.FreeRegion(memAddr, pgCnt, pageIdx);
        globalLock.unlock();
        break;
      } else {
        sched_yield();
      }
    }
  }
}

bool __attribute__((noinline))
RosAllocImpl::HandleAllocFailure(size_t alloc_size, int &forceLevel) {
  if (forceLevel >= kEagerLevelMax) {
    ROSIMPL_ASSERT(allocSpace.heapSize == allocSpace.heapGrowthLimit,
                   "heap size doesn't reach limit before oom");
    size_t largestChunkSize = 0;
    largestChunkSize = allocSpace.GetLargestChunkSize();
    return false;
  }
  collector->RunFullCollection(alloc_size, forceLevel);
  forceLevel += 1;
  return true;
}

// release the physical memory of free pages, using madvise()
bool RosAllocImpl::ReleaseFreePages(bool aggressive) {
  {
    ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD globalLock);
    size_t releasedBytes = allocSpace.ReleaseFreePages(aggressive);
    if (releasedBytes == 0U) {
      return aggressive ? true : false;
    }
  }
  return true;
}

void RosAllocImpl::IterateCTree() { allocSpace.pageManager.IterateCTree(); }

void RosAllocImpl::ReleaseEmptyLocalruns() {
  for (size_t i = 0; i < RunConfig::kRunConfigs; i++) {
    if (globalMutator.localRuns[i]) {
      if (LocalRunIsEmpty(*globalMutator.localRuns[i])) {
        RunSlots *run_to_free = globalMutator.localRuns[i];

        globalMutator.localRuns[i] = nullptr;
        globalMutator.freeListSizes[i] = 0;
        globalMutator.freeLists[i].SetHead(0);
        globalMutator.freeLists[i].SetTail(0);

        FreeRun(*run_to_free);
      }
    }
  }
}

address_t RosAllocImpl::GetValidHeapAddr(address_t addr) {
  MarkPrologue();

  RootSet rootSet;
  TryToRecordValidObjAddr(&rootSet, addr);

  MarkEpilogue();

  if (rootSet.empty())
    return address_t(nullptr);
  else
    return rootSet.front();
}

#ifdef ENABLE_RTS_GC_DEBUG
void RosAllocImpl::DumpSpace() const {
  size_t run_obj_cnt[RunConfig::kRunConfigs] = {0};
  std::map<size_t, size_t> large_obj_cnt;
  std::map<size_t, size_t> huge_obj_cnt;
  size_t allocated_slots_size = 0, used_slots_size = 0;
  for (const auto &group : allocSpace.page_groups.GetGroupArray()) {
    if (!group.IsInitialized()) continue;
    if (group.IsHugeObj()) {
      ++huge_obj_cnt[group.GetCurrSize()];
      continue;
    }
    auto &page_map = group.GetPageMap();
    size_t end_index = page_map.GetPageIndex(page_map.GetEndAddr());
    for (size_t index = 0; index < end_index; ++index) {
      auto type = page_map.GetType(index);
      if (LIKELY(type == kPRun)) {
        address_t run_slots = page_map.GetPageAddr(index);
        RunSlots &slots = *reinterpret_cast<RunSlots *>(run_slots);
        auto slot_idx = slots.mIdx;
        index += RunConfig::kCfgs[slot_idx].numPagesPerRun - 1;
        allocated_slots_size +=
            RunConfig::kCfgs[slot_idx].numPagesPerRun * ALLOCUTIL_PAGE_SIZE;
        used_slots_size += sizeof(RunSlots);
        slots.ForEachObj(
            [&run_obj_cnt, slot_idx](ROS_GC::HeapObjType, address_t obj_addr) {
              // dump obj_addr
              run_obj_cnt[slot_idx]++;
            });
      } else if (type == kPLargeObj) {
        size_t page_cnt = 1;
        for (index = index + 1;
             index < end_index && page_map.GetType(index) == kPLargeObjRem;
             ++index, page_cnt++)
          ;
        ++large_obj_cnt[page_cnt];
      }
    }
  }
  fprintf(stdout, "DUMP_AllocPace begin:\n");
  fprintf(stdout, "DUMP_RunSlots:\n");
  for (size_t i = 0; i < RunConfig::kRunConfigs; ++i) {
    if (run_obj_cnt[i]) {
      fprintf(stdout, "run size: %u Bytes, object counts: %zu\n",
              RunConfig::kCfgs[i].size, run_obj_cnt[i]);
      used_slots_size += run_obj_cnt[i] * RunConfig::kCfgs[i].size;
    }
  }
  fprintf(stdout,
          "Allocated slots's size: %zu bytes, used slots' size: %zu bytes, "
          "fragmentation rate: %%%.2f\n",
          allocated_slots_size, used_slots_size,
          allocated_slots_size ? (1 - static_cast<double>(used_slots_size) /
                                          allocated_slots_size) *
                                     100.0
                               : 0.0);
  fprintf(stdout, "DUMP_RunSlots end.\nDUMP_LargeObj:\n");
  for (const auto &large_info : large_obj_cnt) {
    fprintf(stdout, "page size: %zu KBs, object count:%zu\n",
            large_info.first * ALLOCUTIL_PAGE_SIZE / KB, large_info.second);
  }
  fprintf(stdout, "DUMP_LargeObj end\nDUMP_HugeObj:\n");
  for (const auto &huge_info : huge_obj_cnt) {
    fprintf(stdout, "object size: %zu KBs, object count:%zu\n",
            huge_info.first / KB, huge_info.second);
  }
  fprintf(stdout, "DUMP_HugeObj end\n");
  fprintf(stdout, "MemMapSize: %zu bytes, allocated size: %zu bytes\n",
          allocSpace.GetSize(), allocatedInternalSize.load());
  fprintf(stdout, "DUMP_AllocPace end!\n");
  return;
}
#endif
}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
