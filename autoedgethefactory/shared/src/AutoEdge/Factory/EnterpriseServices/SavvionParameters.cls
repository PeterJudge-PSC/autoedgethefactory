/** ------------------------------------------------------------------------
    File        : SavvionParameters
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 06 15:20:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters.
using OpenEdge.EnterpriseServices.BizLogic.IBizLogicAPI.

using OpenEdge.Lang.Assert.

class AutoEdge.Factory.EnterpriseServices.SavvionParameters implements IBizLogicServerParameters:
     
    /** (optional) Protocol for connecting to the Savvion SBM Server (http/https). Typically HTTP */
    define public property Protocol as character no-undo
        get():
            if Protocol eq '' or Protocol eq ? then
                Protocol = 'http'.
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
    
    /** (mandatory) Username for a user on the Savvion SBM Server */
    define public property UserName as character no-undo get. private set.
    
    /** Password for a user on the Savvion SBM Server.
        The password is settable only; alternatively, the constructor/
        implementation of the parameter object maintains the value. 
        
        This is so because we don't want to expose the password in clear
        text to anyone who asks for it. */
    define public property Password as character no-undo
        get():
            return encode(Password).
        end get.
        set.
    
    constructor public SavvionParameters():
/*        this-object('127.0.0.1', 'ebms', 'ebms').*/
        this-object('ec2-50-16-84-39.compute-1.amazonaws.com', 'ebms', 'ebms').
    end constructor.
    
    constructor public SavvionParameters(input pcHost as character,
                                         input pcUser as character,
                                         input pcPassword as character):
        super().
        
        Assert:ArgumentNotNullOrEmpty(pcHost, 'Host name').
        Assert:ArgumentNotNullOrEmpty(pcUser, 'User name').
        
        assign Host = pcHost
               UserName = pcUser
               Password = pcPassword.
    end constructor.

    /** Connects to the BizLogic server with the username/password stored in this object.
        Since we don't expose the password publically, we need to take the BizLogic API
        as a parameter. 
        
        @param IBizLogicAPI An instance of the BizLogic Api to connect to.
        @return longchar The session ID for the session. */
    method public longchar Connect( input poBizLogicAPI as IBizLogicAPI):
        Assert:ArgumentNotNull(poBizLogicAPI, 'BizLogic API').
        
        return poBizLogicAPI:Connect(UserName, Password).        
    end method.
    
end class.