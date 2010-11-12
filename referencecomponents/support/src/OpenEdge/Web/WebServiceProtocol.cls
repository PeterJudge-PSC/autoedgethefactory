/** ------------------------------------------------------------------------
    File        : WebServiceProtocol
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 02 12:01:04 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

class OpenEdge.Web.WebServiceProtocol abstract:
    define protected property Service as character no-undo get. private set.
    define protected property WSDL as character no-undo get. private set.
    define protected property ConnectionParams as character no-undo get. private set.
    
    define protected property WebServiceHandle as handle no-undo get. private set.
    define protected property PortHandle as handle no-undo get. private set.
    
    define public property Connected as logical no-undo 
        get():
            return (valid-handle(WebServiceHandle) and WebServiceHandle:connected()).
        end get.
    
    constructor public WebServiceProtocol(pcService as character,
                                          pcWSDL as character,
                                          pcConnectionParams as character):
            assign Service = pcService
                   WSDL = pcWSDL
                   ConnectionParams = pcConnectionParams.
    end constructor.
    
    method static public character XmlTypeFromABL(pcABLType as character):
        define variable cXmlType as character no-undo.
        
        case pcABLType:
            when 'datetime' then cXmlType = 'dateTime'. 
            otherwise cXmlType = lc(pcABLType).
        end case.
        
        return cXmlType.
    end method.
    
    method static public character XmlDateTimeFromABL(ptValue as datetime-tz):
        define variable cDateFormat as character no-undo.
        
        cDateFormat = session:date-format.
        session:date-format = 'ymd'.
        
        return iso-date(ptValue).
        finally:
            session:date-format = cDateFormat.        
        end finally.
    end method.
    
    method public longchar ExecuteOperation(input pcPortTypeName as character,
                                            input pcOperationName as character,
                                            input pcInputParam as longchar):
        define variable cOutputParam as longchar no-undo.
        
        ConnectService().
                
        run value(pcOperationName) in ConnectPortType(pcPortTypeName) (input pcInputParam, output cOutputParam).
        
        return cOutputParam.
        
        catch eSoapFaultError as Progress.Lang.SoapFaultError:
            message 
            eSoapFaultError:SoapFault skip
            eSoapFaultError:GetMessage(1)
            view-as alert-box.    
        end catch.
        catch eError as Progress.Lang.Error:
            message 
            eError:GetMessage(1)
            view-as alert-box.
            
        end catch.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.                
    end method.
    
    method public void ConnectService():
        define variable cConnectString as character no-undo.
        
        if not this-object:Connected then
        do:
            cConnectString = substitute('-S &1 -WSDL &2 &3',
                                this-object:Service,
                                this-object:WSDL,
                                this-object:ConnectionParams).
            
            create server WebServiceHandle.
            WebServiceHandle:connect(cConnectString).
        end.
    end method.
    
    method public void DisconnectService():
        if this-object:Connected then
            WebServiceHandle:disconnect().
    end method.
        
    method protected handle ConnectPortType(pcPortType as character):
        if not this-object:Connected then
            undo, throw new Progress.Lang.AppError(substitute('Service &1 not connected', this-object:Service)).
        
        run value(pcPortType) set PortHandle on server WebServiceHandle no-error.
        
        return PortHandle.
    end method.
    
    method protected handle DisconnectPortType():
        delete object PortHandle no-error.
    end method.
    
end class.