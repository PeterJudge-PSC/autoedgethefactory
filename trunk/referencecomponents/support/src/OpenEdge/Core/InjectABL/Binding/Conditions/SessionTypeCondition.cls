/*------------------------------------------------------------------------
    File        : SessionTypeCondition
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Lang.SessionClientTypeEnum.

class OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition:
    
    define static public property Client as ICondition no-undo get. private set. 
    define static public property Server as ICondition no-undo get. private set.
    define static public property Web    as ICondition no-undo get. private set.
    define static public property CurrentSession as ICondition no-undo get. private set.
    
    constructor static SessionTypeCondition():
        assign SessionTypeCondition:Client = new Condition(SessionClientTypeEnum:ABLClient)
               SessionTypeCondition:Web  = new Condition(SessionClientTypeEnum:WebClient)
               SessionTypeCondition:Server = new Condition(SessionClientTypeEnum:AppServer)
               SessionTypeCondition:CurrentSession = new Condition(SessionClientTypeEnum:CurrentSession)
               .
    end constructor.
    
end class.
