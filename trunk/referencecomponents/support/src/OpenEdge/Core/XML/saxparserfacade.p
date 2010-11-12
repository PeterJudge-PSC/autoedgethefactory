/** ------------------------------------------------------------------------
    File        : saxparserfacade.p
    Purpose     : XML SAX parser

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Jul 13 09:40:09 EDT 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.XML.SaxParser.

/* ***************************  Definitions  ************************** */
/** The facade object that handles the callbacks from the SAX parser, and which
    publishes them as typed events. */
define input parameter poWrapper as SaxParser no-undo.

create widget-pool.

/* ***************************  Main Block  *************************** */

procedure ParseDocument:
    define input parameter pcXML as longchar no-undo.
    
    define variable hSaxReader as handle no-undo.
    define variable hSaxAttributes as handle no-undo.
    
    create sax-reader hSaxReader.
    hSaxReader:handler = this-procedure.
    
    create sax-attributes hSaxAttributes.
    
    hSaxReader:set-input-source('longchar', pcXML).
    hSaxReader:sax-parse() no-error.
    
    delete object hSaxAttributes no-error.
    delete object hSaxReader no-error.
end procedure.

/* ***************************  Callbacks  *************************** */

/* Tell the parser where to find an external entity. */
procedure ResolveEntity:
    define input  parameter publicID   as character no-undo.
    define input  parameter systemID   as character no-undo.
    define output parameter filePath   as character no-undo.
    define output parameter memPointer as longchar no-undo.
    
    poWrapper:ResolveEntity(publicID, systemID, output filePath, output memPointer).
end procedure.

/** Process various XML tokens. */
procedure StartDocument:
    poWrapper:StartDocument().
end procedure.

procedure ProcessingInstruction:
    define input parameter target as character no-undo.
    define input parameter data   as character no-undo.
    
    poWrapper:ProcessingInstruction(target, data).
end procedure.

procedure StartPrefixMapping:
    define input parameter prefix as character no-undo.
    define input parameter uri    as character no-undo.
    
    poWrapper:StartPrefixMapping(prefix, uri).
end procedure.

procedure EndPrefixMapping:    
    define input parameter prefix as character no-undo.
    
    poWrapper:EndPrefixMapping(prefix).
end procedure.

procedure StartElement:
    define input parameter namespaceURI as character no-undo.
    define input parameter localName    as character no-undo.
    define input parameter qName        as character no-undo.
    define input parameter attributes   as handle no-undo.
    
    poWrapper:StartElement(namespaceURI, localName, qName, attributes).
end procedure.

procedure Characters:
    define input parameter charData as longchar no-undo.
    define input parameter numChars as integer no-undo.
    
    poWrapper:Characters(charData, numChars).
end procedure.

procedure IgnorableWhitespace:
    define input parameter charData as character no-undo.
    define input parameter numChars as integer.
    
    poWrapper:IgnorableWhitespace(charData, numChars).
end procedure.

procedure EndElement:
     define input parameter namespaceURI as character no-undo.
     define input parameter localName    as character no-undo.
     define input parameter qName        as character no-undo.
     
     poWrapper:EndElement(namespaceURI, localName, qName).
end procedure.

procedure EndDocument:
    poWrapper:EndDocument().
end procedure.

/** Process notations and unparsed entities.*/
procedure NotationDecl:
    define input parameter name     as character no-undo.
    define input parameter publicID as character no-undo.
    define input parameter systemID as character no-undo.
    
    poWrapper:NotationDecl(name, publicID, systemID).
end procedure.

procedure UnparsedEntityDecl:
    define input parameter name         as character no-undo.
    define input parameter publicID     as character no-undo.
    define input parameter systemID     as character no-undo.
    define input parameter notationName as character no-undo.
    
    poWrapper:UnparsedEntityDecl(name, publicID, systemID, notationName).
end procedure.

/*Handle errors.*/
procedure Warning:
    define input parameter errMessage as character no-undo.
    
    poWrapper:Warning(errMessage).
end procedure.

procedure Error:
    define input parameter errMessage as character no-undo.
     
    poWrapper:Error(errMessage).
end procedure.

procedure FatalError:
    define input parameter errMessage as character no-undo.
    
    poWrapper:FatalError(errMessage).
end procedure.