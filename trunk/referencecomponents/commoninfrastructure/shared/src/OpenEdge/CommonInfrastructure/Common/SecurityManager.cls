/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:54:05 EDT 2010
    Notes       :               
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.IConnectionManager.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ConnectionManagerActionEventArgs.
using OpenEdge.CommonInfrastructure.Common.IComponent.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidActionError.
using OpenEdge.Core.System.NotFoundError.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.SecurityManager abstract inherits Service 
        implements ISecurityManager:
    
    /** Use these properties in lieu of having to say Class:GetClass('....ISecurityManager') every time */
    define static public property IUserContextType as class Class no-undo get. private set.
    define static public property ISecurityManagerType as class Class no-undo get. private set.
    
    /** Returns the current user's context. The current user is the one who has
        a request being serviced by this AVM. */
    define public property CurrentUserContext as IUserContext no-undo
        get.
        protected set.
            
    /** Describes whether the current session is managed or not. A managed session
        basically has a user associated with it. */
    define public property IsManagedSession as logical no-undo
        get():
            return valid-object(CurrentUserContext).
        end get.
    
    define protected property ConnectionManager as IConnectionManager no-undo
        get():
            if not valid-object(ConnectionManager) then
                ConnectionManager = cast(ServiceManager:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IConnectionManager')), IConnectionManager).
            
            return ConnectionManager.
        end get.
        set.
    
    constructor static SecurityManager():
        SecurityManager:ISecurityManagerType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager').
        SecurityManager:IUserContextType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IUserContext').
    end constructor.
    
    constructor public SecurityManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    /** Merges the passed context into the current user's context. The
        default is to replace the current context completely. 
        
        @param IUserContext The context to merge.   */
    method public void SetUserContext(input poUserContext as IUserContext):
        MergeUserContext(CurrentUserContext, poUserContext).
    end method.
    
    /** Merges contexts.
        
        @param IUserContext The target for the merge of context. Typically the CurrentUserContext
        @param IUserContext The source context to merge into the target.    */
    method protected void MergeUserContext(input poTargetContext as IUserContext,
                                           input poSourceContext as IUserContext):
        @todo(task="question", action="use :Clone() instead? ").                                                           
        poTargetContext = poSourceContext.
    end method.
    
    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted. */    
    method abstract public void UserLogin(input pcUserName as character,
                                          input pcUserDomain as character,
                                          input pcPassword as character).
    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's password. This should be encoded/encrypted.  */
    method public void UserLogin(input pcUserName as character,
                                 input pcPassword as character):
        define variable cDomain as character no-undo.
        
        if num-entries(pcUserName, '@') eq 2 then
            assign cDomain = entry(2,  pcUserName, '@')
                   pcUserName = entry(1,  pcUserName, '@').
        
        UserLogin(pcUserName, cDomain, pcPassword).                                             
    end method.
    
    /** Ends a user's session (not a log out, but the opposite of ValidateSession).
        Ends the current session. */
    method public void EndSession():
        /* release context */
        CurrentUserContext = ?.
    end method.
    
    /** Read and write allows us to turn context into a kind of cookie, if we so desire. */
    method protected IUserContext ReadContextFromStore(input pcContextId as longchar):
        define variable oOIS as IObjectInput no-undo.
        define variable oUC as IUserContext no-undo.
        define variable cFilename as character no-undo.
        define variable cClientPrincipal as longchar no-undo.
        define variable mClientPrincipal as memptr no-undo.
        define variable rClientPrincipal as raw no-undo.
        
        /* context goes in one place ... */ 
        cFilename = search(string(session:temp-dir + pcContextId + '.' + SecurityManager:IUserContextType:TypeName + '.ser')).
        if not cFilename eq ? then
        do:
            oOIS = new ObjectInputStream().
            oOIS:Read(cFilename).
            oUC = cast(oOIS:ReadObject(), IUserContext).
        end.
        
        /* ... and client-principal in another */ 
        cFilename = search(string(session:temp-dir + pcContextId + '.ClientPrincipal.ser')).
        if valid-object(oUC) and not cFilename eq ? then
        do:
            copy-lob file cFilename to cClientPrincipal.
            
            if cClientPrincipal ne '' then
            do:
                mClientPrincipal = base64-decode(cClientPrincipal).
                rClientPrincipal = get-bytes(mClientPrincipal, 1, get-size(mClientPrincipal)).
                oUC:ClientPrincipal:import-principal(rClientPrincipal).
            end.
        end.
        
        return oUC.
    end method.
    
    method protected void WriteContextToStore(input poUserContext as IUserContext):
        define variable oOOS as IObjectOutput no-undo.
        define variable oUC as IUserContext no-undo.
        define variable cFilename as character no-undo.
        define variable cClientPrincipal as longchar no-undo.
        
        if valid-object(poUserContext) then
        do:
            /* context goes in one place ... */
            cFilename = session:temp-dir + poUserContext:ContextId + '.' + SecurityManager:IUserContextType:TypeName + '.ser'.
            oOOS = new ObjectOutputStream().
            oOOS:WriteObject(poUserContext).
            oOOS:Write(cFilename).

            /* ... client-principal in another */
            cFilename = session:temp-dir + poUserContext:ContextId + '.ClientPrincipal.ser'.
            cClientPrincipal = base64-encode(poUserContext:ClientPrincipal:export-principal()). 
            copy-lob cClientPrincipal to file cFilename.
        end.
    end method.
    
    /** Authorises the current user to undertake the specified action on the
        service. AN error is thrown if the authentication fails.
        
        @param character The service being operated upon.
        @param ServiceMessageActionEnum The Action being performed. */
    @method(virtual="true").        
    method public void AuthoriseServiceAction(input pcService as character,
                                              input poServiceMessageAction as ServiceMessageActionEnum):
    end method.
    
    /** Authorises the current user to undertake the specified action on the
        service. An error is thrown if the authentication fails. */
    @method(virtual="true").
    method public void AuthoriseOperation(input poOperation as OpenEdge.Lang.EnumMember):
        @todo(task="implement", action="").        
    end method.
    
end class.