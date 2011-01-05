/** ------------------------------------------------------------------------
    File        : SessionTypeCondition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.


using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.Core.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.InjectABL.Binding.Conditions.StandardConditionResolver.

using OpenEdge.Lang.SessionClientTypeEnum.
using Progress.Lang.Class. 

class OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition inherits Condition:
    define static public property Client as ICondition no-undo get. private set. 
    define static public property Server as ICondition no-undo get. private set.
    define static public property Web    as ICondition no-undo get. private set.
    define static public property CurrentSession as ICondition no-undo get. private set.

    define static private property ConditionResolverType as class Class no-undo get. set.
    
    constructor static SessionTypeCondition():
        assign SessionTypeCondition:Client = new SessionTypeCondition(SessionClientTypeEnum:ABLClient)
               SessionTypeCondition:Web  = new SessionTypeCondition(SessionClientTypeEnum:WebClient)
               SessionTypeCondition:Server = new SessionTypeCondition(SessionClientTypeEnum:AppServer)
               SessionTypeCondition:CurrentSession = new SessionTypeCondition(SessionClientTypeEnum:CurrentSession)
               
               SessionTypeCondition:ConditionResolverType = Class:GetClass('OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeConditionResolver')
               .
    end constructor.

	constructor public SessionTypeCondition ( input poValue as Progress.Lang.Object ):
		super (input poValue).
	end constructor.
	
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(SessionTypeCondition:ConditionResolverType). 
    end method.
    
end class.
