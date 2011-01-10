 
 /*------------------------------------------------------------------------
    File        : OrderListForm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 16 11:33:05 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.

/*routine-level on error undo, throw.*/

class AutoEdge.Factory.Order.PresentationLayer.OrderListForm inherits Form: 
	
    define private variable bsOrders as Progress.Data.BindingSource no-undo.
	define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable uxOrders as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.
    define private variable mcContextId as longchar no-undo. 
		
	constructor public OrderListForm (  ):
        super().
        InitializeComponent().
        
        run OpenEdge/CommonInfrastructure/Server/service_userlogin.p ('usah', 'p@ssword', output mcContextId).
         
        ShowOrders().
        
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
        define variable appearance21 as Infragistics.Win.Appearance no-undo.
        appearance21 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand1 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand1 = new Infragistics.Win.UltraWinGrid.UltraGridBand("eOrder", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn109 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn109 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("BillingAddressId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn110 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn110 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Carrier").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn111 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn111 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Creditcard").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn112 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn112 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn113 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn113 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerName").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn114 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn114 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("CustomerPO").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn115 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn115 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("EmailDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn116 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn116 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("EnteredDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn117 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn117 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("FromEmail").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn118 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn118 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Instructions").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn119 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn119 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("InventoryTransId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn120 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn120 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("InvoiceId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn121 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn121 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn122 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn122 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn123 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn123 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderNum").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn124 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn124 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("PromiseDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn125 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn125 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SalesrepId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn126 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn126 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ShipDate").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn127 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn127 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("ShippingAddressId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn128 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn128 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("StatusId").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn129 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn129 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("OrderStatus").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn130 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn130 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Terms").
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
        tableDesc1:ChildTables = arrayvar0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 22 no-undo.
        arrayvar1[1] = new Progress.Data.ColumnPropDesc("BillingAddressId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[2] = new Progress.Data.ColumnPropDesc("Carrier", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[3] = new Progress.Data.ColumnPropDesc("Creditcard", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[4] = new Progress.Data.ColumnPropDesc("CustomerId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[5] = new Progress.Data.ColumnPropDesc("CustomerName", "Customer Name", Progress.Data.DataType:CHARACTER).
        arrayvar1[6] = new Progress.Data.ColumnPropDesc("CustomerPO", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[7] = new Progress.Data.ColumnPropDesc("EmailDate", "", Progress.Data.DataType:DATETIME_TZ).
        arrayvar1[8] = new Progress.Data.ColumnPropDesc("EnteredDate", "", Progress.Data.DataType:DATETIME).
        arrayvar1[9] = new Progress.Data.ColumnPropDesc("FromEmail", "", Progress.Data.DataType:LOGICAL).
        arrayvar1[10] = new Progress.Data.ColumnPropDesc("Instructions", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[11] = new Progress.Data.ColumnPropDesc("InventoryTransId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[12] = new Progress.Data.ColumnPropDesc("InvoiceId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[13] = new Progress.Data.ColumnPropDesc("OrderDate", "", Progress.Data.DataType:DATE).
        arrayvar1[14] = new Progress.Data.ColumnPropDesc("OrderId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[15] = new Progress.Data.ColumnPropDesc("OrderNum", "", Progress.Data.DataType:INTEGER).
        arrayvar1[16] = new Progress.Data.ColumnPropDesc("PromiseDate", "", Progress.Data.DataType:DATE).
        arrayvar1[17] = new Progress.Data.ColumnPropDesc("SalesrepId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[18] = new Progress.Data.ColumnPropDesc("ShipDate", "", Progress.Data.DataType:DATE).
        arrayvar1[19] = new Progress.Data.ColumnPropDesc("ShippingAddressId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[20] = new Progress.Data.ColumnPropDesc("StatusId", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[21] = new Progress.Data.ColumnPropDesc("OrderStatus", "", Progress.Data.DataType:CHARACTER).
        arrayvar1[22] = new Progress.Data.ColumnPropDesc("Terms", "", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar1.
        this-object:bsOrders:TableSchema = tableDesc1.
        /*  */
        /* uxOrders */
        /*  */
        this-object:uxOrders:DataSource = this-object:bsOrders.
        appearance21:BackColor = System.Drawing.SystemColors:Window.
        appearance21:BorderColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxOrders:DisplayLayout:Appearance = appearance21.
        ultraGridColumn109:Header:VisiblePosition = 0.
        ultraGridColumn109:Hidden = true.
        ultraGridColumn109:RowLayoutColumnInfo:OriginX = 0.
        ultraGridColumn109:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn109:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn109:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn110:Header:VisiblePosition = 1.
        ultraGridColumn110:Hidden = true.
        ultraGridColumn110:RowLayoutColumnInfo:OriginX = 5.
        ultraGridColumn110:RowLayoutColumnInfo:OriginY = 6.
        ultraGridColumn110:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn110:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn111:Header:VisiblePosition = 2.
        ultraGridColumn111:Hidden = true.
        ultraGridColumn111:RowLayoutColumnInfo:OriginX = 10.
        ultraGridColumn111:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn111:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn111:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn112:Header:VisiblePosition = 3.
        ultraGridColumn112:Hidden = true.
        ultraGridColumn112:RowLayoutColumnInfo:OriginX = 3.
        ultraGridColumn112:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn112:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(276, 0).
        ultraGridColumn112:RowLayoutColumnInfo:SpanX = 5.
        ultraGridColumn112:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn113:Header:VisiblePosition = 4.
        ultraGridColumn113:RowLayoutColumnInfo:OriginX = 4.
        ultraGridColumn113:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn113:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(283, 0).
        ultraGridColumn113:RowLayoutColumnInfo:SpanX = 4.
        ultraGridColumn113:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn114:Header:VisiblePosition = 5.
        ultraGridColumn114:Hidden = true.
        ultraGridColumn114:RowLayoutColumnInfo:OriginX = 15.
        ultraGridColumn114:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn114:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn114:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn115:Header:VisiblePosition = 6.
        ultraGridColumn115:Hidden = true.
        ultraGridColumn115:RowLayoutColumnInfo:OriginX = 17.
        ultraGridColumn115:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn115:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn115:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn116:Header:VisiblePosition = 7.
        ultraGridColumn116:RowLayoutColumnInfo:OriginX = 2.
        ultraGridColumn116:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn116:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn116:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn117:Header:VisiblePosition = 8.
        ultraGridColumn117:Hidden = true.
        ultraGridColumn117:RowLayoutColumnInfo:OriginX = 10.
        ultraGridColumn117:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn117:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(89, 0).
        ultraGridColumn117:RowLayoutColumnInfo:SpanX = 3.
        ultraGridColumn117:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn118:Header:VisiblePosition = 9.
        ultraGridColumn118:RowLayoutColumnInfo:OriginX = 0.
        ultraGridColumn118:RowLayoutColumnInfo:OriginY = 4.
        ultraGridColumn118:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(468, 0).
        ultraGridColumn118:RowLayoutColumnInfo:SpanX = 10.
        ultraGridColumn118:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn119:Header:VisiblePosition = 10.
        ultraGridColumn119:Hidden = true.
        ultraGridColumn119:RowLayoutColumnInfo:OriginX = 19.
        ultraGridColumn119:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn119:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn119:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn120:Header:VisiblePosition = 11.
        ultraGridColumn120:Hidden = true.
        ultraGridColumn120:RowLayoutColumnInfo:OriginX = 21.
        ultraGridColumn120:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn120:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn120:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn121:Header:VisiblePosition = 12.
        ultraGridColumn121:RowLayoutColumnInfo:OriginX = 4.
        ultraGridColumn121:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn121:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(194, 0).
        ultraGridColumn121:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn121:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn122:Header:VisiblePosition = 13.
        ultraGridColumn122:Hidden = true.
        ultraGridColumn122:RowLayoutColumnInfo:OriginX = 25.
        ultraGridColumn122:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn122:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn122:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn123:Header:VisiblePosition = 14.
        ultraGridColumn123:RowLayoutColumnInfo:OriginX = 1.
        ultraGridColumn123:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn123:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(186, 0).
        ultraGridColumn123:RowLayoutColumnInfo:SpanX = 3.
        ultraGridColumn123:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn124:Header:VisiblePosition = 15.
        ultraGridColumn124:RowLayoutColumnInfo:OriginX = 6.
        ultraGridColumn124:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn124:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn124:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn125:Header:VisiblePosition = 16.
        ultraGridColumn125:Hidden = true.
        ultraGridColumn125:RowLayoutColumnInfo:OriginX = 13.
        ultraGridColumn125:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn125:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn125:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn126:Header:VisiblePosition = 17.
        ultraGridColumn126:RowLayoutColumnInfo:OriginX = 8.
        ultraGridColumn126:RowLayoutColumnInfo:OriginY = 2.
        ultraGridColumn126:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn126:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn127:Header:VisiblePosition = 18.
        ultraGridColumn127:Hidden = true.
        ultraGridColumn127:RowLayoutColumnInfo:OriginX = 29.
        ultraGridColumn127:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn127:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn127:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn128:Header:VisiblePosition = 19.
        ultraGridColumn128:Hidden = true.
        ultraGridColumn128:RowLayoutColumnInfo:OriginX = 27.
        ultraGridColumn128:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn128:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn128:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn129:Header:VisiblePosition = 20.
        ultraGridColumn129:RowLayoutColumnInfo:OriginX = 8.
        ultraGridColumn129:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn129:RowLayoutColumnInfo:PreferredCellSize = new System.Drawing.Size(184, 0).
        ultraGridColumn129:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn129:RowLayoutColumnInfo:SpanY = 2.
        ultraGridColumn130:Header:VisiblePosition = 21.
        ultraGridColumn130:Hidden = true.
        ultraGridColumn130:RowLayoutColumnInfo:OriginX = 23.
        ultraGridColumn130:RowLayoutColumnInfo:OriginY = 0.
        ultraGridColumn130:RowLayoutColumnInfo:SpanX = 2.
        ultraGridColumn130:RowLayoutColumnInfo:SpanY = 2.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as System.Object extent 22 no-undo.
        arrayvar2[1] = ultraGridColumn109.
        arrayvar2[2] = ultraGridColumn110.
        arrayvar2[3] = ultraGridColumn111.
        arrayvar2[4] = ultraGridColumn112.
        arrayvar2[5] = ultraGridColumn113.
        arrayvar2[6] = ultraGridColumn114.
        arrayvar2[7] = ultraGridColumn115.
        arrayvar2[8] = ultraGridColumn116.
        arrayvar2[9] = ultraGridColumn117.
        arrayvar2[10] = ultraGridColumn118.
        arrayvar2[11] = ultraGridColumn119.
        arrayvar2[12] = ultraGridColumn120.
        arrayvar2[13] = ultraGridColumn121.
        arrayvar2[14] = ultraGridColumn122.
        arrayvar2[15] = ultraGridColumn123.
        arrayvar2[16] = ultraGridColumn124.
        arrayvar2[17] = ultraGridColumn125.
        arrayvar2[18] = ultraGridColumn126.
        arrayvar2[19] = ultraGridColumn127.
        arrayvar2[20] = ultraGridColumn128.
        arrayvar2[21] = ultraGridColumn129.
        arrayvar2[22] = ultraGridColumn130.
        ultraGridBand1:Columns:AddRange(arrayvar2).
        ultraGridBand1:RowLayoutLabelPosition = Infragistics.Win.UltraWinGrid.LabelPosition:Top.
        ultraGridBand1:RowLayoutStyle = Infragistics.Win.UltraWinGrid.RowLayoutStyle:GroupLayout.
        this-object:uxOrders:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
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

    method protected void ShowOrders():
        define variable hOrders as handle no-undo.
        
        run AutoEdge/Factory/Order/BusinessComponents/service_listorderstatus.p (mcContextId , output dataset-handle hOrders) no-error.
        if error-status:error then
            undo, throw new AppError(return-value).
        
        bsOrders:handle = hOrders.
    end method.

end class.