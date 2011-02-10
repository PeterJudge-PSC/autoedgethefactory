/** ------------------------------------------------------------------------
    File        : SavvionParameters
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 06 15:20:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.EnterpriseServices.BizLogic.BizLogicServerParameters.

class AutoEdge.Factory.Common.EnterpriseServices.SavvionParameters inherits BizLogicServerParameters:
    
    constructor public SavvionParameters():
        super('AutoEdgeTheFactory-Default',
              '127.0.0.1',
              'ebms',
              'ebms').
    end constructor.
    
end class.