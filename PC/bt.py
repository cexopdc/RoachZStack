
from pyblehci import BLEBuilder

class TIBuilder(BLEBuilder):
	def GATT_ReadCharValue(self, conn_handle='\x00\x00', handle=None):
		return self.send("fd8a", conn_handle=conn_handle, handle=handle)

	def GATT_ReadMultipleCharValues(self, conn_handle='\x00\x00', handles=None):
		return self.send("fd8e", conn_handle=conn_handle, handles=handles)

	def GATT_WriteCharValue(self, conn_handle='\x00\x00', handle=None, value=None):
		return self.send("fd92", conn_handle=conn_handle, handle=handle, value=value)

	def GATT_WriteLongCharValue(self, handle='\x00\x00', offset=None, value=None):
		return self.send("fd96", handle=handle, offset=offset, value=value)
		
	def GATT_ReadLongCharValue(self, handle='\x00\x00', offset=None, value=None):
		return self.send("fd8c", handle=handle, offset=offset, value=value)

	def GATT_DiscAllChars(self, start_handle='\x00\x00', end_handle='\xff\xff'):
		return self.send("fdb2", start_handle=start_handle, end_handle=end_handle)

	def GATT_ReadUsingCharUUID(self, conn_handle='\x00\x00', start_handle='\x01\x00', end_handle='\xff\xff', read_type=None):
		return self.send("fdb4", conn_handle=conn_handle, start_handle=start_handle, end_handle=end_handle, read_type=read_type)

	def GAP_DeviceInit(self, profile_role='\x08', max_scan_rsps='\x05', irk='\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00', csrk='\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00', sign_counter='\x01\x00\x00\x00'):
		return self.send("fe00", profile_role=profile_role, max_scan_rsps=max_scan_rsps, irk=irk, csrk=csrk, sign_counter=sign_counter)

	def GAP_ConfigureDeviceAddr(self, addr_type=None, addr=None):
		return self.send("fe03", addr_type=addr_type, addr=addr)

	def GATT_DeviceDiscoveryRequest(self, mode=None, active_scan='\x01', white_list='\x00'):
		return self.send("fe04", mode=mode, active_scan=active_scan, white_list=white_list)

	def GATT_DeviceDiscoveryCancel(self):
		return self.send("fe05")

	def GATT_EstablishLinkRequest(self, high_duty_cycle='\x00', white_list='\x00', addr_type_peer='\x00', peer_addr=None):
		return self.send("fe09", high_duty_cycle=high_duty_cycle, white_list=white_list, addr_type_peer=addr_type_peer, peer_addr=peer_addr)

	def GATT_TerminateLinkRequest(self, conn_handle='\x00\x00', reason='\x13'):
		return self.send("fe0a", conn_handle=conn_handle, reason=reason)

	def GAP_SetParam(self, param_id=None, param_value=None):
		return self.send("fe30", param_id=param_id, param_value=param_value)

	def GAP_GetParam(self, param_id=None):
		return self.send("fe31", param_id=param_id)
