/*------------------------------------------------------------------------
    File        : as_startup.p
    Purpose     : AppServer startup procedure 
    
    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jun 04 13:54:27 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- params, defs -- **/
define input parameter pcStartupData as character no-undo.

run OpenEdge/CommonInfrastructure/Common/start_session.p (session:client-type).

error-status:error = no.
return.

/** -- error handling -- **/
catch oApplError as ApplicationError:
    return error oApplError:ResolvedMessageText().
end catch.

catch oAppError as AppError:
    return error oAppError:ReturnValue. 
end catch.

catch oError as Error:
    return error oError:GetMessage(1).
end catch.

/** -- eof -- **/