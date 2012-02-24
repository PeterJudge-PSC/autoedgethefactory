/** ------------------------------------------------------------------------
    File        : UnhandledError
    Purpose     : An OE ApplicationError to wrap any unhandled PLE that may come along.
                  This allows us to use the standard ShowMessage() etc constructs that
                  are part of the ApplicationError 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue May 03 14:14:57 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.Assert.
using Progress.Lang.Error.
using Progress.Lang.Class.

class OpenEdge.Core.System.UnhandledError inherits ApplicationError: 
	define override protected property ErrorText as longchar no-undo get. set. 
	define override protected property ErrorTitle as character no-undo get. set. 
		
	constructor public UnhandledError (input poInnerError as Error):
		super(input poInnerError).
		
		/* this class is only meant for non-ApplicationError errors (ie the unhandled ones :) ) */
		Assert:ArgumentNotType(poInnerError, Class:GetClass('OpenEdge.Core.System.ApplicationError')).
		
        ErrorText = 'Unhandled error &1'.
        ErrorTitle = 'Unhandled Progress.Lang.Error'.
	end constructor.

    /** For these unhandled errors, there is no containing error, so we only show the inner error's
        resovled text. */
    method override public character ResolvedMessageText():
        return ResolveInnerErrorText('').
	end method.
	
end class.