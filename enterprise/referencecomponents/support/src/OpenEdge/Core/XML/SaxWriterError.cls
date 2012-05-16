/** ------------------------------------------------------------------------
    File        : SaxWriterError
    Purpose     : Application error raised when errors are raised by the SaxWriter / SAX-WRITER
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 22 16:04:57 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.XML.SaxWriterError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 

    constructor public SaxWriterError(input poInnerError as Error):
        super(poInnerError).
        
        this-object:ErrorTitle = 'Sax Writer Error'.
        this-object:ErrorText = 'Error &1 &2'.
    end constructor.

    constructor public SaxWriterError(input poErr as Error,
                                      input pcArgs1 as character,
                                      input pcArgs2 as character):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

    constructor public SaxWriterError(input pcArgs1 as character,
                                      input pcArgs2 as character):
        this-object(?).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class.