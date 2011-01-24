/** ------------------------------------------------------------------------
    File        : StandardScopeEnum
    Purpose     : Enumeration of InjectABL scopes. This is the standard/default set. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 04 13:50:10 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum inherits EnumMember: 
    define static public property Default as StandardScopeEnum no-undo get. private set.
    
    /** One instance, running free, like a wolf. */
    define static public property Transient as StandardScopeEnum no-undo get. private set.
    
    /** Only one instance at a time: effectively scoped to the life of the InjectABL kernel. */
    define static public property Singleton as StandardScopeEnum no-undo get. private set.

    /** One instance per AVM Session. */
    define static public property ABLSession as StandardScopeEnum no-undo get. private set.
    
    /** One instance per connection; meaningless for statefree Appservers */
    define static public property AgentConnection as StandardScopeEnum no-undo get. private set.
    
    /** One instance per AppServer request */
    define static public property AgentRequest as StandardScopeEnum no-undo get. private set.
    
    /** Custom scope */    
    define static public property Custom as StandardScopeEnum no-undo get. private set.
    
    constructor static StandardScopeEnum():
        /* these all use this type as IBinding:ScopeCallbackType */
        StandardScopeEnum:Transient = new StandardScopeEnum('Transient').
        StandardScopeEnum:Singleton = new StandardScopeEnum('Singleton').
        
        StandardScopeEnum:ABLSession = new StandardScopeEnum('ABLSession').
        StandardScopeEnum:AgentRequest = new StandardScopeEnum('AgentRequest').
        StandardScopeEnum:AgentConnection = new StandardScopeEnum('AgentConnection').
        
        /* IBinding:ScopeCallbackType set to input value */
        StandardScopeEnum:Custom = new StandardScopeEnum('Custom').
        
        StandardScopeEnum:Default = StandardScopeEnum:Transient.
    end constructor.
    
    constructor public StandardScopeEnum (pcName as character):
        super(pcName).
    end constructor.
    
end class.