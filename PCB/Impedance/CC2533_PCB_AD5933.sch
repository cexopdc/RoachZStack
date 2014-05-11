<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="6.4">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="CC2530_PCB_TL">
<packages>
<package name="CC2533">
<smd name="NC1" x="-3.048" y="2.286" dx="0.762" dy="0.254" layer="1"/>
<smd name="SCL" x="-3.048" y="1.778" dx="0.762" dy="0.254" layer="1"/>
<smd name="SDA" x="-3.048" y="1.27" dx="0.762" dy="0.254" layer="1"/>
<smd name="NC2" x="-3.048" y="0.762" dx="0.762" dy="0.254" layer="1"/>
<smd name="P1_5" x="-3.048" y="0.254" dx="0.762" dy="0.254" layer="1"/>
<smd name="P1_4" x="-3.048" y="-0.254" dx="0.762" dy="0.254" layer="1"/>
<smd name="P1_3" x="-3.048" y="-0.762" dx="0.762" dy="0.254" layer="1"/>
<smd name="P1_2" x="-3.048" y="-1.27" dx="0.762" dy="0.254" layer="1"/>
<smd name="P1_1" x="-3.048" y="-1.778" dx="0.762" dy="0.254" layer="1"/>
<smd name="DVDD2" x="-3.048" y="-2.286" dx="0.762" dy="0.254" layer="1"/>
<smd name="P0_0" x="1.778" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_1" x="1.27" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_2" x="0.762" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_3" x="0.254" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_4" x="-0.254" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_5" x="-0.762" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_6" x="-1.27" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P0_7" x="-1.778" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="P1_0" x="-2.286" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="RESET_N" x="2.286" y="-3.048" dx="0.762" dy="0.254" layer="1" rot="R90"/>
<smd name="XOSC_Q1" x="3.048" y="-1.778" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="AVDD5" x="3.048" y="-2.286" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="XOSC_Q2" x="3.048" y="-1.27" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="AVDD3" x="3.048" y="-0.762" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="RF_P" x="3.048" y="-0.254" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="RF_N" x="3.048" y="0.254" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="AVDD2" x="3.048" y="0.762" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="AVDD1" x="3.048" y="1.27" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="AVDD4" x="3.048" y="1.778" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="RBIAS" x="3.048" y="2.286" dx="0.762" dy="0.254" layer="1" rot="R180"/>
<smd name="P2_4/XOSC32K_Q1" x="1.778" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P2_3/XOSC32K_Q2" x="1.27" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P2_2" x="0.762" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P2_1" x="0.254" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P2_0" x="-0.254" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P1_7" x="-0.762" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="P1_6" x="-1.27" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="DVDD1" x="-1.778" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="AVDD6" x="2.286" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="DCOUPL" x="-2.286" y="3.048" dx="0.762" dy="0.254" layer="1" rot="R270"/>
<smd name="GND0" x="0" y="0" dx="3.5" dy="3.5" layer="1"/>
<circle x="-2.286" y="2.286" radius="0.05" width="0.1" layer="21"/>
<wire x1="-3.0734" y1="3.0734" x2="3.0734" y2="3.0734" width="0.254" layer="21"/>
<wire x1="3.0734" y1="-3.0734" x2="3.0734" y2="3.0734" width="0.254" layer="21"/>
<wire x1="-3.0734" y1="-3.0734" x2="-3.0734" y2="3.0734" width="0.254" layer="21"/>
<wire x1="-3.0734" y1="-3.0734" x2="3.0734" y2="-3.0734" width="0.254" layer="21"/>
</package>
<package name="BALUN">
<description>2.45 GHz Impedance Matched Balun-BPF: For TI CC253X, CC254X, CC257X, 
CC853X and CC852X Chipset family
P/N 2450BM15A0002</description>
<smd name="UNBALANCED" x="-0.782209375" y="0.64501875" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<smd name="GND2" x="-0.782209375" y="-0.00498125" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<smd name="BALANCED3" x="-0.782209375" y="-0.65498125" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<smd name="GND6" x="0.767790625" y="0.64501875" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<smd name="GND5" x="0.767790625" y="-0.00498125" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<smd name="BALANCED4" x="0.767790625" y="-0.65498125" dx="0.3" dy="0.75" layer="1" rot="R270"/>
<rectangle x1="-0.052209375" y1="0.69501875" x2="0.047790625" y2="0.79501875" layer="21"/>
</package>
<package name="X32MHZ">
<description>X32MHz ABM12-32.000MHZ-B2X-T3</description>
<smd name="Q2" x="-0.453809375" y="0.6737" dx="0.65" dy="0.55" layer="1" rot="R90"/>
<smd name="Q1" x="0.496190625" y="-0.5763" dx="0.65" dy="0.55" layer="1" rot="R90"/>
<wire x1="-0.58" y1="0.85" x2="0.62" y2="0.85" width="0.127" layer="21"/>
<wire x1="0.62" y1="0.85" x2="0.62" y2="-0.75" width="0.127" layer="21"/>
<wire x1="0.62" y1="-0.75" x2="-0.58" y2="-0.75" width="0.127" layer="21"/>
<wire x1="-0.58" y1="-0.75" x2="-0.58" y2="0.85" width="0.127" layer="21"/>
</package>
<package name="0201">
<description>Package / Case	0201 (0603 Metric):
15pF/20pF/0.1uF/0.47uF Cer Cap,
56k/499k Thick Film Res</description>
<smd name="1" x="-0.3" y="-0.0008" dx="0.3" dy="0.2032" layer="1" rot="R90"/>
<smd name="2" x="0.3" y="-0.0008" dx="0.3" dy="0.2032" layer="1" rot="R90"/>
</package>
<package name="ANTENNA_BOTTOM">
<description>Antenna for use in bottom layer of CC2530 PCB</description>
<smd name="P$3" x="0.059171875" y="6.728059375" dx="0.5" dy="0.9" layer="16" stop="no"/>
<smd name="P$4" x="2.50916875" y="6.72668125" dx="4.4" dy="0.9" layer="16" rot="R180" stop="no"/>
<smd name="P$5" x="4.9452" y="4.67651875" dx="0.5" dy="5" layer="16" rot="R180" stop="no"/>
<smd name="P$6" x="3.3702" y="2.4264625" dx="2.65" dy="0.5" layer="16" rot="R180" stop="no"/>
<smd name="P$7" x="2.2962875" y="1.179059375" dx="0.5" dy="2" layer="16" stop="no"/>
<smd name="P$8" x="2.4952" y="4.62651875" dx="4.4" dy="0.5" layer="16" stop="no"/>
<smd name="P$9" x="4.9477375" y="-1.1709375" dx="0.5" dy="2.7" layer="16" rot="R180" stop="no"/>
<smd name="P$10" x="2.7252" y="-6.96205" dx="0.5" dy="3.94" layer="16" rot="R90" stop="no"/>
<smd name="P$11" x="3.380740625" y="-0.0706125" dx="2.667" dy="0.5" layer="16" rot="R180" stop="no"/>
<smd name="P$12" x="3.37528125" y="-2.270940625" dx="2.65" dy="0.5" layer="16" rot="R180" stop="no"/>
<smd name="P$13" x="2.299009375" y="-3.51205" dx="0.5" dy="2" layer="16" stop="no"/>
<smd name="P$14" x="3.371596875" y="-4.759959375" dx="2.65" dy="0.5" layer="16" rot="R180" stop="no"/>
<smd name="P$15" x="4.9452" y="-5.860778125" dx="0.5" dy="2.7" layer="16" rot="R180" stop="no"/>
<smd name="P$16" x="0.0452" y="4.62651875" dx="0.5" dy="0.5" layer="16" rot="R180" stop="no"/>
<smd name="A" x="-0.01396875" y="-0.0960125" dx="0.2032" dy="0.2032" layer="16" rot="R180" stop="no"/>
<smd name="A1" x="-0.01396875" y="2.096678125" dx="0.381" dy="4.589" layer="16" rot="R180" stop="no"/>
</package>
<package name="REGULATOR">
<description>IC REG LDO 3V 50MA SOT23-5
TPS76030DBVT</description>
<smd name="1" x="0.94" y="1.275" dx="0.5" dy="0.8" layer="1"/>
<smd name="2" x="0" y="1.275" dx="0.5" dy="0.8" layer="1"/>
<smd name="3" x="-0.95" y="1.275" dx="0.5" dy="0.8" layer="1"/>
<smd name="5" x="0.95" y="-1.275" dx="0.5" dy="0.8" layer="1"/>
<smd name="4" x="-0.95" y="-1.275" dx="0.5" dy="0.8" layer="1"/>
<wire x1="-1.51" y1="-0.88" x2="1.54" y2="-0.88" width="0.127" layer="21"/>
<wire x1="1.54" y1="-0.88" x2="1.54" y2="0.87" width="0.127" layer="21"/>
<wire x1="1.54" y1="0.87" x2="-1.51" y2="0.87" width="0.127" layer="21"/>
<wire x1="-1.51" y1="0.87" x2="-1.51" y2="-0.88" width="0.127" layer="21"/>
</package>
<package name="0603">
<description>Package / Case	0603 (1608 Metric): Needs revision
LED,
1uF/2.2uF/10uF Tant Cap,
0k Thick Film Res
174k Thin Film Res</description>
<smd name="1" x="-0.7508" y="0" dx="0.6" dy="0.8" layer="1" rot="R90"/>
<smd name="2" x="0.7492" y="0" dx="0.6" dy="0.8" layer="1" rot="R90"/>
</package>
<package name="FFC4POS">
<description>FFC Connector 4POS</description>
<smd name="1" x="0.039859375" y="0.7418" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="2" x="0.039859375" y="0.2418" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="3" x="0.039859375" y="-0.2582" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="4" x="0.039859375" y="-0.7582" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="P$5" x="-2.46" y="1.94" dx="0.8" dy="0.8" layer="1"/>
<smd name="P$6" x="-2.46" y="-1.96" dx="0.8" dy="0.8" layer="1"/>
<wire x1="-3.41" y1="1.99" x2="-0.41" y2="1.99" width="0.127" layer="21"/>
<wire x1="-0.41" y1="1.99" x2="-0.41" y2="-2.01" width="0.127" layer="21"/>
<wire x1="-0.41" y1="-2.01" x2="-3.41" y2="-2.01" width="0.127" layer="21"/>
<wire x1="-3.41" y1="-2.01" x2="-3.41" y2="1.99" width="0.127" layer="21"/>
</package>
<package name="SPDT_DUAL">
<description>TS3A24159DGSR
IC SWITCH DUAL SPDT 10MSOP</description>
<smd name="COM1" x="-2.075" y="0" dx="1.05" dy="0.25" layer="1"/>
<smd name="NO1" x="-2.075" y="0.5" dx="1.05" dy="0.25" layer="1"/>
<smd name="V+" x="-2.075" y="1" dx="1.05" dy="0.25" layer="1"/>
<smd name="IN1" x="-2.075" y="-0.5" dx="1.05" dy="0.25" layer="1"/>
<smd name="NC1" x="-2.075" y="-1" dx="1.05" dy="0.25" layer="1"/>
<smd name="GND" x="2.075" y="-1" dx="1.05" dy="0.25" layer="1"/>
<smd name="NC2" x="2.075" y="-0.5" dx="1.05" dy="0.25" layer="1"/>
<smd name="IN2" x="2.075" y="0" dx="1.05" dy="0.25" layer="1"/>
<smd name="COM2" x="2.075" y="0.5" dx="1.05" dy="0.25" layer="1"/>
<smd name="NO2" x="2.075" y="1" dx="1.05" dy="0.25" layer="1"/>
<circle x="-1.25" y="1" radius="0.05" width="0.127" layer="21"/>
<wire x1="-1.55" y1="1.55" x2="1.55" y2="1.55" width="0.127" layer="21"/>
<wire x1="1.55" y1="1.55" x2="1.55" y2="-1.55" width="0.127" layer="21"/>
<wire x1="1.55" y1="-1.55" x2="-1.55" y2="-1.55" width="0.127" layer="21"/>
<wire x1="-1.55" y1="-1.55" x2="-1.55" y2="1.55" width="0.127" layer="21"/>
</package>
<package name="AD5933">
<description>AD5933</description>
<smd name="MCLK" x="-3.35" y="-2.35" dx="1.4" dy="0.35" layer="1"/>
<smd name="NC7" x="-3.35" y="-1.7" dx="1.4" dy="0.35" layer="1"/>
<smd name="VIN" x="-3.35" y="-0.4" dx="1.4" dy="0.35" layer="1"/>
<smd name="VOUT" x="-3.35" y="-1.05" dx="1.4" dy="0.35" layer="1"/>
<smd name="RFB" x="-3.35" y="0.25" dx="1.4" dy="0.35" layer="1"/>
<smd name="NC3" x="-3.35" y="0.9" dx="1.4" dy="0.35" layer="1"/>
<smd name="NC1" x="-3.35" y="2.2" dx="1.4" dy="0.35" layer="1"/>
<smd name="NC2" x="-3.35" y="1.55" dx="1.4" dy="0.35" layer="1"/>
<smd name="DVDD" x="3.45" y="-2.35" dx="1.4" dy="0.35" layer="1"/>
<smd name="AVDD1" x="3.45" y="-1.7" dx="1.4" dy="0.35" layer="1"/>
<smd name="DGND" x="3.45" y="-0.4" dx="1.4" dy="0.35" layer="1"/>
<smd name="AVDD2" x="3.45" y="-1.05" dx="1.4" dy="0.35" layer="1"/>
<smd name="AGND1" x="3.45" y="0.25" dx="1.4" dy="0.35" layer="1"/>
<smd name="AGND2" x="3.45" y="0.9" dx="1.4" dy="0.35" layer="1"/>
<smd name="SCL" x="3.45" y="2.2" dx="1.4" dy="0.35" layer="1"/>
<smd name="SDA" x="3.45" y="1.55" dx="1.4" dy="0.35" layer="1"/>
<circle x="-2.25" y="2.2" radius="0.05" width="0.2" layer="21"/>
<wire x1="-2.75" y1="3.2" x2="2.85" y2="3.2" width="0.127" layer="21"/>
<wire x1="2.85" y1="3.2" x2="2.85" y2="-3.3" width="0.127" layer="21"/>
<wire x1="2.85" y1="-3.3" x2="-2.75" y2="-3.3" width="0.127" layer="21"/>
<wire x1="-2.75" y1="-3.3" x2="-2.75" y2="3.2" width="0.127" layer="21"/>
</package>
<package name="FFC6POS">
<description>FFC Connector 6POS</description>
<smd name="1" x="0.00765" y="1.26886875" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="2" x="0.00765" y="0.76886875" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="3" x="0.00765" y="0.26886875" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="4" x="0.00765" y="-0.23113125" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="5" x="0.00765" y="-0.73113125" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="6" x="0.00765" y="-1.23113125" dx="0.254" dy="0.762" layer="1" rot="R90"/>
<smd name="P$7" x="-2.49" y="2.47" dx="0.8" dy="0.8" layer="1"/>
<smd name="P$8" x="-2.49" y="-2.43" dx="0.8" dy="0.8" layer="1"/>
<wire x1="-3.44" y1="2.52" x2="-0.44" y2="2.52" width="0.127" layer="21"/>
<wire x1="-0.44" y1="2.52" x2="-0.44" y2="-2.48" width="0.127" layer="21"/>
<wire x1="-0.44" y1="-2.48" x2="-3.44" y2="-2.48" width="0.127" layer="21"/>
<wire x1="-3.44" y1="-2.48" x2="-3.44" y2="2.52" width="0.127" layer="21"/>
</package>
<package name="SWITCH_MANUAL">
<smd name="1" x="-4.130040625" y="0" dx="1.524" dy="1.016" layer="1"/>
<smd name="2" x="3.81" y="0" dx="1.524" dy="1.016" layer="1"/>
<wire x1="-3.05" y1="1.155" x2="2.75" y2="1.155" width="0.127" layer="21"/>
<wire x1="2.75" y1="1.155" x2="2.75" y2="-1.155" width="0.127" layer="21"/>
<wire x1="2.75" y1="-1.155" x2="-3.05" y2="-1.155" width="0.127" layer="21"/>
<wire x1="-3.05" y1="-1.155" x2="-3.05" y2="1.155" width="0.127" layer="21"/>
</package>
<package name="AD8606_OPAMP">
<description>OPAMP AD8606ARMZ-REEL</description>
<smd name="V-" x="-2.1" y="-0.975" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="+INA" x="-2.1" y="-0.325" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="-INA" x="-2.1" y="0.325" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="OUTA" x="-2.1" y="0.975" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="+INB" x="2.1" y="-0.975" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="-INB" x="2.1" y="-0.325" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="OUTB" x="2.1" y="0.325" dx="0.25" dy="1" layer="1" rot="R90"/>
<smd name="V+" x="2.1" y="0.975" dx="0.25" dy="1" layer="1" rot="R90"/>
<circle x="-1.2" y="1" radius="0.05" width="0.1" layer="21"/>
<wire x1="-1.6" y1="-1.6" x2="-1.6" y2="1.6" width="0.127" layer="21"/>
<wire x1="-1.6" y1="1.6" x2="1.6" y2="1.6" width="0.127" layer="21"/>
<wire x1="1.6" y1="1.6" x2="1.6" y2="-1.6" width="0.127" layer="21"/>
<wire x1="1.6" y1="-1.6" x2="-1.6" y2="-1.6" width="0.127" layer="21"/>
</package>
<package name="0603_RES">
<description>Package / Case	0603 (1608 Metric):
LED?,
1uF/2.2uF/10uF Tant Cap?,
0k Thick Film Res
174k Thin Film Res</description>
<smd name="1" x="-0.8" y="0" dx="0.6" dy="0.8" layer="1"/>
<smd name="2" x="0.8" y="0" dx="0.6" dy="0.8" layer="1"/>
</package>
<package name="0402_CAP">
<smd name="1" x="-0.4754" y="0.0008" dx="0.5334" dy="0.3302" layer="1" rot="R90"/>
<smd name="2" x="0.5008" y="0.0008" dx="0.5334" dy="0.3302" layer="1" rot="R90"/>
</package>
<package name="0402">
<description>Package / Case	0402 (1005 Metric):
10uF Cer Cap,
0k/1k Thick Film Res,
2k/75k/100k Thin Film Res</description>
<smd name="1" x="-0.45" y="0.0008" dx="0.5" dy="0.3" layer="1" rot="R90"/>
<smd name="2" x="0.45" y="0.0008" dx="0.5" dy="0.3" layer="1" rot="R90"/>
</package>
<package name="X32.768KHZ">
<description>X32.768kHz 9HT11-32.768KDZC-T</description>
<smd name="Q2" x="0.008559375" y="0.78936875" dx="0.7" dy="1.25" layer="1" rot="R90"/>
<smd name="Q1" x="0.008559375" y="-0.81063125" dx="0.7" dy="1.25" layer="1" rot="R90"/>
<wire x1="-0.59" y1="0.99" x2="0.61" y2="0.99" width="0.127" layer="21"/>
<wire x1="0.61" y1="0.99" x2="0.61" y2="-1.01" width="0.127" layer="21"/>
<wire x1="0.61" y1="-1.01" x2="-0.59" y2="-1.01" width="0.127" layer="21"/>
<wire x1="-0.59" y1="-1.01" x2="-0.59" y2="0.99" width="0.127" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="CC2533">
<pin name="DVDD2" x="-27.94" y="-12.7" length="middle" direction="pwr"/>
<pin name="P1_0" x="-10.16" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_7" x="-7.62" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_6" x="-5.08" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_5" x="-2.54" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_4" x="0" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_3" x="2.54" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_2" x="5.08" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_1" x="7.62" y="-25.4" length="middle" rot="R90"/>
<pin name="P0_0" x="10.16" y="-25.4" length="middle" rot="R90"/>
<pin name="RESET_N" x="12.7" y="-25.4" length="middle" direction="in" rot="R90"/>
<pin name="AVDD5" x="30.48" y="-12.7" length="middle" direction="pwr" rot="R180"/>
<pin name="AVDD6" x="12.7" y="22.86" length="middle" direction="pwr" rot="R270"/>
<pin name="P2_4/XOSC32K_Q1" x="10.16" y="22.86" length="middle" rot="R270"/>
<pin name="P2_3/XOSC32K_Q2" x="7.62" y="22.86" length="middle" rot="R270"/>
<pin name="P2_2" x="5.08" y="22.86" length="middle" rot="R270"/>
<pin name="P2_1" x="2.54" y="22.86" length="middle" rot="R270"/>
<pin name="P2_0" x="0" y="22.86" length="middle" rot="R270"/>
<pin name="P1_7" x="-2.54" y="22.86" length="middle" rot="R270"/>
<pin name="P1_6" x="-5.08" y="22.86" length="middle" rot="R270"/>
<pin name="DVDD1" x="-7.62" y="22.86" length="middle" direction="pwr" rot="R270"/>
<pin name="DCOUPL" x="-10.16" y="22.86" length="middle" direction="pwr" rot="R270"/>
<pin name="NC1" x="-27.94" y="10.16" length="middle" direction="pwr"/>
<pin name="SCL" x="-27.94" y="7.62" length="middle" direction="pwr"/>
<pin name="SDA" x="-27.94" y="5.08" length="middle" direction="pwr"/>
<pin name="NC2" x="-27.94" y="2.54" length="middle" direction="pwr"/>
<pin name="P1_5" x="-27.94" y="0" length="middle"/>
<pin name="P1_4" x="-27.94" y="-2.54" length="middle"/>
<pin name="P1_3" x="-27.94" y="-5.08" length="middle"/>
<pin name="P1_2" x="-27.94" y="-7.62" length="middle"/>
<pin name="P1_1" x="-27.94" y="-10.16" length="middle"/>
<pin name="XOSC_Q1" x="30.48" y="-10.16" length="middle" rot="R180"/>
<pin name="XOSC_Q2" x="30.48" y="-7.62" length="middle" rot="R180"/>
<pin name="AVDD3" x="30.48" y="-5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="RF_P" x="30.48" y="-2.54" length="middle" rot="R180"/>
<pin name="RF_N" x="30.48" y="0" length="middle" rot="R180"/>
<pin name="AVDD2" x="30.48" y="2.54" length="middle" direction="pwr" rot="R180"/>
<pin name="AVDD1" x="30.48" y="5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="AVDD4" x="30.48" y="7.62" length="middle" direction="pwr" rot="R180"/>
<pin name="RBIAS" x="30.48" y="10.16" length="middle" rot="R180"/>
<wire x1="-22.86" y1="17.78" x2="25.4" y2="17.78" width="0.254" layer="94"/>
<wire x1="25.4" y1="17.78" x2="25.4" y2="-20.32" width="0.254" layer="94"/>
<wire x1="25.4" y1="-20.32" x2="-22.86" y2="-20.32" width="0.254" layer="94"/>
<wire x1="-22.86" y1="-20.32" x2="-22.86" y2="17.78" width="0.254" layer="94"/>
<pin name="GND0" x="-5.08" y="0" length="short" direction="pwr"/>
</symbol>
<symbol name="BALUN">
<description>2.45 GHz Impedance Matched Balun-BPF: For TI CC253X, CC254X, CC257X, 
CC853X and CC852X Chipset family
P/N 2450BM15A0002</description>
<pin name="UNBALANCED" x="-22.86" y="5.08" length="middle"/>
<pin name="GND2" x="-22.86" y="0" length="middle" direction="pwr"/>
<pin name="BALANCED3" x="-22.86" y="-5.08" length="middle"/>
<pin name="BALANCED4" x="22.86" y="-5.08" length="middle" rot="R180"/>
<pin name="GND5" x="22.86" y="0" length="middle" direction="pwr" rot="R180"/>
<pin name="GND6" x="22.86" y="5.08" length="middle" direction="pwr" rot="R180"/>
<wire x1="-17.78" y1="-10.16" x2="-17.78" y2="10.16" width="0.254" layer="94"/>
<wire x1="-17.78" y1="10.16" x2="17.78" y2="10.16" width="0.254" layer="94"/>
<wire x1="17.78" y1="10.16" x2="17.78" y2="-10.16" width="0.254" layer="94"/>
<wire x1="17.78" y1="-10.16" x2="-17.78" y2="-10.16" width="0.254" layer="94"/>
</symbol>
<symbol name="X32MHZ">
<description>X32MHz ABM12-32.000MHZ-B2X-T3</description>
<pin name="Q2" x="-5.08" y="12.7" length="middle" rot="R270"/>
<pin name="Q1" x="5.08" y="-12.7" length="middle" rot="R90"/>
<wire x1="-7.62" y1="7.62" x2="7.62" y2="7.62" width="0.254" layer="94"/>
<wire x1="7.62" y1="7.62" x2="7.62" y2="-7.62" width="0.254" layer="94"/>
<wire x1="7.62" y1="-7.62" x2="-7.62" y2="-7.62" width="0.254" layer="94"/>
<wire x1="-7.62" y1="-7.62" x2="-7.62" y2="7.62" width="0.254" layer="94"/>
</symbol>
<symbol name="0201">
<description>Package / Case	0201 (0603 Metric)</description>
<pin name="1" x="-15.24" y="0" length="middle"/>
<pin name="2" x="12.7" y="0" length="middle" rot="R180"/>
<wire x1="-10.16" y1="2.54" x2="7.62" y2="2.54" width="0.254" layer="94"/>
<wire x1="7.62" y1="2.54" x2="7.62" y2="-2.54" width="0.254" layer="94"/>
<wire x1="7.62" y1="-2.54" x2="-10.16" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-10.16" y1="-2.54" x2="-10.16" y2="2.54" width="0.254" layer="94"/>
</symbol>
<symbol name="ANTENNA_BOTTOM">
<description>Antenna for use in bottom layer of CC2530 PCB</description>
<pin name="A" x="-5.08" y="0" length="middle"/>
<wire x1="0" y1="2.54" x2="0" y2="-2.54" width="0.254" layer="94"/>
<wire x1="0" y1="-2.54" x2="12.7" y2="-2.54" width="0.254" layer="94"/>
<wire x1="0" y1="2.54" x2="12.7" y2="2.54" width="0.254" layer="94"/>
<wire x1="12.7" y1="2.54" x2="12.7" y2="-2.54" width="0.254" layer="94"/>
</symbol>
<symbol name="FFC4POS">
<description>FFC Connector 4POS</description>
<pin name="4" x="2.54" y="-7.62" length="middle" rot="R180"/>
<pin name="3" x="2.54" y="-2.54" length="middle" rot="R180"/>
<pin name="2" x="2.54" y="2.54" length="middle" rot="R180"/>
<pin name="1" x="2.54" y="7.62" length="middle" rot="R180"/>
</symbol>
<symbol name="REGULATOR">
<description>IC REG LDO 3V 50MA SOT23-5
TPS76030DBVT</description>
<pin name="1_IN" x="5.08" y="15.24" length="middle" rot="R270"/>
<pin name="3_EN" x="-5.08" y="15.24" length="middle" rot="R270"/>
<pin name="4_NC" x="-5.08" y="-15.24" length="middle" direction="nc" rot="R90"/>
<pin name="5_OUT" x="5.08" y="-15.24" length="middle" rot="R90"/>
<pin name="2_GND" x="0" y="15.24" length="middle" direction="pwr" rot="R270"/>
<wire x1="-7.62" y1="10.16" x2="7.62" y2="10.16" width="0.254" layer="94"/>
<wire x1="7.62" y1="10.16" x2="7.62" y2="-10.16" width="0.254" layer="94"/>
<wire x1="7.62" y1="-10.16" x2="-7.62" y2="-10.16" width="0.254" layer="94"/>
<wire x1="-7.62" y1="-10.16" x2="-7.62" y2="10.16" width="0.254" layer="94"/>
</symbol>
<symbol name="0603">
<description>Package / Case	0603 (1608 Metric)</description>
<pin name="1" x="-12.7" y="0" length="middle"/>
<pin name="2" x="15.24" y="0" length="middle" rot="R180"/>
<wire x1="-7.62" y1="2.54" x2="10.16" y2="2.54" width="0.254" layer="94"/>
<wire x1="10.16" y1="2.54" x2="10.16" y2="-2.54" width="0.254" layer="94"/>
<wire x1="10.16" y1="-2.54" x2="-7.62" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-7.62" y1="-2.54" x2="-7.62" y2="2.54" width="0.254" layer="94"/>
</symbol>
<symbol name="SPDT_DUAL">
<description>TS3A24159DGSR
IC SWITCH DUAL SPDT 10MSOP</description>
<pin name="V+" x="-15.24" y="5.08" length="middle" direction="pwr"/>
<pin name="NO1" x="-15.24" y="2.54" length="middle"/>
<pin name="COM1" x="-15.24" y="0" length="middle"/>
<pin name="IN1" x="-15.24" y="-2.54" length="middle" direction="in"/>
<pin name="NC1" x="-15.24" y="-5.08" length="middle" direction="nc"/>
<pin name="GND" x="15.24" y="-5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="NC2" x="15.24" y="-2.54" length="middle" direction="nc" rot="R180"/>
<pin name="IN2" x="15.24" y="0" length="middle" rot="R180"/>
<pin name="COM2" x="15.24" y="2.54" length="middle" rot="R180"/>
<pin name="NO2" x="15.24" y="5.08" length="middle" rot="R180"/>
<wire x1="-10.16" y1="7.62" x2="-10.16" y2="-7.62" width="0.254" layer="94"/>
<wire x1="-10.16" y1="-7.62" x2="10.16" y2="-7.62" width="0.254" layer="94"/>
<wire x1="10.16" y1="-7.62" x2="10.16" y2="7.62" width="0.254" layer="94"/>
<wire x1="10.16" y1="7.62" x2="-10.16" y2="7.62" width="0.254" layer="94"/>
</symbol>
<symbol name="AD5933">
<description>AD5933</description>
<pin name="NC1" x="-15.24" y="7.62" length="middle" direction="nc"/>
<pin name="NC2" x="-15.24" y="5.08" length="middle" direction="nc"/>
<pin name="NC3" x="-15.24" y="2.54" length="middle" direction="nc"/>
<pin name="NC7" x="-15.24" y="-7.62" length="middle" direction="nc"/>
<pin name="DVDD" x="15.24" y="-10.16" length="middle" direction="pwr" rot="R180"/>
<pin name="AVDD1" x="15.24" y="-7.62" length="middle" direction="pwr" rot="R180"/>
<pin name="AVDD2" x="15.24" y="-5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="DGND" x="15.24" y="-2.54" length="middle" direction="pwr" rot="R180"/>
<pin name="AGND1" x="15.24" y="0" length="middle" direction="pwr" rot="R180"/>
<pin name="AGND2" x="15.24" y="2.54" length="middle" direction="pwr" rot="R180"/>
<pin name="VOUT" x="-15.24" y="-5.08" length="middle" direction="out"/>
<pin name="VIN" x="-15.24" y="-2.54" length="middle" direction="in"/>
<pin name="RFB" x="-15.24" y="0" length="middle"/>
<pin name="MCLK" x="-15.24" y="-10.16" length="middle"/>
<pin name="SCL" x="15.24" y="7.62" length="middle" rot="R180"/>
<pin name="SDA" x="15.24" y="5.08" length="middle" rot="R180"/>
<wire x1="-10.16" y1="10.16" x2="10.16" y2="10.16" width="0.254" layer="94"/>
<wire x1="10.16" y1="10.16" x2="10.16" y2="-12.7" width="0.254" layer="94"/>
<wire x1="10.16" y1="-12.7" x2="-10.16" y2="-12.7" width="0.254" layer="94"/>
<wire x1="-10.16" y1="-12.7" x2="-10.16" y2="10.16" width="0.254" layer="94"/>
</symbol>
<symbol name="FFC6POS">
<description>FFC Connector 6POS</description>
<pin name="6" x="-2.54" y="12.7" length="middle"/>
<pin name="5" x="-2.54" y="7.62" length="middle"/>
<pin name="4" x="-2.54" y="2.54" length="middle"/>
<pin name="3" x="-2.54" y="-2.54" length="middle"/>
<pin name="2" x="-2.54" y="-7.62" length="middle"/>
<pin name="1" x="-2.54" y="-12.7" length="middle"/>
</symbol>
<symbol name="SWITCH_MANUAL">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="0" y2="2.54" width="0.254" layer="94"/>
<wire x1="0" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="0" y1="2.54" x2="0" y2="7.62" width="0.254" layer="94"/>
<circle x="0" y="7.62" radius="0.567959375" width="0.254" layer="94"/>
<pin name="1" x="-10.16" y="0" length="middle"/>
<pin name="2" x="10.16" y="0" length="middle" rot="R180"/>
</symbol>
<symbol name="AD8606_OPAMP">
<description>OPAMP AD8606ARMZ-REEL</description>
<pin name="OUTA" x="-15.24" y="2.54" length="middle"/>
<pin name="-INA" x="-15.24" y="0" length="middle"/>
<pin name="+INA" x="-15.24" y="-2.54" length="middle"/>
<pin name="V-" x="-15.24" y="-5.08" length="middle" direction="pwr"/>
<pin name="+INB" x="15.24" y="-5.08" length="middle" rot="R180"/>
<pin name="-INB" x="15.24" y="-2.54" length="middle" rot="R180"/>
<pin name="OUTB" x="15.24" y="0" length="middle" rot="R180"/>
<pin name="V+" x="15.24" y="2.54" length="middle" direction="pwr" rot="R180"/>
<wire x1="-10.16" y1="5.08" x2="-10.16" y2="-7.62" width="0.254" layer="94"/>
<wire x1="-10.16" y1="-7.62" x2="10.16" y2="-7.62" width="0.254" layer="94"/>
<wire x1="10.16" y1="-7.62" x2="10.16" y2="5.08" width="0.254" layer="94"/>
<wire x1="10.16" y1="5.08" x2="-10.16" y2="5.08" width="0.254" layer="94"/>
</symbol>
<symbol name="0402_CAP">
<pin name="1" x="-15.24" y="0" length="middle"/>
<pin name="2" x="12.7" y="0" length="middle" rot="R180"/>
<wire x1="-10.16" y1="2.54" x2="7.62" y2="2.54" width="0.254" layer="94"/>
<wire x1="7.62" y1="2.54" x2="7.62" y2="-2.54" width="0.254" layer="94"/>
<wire x1="7.62" y1="-2.54" x2="-10.16" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-10.16" y1="-2.54" x2="-10.16" y2="2.54" width="0.254" layer="94"/>
</symbol>
<symbol name="0402">
<description>Package / Case	0402 (1005 Metric)</description>
<pin name="1" x="-12.7" y="0" length="middle"/>
<pin name="2" x="15.24" y="0" length="middle" rot="R180"/>
<wire x1="-7.62" y1="2.54" x2="10.16" y2="2.54" width="0.254" layer="94"/>
<wire x1="10.16" y1="2.54" x2="10.16" y2="-2.54" width="0.254" layer="94"/>
<wire x1="10.16" y1="-2.54" x2="-7.62" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-7.62" y1="-2.54" x2="-7.62" y2="2.54" width="0.254" layer="94"/>
</symbol>
<symbol name="X32.768KHZ">
<description>X32.768kHz 9HT11-32.768KDZC-T</description>
<pin name="Q2" x="0" y="12.7" length="middle" rot="R270"/>
<pin name="Q1" x="0" y="-12.7" length="middle" rot="R90"/>
<wire x1="-7.62" y1="7.62" x2="7.62" y2="7.62" width="0.254" layer="94"/>
<wire x1="7.62" y1="7.62" x2="7.62" y2="-7.62" width="0.254" layer="94"/>
<wire x1="7.62" y1="-7.62" x2="-7.62" y2="-7.62" width="0.254" layer="94"/>
<wire x1="-7.62" y1="-7.62" x2="-7.62" y2="7.62" width="0.254" layer="94"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="CC2533">
<gates>
<gate name="G$1" symbol="CC2533" x="0" y="0"/>
</gates>
<devices>
<device name="" package="CC2533">
<connects>
<connect gate="G$1" pin="AVDD1" pad="AVDD1"/>
<connect gate="G$1" pin="AVDD2" pad="AVDD2"/>
<connect gate="G$1" pin="AVDD3" pad="AVDD3"/>
<connect gate="G$1" pin="AVDD4" pad="AVDD4"/>
<connect gate="G$1" pin="AVDD5" pad="AVDD5"/>
<connect gate="G$1" pin="AVDD6" pad="AVDD6"/>
<connect gate="G$1" pin="DCOUPL" pad="DCOUPL"/>
<connect gate="G$1" pin="DVDD1" pad="DVDD1"/>
<connect gate="G$1" pin="DVDD2" pad="DVDD2"/>
<connect gate="G$1" pin="GND0" pad="GND0"/>
<connect gate="G$1" pin="NC1" pad="NC1"/>
<connect gate="G$1" pin="NC2" pad="NC2"/>
<connect gate="G$1" pin="P0_0" pad="P0_0"/>
<connect gate="G$1" pin="P0_1" pad="P0_1"/>
<connect gate="G$1" pin="P0_2" pad="P0_2"/>
<connect gate="G$1" pin="P0_3" pad="P0_3"/>
<connect gate="G$1" pin="P0_4" pad="P0_4"/>
<connect gate="G$1" pin="P0_5" pad="P0_5"/>
<connect gate="G$1" pin="P0_6" pad="P0_6"/>
<connect gate="G$1" pin="P0_7" pad="P0_7"/>
<connect gate="G$1" pin="P1_0" pad="P1_0"/>
<connect gate="G$1" pin="P1_1" pad="P1_1"/>
<connect gate="G$1" pin="P1_2" pad="P1_2"/>
<connect gate="G$1" pin="P1_3" pad="P1_3"/>
<connect gate="G$1" pin="P1_4" pad="P1_4"/>
<connect gate="G$1" pin="P1_5" pad="P1_5"/>
<connect gate="G$1" pin="P1_6" pad="P1_6"/>
<connect gate="G$1" pin="P1_7" pad="P1_7"/>
<connect gate="G$1" pin="P2_0" pad="P2_0"/>
<connect gate="G$1" pin="P2_1" pad="P2_1"/>
<connect gate="G$1" pin="P2_2" pad="P2_2"/>
<connect gate="G$1" pin="P2_3/XOSC32K_Q2" pad="P2_3/XOSC32K_Q2"/>
<connect gate="G$1" pin="P2_4/XOSC32K_Q1" pad="P2_4/XOSC32K_Q1"/>
<connect gate="G$1" pin="RBIAS" pad="RBIAS"/>
<connect gate="G$1" pin="RESET_N" pad="RESET_N"/>
<connect gate="G$1" pin="RF_N" pad="RF_N"/>
<connect gate="G$1" pin="RF_P" pad="RF_P"/>
<connect gate="G$1" pin="SCL" pad="SCL"/>
<connect gate="G$1" pin="SDA" pad="SDA"/>
<connect gate="G$1" pin="XOSC_Q1" pad="XOSC_Q1"/>
<connect gate="G$1" pin="XOSC_Q2" pad="XOSC_Q2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="BALUN">
<description>2.45 GHz Impedance Matched Balun-BPF: For TI CC253X, CC254X, CC257X, 
CC853X and CC852X Chipset family
P/N 2450BM15A0002</description>
<gates>
<gate name="G$1" symbol="BALUN" x="0" y="0"/>
</gates>
<devices>
<device name="" package="BALUN">
<connects>
<connect gate="G$1" pin="BALANCED3" pad="BALANCED3"/>
<connect gate="G$1" pin="BALANCED4" pad="BALANCED4"/>
<connect gate="G$1" pin="GND2" pad="GND2"/>
<connect gate="G$1" pin="GND5" pad="GND5"/>
<connect gate="G$1" pin="GND6" pad="GND6"/>
<connect gate="G$1" pin="UNBALANCED" pad="UNBALANCED"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="X32MHZ">
<description>X32MHz ABM12-32.000MHZ-B2X-T3</description>
<gates>
<gate name="G$1" symbol="X32MHZ" x="10.16" y="2.54"/>
</gates>
<devices>
<device name="" package="X32MHZ">
<connects>
<connect gate="G$1" pin="Q1" pad="Q1"/>
<connect gate="G$1" pin="Q2" pad="Q2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="0201">
<description>Package / Case	0201 (0603 Metric)</description>
<gates>
<gate name="G$1" symbol="0201" x="5.08" y="-2.54"/>
</gates>
<devices>
<device name="" package="0201">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="ANTENNA_BOTTOM">
<description>Antenna for use in bottom layer of CC2530 PCB</description>
<gates>
<gate name="G$1" symbol="ANTENNA_BOTTOM" x="0" y="0"/>
</gates>
<devices>
<device name="" package="ANTENNA_BOTTOM">
<connects>
<connect gate="G$1" pin="A" pad="A"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="REGULATOR">
<description>IC REG LDO 3V 50MA SOT23-5
TPS76030DBVT</description>
<gates>
<gate name="G$1" symbol="REGULATOR" x="0" y="0"/>
</gates>
<devices>
<device name="" package="REGULATOR">
<connects>
<connect gate="G$1" pin="1_IN" pad="1"/>
<connect gate="G$1" pin="2_GND" pad="2"/>
<connect gate="G$1" pin="3_EN" pad="3"/>
<connect gate="G$1" pin="4_NC" pad="4"/>
<connect gate="G$1" pin="5_OUT" pad="5"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="0603">
<description>Package / Case	0603 (1608 Metric)</description>
<gates>
<gate name="G$1" symbol="0603" x="0" y="0"/>
</gates>
<devices>
<device name="" package="0603">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="FFC4POS">
<description>FFC COnnector 4POS</description>
<gates>
<gate name="G$1" symbol="FFC4POS" x="10.16" y="-10.16"/>
</gates>
<devices>
<device name="" package="FFC4POS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
<connect gate="G$1" pin="3" pad="3"/>
<connect gate="G$1" pin="4" pad="4"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="SPDT_DUAL">
<description>TS3A24159DGSR
IC SWITCH DUAL SPDT 10MSOP</description>
<gates>
<gate name="G$1" symbol="SPDT_DUAL" x="0" y="0"/>
</gates>
<devices>
<device name="" package="SPDT_DUAL">
<connects>
<connect gate="G$1" pin="COM1" pad="COM1"/>
<connect gate="G$1" pin="COM2" pad="COM2"/>
<connect gate="G$1" pin="GND" pad="GND"/>
<connect gate="G$1" pin="IN1" pad="IN1"/>
<connect gate="G$1" pin="IN2" pad="IN2"/>
<connect gate="G$1" pin="NC1" pad="NC1"/>
<connect gate="G$1" pin="NC2" pad="NC2"/>
<connect gate="G$1" pin="NO1" pad="NO1"/>
<connect gate="G$1" pin="NO2" pad="NO2"/>
<connect gate="G$1" pin="V+" pad="V+"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="AD5933">
<description>AD5933</description>
<gates>
<gate name="G$1" symbol="AD5933" x="0" y="0"/>
</gates>
<devices>
<device name="" package="AD5933">
<connects>
<connect gate="G$1" pin="AGND1" pad="AGND1"/>
<connect gate="G$1" pin="AGND2" pad="AGND2"/>
<connect gate="G$1" pin="AVDD1" pad="AVDD1"/>
<connect gate="G$1" pin="AVDD2" pad="AVDD2"/>
<connect gate="G$1" pin="DGND" pad="DGND"/>
<connect gate="G$1" pin="DVDD" pad="DVDD"/>
<connect gate="G$1" pin="MCLK" pad="MCLK"/>
<connect gate="G$1" pin="NC1" pad="NC1"/>
<connect gate="G$1" pin="NC2" pad="NC2"/>
<connect gate="G$1" pin="NC3" pad="NC3"/>
<connect gate="G$1" pin="NC7" pad="NC7"/>
<connect gate="G$1" pin="RFB" pad="RFB"/>
<connect gate="G$1" pin="SCL" pad="SCL"/>
<connect gate="G$1" pin="SDA" pad="SDA"/>
<connect gate="G$1" pin="VIN" pad="VIN"/>
<connect gate="G$1" pin="VOUT" pad="VOUT"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="FFC6POS">
<description>FFC Connector 6POS</description>
<gates>
<gate name="G$1" symbol="FFC6POS" x="7.62" y="-10.16"/>
</gates>
<devices>
<device name="" package="FFC6POS">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
<connect gate="G$1" pin="3" pad="3"/>
<connect gate="G$1" pin="4" pad="4"/>
<connect gate="G$1" pin="5" pad="5"/>
<connect gate="G$1" pin="6" pad="6"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="SWITCH_MANUAL">
<gates>
<gate name="G$1" symbol="SWITCH_MANUAL" x="0" y="0"/>
</gates>
<devices>
<device name="" package="SWITCH_MANUAL">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="AD8606_OPAMP">
<description>OPAMP AD8606ARMZ-REEL</description>
<gates>
<gate name="G$1" symbol="AD8606_OPAMP" x="0" y="0"/>
</gates>
<devices>
<device name="" package="AD8606_OPAMP">
<connects>
<connect gate="G$1" pin="+INA" pad="+INA"/>
<connect gate="G$1" pin="+INB" pad="+INB"/>
<connect gate="G$1" pin="-INA" pad="-INA"/>
<connect gate="G$1" pin="-INB" pad="-INB"/>
<connect gate="G$1" pin="OUTA" pad="OUTA"/>
<connect gate="G$1" pin="OUTB" pad="OUTB"/>
<connect gate="G$1" pin="V+" pad="V+"/>
<connect gate="G$1" pin="V-" pad="V-"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="0603_RES">
<gates>
<gate name="G$1" symbol="0603" x="0" y="0"/>
</gates>
<devices>
<device name="" package="0603_RES">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="0402_CAP">
<gates>
<gate name="G$1" symbol="0402_CAP" x="2.54" y="0"/>
</gates>
<devices>
<device name="" package="0402_CAP">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="0402">
<description>Package / Case	0402 (1005 Metric)</description>
<gates>
<gate name="G$1" symbol="0402" x="0" y="0"/>
</gates>
<devices>
<device name="" package="0402">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="X32.768KHZ">
<description>X32.768kHz 9HT11-32.768KDZC-T</description>
<gates>
<gate name="G$1" symbol="X32.768KHZ" x="0" y="0"/>
</gates>
<devices>
<device name="" package="X32.768KHZ">
<connects>
<connect gate="G$1" pin="Q1" pad="Q1"/>
<connect gate="G$1" pin="Q2" pad="Q2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="U$1" library="CC2530_PCB_TL" deviceset="CC2533" device=""/>
<part name="U$2" library="CC2530_PCB_TL" deviceset="BALUN" device="">
<attribute name="BALUN" value=""/>
</part>
<part name="U$3" library="CC2530_PCB_TL" deviceset="X32MHZ" device="">
<attribute name="X" value="32MHz"/>
</part>
<part name="U$4" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="CAP" value="20pF"/>
</part>
<part name="U$5" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="CAP" value="20pF"/>
</part>
<part name="U$6" library="CC2530_PCB_TL" deviceset="ANTENNA_BOTTOM" device="">
<attribute name="IFA" value=""/>
</part>
<part name="U$9" library="CC2530_PCB_TL" deviceset="0201" device="" value="56k">
<attribute name="R_BIAS" value="56k"/>
</part>
<part name="U$10" library="CC2530_PCB_TL" deviceset="REGULATOR" device="">
<attribute name="TPS76030DBVT" value=""/>
</part>
<part name="U$11" library="CC2530_PCB_TL" deviceset="0603" device="">
<attribute name="CAP" value="+2.2uF-"/>
</part>
<part name="U$12" library="CC2530_PCB_TL" deviceset="0603" device="">
<attribute name="CAP" value="+1uF-"/>
</part>
<part name="U$14" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="CAP" value="0.47uF"/>
</part>
<part name="U$7" library="CC2530_PCB_TL" deviceset="FFC4POS" device=""/>
<part name="U$8" library="CC2530_PCB_TL" deviceset="FFC4POS" device=""/>
<part name="U$16" library="CC2530_PCB_TL" deviceset="AD5933" device="">
<attribute name="AD5933" value=""/>
</part>
<part name="U$17" library="CC2530_PCB_TL" deviceset="FFC6POS" device=""/>
<part name="U$18" library="CC2530_PCB_TL" deviceset="SWITCH_MANUAL" device=""/>
<part name="U$19" library="CC2530_PCB_TL" deviceset="SPDT_DUAL" device="">
<attribute name="SPDT-TS3A24159_AD" value=""/>
</part>
<part name="U$20" library="CC2530_PCB_TL" deviceset="AD8606_OPAMP" device="">
<attribute name="AD8606" value=""/>
</part>
<part name="U$21" library="CC2530_PCB_TL" deviceset="0603_RES" device="">
<attribute name="RES" value="20k"/>
</part>
<part name="U$22" library="CC2530_PCB_TL" deviceset="0603_RES" device="">
<attribute name="RES" value="20k"/>
</part>
<part name="U$23" library="CC2530_PCB_TL" deviceset="0603_RES" device="">
<attribute name="RFB" value=""/>
</part>
<part name="U$24" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="RES" value="49.9k"/>
</part>
<part name="U$25" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="RES" value="49.9k"/>
</part>
<part name="U$26" library="CC2530_PCB_TL" deviceset="0402_CAP" device="">
<attribute name="CAP" value="0.047uF"/>
</part>
<part name="U$27" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="RES" value="49.9k"/>
</part>
<part name="U$28" library="CC2530_PCB_TL" deviceset="0201" device="">
<attribute name="RES" value="49.9k"/>
</part>
<part name="U$30" library="CC2530_PCB_TL" deviceset="FFC6POS" device=""/>
<part name="U$29" library="CC2530_PCB_TL" deviceset="0603_RES" device="">
<attribute name="LED" value=""/>
</part>
<part name="U$31" library="CC2530_PCB_TL" deviceset="0402" device="">
<attribute name="RES" value="1k"/>
</part>
<part name="U$39" library="CC2530_PCB_TL" deviceset="X32.768KHZ" device=""/>
<part name="U$40" library="CC2530_PCB_TL" deviceset="0201" device=""/>
<part name="U$41" library="CC2530_PCB_TL" deviceset="0201" device=""/>
</parts>
<sheets>
<sheet>
<plain>
</plain>
<instances>
<instance part="U$1" gate="G$1" x="73.66" y="58.42"/>
<instance part="U$2" gate="G$1" x="218.44" y="55.88" rot="MR90">
<attribute name="BALUN" x="218.44" y="55.88" size="1.778" layer="96" rot="R90" display="name"/>
</instance>
<instance part="U$3" gate="G$1" x="121.92" y="38.1">
<attribute name="X" x="121.92" y="38.1" size="1.778" layer="96"/>
</instance>
<instance part="U$4" gate="G$1" x="144.78" y="25.4">
<attribute name="CAP" x="139.7" y="25.4" size="1.778" layer="96"/>
</instance>
<instance part="U$5" gate="G$1" x="144.78" y="50.8">
<attribute name="CAP" x="142.24" y="50.8" size="1.778" layer="96"/>
</instance>
<instance part="U$6" gate="G$1" x="238.76" y="33.02" rot="MR180">
<attribute name="IFA" x="238.76" y="33.02" size="1.778" layer="96" rot="MR180" display="name"/>
</instance>
<instance part="U$9" gate="G$1" x="127" y="68.58" smashed="yes">
<attribute name="R_BIAS" x="124.46" y="68.58" size="1.778" layer="96"/>
</instance>
<instance part="U$10" gate="G$1" x="127" y="-7.62" rot="R270">
<attribute name="TPS76030DBVT" x="116.84" y="-17.78" size="1.778" layer="96" display="name"/>
</instance>
<instance part="U$11" gate="G$1" x="124.46" y="5.08">
<attribute name="CAP" x="124.46" y="5.08" size="1.778" layer="96"/>
</instance>
<instance part="U$12" gate="G$1" x="152.4" y="-17.78">
<attribute name="CAP" x="152.4" y="-17.78" size="1.778" layer="96"/>
</instance>
<instance part="U$14" gate="G$1" x="43.18" y="81.28" rot="R180">
<attribute name="CAP" x="43.18" y="81.28" size="1.778" layer="96" rot="R180"/>
</instance>
<instance part="U$7" gate="G$1" x="180.34" y="0" rot="R180"/>
<instance part="U$8" gate="G$1" x="180.34" y="76.2" rot="R180"/>
<instance part="U$16" gate="G$1" x="-78.74" y="83.82">
<attribute name="AD5933" x="-83.82" y="93.98" size="1.778" layer="96" display="name"/>
</instance>
<instance part="U$17" gate="G$1" x="78.74" y="129.54" rot="R90"/>
<instance part="U$18" gate="G$1" x="109.22" y="15.24" rot="R90"/>
<instance part="U$19" gate="G$1" x="-124.46" y="10.16">
<attribute name="SPDT-TS3A24159_AD" x="-134.62" y="17.78" size="1.778" layer="96" display="name"/>
</instance>
<instance part="U$20" gate="G$1" x="-121.92" y="55.88">
<attribute name="AD8606" x="-127" y="60.96" size="1.778" layer="96" display="name"/>
</instance>
<instance part="U$21" gate="G$1" x="-111.76" y="83.82" rot="R180">
<attribute name="RES" x="-111.76" y="83.82" size="1.778" layer="96" rot="R180"/>
</instance>
<instance part="U$22" gate="G$1" x="-142.24" y="83.82" rot="R180">
<attribute name="RES" x="-142.24" y="83.82" size="1.778" layer="96" rot="R180"/>
</instance>
<instance part="U$23" gate="G$1" x="-162.56" y="68.58" rot="R90">
<attribute name="RFB" x="-162.56" y="68.58" size="1.778" layer="96" rot="R90" display="name"/>
</instance>
<instance part="U$24" gate="G$1" x="-172.72" y="53.34">
<attribute name="RES" x="-172.72" y="53.34" size="1.778" layer="96"/>
</instance>
<instance part="U$25" gate="G$1" x="-160.02" y="40.64" rot="R90">
<attribute name="RES" x="-160.02" y="40.64" size="1.778" layer="96" rot="R90"/>
</instance>
<instance part="U$26" gate="G$1" x="-81.28" y="50.8" rot="R180">
<attribute name="CAP" x="-81.28" y="50.8" size="1.778" layer="96" rot="R180"/>
</instance>
<instance part="U$27" gate="G$1" x="-78.74" y="58.42">
<attribute name="RES" x="-78.74" y="58.42" size="1.778" layer="96"/>
</instance>
<instance part="U$28" gate="G$1" x="-78.74" y="43.18">
<attribute name="RES" x="-78.74" y="43.18" size="1.778" layer="96"/>
</instance>
<instance part="U$30" gate="G$1" x="-10.16" y="-33.02" rot="R270"/>
<instance part="U$29" gate="G$1" x="-2.54" y="58.42" rot="R180">
<attribute name="LED" x="-2.54" y="58.42" size="1.778" layer="96" rot="R180" display="name"/>
</instance>
<instance part="U$31" gate="G$1" x="-5.08" y="71.12">
<attribute name="RES" x="-5.08" y="71.12" size="1.778" layer="96"/>
</instance>
<instance part="U$39" gate="G$1" x="106.68" y="106.68"/>
<instance part="U$40" gate="G$1" x="124.46" y="119.38"/>
<instance part="U$41" gate="G$1" x="124.46" y="93.98"/>
</instances>
<busses>
</busses>
<nets>
<net name="N$3" class="0">
<segment>
<pinref part="U$6" gate="G$1" pin="A"/>
<pinref part="U$2" gate="G$1" pin="UNBALANCED"/>
<wire x1="233.68" y1="33.02" x2="223.52" y2="33.02" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$4" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="XOSC_Q2"/>
<pinref part="U$3" gate="G$1" pin="Q2"/>
<wire x1="104.14" y1="50.8" x2="116.84" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$5" gate="G$1" pin="1"/>
<wire x1="129.54" y1="50.8" x2="116.84" y2="50.8" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$5" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="XOSC_Q1"/>
<wire x1="104.14" y1="48.26" x2="111.76" y2="48.26" width="0.1524" layer="91"/>
<wire x1="111.76" y1="48.26" x2="111.76" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$3" gate="G$1" pin="Q1"/>
<pinref part="U$4" gate="G$1" pin="1"/>
<wire x1="129.54" y1="25.4" x2="127" y2="25.4" width="0.1524" layer="91"/>
<wire x1="111.76" y1="25.4" x2="127" y2="25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="VDD" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="AVDD4"/>
<pinref part="U$1" gate="G$1" pin="AVDD1"/>
<wire x1="104.14" y1="66.04" x2="104.14" y2="63.5" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="AVDD2"/>
<wire x1="104.14" y1="63.5" x2="104.14" y2="60.96" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="AVDD6"/>
<wire x1="86.36" y1="81.28" x2="109.22" y2="81.28" width="0.1524" layer="91"/>
<wire x1="109.22" y1="81.28" x2="109.22" y2="66.04" width="0.1524" layer="91"/>
<wire x1="109.22" y1="66.04" x2="104.14" y2="66.04" width="0.1524" layer="91"/>
<wire x1="109.22" y1="60.96" x2="104.14" y2="60.96" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="AVDD5"/>
<wire x1="109.22" y1="45.72" x2="104.14" y2="45.72" width="0.1524" layer="91"/>
<wire x1="109.22" y1="60.96" x2="109.22" y2="53.34" width="0.1524" layer="91"/>
<pinref part="U$18" gate="G$1" pin="2"/>
<wire x1="109.22" y1="53.34" x2="109.22" y2="45.72" width="0.1524" layer="91"/>
<wire x1="109.22" y1="25.4" x2="109.22" y2="45.72" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="AVDD3"/>
<wire x1="104.14" y1="53.34" x2="109.22" y2="53.34" width="0.1524" layer="91"/>
<wire x1="66.04" y1="91.44" x2="86.36" y2="91.44" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="DVDD1"/>
<wire x1="66.04" y1="81.28" x2="66.04" y2="91.44" width="0.1524" layer="91"/>
<wire x1="86.36" y1="91.44" x2="86.36" y2="81.28" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$1" gate="G$1" pin="DVDD2"/>
<wire x1="45.72" y1="45.72" x2="40.64" y2="45.72" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$16" gate="G$1" pin="AVDD2"/>
<pinref part="U$16" gate="G$1" pin="AVDD1"/>
<wire x1="-63.5" y1="78.74" x2="-63.5" y2="76.2" width="0.1524" layer="91"/>
<pinref part="U$16" gate="G$1" pin="DVDD"/>
<wire x1="-63.5" y1="76.2" x2="-63.5" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$27" gate="G$1" pin="2"/>
<wire x1="-66.04" y1="58.42" x2="-63.5" y2="58.42" width="0.1524" layer="91"/>
<wire x1="-63.5" y1="58.42" x2="-63.5" y2="73.66" width="0.1524" layer="91"/>
<wire x1="-63.5" y1="78.74" x2="-50.8" y2="78.74" width="0.1524" layer="91"/>
<wire x1="-50.8" y1="78.74" x2="-50.8" y2="83.82" width="0.1524" layer="91"/>
<wire x1="-50.8" y1="83.82" x2="-48.26" y2="81.28" width="0.1524" layer="91"/>
<wire x1="-50.8" y1="83.82" x2="-53.34" y2="81.28" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$24" gate="G$1" pin="1"/>
<wire x1="-187.96" y1="58.42" x2="-187.96" y2="53.34" width="0.1524" layer="91"/>
<wire x1="-185.42" y1="55.88" x2="-187.96" y2="58.42" width="0.1524" layer="91"/>
<wire x1="-187.96" y1="58.42" x2="-190.5" y2="55.88" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$20" gate="G$1" pin="V+"/>
<wire x1="-106.68" y1="58.42" x2="-106.68" y2="63.5" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$19" gate="G$1" pin="V+"/>
<wire x1="-139.7" y1="15.24" x2="-139.7" y2="20.32" width="0.1524" layer="91"/>
<wire x1="-137.16" y1="17.78" x2="-139.7" y2="20.32" width="0.1524" layer="91"/>
<wire x1="-139.7" y1="20.32" x2="-142.24" y2="17.78" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$17" gate="G$1" pin="1"/>
<wire x1="91.44" y1="127" x2="91.44" y2="124.46" width="0.1524" layer="91"/>
<wire x1="91.44" y1="124.46" x2="96.52" y2="124.46" width="0.1524" layer="91"/>
<wire x1="96.52" y1="124.46" x2="96.52" y2="129.54" width="0.1524" layer="91"/>
<wire x1="99.06" y1="127" x2="96.52" y2="129.54" width="0.1524" layer="91"/>
<wire x1="96.52" y1="129.54" x2="93.98" y2="127" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$12" class="0">
<segment>
<pinref part="U$9" gate="G$1" pin="1"/>
<pinref part="U$1" gate="G$1" pin="RBIAS"/>
<wire x1="111.76" y1="68.58" x2="104.14" y2="68.58" width="0.1524" layer="91"/>
</segment>
</net>
<net name="GND" class="0">
<segment>
<wire x1="167.64" y1="5.08" x2="167.64" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$11" gate="G$1" pin="2"/>
<wire x1="139.7" y1="5.08" x2="167.64" y2="5.08" width="0.1524" layer="91"/>
<pinref part="U$4" gate="G$1" pin="2"/>
<wire x1="157.48" y1="25.4" x2="167.64" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$5" gate="G$1" pin="2"/>
<wire x1="157.48" y1="50.8" x2="167.64" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$12" gate="G$1" pin="2"/>
<wire x1="167.64" y1="25.4" x2="167.64" y2="50.8" width="0.1524" layer="91"/>
<wire x1="167.64" y1="-7.62" x2="167.64" y2="-17.78" width="0.1524" layer="91"/>
<pinref part="U$10" gate="G$1" pin="2_GND"/>
<wire x1="142.24" y1="-7.62" x2="167.64" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="167.64" y1="5.08" x2="167.64" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="177.8" y1="66.04" x2="180.34" y2="66.04" width="0.1524" layer="91"/>
<wire x1="177.8" y1="66.04" x2="175.26" y2="66.04" width="0.1524" layer="91"/>
<pinref part="U$9" gate="G$1" pin="2"/>
<wire x1="139.7" y1="68.58" x2="167.64" y2="68.58" width="0.1524" layer="91"/>
<pinref part="U$8" gate="G$1" pin="1"/>
<junction x="177.8" y="68.58"/>
<wire x1="167.64" y1="68.58" x2="177.8" y2="68.58" width="0.1524" layer="91"/>
<wire x1="177.8" y1="68.58" x2="177.8" y2="66.04" width="0.1524" layer="91"/>
<wire x1="177.8" y1="73.66" x2="177.8" y2="68.58" width="0.1524" layer="91"/>
<pinref part="U$8" gate="G$1" pin="2"/>
<junction x="177.8" y="73.66"/>
<pinref part="U$8" gate="G$1" pin="4"/>
<wire x1="177.8" y1="83.82" x2="177.8" y2="78.74" width="0.1524" layer="91"/>
<wire x1="177.8" y1="78.74" x2="177.8" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$8" gate="G$1" pin="3"/>
<junction x="177.8" y="78.74"/>
<wire x1="167.64" y1="68.58" x2="167.64" y2="50.8" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$17" gate="G$1" pin="2"/>
<wire x1="86.36" y1="127" x2="86.36" y2="121.92" width="0.1524" layer="91"/>
<wire x1="86.36" y1="121.92" x2="88.9" y2="121.92" width="0.1524" layer="91"/>
<wire x1="86.36" y1="121.92" x2="83.82" y2="121.92" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$25" gate="G$1" pin="1"/>
<pinref part="U$20" gate="G$1" pin="V-"/>
<wire x1="-160.02" y1="25.4" x2="-137.16" y2="25.4" width="0.1524" layer="91"/>
<wire x1="-137.16" y1="25.4" x2="-137.16" y2="50.8" width="0.1524" layer="91"/>
<wire x1="-160.02" y1="25.4" x2="-160.02" y2="22.86" width="0.1524" layer="91"/>
<wire x1="-160.02" y1="22.86" x2="-157.48" y2="22.86" width="0.1524" layer="91"/>
<wire x1="-160.02" y1="22.86" x2="-162.56" y2="22.86" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$28" gate="G$1" pin="2"/>
<wire x1="-66.04" y1="43.18" x2="-66.04" y2="38.1" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$16" gate="G$1" pin="AGND2"/>
<pinref part="U$16" gate="G$1" pin="AGND1"/>
<wire x1="-63.5" y1="86.36" x2="-63.5" y2="83.82" width="0.1524" layer="91"/>
<pinref part="U$16" gate="G$1" pin="DGND"/>
<wire x1="-63.5" y1="83.82" x2="-63.5" y2="81.28" width="0.1524" layer="91"/>
<wire x1="20.32" y1="101.6" x2="25.4" y2="101.6" width="0.1524" layer="91"/>
<pinref part="U$14" gate="G$1" pin="2"/>
<wire x1="25.4" y1="101.6" x2="30.48" y2="101.6" width="0.1524" layer="91"/>
<wire x1="30.48" y1="101.6" x2="35.56" y2="101.6" width="0.1524" layer="91"/>
<wire x1="30.48" y1="81.28" x2="30.48" y2="101.6" width="0.1524" layer="91"/>
<wire x1="-63.5" y1="86.36" x2="25.4" y2="86.36" width="0.1524" layer="91"/>
<wire x1="25.4" y1="86.36" x2="25.4" y2="101.6" width="0.1524" layer="91"/>
<wire x1="60.96" y1="58.42" x2="60.96" y2="73.66" width="0.1524" layer="91"/>
<wire x1="60.96" y1="73.66" x2="30.48" y2="73.66" width="0.1524" layer="91"/>
<wire x1="30.48" y1="73.66" x2="30.48" y2="81.28" width="0.1524" layer="91"/>
<wire x1="60.96" y1="53.34" x2="60.96" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="P1_3"/>
<wire x1="45.72" y1="53.34" x2="60.96" y2="53.34" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="GND0"/>
<wire x1="68.58" y1="58.42" x2="60.96" y2="58.42" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$30" gate="G$1" pin="3"/>
<pinref part="U$30" gate="G$1" pin="4"/>
<wire x1="-12.7" y1="-30.48" x2="-7.62" y2="-30.48" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$31" gate="G$1" pin="2"/>
<wire x1="10.16" y1="71.12" x2="10.16" y2="68.58" width="0.1524" layer="91"/>
<wire x1="10.16" y1="68.58" x2="7.62" y2="68.58" width="0.1524" layer="91"/>
<wire x1="12.7" y1="68.58" x2="10.16" y2="68.58" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$19" gate="G$1" pin="GND"/>
<wire x1="-109.22" y1="5.08" x2="-109.22" y2="2.54" width="0.1524" layer="91"/>
<wire x1="-109.22" y1="2.54" x2="-111.76" y2="2.54" width="0.1524" layer="91"/>
<wire x1="-109.22" y1="2.54" x2="-106.68" y2="2.54" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$40" gate="G$1" pin="2"/>
<pinref part="U$41" gate="G$1" pin="2"/>
<wire x1="137.16" y1="119.38" x2="137.16" y2="93.98" width="0.1524" layer="91"/>
<wire x1="137.16" y1="93.98" x2="137.16" y2="88.9" width="0.1524" layer="91"/>
<wire x1="137.16" y1="88.9" x2="134.62" y2="88.9" width="0.1524" layer="91"/>
<wire x1="137.16" y1="88.9" x2="139.7" y2="88.9" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$18" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="DCOUPL"/>
<pinref part="U$14" gate="G$1" pin="1"/>
<wire x1="63.5" y1="81.28" x2="58.42" y2="81.28" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$13" class="0">
<segment>
<pinref part="U$16" gate="G$1" pin="SCL"/>
<wire x1="-63.5" y1="91.44" x2="22.86" y2="91.44" width="0.1524" layer="91"/>
<wire x1="22.86" y1="91.44" x2="22.86" y2="66.04" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="SCL"/>
<wire x1="22.86" y1="66.04" x2="45.72" y2="66.04" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$14" class="0">
<segment>
<pinref part="U$16" gate="G$1" pin="SDA"/>
<wire x1="-63.5" y1="88.9" x2="20.32" y2="88.9" width="0.1524" layer="91"/>
<wire x1="20.32" y1="88.9" x2="20.32" y2="63.5" width="0.1524" layer="91"/>
<pinref part="U$1" gate="G$1" pin="SDA"/>
<wire x1="20.32" y1="63.5" x2="45.72" y2="63.5" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$17" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P2_1"/>
<wire x1="76.2" y1="81.28" x2="76.2" y2="121.92" width="0.1524" layer="91"/>
<pinref part="U$17" gate="G$1" pin="5"/>
<wire x1="76.2" y1="121.92" x2="71.12" y2="121.92" width="0.1524" layer="91"/>
<wire x1="71.12" y1="121.92" x2="71.12" y2="127" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$20" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P2_2"/>
<wire x1="78.74" y1="81.28" x2="78.74" y2="119.38" width="0.1524" layer="91"/>
<pinref part="U$17" gate="G$1" pin="6"/>
<wire x1="78.74" y1="119.38" x2="66.04" y2="119.38" width="0.1524" layer="91"/>
<wire x1="66.04" y1="119.38" x2="66.04" y2="127" width="0.1524" layer="91"/>
</segment>
</net>
<net name="RESET" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="RESET_N"/>
<wire x1="86.36" y1="33.02" x2="86.36" y2="30.48" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$17" gate="G$1" pin="3"/>
<wire x1="81.28" y1="127" x2="81.28" y2="124.46" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$21" class="0">
<segment>
<pinref part="U$10" gate="G$1" pin="5_OUT"/>
<wire x1="111.76" y1="-12.7" x2="109.22" y2="-12.7" width="0.1524" layer="91"/>
<pinref part="U$18" gate="G$1" pin="1"/>
<wire x1="109.22" y1="5.08" x2="109.22" y2="-12.7" width="0.1524" layer="91"/>
<pinref part="U$11" gate="G$1" pin="1"/>
<wire x1="109.22" y1="5.08" x2="111.76" y2="5.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$25" class="0">
<segment>
<pinref part="U$22" gate="G$1" pin="2"/>
<wire x1="-157.48" y1="83.82" x2="-157.48" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$20" gate="G$1" pin="OUTA"/>
<pinref part="U$23" gate="G$1" pin="2"/>
<wire x1="-157.48" y1="58.42" x2="-137.16" y2="58.42" width="0.1524" layer="91"/>
<wire x1="-162.56" y1="83.82" x2="-157.48" y2="83.82" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$27" class="0">
<segment>
<pinref part="U$24" gate="G$1" pin="2"/>
<pinref part="U$25" gate="G$1" pin="2"/>
<pinref part="U$20" gate="G$1" pin="+INA"/>
<wire x1="-160.02" y1="53.34" x2="-137.16" y2="53.34" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$28" class="0">
<segment>
<pinref part="U$28" gate="G$1" pin="1"/>
<pinref part="U$26" gate="G$1" pin="2"/>
<wire x1="-93.98" y1="43.18" x2="-93.98" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$27" gate="G$1" pin="1"/>
<wire x1="-93.98" y1="50.8" x2="-93.98" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$20" gate="G$1" pin="+INB"/>
<wire x1="-106.68" y1="50.8" x2="-93.98" y2="50.8" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$19" class="0">
<segment>
<pinref part="U$16" gate="G$1" pin="VOUT"/>
<wire x1="-93.98" y1="78.74" x2="-99.06" y2="78.74" width="0.1524" layer="91"/>
<wire x1="-99.06" y1="78.74" x2="-99.06" y2="66.04" width="0.1524" layer="91"/>
<wire x1="-99.06" y1="66.04" x2="-60.96" y2="66.04" width="0.1524" layer="91"/>
<wire x1="-60.96" y1="66.04" x2="-60.96" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$26" gate="G$1" pin="1"/>
<wire x1="-60.96" y1="50.8" x2="-66.04" y2="50.8" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$29" class="0">
<segment>
<pinref part="U$20" gate="G$1" pin="OUTB"/>
<pinref part="U$20" gate="G$1" pin="-INB"/>
<wire x1="-106.68" y1="55.88" x2="-106.68" y2="53.34" width="0.1524" layer="91"/>
<wire x1="-106.68" y1="53.34" x2="-106.68" y2="12.7" width="0.1524" layer="91"/>
<pinref part="U$19" gate="G$1" pin="COM2"/>
<wire x1="-106.68" y1="12.7" x2="-109.22" y2="12.7" width="0.1524" layer="91"/>
</segment>
</net>
<net name="P0_1" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P0_1"/>
<wire x1="81.28" y1="33.02" x2="81.28" y2="27.94" width="0.1524" layer="91"/>
</segment>
</net>
<net name="P0_3" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P0_3"/>
<wire x1="76.2" y1="33.02" x2="76.2" y2="27.94" width="0.1524" layer="91"/>
</segment>
</net>
<net name="RIGHT" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P1_2"/>
<wire x1="45.72" y1="50.8" x2="27.94" y2="50.8" width="0.1524" layer="91"/>
<wire x1="27.94" y1="50.8" x2="30.48" y2="53.34" width="0.1524" layer="91"/>
</segment>
</net>
<net name="LEFT" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P1_4"/>
<wire x1="45.72" y1="55.88" x2="27.94" y2="55.88" width="0.1524" layer="91"/>
<wire x1="27.94" y1="55.88" x2="25.4" y2="53.34" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$34" class="0">
<segment>
<pinref part="U$31" gate="G$1" pin="1"/>
<pinref part="U$29" gate="G$1" pin="2"/>
<wire x1="-17.78" y1="71.12" x2="-17.78" y2="58.42" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$36" class="0">
<segment>
<wire x1="-68.58" y1="38.1" x2="-63.5" y2="38.1" width="0.1524" layer="91"/>
</segment>
</net>
<net name="V+" class="0">
<segment>
<pinref part="U$10" gate="G$1" pin="3_EN"/>
<wire x1="142.24" y1="-2.54" x2="147.32" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="147.32" y1="-2.54" x2="147.32" y2="-12.7" width="0.1524" layer="91"/>
<pinref part="U$10" gate="G$1" pin="1_IN"/>
<wire x1="147.32" y1="-12.7" x2="142.24" y2="-12.7" width="0.1524" layer="91"/>
<pinref part="U$7" gate="G$1" pin="4"/>
<wire x1="177.8" y1="2.54" x2="177.8" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$7" gate="G$1" pin="3"/>
<junction x="177.8" y="2.54"/>
<wire x1="177.8" y1="-2.54" x2="177.8" y2="2.54" width="0.1524" layer="91"/>
<pinref part="U$7" gate="G$1" pin="2"/>
<junction x="177.8" y="-2.54"/>
<wire x1="177.8" y1="-7.62" x2="177.8" y2="-2.54" width="0.1524" layer="91"/>
<pinref part="U$7" gate="G$1" pin="1"/>
<wire x1="147.32" y1="-2.54" x2="177.8" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="177.8" y1="7.62" x2="177.8" y2="12.7" width="0.1524" layer="91"/>
<wire x1="177.8" y1="12.7" x2="177.8" y2="15.24" width="0.1524" layer="91"/>
<wire x1="180.34" y1="12.7" x2="177.8" y2="12.7" width="0.1524" layer="91"/>
<junction x="177.8" y="12.7"/>
<wire x1="177.8" y1="12.7" x2="175.26" y2="12.7" width="0.1524" layer="91"/>
<pinref part="U$12" gate="G$1" pin="1"/>
<wire x1="139.7" y1="-17.78" x2="139.7" y2="-15.24" width="0.1524" layer="91"/>
<wire x1="139.7" y1="-15.24" x2="142.24" y2="-15.24" width="0.1524" layer="91"/>
<wire x1="142.24" y1="-15.24" x2="142.24" y2="-12.7" width="0.1524" layer="91"/>
</segment>
</net>
<net name="IN2" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P1_6"/>
<wire x1="68.58" y1="81.28" x2="68.58" y2="96.52" width="0.1524" layer="91"/>
<wire x1="68.58" y1="96.52" x2="55.88" y2="96.52" width="0.1524" layer="91"/>
<wire x1="55.88" y1="96.52" x2="55.88" y2="99.06" width="0.1524" layer="91"/>
<wire x1="55.88" y1="99.06" x2="50.8" y2="99.06" width="0.1524" layer="91"/>
<wire x1="50.8" y1="99.06" x2="50.8" y2="93.98" width="0.1524" layer="91"/>
<wire x1="50.8" y1="93.98" x2="55.88" y2="93.98" width="0.1524" layer="91"/>
<wire x1="55.88" y1="93.98" x2="55.88" y2="96.52" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="U$19" gate="G$1" pin="IN2"/>
<wire x1="-109.22" y1="10.16" x2="-101.6" y2="10.16" width="0.1524" layer="91"/>
<wire x1="-101.6" y1="10.16" x2="-101.6" y2="-5.08" width="0.1524" layer="91"/>
<wire x1="-101.6" y1="-5.08" x2="-144.78" y2="-5.08" width="0.1524" layer="91"/>
<wire x1="-144.78" y1="-5.08" x2="-144.78" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$19" gate="G$1" pin="IN1"/>
<wire x1="-144.78" y1="7.62" x2="-139.7" y2="7.62" width="0.1524" layer="91"/>
<wire x1="-144.78" y1="-5.08" x2="-144.78" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="-144.78" y1="-7.62" x2="-142.24" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="-142.24" y1="-7.62" x2="-142.24" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="-142.24" y1="-12.7" x2="-147.32" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="-147.32" y1="-12.7" x2="-147.32" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="-147.32" y1="-7.62" x2="-144.78" y2="-7.62" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$6" class="0">
<segment>
<pinref part="U$21" gate="G$1" pin="1"/>
<pinref part="U$16" gate="G$1" pin="RFB"/>
<wire x1="-93.98" y1="83.82" x2="-99.06" y2="83.82" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$23" class="0">
<segment>
<pinref part="U$16" gate="G$1" pin="VIN"/>
<wire x1="-93.98" y1="81.28" x2="-127" y2="81.28" width="0.1524" layer="91"/>
<pinref part="U$22" gate="G$1" pin="1"/>
<pinref part="U$21" gate="G$1" pin="2"/>
<wire x1="-129.54" y1="83.82" x2="-127" y2="83.82" width="0.1524" layer="91"/>
<wire x1="-127" y1="81.28" x2="-127" y2="83.82" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$1" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="RF_N"/>
<wire x1="104.14" y1="58.42" x2="198.12" y2="58.42" width="0.1524" layer="91"/>
<wire x1="198.12" y1="58.42" x2="198.12" y2="78.74" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="BALANCED4"/>
<wire x1="198.12" y1="78.74" x2="213.36" y2="78.74" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$2" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="RF_P"/>
<wire x1="104.14" y1="55.88" x2="198.12" y2="55.88" width="0.1524" layer="91"/>
<wire x1="198.12" y1="55.88" x2="198.12" y2="33.02" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="BALANCED3"/>
<wire x1="198.12" y1="33.02" x2="213.36" y2="33.02" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$16" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P2_4/XOSC32K_Q1"/>
<wire x1="83.82" y1="81.28" x2="83.82" y2="93.98" width="0.1524" layer="91"/>
<pinref part="U$39" gate="G$1" pin="Q1"/>
<wire x1="83.82" y1="93.98" x2="106.68" y2="93.98" width="0.1524" layer="91"/>
<pinref part="U$41" gate="G$1" pin="1"/>
<wire x1="109.22" y1="93.98" x2="106.68" y2="93.98" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$22" class="0">
<segment>
<pinref part="U$1" gate="G$1" pin="P2_3/XOSC32K_Q2"/>
<wire x1="81.28" y1="81.28" x2="81.28" y2="119.38" width="0.1524" layer="91"/>
<pinref part="U$39" gate="G$1" pin="Q2"/>
<wire x1="81.28" y1="119.38" x2="106.68" y2="119.38" width="0.1524" layer="91"/>
<pinref part="U$40" gate="G$1" pin="1"/>
<wire x1="109.22" y1="119.38" x2="106.68" y2="119.38" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$11" class="0">
<segment>
<pinref part="U$19" gate="G$1" pin="COM1"/>
<wire x1="-149.86" y1="10.16" x2="-139.7" y2="10.16" width="0.1524" layer="91"/>
<pinref part="U$23" gate="G$1" pin="1"/>
<pinref part="U$20" gate="G$1" pin="-INA"/>
<wire x1="-162.56" y1="55.88" x2="-149.86" y2="55.88" width="0.1524" layer="91"/>
<wire x1="-149.86" y1="55.88" x2="-137.16" y2="55.88" width="0.1524" layer="91"/>
<wire x1="-149.86" y1="10.16" x2="-149.86" y2="55.88" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$24" class="0">
<segment>
<pinref part="U$29" gate="G$1" pin="1"/>
<pinref part="U$1" gate="G$1" pin="P1_5"/>
<wire x1="10.16" y1="58.42" x2="45.72" y2="58.42" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$8" class="0">
<segment>
<wire x1="20.32" y1="12.7" x2="20.32" y2="-27.94" width="0.1524" layer="91"/>
<pinref part="U$30" gate="G$1" pin="5"/>
<wire x1="20.32" y1="-27.94" x2="-2.54" y2="-27.94" width="0.1524" layer="91"/>
<wire x1="-2.54" y1="-27.94" x2="-2.54" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="20.32" y1="12.7" x2="-78.74" y2="12.7" width="0.1524" layer="91"/>
<wire x1="-78.74" y1="12.7" x2="-78.74" y2="0" width="0.1524" layer="91"/>
<wire x1="-78.74" y1="0" x2="-139.7" y2="0" width="0.1524" layer="91"/>
<pinref part="U$19" gate="G$1" pin="NC1"/>
<wire x1="-139.7" y1="0" x2="-139.7" y2="5.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$7" class="0">
<segment>
<wire x1="-25.4" y1="-27.94" x2="-25.4" y2="27.94" width="0.1524" layer="91"/>
<pinref part="U$30" gate="G$1" pin="2"/>
<wire x1="-25.4" y1="-27.94" x2="-17.78" y2="-27.94" width="0.1524" layer="91"/>
<wire x1="-17.78" y1="-27.94" x2="-17.78" y2="-30.48" width="0.1524" layer="91"/>
<wire x1="-25.4" y1="27.94" x2="-86.36" y2="27.94" width="0.1524" layer="91"/>
<wire x1="-86.36" y1="27.94" x2="-86.36" y2="22.86" width="0.1524" layer="91"/>
<wire x1="-86.36" y1="22.86" x2="-147.32" y2="22.86" width="0.1524" layer="91"/>
<wire x1="-147.32" y1="22.86" x2="-147.32" y2="12.7" width="0.1524" layer="91"/>
<pinref part="U$19" gate="G$1" pin="NO1"/>
<wire x1="-147.32" y1="12.7" x2="-139.7" y2="12.7" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$10" class="0">
<segment>
<pinref part="U$19" gate="G$1" pin="NC2"/>
<wire x1="-109.22" y1="7.62" x2="10.16" y2="7.62" width="0.1524" layer="91"/>
<wire x1="10.16" y1="7.62" x2="10.16" y2="-30.48" width="0.1524" layer="91"/>
<pinref part="U$30" gate="G$1" pin="6"/>
<wire x1="10.16" y1="-30.48" x2="2.54" y2="-30.48" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$9" class="0">
<segment>
<pinref part="U$19" gate="G$1" pin="NO2"/>
<wire x1="-109.22" y1="15.24" x2="-68.58" y2="15.24" width="0.1524" layer="91"/>
<wire x1="-68.58" y1="15.24" x2="-68.58" y2="-7.62" width="0.1524" layer="91"/>
<wire x1="-68.58" y1="-7.62" x2="-22.86" y2="-7.62" width="0.1524" layer="91"/>
<pinref part="U$30" gate="G$1" pin="1"/>
<wire x1="-22.86" y1="-7.62" x2="-22.86" y2="-30.48" width="0.1524" layer="91"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
