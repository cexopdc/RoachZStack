
from pylab import *
from scipy import stats


""" Sample application demonstrating use of pyblehci to write/read from a serial device """

import sys
import time
import threading
from struct import unpack, pack
import code
import threading

from connection import TIConnection

Handle_StartSweep = '\x25\x00'
Handle_SweepDone = '\x2E\x00'
Handle_SweepDone_Notify = '\x2F\x00'

Handle_SweepData1 = '\x32\x00'
Handle_SweepData2 = '\x35\x00'


Handle_StartFreq = '\x38\x00'
Handle_IncFreq = '\x3E\x00'
Handle_Range = '\x41\x00'
Handle_Gain = '\x44\x00'
Handle_Electrodes = '\x47\x00'

Handle_Direction = '\x4B\x00'
Handle_Repeats = '\x4E\x00'
Handle_Duration = '\x51\x00'
Handle_Amplitude = '\x54\x00'
Handle_Voltage = '\x57\x00'
Handle_Voltage_Notify = '\x58\x00'

class Device:

	def __init__(self):
		self.data = ""
		self.gains = None
		self.success = False
	
	def processData(self, data):
		self.data += data
		
	def getData(self):
		dataList = [self.data[i:i+4] for i in range(0, len(self.data), 4)]
		floatList = [unpack("<l", x)[0] for x in dataList]
		reals = floatList[0:len(floatList)/2]
		imag = floatList[len(floatList)/2:]
		return np.vectorize(complex)(np.array(reals),np.array(imag))
		
device = Device()
cv = threading.Condition()
notify = threading.Condition()
serial_port = None
ble_parser = None
state = None
COM_port = "COM17"



def analyse_packet(packet_dictionary):
	packet, dictionary = packet_dictionary
	global device, cv, state
	#print("EVENT: Response received from the device")
	
	if state == STATE_RECEIVING:
		if dictionary["event"][1] == "ATT_ReadBlobRsp":
			if dictionary["status"][0] == "\x1a":
				cv.acquire()
				device.success = True
				cv.notify()
				cv.release()
				
			if dictionary["status"][0] == "\x00":
				device.processData(dictionary["value"][0])
				
	#print(dictionary["event"][1])

def doSweep(mode = '\x01'):
	global device, state, cv, notify
	device.data = ""
	
	print("Performing sweep.....................")
	print("%d Hz -> %d Hz (%d Hz step)" %(startFreq, 49 * incFreq + startFreq, incFreq))
	print("Range: " + ranges[outRange])
	print("Gain: " + gains[gain])

	notify.acquire()
	conn.GATT_WriteCharValue(handle=Handle_StartSweep, value=mode)
	
	notify.wait(15)
	if not state == STATE_RECEIVING:
		raise Exception("Did not get handle notification")
	notify.release()
	
	cv.acquire()
	device.success = False
	conn.GATT_ReadLongCharValue(handle=Handle_SweepData1, offset='\x00\x00')
	cv.wait(4)
	if not device.success:
		raise Exception("Did not receive data")
	cv.release()

	cv.acquire()
	device.success = False
	conn.GATT_ReadLongCharValue(handle=Handle_SweepData2, offset='\x00\x00')
	cv.wait(4)
	if not device.success:
		raise Exception("Did not receive data")
	cv.release()

	return device.getData()

OUTPUT_IMP = 1.0

def calibrate(calibration_impedance, repeats = 1, file_name = None):
	global device, state
		
	raw_data = []
	for i in range(0, repeats):
		raw_data.append(abs(np.array(doSweep('\x02'))))

	f_axis = arange(startFreq, startFreq+incFreq*50, incFreq)
	raw_avg = np.mean(raw_data, 0)
	gains = 1/((calibration_impedance+OUTPUT_IMP)*raw_avg)

	slope, intercept, r_value, p_value, std_err = stats.linregress(f_axis, gains)
	device.gains = slope * f_axis + intercept
	plot(f_axis, gains)
	plot(f_axis, device.gains)

	if not file_name is None:
		data = transpose(raw_data)
		savetxt(file_name, c_[f_axis, data, device.gains], delimiter=",")

def measure(showPlot=True, prefix=None):
	global device, state
	imps = 1.0/(np.array(doSweep('\x02')) * device.gains) - OUTPUT_IMP

	f_axis = arange(startFreq, startFreq+incFreq*50, incFreq)

	from time import gmtime, strftime
	stamp = strftime("%Y_%m_%d_%H_%M_%S", gmtime())

	if not prefix is None:
		savetxt("%s_%s.csv"% (prefix, stamp), transpose(asarray([f_axis, device.gains, np.abs(imps), np.angle(imps)])), delimiter=",")

	if(showPlot):
		figure(1)
		plot(f_axis, np.abs(imps))
		figure(2)
		plot(f_axis, np.angle(imps))
		show()

	return(f_axis, imps)

