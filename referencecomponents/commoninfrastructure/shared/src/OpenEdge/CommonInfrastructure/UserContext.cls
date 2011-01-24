/** ------------------------------------------------------------------------
    File        : UserContext
    Purpose     : Dummy user context object 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 02 11:37:05 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ITenantManager.
using OpenEdge.CommonInfrastructure.IUserContext.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.UserContext
        implements IUserContext, IExternalizable:
    
    /* name of the user to whom this context applies */
    define public property UserName as character no-undo get. private set.
    
    /* domain of the user to whom this context applies */
    define public property UserDomain as character no-undo get. private set.
    
    /** Unique identifier for the client session */
    define public property ContextId as longchar no-undo get. private set.
    
    /** The tenant to whom this user belongs */
    define public property TenantName as character no-undo get. private set.
    
    /** A collection of tenant Ids for this User. 
        
        value = TenantId
        key   = Logical DB Name */            
    define public property TenantId as IMap no-undo
        get():
            if not valid-object(TenantId) then
                TenantId = new TypedMap(String:Type, String:Type).
            return TenantId.
        end. private set.
    
    constructor public UserContext():
        /* only used for Serialization */
    end constructor.
        
    constructor public UserContext (input pcUserName as character):
        Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
        
        assign UserName = entry(1, pcUserName, '@')
               ContextId = guid(generate-uuid).
        
        if num-entries(pcUserName, '@') gt 1 then
            UserDomain = entry(2, pcUserName, '@').
    end method.
    
    constructor public UserContext (input pcUserName as character,
                                    input pcUserDomain as character):
        Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
        Assert:ArgumentNotNullOrEmpty(pcUserDomain, 'User Domain').
        
        assign UserName = pcUserName
               UserDomain = pcUserDomain                              
               ContextId = guid(generate-uuid).
    end constructor.
    
    /** Sets up the user's tenancy (including the tenant name and id map). */
    method public void EstablishTenancy(input poTenantManager as ITenantManager):
        TenantName = poTenantManager:GetDomainTenant(UserDomain).
        TenantId = poTenantManager:GetTenantId(TenantName).
    end method.
    
    method public void WriteObject(input poStream as ObjectOutputStream):
        poStream:WriteChar(UserName).
        poStream:WriteChar(UserDomain).
        poStream:WriteLongChar(ContextId).
        poStream:WriteChar(TenantName).
        
        poStream:WriteObjectArray(TenantId:KeySet:ToArray()).
        poStream:WriteObjectArray(TenantId:Values:ToArray()).
    end method.
    
    method public void ReadObject(input poStream as ObjectInputStream):
        UserName = poStream:ReadChar().
        UserDomain = poStream:ReadChar().
        ContextId = poStream:ReadLongChar().
        TenantName = poStream:ReadChar().
        
        def var oo as Object extent.
        
        oo = poStream:ReadObjectArray().
        cast(TenantId:KeySet, ICollection):AddArray(oo).

        oo = poStream:ReadObjectArray().
        TenantId:Values:AddArray(oo).
    end method.

	method override public logical Equals(input p0 as Object ):
		define variable lEquals as logical no-undo.
		define variable oUserContext as IUserContext no-undo.
		
		lEquals = super:Equals(input p0).
		if not lEquals then
            lEquals = type-of(p0, IUserContext).
            
		if lEquals then
            assign oUserContext = cast(p0, IUserContext) 
                   lEquals = (this-object:UserName eq oUserContext:UserName and
                              this-object:UserDomain eq oUserContext:UserDomain and
                              this-object:TenantName eq oUserContext:TenantName and
                              this-object:ContextId eq oUserContext:ContextId).
        return lEquals.		
	end method.
    
end class.