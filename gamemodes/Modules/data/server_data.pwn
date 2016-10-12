// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
*
*       Andy's Cops and Robbers - a SA:MP server

*       Copyright (c) 2016 Andy Sedeyn
*
*       Permission is hereby granted, free of charge, to any person obtaining a copy
*       of this software and associated documentation files (the "Software"), to deal
*       in the Software without restriction, including without limitation the rights
*       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*       copies of the Software, and to permit persons to whom the Software is
*       furnished to do so, subject to the following conditions:
*
*       The above copyright notice and this permission notice shall be included in all
*       copies or substantial portions of the Software.
*
*       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*       SOFTWARE.
*
*/
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
*
*       Data module: server_data.pwn
*
*/

/*
*
*       Macro Functions (MF_)
*
*/

/*
*
*       Defines
*
*/

// Statistics
#define STAT_PLAYERS_CONNECTED          0
#define STAT_NPCS_CONNECTED             1
#define STAT_REGISTERED_CONNECTED       2
#define STAT_TOTAL_REGISTERED_PLAYERS   3   
#define STAT_COP_COUNT                  4
#define STAT_ROBBER_COUNT               5
#define STAT_PEAK_PLAYERS_ONLINE        6
#define STAT_SERVER_RUNNING_TIME        7

#define MAX_SERVER_STAT                 8

/*
*
*       Variables
*
*/

new ServerInfo[MAX_SERVER_STAT];

/*
*
*       Enums
*
*/

enum E_CAMERA_COORDINATES_DATA {

    Float:eccd_X,
    Float:eccd_Y,
    Float:eccd_Z,
    Float:eccd_LookatX,
    Float:eccd_LookatY,
    Float:eccd_LookatZ
};
new const gArr_CameraCoordinates[][E_CAMERA_COORDINATES_DATA] = {

    // Credits to Kevin Marapao Reinke for the coordinates
    { 987.975341, -955.438049, 49.101081, 985.155151, -959.480529, 49.940834 },
    { 1001.411376, -1025.995117, 60.197208, 1005.749877, -1028.159423, 58.975334 },
    { 1138.597167, -1239.133422, 38.861011, 1142.464843, -1242.201171, 38.067504 },
    { 1368.609252, -1456.940429, 55.747081, 1370.278930, -1461.624389, 55.224601 },
    { 1447.075439, -1595.283935, 40.958850, 1451.277587, -1597.798828, 39.950195 },
    { 1680.320556, -1839.974365, 46.456027, 1683.845703, -1842.833740, 44.358901 },
    { 1902.085937, -1805.962036, 32.699592, 1905.147827, -1802.238769, 31.371961 },
    { 2072.466308, -1801.947021, 29.624954, 2076.496826, -1799.451171, 28.035816 },
    { 2391.272216, -1531.180053, 42.574451, 2394.472900, -1527.538330, 41.352577 },
    { 2608.826171, -1656.604736, 30.392986, 2613.235595, -1658.804443, 29.545536 },
    { 1580.957641, -1159.483642, 58.350505, 1584.759399, -1156.743896, 56.606693 },
    { 1920.992797, -1137.577636, 38.442279, 1923.667236, -1141.737060, 37.702816 },
    { 2128.672119, -969.847839, 76.608810, 2132.188964, -973.255798, 75.600158 },
    { 1275.479248, -2009.787231, 70.787818, 1271.209838, -2012.377563, 70.537925 },
    { 535.669250, -1561.102905, 28.937414, 539.385009, -1564.447387, 28.851480 },
    { 1246.806030, -2313.866699, 31.218750, 1243.762573, -2317.565917, 29.785995 },
    { 869.608215, -1922.826660, 16.601207, 867.136291, -1918.481323, 16.515275 },
    { 432.075683, -2018.896850, 17.881744, 427.542510, -2020.997314, 17.686481 },
    { -20.899288, -368.379699, 25.116037, -23.212120, -363.984466, 24.539199 },
    { 1351.946411, 1794.910278, 31.134214, 1355.263549, 1791.266357, 30.286762 },
    { 2101.370849, -136.369842, 33.559062, 2104.436035, -133.224914, 31.168794 },
    { 2111.181396, 860.944946, 23.544681, 2109.075927, 865.400146, 22.697229 },
    { 2129.411132, 964.222106, 20.906347, 2130.734863, 969.015319, 20.383865 },
    { 2609.197753, 1056.329956, 22.494182, 2611.885498, 1060.470825, 21.700675 },
    { 2618.314941, 1430.729370, 29.249929, 2614.601074, 1434.017089, 28.618804 },
    { 2546.806640, 1709.195434, 35.060062, 2548.058593, 1713.929931, 34.051406 },
    { 2362.350097, 1977.292358, 46.777801, 2357.746826, 1978.930053, 45.715644 },
    { 1888.678955, 2253.938964, 29.539340, 1884.081298, 2252.443603, 28.264511 },
    { 1920.349853, 2584.994628, 47.860237, 1922.832519, 2589.109375, 46.479961 },
    { 2485.994628, 2737.228027, 26.439661, 2490.666259, 2738.932128, 25.917179 },
    { 1219.870727, 1088.383300, 48.631584, 1215.522338, 1086.337158, 47.251308 },
    { 795.533996, 841.734680, 26.462825, 790.730529, 841.881225, 25.082550 },
    { -506.981414, 587.725952, 47.946445, -503.441894, 590.736694, 46.100551 },
    { -669.061767, 898.894348, 19.884815, -671.589843, 903.169372, 19.307977 },
    { -1084.305908, 804.821533, 53.838256, -1089.234863, 803.993835, 53.697650 },
    { -1533.504272, 774.869201, 30.132383, -1536.320800, 770.804687, 29.392917 },
    { -1610.850097, 1217.079711, 20.456762, -1615.722656, 1216.236083, 19.717296 },
    { -2578.240234, 1377.392211, 22.451934, -2583.171386, 1377.625732, 21.658428 },
    { -2887.700683, 1094.186401, 34.614059, -2885.249755, 1089.852661, 35.074344 },
    { -2522.903808, 685.555480, 57.301433, -2526.295166, 682.022644, 56.292778 },
    { -2512.928222, 452.833831, 62.947818, -2513.241210, 448.023498, 61.620185 },
    { -2643.915771, 77.618980, 42.229888, -2645.038330, 73.031257, 40.588993 },
    { -2522.973144, -258.147369, 49.276565, -2518.883544, -260.860717, 48.321533 },
    { -2002.908691, 105.276939, 43.062492, -2004.911743, 109.706596, 41.893718 }
};

