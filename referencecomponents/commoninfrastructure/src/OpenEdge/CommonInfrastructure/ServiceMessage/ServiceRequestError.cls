/** ------------------------------------------------------------------------
    File        : ServiceRequestError
    Purpose     : Error thrown on ServiceRequest error. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 22:03:24 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequestError inherits ApplicationError: 

	define override protected property ErrorText as character no-undo get. private set. 
	define override protected property ErrorTitle as character no-undo get. private set. 
		
	constructor public ServiceRequestError(input poInnerError as Error):
		super(input poInnerError).
		
	   assign ErrorTitle = 'Service Request Error'
	          ErrorText = 'Error &1 on service request &2'.
	end constructor.

    constructor public ServiceRequestError(pcArgs1 as char, pcArgs2 as char):
        this-object(?, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public ServiceRequestError(poInnerError as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poInnerError).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class.