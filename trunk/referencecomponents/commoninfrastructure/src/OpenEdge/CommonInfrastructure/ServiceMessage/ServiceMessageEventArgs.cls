/*------------------------------------------------------------------------
    File        : ServiceMessageEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 11:52:50 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.Core.System.EventArgs.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs inherits EventArgs:
     
    define public property ServiceMessage as IServiceMessage no-undo get. set.
    
    constructor public ServiceMessageEventArgs():
    end constructor.
    
    constructor public ServiceMessageEventArgs(poMessage as IServiceMessage):
        ServiceMessage = poMessage.
    end constructor.
    
end class.