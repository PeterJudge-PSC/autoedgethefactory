/** ------------------------------------------------------------------------
    File        : IBizLogicServerParameters
    Purpose     : 
    Syntax      : 
    Description : Parameter object for connecting to a BizLogic server.
    @author pjudge
    Created     : Mon Dec 06 15:08:34 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.EnterpriseServices.BizLogic.IBizLogicAPI.

interface OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters:  
    
    /** (optional) Protocol for connecting to the Savvion SBM Server (http/https). Typically HTTP */
    define public property Protocol as character no-undo get. set.
    
    /** (mandatory) Hostname or IP address of the Savvion SBM Server */
    define public property Host as character no-undo get.
    
    /** (Optional) Port of the Savvion SBM Server; typically defauls to 18793 */
    define public property Port as integer no-undo get. set.
    
    /** (mandatory) Username for a user on the Savvion SBM Server */
    define public property UserName as character no-undo get.
    
    /** Password for a user on the Savvion SBM Server.
        The password is settable only; alternatively, the constructor/
        implementation of the parameter object maintains the value. 
        
        This is so because we don't want to expose the password in clear
        text to anyone who asks for it. */
    define public property Password as character no-undo set.
    
    /** Connects to the BizLogic server with the username/password stored in this object.
        Since we don't expose the password publically, we need to take the BizLogic API
        as a parameter. 
        
        @param IBizLogicAPI An instance of the BizLogic API to connect to.
        @return longchar The session ID for the session. */
    method public longchar Connect(input poBizLogicAPI as IBizLogicAPI).
    
end interface.