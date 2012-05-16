/** ------------------------------------------------------------------------
    File        : BpmServerConnectionParameters
    Purpose     : 
    Syntax      : 
    Description : 
    @author(s)   : pjudge
    Created     : Fri Jan 28 15:14:28 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.BpmServerConnectionParameters.
using OpenEdge.CommonInfrastructure.Common.Connection.ConnectionParameters.
using OpenEdge.Lang.Assert.

class OpenEdge.CommonInfrastructure.Common.Connection.BpmServerConnectionParameters inherits ConnectionParameters:
    
    /** (optional) Protocol for connecting to the Savvion SBM Server (http/https). Typically SBMServerDC.
        As of 11.0, the default connection is via the UserSession object and uses the custom SBMServerDC protocol */
    define public property Protocol as character no-undo
        get():
            if Protocol eq '' or Protocol eq ? then
                Protocol = 'SBMServerDC'.
            return Protocol.
        end get.
        set.
    
    /** (mandatory) Hostname or IP address of the Savvion SBM Server */
    define public property Host as character no-undo get. private set.
    
    /** (Optional) Port of the Savvion SBM Server; typically defauls to 18793 */
    define public property Port as integer no-undo
        get():
            if Port eq 0 or Port eq ? then
                Port = 18793.
            
            return Port.
        end get.
        set.
        
    constructor public BpmServerConnectionParameters():
        super().
    end constructor.
    
    constructor public BpmServerConnectionParameters(input pcHost as character,
                                                     input pcProtocol as character,
                                                     input piPort as integer,
                                                     input pcOptions as longchar):
        super(pcOptions).
        
        Assert:ArgumentNotNullOrEmpty(pcHost, 'Host name').        
        assign Host = pcHost
               Protocol = pcProtocol
               Port = piPort.
    end constructor.
    
    method override public longchar GetConnectionString():
		return substitute('&1://&2:&3',
		          this-object:Protocol,
		          this-object:Host,
		          this-object:Port).
	end method.
	
end class.