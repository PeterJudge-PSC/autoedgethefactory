/** ------------------------------------------------------------------------
    File        : SaxParser
    Purpose     : Facade to OpenEdge/Core/XML/saxparser.p which handles SAX
                  parser events.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 13 09:50:23 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

class OpenEdge.Core.XML.SaxParser:
    
    /* SAX Events from SAX-READER callbacks */
    define public event SaxParserStartDocument signature void(input phReader as handle).
     
    define public event SaxParserProcessingInstruction signature void (input phReader as handle, 
                                                                       input pcTarget as character,
                                                                       input pcData as character).    
    define public event SaxParserResolveEntity signature void (input phReader as handle,
                                                               input pcPublicID as character,
                                                               input pcSystemID as character,
                                                               output pcFilePath as character,
                                                               output pcMemPointer as longchar).
    define public event SaxParserStartPrefixMapping signature void (input phReader as handle,
                                                                    input pcPrefix as character,
                                                                    input pcURI as character).    
    define public event SaxParserEndPrefixMapping signature void (input phReader as handle,
                                                                  input pcPrefix as character).    
    define public event SaxParserStartElement signature void (input phReader as handle,
                                                              input pcNamespaceURI as character,
                                                              input pcLocalName as character,
                                                              input pcQName as character,
                                                              input phAttributes as handle ).
    define public event SaxParserCharacters signature void (input phReader as handle,
                                                            input pcCharData as longchar,
                                                            input piNumChars as integer).
    define public event SaxParserIgnorableWhitespace signature void (input phReader as handle,
                                                                     input pcCharData as character,
                                                                     input piNumChars as integer).
    define public event SaxParserEndElement signature void (input phReader as handle,
                                                            input pcName  as character,
                                                            input pcPublicID as character,
                                                            input pcSystemID as character).
    define public event SaxParserEndDocument signature void (input phReader as handle).
    define public event SaxParserNotationDecl signature void (input phReader as handle,
                                                              input pcName  as character,
                                                              input pcPublicID as character,
                                                              input pcSystemID as character).
    define public event SaxParserUnparsedEntityDecl signature void (input phReader as handle,
                                                                    input pcName as character,
                                                                    input publicID     as character,
                                                                    input systemID     as character,
                                                                    input pcNotationName as character).    
    define public event SaxParserWarning signature void (input phReader as handle,
                                                         input pcErrMessage as character).
    define public event SaxParserError signature void (input phReader as handle,
                                                       input pcErrMessage as character).
    define public event SaxParserFatalError signature void (input phReader as handle,
                                                            input pcErrMessage as character).
    
    define private variable mhParserProc as handle no-undo.
    
    constructor public SaxParser():        
        run OpenEdge/Core/XML/saxparserfacade.p persistent set mhParserProc (this-object).        
    end constructor.
    
    destructor public SaxParser():
        delete procedure mhParserProc no-error.
    end destructor.
    
    method public void ParseDocument(pcXML as longchar):
        run ParseDocument in mhParserProc (pcXML).
    end method.
    
    /* Tell the parser where to find an external entity. */
    method public void ResolveEntity (input pcPublicID as character,
                                      input pcSystemID as character,
                                      output pcFilePath as character,
                                      output pcMemPointer as longchar):
        SaxParserResolveEntity:Publish(self:handle, pcPublicID, pcSystemID, output pcFilePath, output pcMemPointer).                                          
    end method.
    
    /** Process various XML tokens. */
    method public void StartDocument():
        SaxParserStartDocument:Publish(self:handle).
    end method.
    
    method public void ProcessingInstruction(input pcTarget as character,
                                             input pcData as character):
        SaxParserProcessingInstruction:Publish(self:handle, pcTarget, pcData).
    end method.
    
    method public void StartPrefixMapping(input pcPrefix as character,
                                          input pcURI as character):
        SaxParserStartPrefixMapping:Publish(self:handle, pcPrefix, pcURI).                                              
    end method.

    method public void EndPrefixMapping(input pcPrefix as character):
        SaxParserEndPrefixMapping:Publish(self:handle, pcPrefix).
    end method.

    method public void StartElement(input pcNamespaceURI as character,
                                    input pcLocalName as character,
                                    input pcQName as character,
                                    input phAttributes as handle ):
        SaxParserStartElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName, phAttributes).                                        
    end method.

    method public void Characters(input pcCharData as longchar,
                                  input piNumChars as integer):
        SaxParserCharacters:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void IgnorableWhitespace(input pcCharData as character,
                                           input piNumChars as integer):
        SaxParserIgnorableWhitespace:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void EndElement(input pcNamespaceURI as character,
                                  input pcLocalName as character,
                                  input pcQName as character):
        SaxParserEndElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName).                                      
    end method.

    method public void EndDocument():
        SaxParserEndDocument:Publish(self:handle).
    end method.

    /** Process notations and unparsed entities.*/
    method public void NotationDecl(input pcName  as character,
                                    input pcPublicID as character,
                                    input pcSystemID as character):
        SaxParserNotationDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID).                                        
    end method.

    method public void UnparsedEntityDecl(input pcName as character,
                                          input pcPublicID as character,
                                          input pcSystemID as character,
                                          input pcNotationName as character):
        SaxParserUnparsedEntityDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID, pcNotationName).                                              
    end method.

    /*Handle errors.*/
    method public void Warning(input pcErrMessage as character):
        SaxParserWarning:Publish(self:handle, pcErrMessage).
    end method.

    method public void Error(input pcErrMessage as character):
        SaxParserError:Publish(self:handle, pcErrMessage).
    end method.

    method public void FatalError(input pcErrMessage as character):
        SaxParserFatalError:Publish(self:handle, pcErrMessage).
    end method. 
    
end class.