startFreq = 60000
def setStart(freq):
	if not 1000 <= freq <= 100000:
		raise Exception("Start freq not valid")
	global startFreq
	conn.GATT_WriteCharValue(handle=Handle_StartFreq, value=pack("<L", freq))
	startFreq = freq

incFreq = 100
def setInc(freq):
	global incFreq
	conn.GATT_WriteCharValue(handle=Handle_IncFreq, value=pack("<L", freq))
	incFreq = freq

RANGE_2000 = 0x0
RANGE_200 = 0x1
RANGE_400 = 0x2
RANGE_1000 = 0x3
ranges = ["2000 Vpp", "200 Vpp", "400 Vpp", "1000 Vpp"]
gains = ["X5", "X1"]
outRange = RANGE_2000
def setRange(val):
	global outRange
	if not 0 <= val <= 0x3:
		raise Exception("Range not valid")
	conn.GATT_WriteCharValue(handle=Handle_Range, value=pack("<B", val))
	outRange = val

GAIN_X1 = 1
GAIN_X5 = 0
gain = GAIN_X1
def setGain(val):
	if not 0 <= val <= 1:
		raise Exception("Gain not valid")
	global gain
	conn.GATT_WriteCharValue(handle=Handle_Gain, value=pack("<B", val))
	gain = val

electrodes = 0x0;
def setElectrodes(val):
	global electrodes
	conn.GATT_WriteCharValue(handle=Handle_Electrodes, value=pack("<B", val))
	electrodes = val

STATE_RECEIVING = 1
STATE_READY = 2

def data_ready(packet_dictionary):
	packet, dictionary = packet_dictionary
	global state
	notify.acquire()
	state = STATE_RECEIVING
	notify.notify()
	notify.release()

conn = None

def stimulate(direction, repeats, onP, offP, onN, offN):
	duration = pack("<H", onP) + pack("<H", offP) + pack("<H", onN) + pack("<H", offN)
	conn.GATT_WriteCharValue(handle=Handle_Direction, value=pack("<B", direction))
	conn.GATT_WriteCharValue(handle=Handle_Repeats, value=pack("<H", repeats))
	conn.GATT_WriteCharValue(handle=Handle_Duration, value=duration)

def monitor():
	conn.register_notification(Handle_Voltage, Handle_Voltage_Notify, callback=voltage_ready)

def voltage_ready(packet_dictionary):
	packet, dictionary = packet_dictionary
	data = dictionary["values"][0]
	dataList = [data[i:i+2] for i in range(0, len(data), 2)]
	voltages = [unpack("<H", x)[0] for x in dataList]
	print(voltages)

def make_calib_file_name(freq_start, prefix):
	return "calibration/%s_%d.csv" % (prefix, freq_start)

sweepStarts = range(10000, 100000, 5000)
def doCalibration(calibration_impedance, repeats, prefix):
	for start in sweepStarts:
		setStart(start)
		calibrate(calibration_impedance, repeats, make_calib_file_name(start, prefix))

def doSweeps(calibration_prefix, data_prefix):
	global device
	for start in sweepStarts:
		setStart(start)
		data = loadtxt(make_calib_file_name(start, calibration_prefix),delimiter=",")
		device.gains = data[:,-1]
		measure(False, data_prefix)

def main():
	global conn
	conn = TIConnection(port=COM_port, baudrate=115200, callback=analyse_packet)
	conn.connect("Edema_Band v0.1*V3*") # Roach_Backpack_BTv1
	
	conn.register_notification(Handle_SweepDone, Handle_SweepDone_Notify, callback=data_ready)

	setStart(startFreq)
	setInc(incFreq)
	setRange(outRange)
	setGain(gain)
	setElectrodes(electrodes)

def terminate():
	global conn, state, ble_parser
	
	conn.GATT_TerminateLinkRequest()
	time.sleep(1)
	#close device
	conn.parser.stop()
	
if __name__ == "__main__":
	import argparse
	parser = argparse.ArgumentParser()
	parser.add_argument("port")
	args = parser.parse_args()
	COM_port = args.port
	try:
		main()
		code.interact(local=locals())
	except:
		raise
		pass
	finally:
		if not conn is None:
			terminate()