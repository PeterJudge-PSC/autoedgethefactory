/** ------------------------------------------------------------------------
    File        : OrderListForm
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Dec 16 11:33:05 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using Progress.Windows.Form.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IConnectionManager.
using OpenEdge.CommonInfrastructure.Common.ConnectionManager.
using OpenEdge.CommonInfrastructure.Common.ConnectionTypeEnum.

using OpenEdge.Lang.String.
using OpenEdge.Lang.ABLSession.


class AutoEdge.Factory.Client.Order.PresentationLayer.OrderListForm inherits Form: 
    
    define private variable bsOrders as Progress.Data.BindingSource no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable uxOrders as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.

    define private variable mhOrders as handle no-undo. 

    /** (mandatory) The session's service manager. Used to determine the ServiceMessageManager and 
        other managers for callbacks, context and more. */
    define protected property SvcMgr as IServiceManager no-undo
        get():
            if not valid-object(SvcMgr) then
                SvcMgr = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
            
            return SvcMgr.
        end get.
        private set.
        
    /** The ConnectionManager is used plentifully; we keep it as a property so that
        we can get it whenever needed, without fuss. */
    define protected property ConnMgr as IConnectionManager no-undo
        get():
            if not valid-object(ConnMgr) then
                ConnMgr = cast(SvcMgr:GetService(ConnectionManager:IConnectionManagerType) , IConnectionManager).
            return ConnMgr.
        end get.
        private set.
        
    constructor public OrderListForm (  ):
        super().
        InitializeComponent().
        
        InitData().
        
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

    method private void InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("eOrder").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc2 as Progress.Data.TableDesc no-undo.
        tableDesc2 = new Progress.Data.TableDesc("eOrderLine").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc3 as Progress.Data.TableDesc no-undo.
        tableDesc3 = new Progress.Data.TableDesc("eItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc4 as Progress.Data.TableDesc no-undo.
        tableDesc4 = new Progress.Data.TableDesc("eFinishedItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc5 as Progress.Data.TableDesc no-undo.
        tableDesc5 = new Progress.Data.TableDesc("eComponentItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance21 as Infragistics.Win.Appearance no-undo.
        appearance21 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand1 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand1 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eOrder", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn5 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn5 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerName").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn6 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn6 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn7 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn7 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerPO").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn24 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn24 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderAmount").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn9 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn9 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("EnteredDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn10 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn10 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FromEmail").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn25 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn25 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SalesrepCode").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn26 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn26 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("DealerCode").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn47 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn47 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("eOrderLine").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn11 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn11 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Instructions").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn14 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn14 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn15 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn15 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn16 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn16 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn22 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn22 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderStatus").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand2 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand2 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eOrderLine", 0).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn27 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn27 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn28 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn28 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("LineNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn29 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn29 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Price").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn30 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn30 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Quantity").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn31 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn31 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Discount").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn32 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn32 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn33 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn33 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderLineStatus").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn34 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn34 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FinishedItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn35 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn35 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("eItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn48 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn48 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("eFinishedItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand3 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand3 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eItem", 1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn36 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn36 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn37 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn37 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn38 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn38 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemName").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn39 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn39 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemType").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn40 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn40 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Description").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn41 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn41 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Price").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand4 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand4 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eFinishedItem", 1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn42 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn42 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FinishedItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn43 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn43 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn44 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn44 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("StatusDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn45 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn45 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FinishedItemStatus").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn46 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn46 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ExternalId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn49 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn49 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("eComponentItem").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand5 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand5 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eComponentItem", 3).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn50 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn50 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn51 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn51 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FinishedItemId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn52 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn52 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Quantity").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance22 as Infragistics.Win.Appearance no-undo.
        appearance22 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance23 as Infragistics.Win.Appearance no-undo.
        appearance23 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance24 as Infragistics.Win.Appearance no-undo.
        appearance24 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance13 as Infragistics.Win.Appearance no-undo.
        appearance13 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance14 as Infragistics.Win.Appearance no-undo.
        appearance14 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance15 as Infragistics.Win.Appearance no-undo.
        appearance15 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance16 as Infragistics.Win.Appearance no-undo.
        appearance16 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance17 as Infragistics.Win.Appearance no-undo.
        appearance17 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance18 as Infragistics.Win.Appearance no-undo.
        appearance18 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance19 as Infragistics.Win.Appearance no-undo.
        appearance19 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance20 as Infragistics.Win.Appearance no-undo.
        appearance20 = new Infragistics.Win.Appearance().
        this-object:bsOrders = new Progress.Data.BindingSource(this-object:components).
        this-object:uxOrders = new Infragistics.Win.UltraWinGrid.UltraGrid().
        cast(this-object:bsOrders, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxOrders, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* bsOrders */
        /*  */
        this-object:bsOrders:MaxDataGuess = 0.
        this-object:bsOrders:NoLOBs = false.
        this-object:bsOrders:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar0 = new "Progress.Data.TableDesc[]"(0).
        tableDesc3:ChildTables = arrayvar0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 6 no-undo.
        arrayvar1[1] = new Progress.Data.ColumnPropDesc("ItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[2] = new Progress.Data.ColumnPropDesc("ItemNum", "", Progress.Data.DataType:INTEGER).
        arrayvar1[3] = new Progress.Data.ColumnPropDesc("ItemName", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[4] = new Progress.Data.ColumnPropDesc("ItemType", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[5] = new Progress.Data.ColumnPropDesc("Description", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[6] = new Progress.Data.ColumnPropDesc("Price", "", Progress.Data.DataType:DECIMAL).
        tableDesc3:Columns = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar2 = new "Progress.Data.TableDesc[]"(0).
        tableDesc5:ChildTables = arrayvar2.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as Progress.Data.ColumnPropDesc extent 3 no-undo.
        arrayvar3[1] = new Progress.Data.ColumnPropDesc("ItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar3[2] = new Progress.Data.ColumnPropDesc("FinishedItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar3[3] = new Progress.Data.ColumnPropDesc("Quantity", "", Progress.Data.DataType:DECIMAL).
        tableDesc5:Columns = arrayvar3.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as Progress.Data.TableDesc extent 1 no-undo.
        arrayvar4[1] = tableDesc5.
        tableDesc4:ChildTables = arrayvar4.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as Progress.Data.ColumnPropDesc extent 5 no-undo.
        arrayvar5[1] = new Progress.Data.ColumnPropDesc("FinishedItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[2] = new Progress.Data.ColumnPropDesc("ItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[3] = new Progress.Data.ColumnPropDesc("StatusDate", "", Progress.Data.DataType:DATETIME_TZ).
        arrayvar5[4] = new Progress.Data.ColumnPropDesc("FinishedItemStatus", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[5] = new Progress.Data.ColumnPropDesc("ExternalId", "", Progress.Data.DataType:CHARACTER).
        tableDesc4:Columns = arrayvar5.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar6 as Progress.Data.TableDesc extent 2 no-undo.
        arrayvar6[1] = tableDesc3.
        arrayvar6[2] = tableDesc4.
        tableDesc2:ChildTables = arrayvar6.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar7 as Progress.Data.ColumnPropDesc extent 8 no-undo.
        arrayvar7[1] = new Progress.Data.ColumnPropDesc("OrderId", "", Progress.Data.DataType:CHARACTER).
        arrayvar7[2] = new Progress.Data.ColumnPropDesc("LineNum", "", Progress.Data.DataType:INTEGER).
        arrayvar7[3] = new Progress.Data.ColumnPropDesc("Price", "", Progress.Data.DataType:DECIMAL).
        arrayvar7[4] = new Progress.Data.ColumnPropDesc("Quantity", "", Progress.Data.DataType:INTEGER).
        arrayvar7[5] = new Progress.Data.ColumnPropDesc("Discount", "", Progress.Data.DataType:INTEGER).
        arrayvar7[6] = new Progress.Data.ColumnPropDesc("ItemId", "", Progress.Data.DataType:CHARACTER).
        arrayvar7[7] = new Progress.Data.ColumnPropDesc("OrderLineStatus", "", Progress.Data.DataType:CHARACTER).
        arrayvar7[8] = new Progress.Data.ColumnPropDesc("FinishedItemId", "", Progress.Data.DataType:CHARACTER).
        tableDesc2:Columns = arrayvar7.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar8 as Progress.Data.TableDesc extent 1 no-undo.
        arrayvar8[1] = tableDesc2.
        tableDesc1:ChildTables = arrayvar8.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar9 as Progress.Data.ColumnPropDesc extent 13 no-undo.
        arrayvar9[1] = new Progress.Data.ColumnPropDesc("OrderNum", "", Progress.Data.DataType:INTEGER).
        arrayvar9[2] = new Progress.Data.ColumnPropDesc("OrderId", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[3] = new Progress.Data.ColumnPropDesc("OrderDate", "", Progress.Data.DataType:DATE).
        arrayvar9[4] = new Progress.Data.ColumnPropDesc("EnteredDate", "", Progress.Data.DataType:DATETIME_TZ).
        arrayvar9[5] = new Progress.Data.ColumnPropDesc("FromEmail", "", Progress.Data.DataType:LOGICAL).
        arrayvar9[6] = new Progress.Data.ColumnPropDesc("CustomerNum", "", Progress.Data.DataType:INTEGER).
        arrayvar9[7] = new Progress.Data.ColumnPropDesc("CustomerName", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[8] = new Progress.Data.ColumnPropDesc("CustomerPO", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[9] = new Progress.Data.ColumnPropDesc("OrderAmount", "", Progress.Data.DataType:DECIMAL).
        arrayvar9[10] = new Progress.Data.ColumnPropDesc("OrderStatus", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[11] = new Progress.Data.ColumnPropDesc("Instructions", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[12] = new Progress.Data.ColumnPropDesc("SalesrepCode", "", Progress.Data.DataType:CHARACTER).
        arrayvar9[13] = new Progress.Data.ColumnPropDesc("DealerCode", "", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar9.
        this-object:bsOrders:TableSchema = tableDesc1.
        /*  */
        /* uxOrders */
        /*  */
        this-object:uxOrders:DataSource = this-object:bsOrders.
        appearance21:BackColor = System.Drawing.SystemColors:Window.
        appearance21:BorderColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxOrders:DisplayLayout:Appearance = appearance21.
        ultraGridColumn5:Header:VisiblePosition = 0.
        ultraGridColumn5:RowLayoutColumnInfo:OriginX = 4.
        ultraGridColumn5:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn5:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(283, 0).
        ultraGridColumn5:RowLayoutColumnInfo:SpanX = 4.
        ultraGridColumn5:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn6:Header:VisiblePosition = 1.
        ultraGridColumn7:Header:VisiblePosition = 2.
        ultraGridColumn7:Hidden = true.
        ultraGridColumn7:RowLayoutColumnInfo:OriginX = 15.
        ultraGridColumn7:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn7:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn7:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn24:Header:VisiblePosition = 3.
        ultraGridColumn9:Header:VisiblePosition = 4.
        ultraGridColumn9:RowLayoutColumnInfo:OriginX = 2.
        ultraGridColumn9:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn9:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn9:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn10:Header:VisiblePosition = 5.
        ultraGridColumn10:Hidden = true.
        ultraGridColumn10:RowLayoutColumnInfo:OriginX = 10.
        ultraGridColumn10:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn10:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(89, 0).
        ultraGridColumn10:RowLayoutColumnInfo:SpanX = 3.
        ultraGridColumn10:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn25:Header:VisiblePosition = 6.
        ultraGridColumn26:Header:VisiblePosition = 7.
        ultraGridColumn47:Header:VisiblePosition = 13.
        ultraGridColumn11:Header:VisiblePosition = 8.
        ultraGridColumn11:RowLayoutColumnInfo:OriginX = 0.
        ultraGridColumn11:RowLayoutColumnInfo:OriginY = 4.
        ultraGridColumn11:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(468, 0).
        ultraGridColumn11:RowLayoutColumnInfo:SpanX = 10.
        ultraGridColumn11:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn14:Header:VisiblePosition = 9.
        ultraGridColumn14:RowLayoutColumnInfo:OriginX = 4.
        ultraGridColumn14:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn14:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(194, 0).
        ultraGridColumn14:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn14:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn15:Header:VisiblePosition = 10.
        ultraGridColumn15:Hidden = true.
        ultraGridColumn15:RowLayoutColumnInfo:OriginX = 25.
        ultraGridColumn15:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn15:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn15:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn16:Header:VisiblePosition = 11.
        ultraGridColumn16:RowLayoutColumnInfo:OriginX = 1.
        ultraGridColumn16:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn16:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(186, 0).
        ultraGridColumn16:RowLayoutColumnInfo:SpanX = 3.
        ultraGridColumn16:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn22:Header:VisiblePosition = 12.
        ultraGridColumn22:RowLayoutColumnInfo:OriginX = 8.
        ultraGridColumn22:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn22:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(184, 0).
        ultraGridColumn22:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn22:RowLayoutColumnInfo:SpanY = 2.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar10 as System.Object extent 14 no-undo.
        arrayvar10[1] = ultraGridColumn5.
        arrayvar10[2] = ultraGridColumn6.
        arrayvar10[3] = ultraGridColumn7.
        arrayvar10[4] = ultraGridColumn24.
        arrayvar10[5] = ultraGridColumn9.
        arrayvar10[6] = ultraGridColumn10.
        arrayvar10[7] = ultraGridColumn25.
        arrayvar10[8] = ultraGridColumn26.
        arrayvar10[9] = ultraGridColumn47.
        arrayvar10[10] = ultraGridColumn11.
        arrayvar10[11] = ultraGridColumn14.
        arrayvar10[12] = ultraGridColumn15.
        arrayvar10[13] = ultraGridColumn16.
        arrayvar10[14] = ultraGridColumn22.
        ultraGridBand1:Columns:AddRange(arrayvar10).
        ultraGridBand1:RowLayoutLabelPosition = Infragistics.Win.UltraWinGrid.LabelPosition:Top.
        ultraGridBand1:RowLayoutStyle = Infragistics.Win.UltraWinGrid.RowLayoutStyle:GroupLayout.
        ultraGridColumn27:Header:VisiblePosition = 0.
        ultraGridColumn28:Header:VisiblePosition = 1.
        ultraGridColumn29:Header:VisiblePosition = 2.
        ultraGridColumn30:Header:VisiblePosition = 3.
        ultraGridColumn31:Header:VisiblePosition = 4.
        ultraGridColumn32:Header:VisiblePosition = 5.
        ultraGridColumn33:Header:VisiblePosition = 6.
        ultraGridColumn34:Header:VisiblePosition = 7.
        ultraGridColumn35:Header:VisiblePosition = 8.
        ultraGridColumn48:Header:VisiblePosition = 9.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar11 as System.Object extent 10 no-undo.
        arrayvar11[1] = ultraGridColumn27.
        arrayvar11[2] = ultraGridColumn28.
        arrayvar11[3] = ultraGridColumn29.
        arrayvar11[4] = ultraGridColumn30.
        arrayvar11[5] = ultraGridColumn31.
        arrayvar11[6] = ultraGridColumn32.
        arrayvar11[7] = ultraGridColumn33.
        arrayvar11[8] = ultraGridColumn34.
        arrayvar11[9] = ultraGridColumn35.
        arrayvar11[10] = ultraGridColumn48.
        ultraGridBand2:Columns:AddRange(arrayvar11).
        ultraGridColumn36:Header:VisiblePosition = 0.
        ultraGridColumn37:Header:VisiblePosition = 1.
        ultraGridColumn38:Header:VisiblePosition = 2.
        ultraGridColumn39:Header:VisiblePosition = 3.
        ultraGridColumn40:Header:VisiblePosition = 4.
        ultraGridColumn41:Header:VisiblePosition = 5.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar12 as System.Object extent 6 no-undo.
        arrayvar12[1] = ultraGridColumn36.
        arrayvar12[2] = ultraGridColumn37.
        arrayvar12[3] = ultraGridColumn38.
        arrayvar12[4] = ultraGridColumn39.
        arrayvar12[5] = ultraGridColumn40.
        arrayvar12[6] = ultraGridColumn41.
        ultraGridBand3:Columns:AddRange(arrayvar12).
        ultraGridColumn42:Header:VisiblePosition = 0.
        ultraGridColumn43:Header:VisiblePosition = 1.
        ultraGridColumn44:Header:VisiblePosition = 2.
        ultraGridColumn45:Header:VisiblePosition = 3.
        ultraGridColumn46:Header:VisiblePosition = 4.
        ultraGridColumn49:Header:VisiblePosition = 5.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar13 as System.Object extent 6 no-undo.
        arrayvar13[1] = ultraGridColumn42.
        arrayvar13[2] = ultraGridColumn43.
        arrayvar13[3] = ultraGridColumn44.
        arrayvar13[4] = ultraGridColumn45.
        arrayvar13[5] = ultraGridColumn46.
        arrayvar13[6] = ultraGridColumn49.
        ultraGridBand4:Columns:AddRange(arrayvar13).
        ultraGridColumn50:Header:VisiblePosition = 0.
        ultraGridColumn51:Header:VisiblePosition = 1.
        ultraGridColumn52:Header:VisiblePosition = 2.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar14 as System.Object extent 3 no-undo.
        arrayvar14[1] = ultraGridColumn50.
        arrayvar14[2] = ultraGridColumn51.
        arrayvar14[3] = ultraGridColumn52.
        ultraGridBand5:Columns:AddRange(arrayvar14).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand2).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand3).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand4).
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand5).
        this-object:uxOrders:DisplayLayout:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        this-object:uxOrders:DisplayLayout:CaptionVisible = Infragistics.Win.DefaultableBoolean:False.
        appearance22:BackColor = System.Drawing.SystemColors:ActiveBorder.
        appearance22:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance22:BackGradientStyle = Infragistics.Win.GradientStyle:Vertical.
        appearance22:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:GroupByBox:Appearance = appearance22.
        appearance23:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxOrders:DisplayLayout:GroupByBox:BandLabelAppearance = appearance23.
        this-object:uxOrders:DisplayLayout:GroupByBox:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        appearance24:BackColor = System.Drawing.SystemColors:ControlLightLight.
        appearance24:BackColor2 = System.Drawing.SystemColors:Control.
        appearance24:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance24:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxOrders:DisplayLayout:GroupByBox:PromptAppearance = appearance24.
        this-object:uxOrders:DisplayLayout:MaxColScrollRegions = 1.
        this-object:uxOrders:DisplayLayout:MaxRowScrollRegions = 1.
        appearance13:BackColor = System.Drawing.SystemColors:Window.
        appearance13:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:uxOrders:DisplayLayout:Override:ActiveCellAppearance = appearance13.
        appearance14:BackColor = System.Drawing.SystemColors:Highlight.
        appearance14:ForeColor = System.Drawing.SystemColors:HighlightText.
        this-object:uxOrders:DisplayLayout:Override:ActiveRowAppearance = appearance14.
        this-object:uxOrders:DisplayLayout:Override:BorderStyleCell = Infragistics.Win.UIElementBorderStyle:Dotted.
        this-object:uxOrders:DisplayLayout:Override:BorderStyleRow = Infragistics.Win.UIElementBorderStyle:Dotted.
        appearance15:BackColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:Override:CardAreaAppearance = appearance15.
        appearance16:BorderColor = System.Drawing.Color:Silver.
        appearance16:TextTrimming = Infragistics.Win.TextTrimming:EllipsisCharacter.
        this-object:uxOrders:DisplayLayout:Override:CellAppearance = appearance16.
        this-object:uxOrders:DisplayLayout:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:EditAndSelectText.
        this-object:uxOrders:DisplayLayout:Override:CellPadding = 0.
        appearance17:BackColor = System.Drawing.SystemColors:Control.
        appearance17:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance17:BackGradientAlignment = Infragistics.Win.GradientAlignment:Element.
        appearance17:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance17:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxOrders:DisplayLayout:Override:GroupByRowAppearance = appearance17.
        appearance18:TextHAlignAsString = "Left".
        this-object:uxOrders:DisplayLayout:Override:HeaderAppearance = appearance18.
        this-object:uxOrders:DisplayLayout:Override:HeaderClickAction = Infragistics.Win.UltraWinGrid.HeaderClickAction:SortMulti.
        this-object:uxOrders:DisplayLayout:Override:HeaderStyle = Infragistics.Win.HeaderStyle:WindowsXPCommand.
        appearance19:BackColor = System.Drawing.SystemColors:Window.
        appearance19:BorderColor = System.Drawing.Color:Silver.
        this-object:uxOrders:DisplayLayout:Override:RowAppearance = appearance19.
        this-object:uxOrders:DisplayLayout:Override:RowSelectors = Infragistics.Win.DefaultableBoolean:False.
        appearance20:BackColor = System.Drawing.SystemColors:ControlLight.
        this-object:uxOrders:DisplayLayout:Override:TemplateAddRowAppearance = appearance20.
        this-object:uxOrders:DisplayLayout:ScrollBounds = Infragistics.Win.UltraWinGrid.ScrollBounds:ScrollToFill.
        this-object:uxOrders:DisplayLayout:ScrollStyle = Infragistics.Win.UltraWinGrid.ScrollStyle:Immediate.
        this-object:uxOrders:DisplayLayout:ViewStyleBand = Infragistics.Win.UltraWinGrid.ViewStyleBand:OutlookGroupBy.
        this-object:uxOrders:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxOrders:Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25, System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:uxOrders:Location = new System.Drawing.Point(0, 0).
        this-object:uxOrders:Name = "uxOrders".
        this-object:uxOrders:Size = new System.Drawing.Size(581, 347).
        this-object:uxOrders:TabIndex = 0.
        this-object:uxOrders:Text = "ultraGrid1".
        /*  */
        /* OrderListForm */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(581, 347).
        this-object:Controls:Add(this-object:uxOrders).
        this-object:Name = "OrderListForm".
        this-object:Text = "OrderListForm".
        cast(this-object:bsOrders, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxOrders, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    destructor public OrderListForm ( ):
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.

    method protected void InitData():
        define variable oUC as IUserContext no-undo.
        define variable cDealerCode as character no-undo.
        define variable oPropertyValue as String no-undo.
        
        oUC = cast(SvcMgr:StartService(SecurityManager:ISecurityManagerType), ISecurityManager):CurrentUserContext.
        
        oPropertyValue = cast(oUC:UserProperties:Get(new String('Dealer.Code')), String).
        if valid-object(oPropertyValue) then
           cDealerCode = oPropertyValue:Value.
           
        run AutoEdge/Factory/Server/Order/BusinessComponent/service_listorderdealer.p
               on ConnMgr:GetConnectionHandle(ConnectionTypeEnum:AppServer, 'AutoEdgeTheFactory') 
                    (input cDealerCode,
                     input oUC:ContextId,
                     output dataset-handle mhOrders).
        
        bsOrders:handle = mhOrders.                     
    end method.    

end class.