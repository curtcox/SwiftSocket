/*
Copyright (c) <2014>, skysent
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
must display the following acknowledgement:
This product includes software developed by skysent.
4. Neither the name of the skysent nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY skysent ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL skysent BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import Foundation
import Darwin.C

func testudpserver(){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
        let server:UDPServer=UDPServer(addr:"127.0.0.1",port:8080)
        let run:Bool=true
        while run{
            var (data,remoteip,_)=server.recv(1024)
            print("recive")
            if let d=data{
                if let str=String(bytes: d, encoding: NSUTF8StringEncoding){
                    print(str)
                }
            }
            print(remoteip)
            server.close()
            break
        }
    })
}

func testudpclient(){
    let client:UDPClient=UDPClient(addr: "localhost", port: 8080)
    print("send hello world")
    client.send(str: "hello world")
    client.close()
}

func testudpBroadcastserver(){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
        //turn the server to broadcast mode with the address 255.255.255.255 or empty string
        let server:UDPServer=UDPServer(addr:"",port:8080)
        let run:Bool=true
        print("server.started")
        while run{
            let (data,remoteip,remoteport)=server.recv(1024)
            print("recive\(remoteip);\(remoteport)")
            if let d=data{
                if let str=String(bytes: d, encoding: NSUTF8StringEncoding){
                    print(str)
                }
            }
            print(remoteip)
        }
    })
}

func testudpBroadcastclient(){
    //wait a few second till server will ready
    sleep(2)
    print("Broadcastclient.send...")
    let clientB:UDPClient = UDPClient(addr: "255.255.255.255", port: 8080)
    clientB.enableBroadcast()
    clientB.send(str: "test hello from broadcast")
    clientB.close()
}

testudpBroadcastserver()
testudpBroadcastclient()

var stdinput=NSFileHandle.fileHandleWithStandardInput()
stdinput.readDataToEndOfFile()

