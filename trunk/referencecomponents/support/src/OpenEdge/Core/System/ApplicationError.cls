/*------------------------------------------------------------------------
    File        : OpenEdge.Core.System.ApplicationError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Mar 09 10:37:02 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.FlagsEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Lang.Class.
using Progress.Lang.Error.

class OpenEdge.Core.System.ApplicationError abstract inherits AppError:
    define static public property ShowDebugMessages as logical no-undo init false get. set.
    
    define public property InnerError as Error no-undo get. protected set.
    
    define abstract protected property ErrorTitle as character no-undo get.         
    define abstract protected property ErrorText as character no-undo get.
    
    constructor public ApplicationError():               
        /* can/will be overwritten by individual Error */
        this-object:Severity = ErrorSeverityEnum:Default:Value.
    end constructor.
    
    constructor public ApplicationError(poInnerError as Error):               
        super().
        this-object:InnerError = poInnerError.
    end constructor.
    
    method public void LogError():
        @todo(task="implement").
    end method.
    
    method public void ShowError():
        /** This method should probably use a 'proper' message dialog; this
            might be a complete MVP application. For now, we simply use
            the MESSAGE statement. **/

        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Fatal) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Critical) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Error)then
            message ResolvedMessageText() view-as alert-box error title ResolvedTitle().
        else
        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Info) or
           FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Debug) then
            message ResolvedMessageText() view-as alert-box information title ResolvedTitle().
        else
        if FlagsEnum:IsA(this-object:Severity, ErrorSeverityEnum:Message) then
            message ResolvedMessageText() view-as alert-box message title ResolvedTitle().
        else
            message ResolvedMessageText() view-as alert-box warning title ResolvedTitle().
    end method.
    
    method public character ResolvedTitle():
        return substitute('&1', this-object:ErrorTitle).
    end method.
            
    method public character ResolvedMessageText ():
        define variable cMsg      as character no-undo.        
        define variable cInnerMsg as character no-undo.
        define variable oError    as Error no-undo.        
        
        cMsg = substitute(this-object:ErrorText,
                               GetMessage(1),
                               GetMessage(2),
                               GetMessage(3),
                               GetMessage(4),
                               GetMessage(5),
                               GetMessage(6),
                               GetMessage(7),
                               GetMessage(8),
                               GetMessage(9)).
        if CallStack > "" then 
            cMsg = cMsg 
                 + "~n~n"
                 + "Call Stack:"
                 + "~n------------~n"
                 + CallStack.                  
        if valid-object(InnerError) then 
        do:
            if type-of(InnerError, ApplicationError) then                     
                cInnerMsg = cast(InnerError, ApplicationError):ResolvedMessageText().
            else if type-of(InnerError,AppError) then
                cInnerMsg = CoreErrorMessageText(cast(InnerError, AppError)).
            else 
                cInnerMsg = CoreErrorMessageText(InnerError).
            if cInnerMsg > "" then
            do:
               cMsg = cMsg 
                    + (if cMsg = "" then "" 
                       else "~n~n" 
                            + "Caused by:" 
                            + "~n") 
                    + cInnerMsg.
               if InnerError:CallStack > "" then 
                  cMsg = cMsg 
                       + "~n~n"
                       + "Call Stack:"
                       + "~n------------~n"
                       + InnerError:CallStack.
            end.       
        end.     
        
        return cMsg.                 
    end method.
    
    /* returns text for an AppError 
       If there is a ReturnValue then NumMessages will not be checked or used  */  
    method protected character CoreErrorMessageText (poErr as AppError):
        if poErr:ReturnValue > "" then 
            return poErr:ReturnValue.
        else  
            return CoreErrorMessagetext(cast(poErr,Error)).   
    end method.
    
    method protected character CoreErrorMessageText (poErr as Error):
        define variable cMsg as character no-undo.
        define variable i as integer no-undo. 
       
        do i = 1 to poErr:NumMessages:
            cMsg = cMsg 
                 + (if cMsg = "" then "" else "~n~n") 
                 + poErr:GetMessage(i).
        end.    
       
        return cMsg.
    end method.
         
    method public override Object Clone():
        define variable oClone as ApplicationError no-undo.
        define variable oClass as class Class no-undo. 
        define variable iLoop  as integer no-undo. 
        oClass = this-object:GetClass().
        oClone = cast(oClass:New(), ApplicationError).
        do iLoop = 1 to NumMessages:
            oClone:AddMessage(GetMessage(iLoop), iLoop).
        end.
        oClone:Severity = this-object:Severity.
        
        return oClone.
    end method.
    
end class.