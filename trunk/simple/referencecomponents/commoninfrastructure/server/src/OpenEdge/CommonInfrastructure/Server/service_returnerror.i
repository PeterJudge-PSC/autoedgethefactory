/** ------------------------------------------------------------------------
    File        : OpenEdge/CommonInfrastructure/Server/service_returnerror.i
    Purpose     : Server-side include for common error handling.                   
    @author pjudge
    Created     : Fri Jan 20 09:43:17 EST 2012
    Arguments   : RETURN-PARAM   : Caught errors are returned in string form in a variable/parameter 
                  [default] RETURN-ERROR   : Caught errors are returned in string form via RETURN ERROR
                  RETURN-NOERROR : Caught errors are returned in string form via RETURN without raising the error status.
                  THROW-ERROR    : Caught errors are re-thrown. This will fail on an AppServer, with ABL error 14438.
                  
                  LOG-ERROR      : Errors logged to system log via LOG-MANAGER (indep. of above)
                  
    Notes       : * All arguments are optional.
                  * All arguments default to false or empty
                  * The order of precedence is RETURN-ERROR, THROW-ERROR, RETURN-NOERROR, RETURN-PARAM 
  ---------------------------------------------------------------------- */
&if defined(RETURN-PARAM) eq 0 &then
    &global-define RETURN-PARAM  
&endif

&if "{&RETURN-PARAM}" ne "" &then
    &undefine THROW-ERROR
    &global-define THROW-ERROR false
    
    &undefine RETURN-ERROR
    &global-define RETURN-ERROR false
    
    &undefine RETURN-NOERROR
    &global-define RETURN-NOERROR false
&endif
  
&if defined(THROW-ERROR) eq 0 &then
    &global-define THROW-ERROR false
&endif 

&if "{&THROW-ERROR}" eq "true" &then
    &if defined(RETURN-ERROR) gt 0 &then
        &undefine RETURN-ERROR
    &endif
    &global-define RETURN-ERROR false
    
    &if defined(RETURN-NOERROR) gt 0 &then
        &undefine RETURN-NOERROR
    &endif
    &global-define RETURN-NOERROR false
    
    &undefine RETURN-PARAM
    &global-define RETURN-PARAM 
&endif

&if defined(RETURN-NOERROR) eq 0 &then
    &global-define RETURN-NOERROR false
&endif

&if "{&RETURN-NOERROR}" eq "true" &then
    &undefine THROW-ERROR 
    &global-define THROW-ERROR false
    
    &undefine RETURN-ERROR
    &global-define RETURN-ERROR false
    
    &undefine RETURN-PARAM
    &global-define RETURN-PARAM 
&endif

&if defined(RETURN-ERROR) eq 0 &then
    &global-define RETURN-ERROR true
&endif

&if "{&RETURN-ERROR}" eq "true" &then
    &undefine THROW-ERROR
    &global-define THROW-ERROR false
    
    &undefine RETURN-NOERROR
    &global-define RETURN-NOERROR false
    
    &undefine RETURN-PARAM
    &global-define RETURN-PARAM 
&endif

&if defined(LOG-ERROR) eq 0 &then
    &global-define LOG-ERROR false
&endif 

/* if nothing is specified, automatically log errors. */
&if "{&THROW-ERROR}" eq "false" and
    "{&RETURN-ERROR}" eq "false" and 
    "{&RETURN-NOERROR}" eq "false" and
    "{&RETURN-PARAM}" eq "" &then
    &undefine LOG-ERROR 
    &global-define LOG-ERROR true
&endif

/** -- error handling -- **/
catch oApplicationError as OpenEdge.Core.System.ApplicationError:
    &if "{&LOG-ERROR}" eq "true" &then 
    oApplicationError:LogError().
    &endif
    
    &if "{&RETURN-PARAM}" ne "" &then
    assign error-status:error = false
           {&RETURN-PARAM} = oApplicationError:ResolvedMessageText. 
    &elseif "{&RETURN-ERROR}" eq "true" &then
    return error oApplicationError:ResolvedMessageText().
    &elseif "{&RETURN-NOERROR}" eq "true" &then
    return oApplicationError:ResolvedMessageText().
    &elseif "{&THROW-ERROR}" eq "true" &then
    undo, throw oApplicationError.    
    &endif
end catch.

catch oError as Progress.Lang.Error:
    define variable oUHError as OpenEdge.Core.System.UnhandledError no-undo.
    oUHError = new OpenEdge.Core.System.UnhandledError(oError).
    
    &if "{&LOG-ERROR}" eq "true" &then      
    oUHError:LogError().
    &endif
    
    &if "{&RETURN-PARAM}" ne "" &then 
    assign error-status:error = false
           {&RETURN-PARAM} = oError:ResolvedMessageText().  
    &elseif "{&RETURN-ERROR}" eq "true" &then 
    return error oUHError:ResolvedMessageText(). 
    &elseif "{&RETURN-NOERROR}" eq "true" &then
    return oError:ResolvedMessageText.
    &elseif "{&THROW-ERROR}" eq "true" &then
    undo, throw oUHError.    
    &endif
end catch.
/** eof **/