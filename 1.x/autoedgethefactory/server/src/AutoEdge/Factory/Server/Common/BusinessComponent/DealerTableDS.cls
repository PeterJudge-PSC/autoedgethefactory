/** ------------------------------------------------------------------------
    File        : DealerTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 25 14:23:38 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Server.Common.BusinessComponent.DealerTableDS inherits StandardDataSource:
     
    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                create buffer PrimaryTable for table buffer Dealer:handle.
            
            return PrimaryTable.
        end get.
        set.
    
	constructor public DealerTableDS ( input poComponentInfo as IComponentInfo ):
		super (input poComponentInfo).
	end constructor.
	
end class.