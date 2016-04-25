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

public class UDPServer:YSocket{
    public override init(addr a:String,port p:Int){
        super.init(addr: a, port: p)
        let fd:Int32 = c_yudpsocket_server(self.addr, port: Int32(self.port))
        if fd>0{
            self.fd=fd
        }
    }
    //TODO add multycast and boardcast
    public func recv(expectlen:Int)->([UInt8]?,String,Int){
        if let fd:Int32 = self.fd{
            var buff:[UInt8] = [UInt8](count:expectlen,repeatedValue:0x0)
            var remoteipbuff:[Int8] = [Int8](count:16,repeatedValue:0x0)
            var remoteport:Int32=0
            let readLen:Int32=c_yudpsocket_recive(fd, buff: buff, len: Int32(expectlen), ip: &remoteipbuff, port: &remoteport)
            let port:Int=Int(remoteport)
            var addr:String=""
            if let ip=String(CString: remoteipbuff, encoding: NSUTF8StringEncoding){
                addr=ip
            }
            if readLen<=0{
                return (nil,addr,port)
            }
            let rs=buff[0...Int(readLen-1)]
            let data:[UInt8] = Array(rs)
            return (data,addr,port)
        }
        return (nil,"no ip",0)
    }
    public func close()->(Bool,String){
        if let fd:Int32=self.fd{
            c_yudpsocket_close(fd)
            self.fd=nil
            return (true,"close success")
        }else{
            return (false,"socket not open")
        }
    }
}
