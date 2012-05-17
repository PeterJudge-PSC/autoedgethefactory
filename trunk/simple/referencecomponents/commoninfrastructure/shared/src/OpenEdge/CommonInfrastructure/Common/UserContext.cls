/** ------------------------------------------------------------------------
    File        : UserContext
    Purpose     : Dummy user context object
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Thu Dec 02 11:37:05 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.UserContext
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

    /** A collection of properties associated with this context. These
        can be any key/value set of objects (key and value types should
        be serialisable). */
    define public property UserProperties as IMap no-undo
        get():
            if not valid-object(UserProperties) then
                UserProperties = new Map().

            return UserProperties.
        end get.
        private set.

    /** ABL CLIENT-PRINCIPAL object for pertaining to this context */
    define public property ClientPrincipal as handle no-undo get. private set.

    constructor public UserContext():
        /* only used for Serialization */
        create client-principal ClientPrincipal.
    end constructor.

    destructor public UserContext():
        delete object ClientPrincipal no-error.
    end destructor.

    constructor public UserContext (input pcUserName as character):
        define variable cUserDomain as character no-undo.

        this-object().

        if num-entries(pcUserName, '@') gt 1 then
            UserDomain = entry(2, pcUserName, '@').

        ShadowConstructor(entry(1, pcUserName, '@'), cUserDomain, guid(generate-uuid)).
    end method.

    constructor public UserContext (input pcUserName as character,
                                    input pcUserDomain as character):
        this-object().

        ShadowConstructor(pcUserName, pcUserDomain, guid(generate-uuid)).
    end constructor.

    constructor public UserContext (input pcUserName as character,
                                    input pcUserDomain as character,
                                    input pcContextId as longchar):
        this-object().

        ShadowConstructor(pcUserName, pcUserDomain, pcContextId).
    end constructor.

    /* Since are calculated from others, which may not always be passed, we have
       created a shadow constructor which doesn't need to be run as the first line in
       a constructor. This lets us change the parameters as needed before setting them
       in the object. */
    method private void ShadowConstructor(input pcUserName as character,
                                          input pcUserDomain as character,
                                          input pcContextId as longchar):

        Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
        Assert:ArgumentNotNullOrEmpty(pcContextId, 'Context Id').

        assign UserName = pcUserName
               UserDomain = pcUserDomain
               ContextId = pcContextId.

        create client-principal ClientPrincipal.
        assign ClientPrincipal:session-id = ContextId
               ClientPrincipal:user-id = UserName
               ClientPrincipal:domain-name = lc(pcUserDomain).
    end method.

    /** Sets up the user's tenancy (including the tenant name and id map). */
    method public void EstablishTenancy(input poTenantManager as ITenantManager):
        TenantName = poTenantManager:GetDomainTenant(UserDomain).
        TenantId = poTenantManager:GetTenantId(TenantName).
    end method.

    method public void WriteObject(input poStream as IObjectOutput):
        poStream:WriteChar(UserName).
        poStream:WriteChar(UserDomain).
        poStream:WriteLongChar(ContextId).
        poStream:WriteChar(TenantName).

        poStream:WriteObjectArray(TenantId:KeySet:ToArray()).
        poStream:WriteObjectArray(TenantId:Values:ToArray()).

        poStream:WriteObjectArray(UserProperties:KeySet:ToArray()).
        poStream:WriteObjectArray(UserProperties:Values:ToArray()).

        /* We do not serialize the CLIENT-PRINCIPAL object */
    end method.

    method public void ReadObject(input poStream as IObjectInput):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oKeys as Object extent no-undo.
        define variable oValues as Object extent no-undo.

        assign UserName = poStream:ReadChar()
               UserDomain = poStream:ReadChar()
               ContextId = poStream:ReadLongChar()
               TenantName = poStream:ReadChar()

               oKeys = poStream:ReadObjectArray()
               oValues = poStream:ReadObjectArray()
               iMax = extent(oKeys).

        do iloop = 1 to iMax:
            TenantId:Put(oKeys[iLoop], oValues[iLoop]).
        end.

        assign extent(oKeys) = ?
               oKeys = poStream:ReadObjectArray()
               extent(oValues) = ?
               oValues = poStream:ReadObjectArray()
               iMax = extent(oKeys).
        do iloop = 1 to iMax:
            UserProperties:Put(oKeys[iLoop], oValues[iLoop]).
        end.

        /* We do not deserialize the CLIENT-PRINCIPAL object */
    end method.

    method override public logical Equals(input p0 as Object):
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