enum E_RADIO_STATIONS_DATA {

    ersd_Name[144],
    ersd_URL[256]
};
new const gArr_RadioStations[][E_RADIO_STATIONS_DATA] = {

    // Credits to Kevin Marapao Reinke for the URLs
    { ".977 Today's Hits", "http://7609.live.streamtheworld.com/977_HITS_SC" },
    { ".977 Country", "http://7599.live.streamtheworld.com/977_COUNTRY_SC" },
    { ".977 Jazz", "http://7609.live.streamtheworld.com/977_SMOOJAZZ_SC" },
    { ".977 Hip Hop", "http://7609.live.streamtheworld.com/977_JAMZ_SC" },
    { ".977 70's Rock", "http://7649.live.streamtheworld.com/977_CLASSROCK_S" },
    { ".977 80's Hits", "http://7649.live.streamtheworld.com/977_80_SC" },
    { ".977 90's Hits", "http://7599.live.streamtheworld.com/977_90_SC" },
    { "Radio Britney", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=99180420 " },
    { "#1 Hits", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=389248" },
    { "One Dance", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=24037" },
    { "New York Classic Rock", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=552327" },
    { "Noise FM", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=528376" },
    { "Aardvark Blues FM", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=621720" },
    { "Radio Mozart","http://yp.shoutcast.com/sbin/tunein-station.pls?id=140955" },
    { "Our World Pop", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=69351" },
    { "AAZO Radio", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=250423" },
    { "Cristal Relax", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=633849" },
    { "Animes Station", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=99181623" },
    { "Inolvidable Digital", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=99180765" },
    { "R1 Dubstep", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=99188715" },
    { "Taylor Swift Radio", "http://95.81.147.25/8798/nrj_177446.mp3" }
};
