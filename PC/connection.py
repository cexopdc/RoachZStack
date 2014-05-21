from bt import *
import serial
from pyblehci import BLEParser
import collections
import threading

def pretty(hex_string, seperator=None):
	# >>> pretty("\x01\x02\x03\xff")
	#       '01 02 03 FF'
	if seperator: 
		sep = seperator 
	else: sep = ' '
	hex_string = hex_string.encode('hex')
	a = 0
	out = ''
	for i in range(len(hex_string)):
		if a == 2:
			out = out + sep
			a = 0
		out = out + hex_string[i].capitalize()
		a = a + 1
	return out

def print_orderedDict(dictionary):
	result = ""
	for idx, key in enumerate(dictionary.keys()):
		if dictionary[key]:
			#convert e.g. "data_len" -> "Data Len"
			title = ' '.join(key.split("_")).title()
			if isinstance(dictionary[key], list):
				for idx2, item in enumerate(dictionary[key]):
					result += "{0} ({1})\n".format(title, idx2)
					result += print_orderedDict(dictionary[key][idx2])
			elif isinstance(dictionary[key], type(collections.OrderedDict())):
				result += '{0}\n{1}'.format(title, print_orderedDict(dictionary[key]))
			else:
				result += "{0:15}\t: {1}\n\t\t  ({2})\n".format(title, pretty(dictionary[key][0], ':'), dictionary[key][1])
		else:
			result += "{0:15}\t: None".format(key)
	return result

def print_output(packet_dictionary):
	packet, dictionary = packet_dictionary
	return ""
	result = print_orderedDict(dictionary)
	result += 'Dump:\n{0}\n'.format(pretty(packet))
	return result

class State():
	DISCONNECTED = 0
	DISCOVERY = 1
	FOUND = 2
	LINKING = 3
	CONNECTED = 4

class TIConnection(TIBuilder):



	def __init__(self, port, baudrate, callback):
		self.serial_port = serial.Serial(port=port, baudrate=baudrate)
		super( TIConnection, self ).__init__(self.serial_port)
		self.parser = BLEParser(self.serial_port, callback=self.analyse_packet)
		self.callback = callback
		self.GAP_DeviceInit()
		self.state = State.DISCONNECTED
		self.desiredName = ""
		self.macAddr = ""
		self.name = ""
		self.notifications = list()
		self.wasSuccess = False

		self.cv = threading.Condition()

	def connect(self, name):
		self.state = State.DISCOVERY
		self.desiredName = name
		self.cv.acquire()
		print(print_output(self.GATT_DeviceDiscoveryRequest(mode="\x03")))
		self.cv.wait(4)
		if not self.state == State.FOUND:
			raise Exception("No device found")
		self.cv.release()
		self.GATT_DeviceDiscoveryCancel()
		
		self.state = State.LINKING
		self.cv.acquire()
		print(print_output(self.GATT_EstablishLinkRequest(peer_addr = self.mac)))
		self.cv.wait(4)
		if not self.state == State.CONNECTED:
			raise Exception("Could not establish link")
		self.cv.release()

	def register_notification(self, handle, notifyHandle, callback):
		if not self.state == State.CONNECTED:
			raise Exception("Not connected")
		self.GATT_WriteCharValue(handle=notifyHandle, value='\x01\x00')
		self.notifications.append((handle, callback))

	def GATT_WriteCharValue(self, conn_handle='\x00\x00', handle=None, value=None):
		if not self.state == State.CONNECTED:
			raise "Not connected"
		self.cv.acquire()
		self.wasSuccess = False
		print(print_output(super( TIConnection, self ).GATT_WriteCharValue(conn_handle=conn_handle, handle=handle, value=value)))
		self.cv.wait(8)
		if not self.wasSuccess:
			raise Exception("Write char failed")
		self.cv.release()

	def analyse_packet(self, packet_dictionary):
		packet, dictionary = packet_dictionary

		print("EVENT: Response received from the device")
		if self.state == State.DISCOVERY:
			if dictionary["event"][1] == "GAP_DeviceInformation":
				if self.desiredName in dictionary['data_field'][0]:
					self.name = dictionary['data_field'][0]
					self.mac = dictionary['addr'][0]
					self.cv.acquire()
					self.state = State.FOUND
					self.cv.notify()
					self.cv.release()
				else:
					print(dictionary['data_field'][0])
		elif self.state == State.LINKING:
			if dictionary["event"][1] == "GAP_EstablishLink" and dictionary["status"][0] == "\x00":
				self.state = State.CONNECTED
				self.cv.acquire()
				self.cv.notify()
				self.cv.release()

		elif self.state == State.CONNECTED:
			if dictionary["event"][1] == "ATT_WriteRsp" and dictionary["status"][0] == "\x00":
				self.wasSuccess = True
				self.cv.acquire()
				self.cv.notify()
				self.cv.release()
			elif dictionary["event"][1] == "ATT_HandleValueNotification" and dictionary["status"][0] == "\x00":
				for (handle, callback) in self.notifications:
					if handle == dictionary["handle"][0]:
						callback((packet, dictionary))
					
		print(dictionary["event"][1])
		#print(print_output((packet, dictionary)))
		if not self.callback == None:
			self.callback((packet, dictionary))