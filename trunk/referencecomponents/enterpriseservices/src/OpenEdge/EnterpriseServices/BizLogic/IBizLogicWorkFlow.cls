/** ------------------------------------------------------------------------
    File        : IBizLogicWorkFlow
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 14:33:21 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters.
  
interface OpenEdge.EnterpriseServices.BizLogic.IBizLogicWorkFlow:
    /* The Savvion Session ID */
    define public property SessionId as longchar no-undo get.
    
    define public property ServerParameter as IBizLogicServerParameters no-undo get. set.
    
    /* Currently-running Process' instance ID  */
    define public property ProcessInstanceId as int64 no-undo get.

    method public void Login (input pcUsername as character,    
                              input pcPassword as character).
    method public void Logout().
    
end interface.