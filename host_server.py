#!/usr/bin/env python

# Small server script for the gaming VM to call with python requests
# Will execute a bash script that adds the keyboard and mouse to the VM
# Allows me to continue using host while waiting for VM to boot up

from http.server import BaseHTTPRequestHandler, HTTPServer
import socketserver
import os
import sys
from sys import argv

# Globals
vm_name = "win10"
keybd_xml = "keybd.xml"
mouse_xml = "mouse.xml"
server_status_file = "vm_status.txt"

# Let the host know when the VM is online, will be used to check on phone apps etc 
def write_out_server_status(status):
    with open(server_status_file, "w") as outfile:
        outfile.write(status)

# Receives HTTP messages, GET is handled in do_GET
class server(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
    
    def _send_response_body(self, bodytext):
        self.wfile.write(bodytext.encode("utf-8"))
    
    def do_GET(self):
        self._set_headers()
        command = self.path[1:] # chop off the / character from the start
        
        #print("Received call from gaming VM")
        #self.wfile.write("<html><body>Response back from host machine to VM!</body></html>\n".encode("utf-8"))
        
        if command == "add_keyboard_mouse":
            print("Received request from gaming VM to attach the keyboard and mouse")
            attach_keyboard_cmd = "sudo virsh attach-device {0} {1}".format(vm_name, keybd_xml)
            attach_mouse_cmd = "sudo virsh attach-device {0} {1}".format(vm_name, mouse_xml)
            os.system(attach_keyboard_cmd)
            os.system(attach_mouse_cmd)
            
            self._send_response_body("Server: Performed commands to attach keyboard and mouse") #shoot a message back to the client
        
        if command == "test":
            print("Received request from VM for test purpose")
            self._send_response_body("Server: I received your message buddy")
        
        if command == "tell_online":
            write_out_server_status("Online")
            self._send_response_body("Server: Set the VM status to online")
        
        if command == "exit_http_server":
            print("Received request to exit the HTTP server")
            write_out_server_status("Offline")
            sys.exit(0)
        
        #print("Received command: {0}".format(self.command))
        #print("Received requestline: {0}".format(self.requestline))
        #print("Received path: {0}".format(self.path))
   
def run(server_class=HTTPServer, handler_class=server, port=8080):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print("*** Starting host control server application...")
    httpd.serve_forever()

if __name__ == "__main__":
    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
