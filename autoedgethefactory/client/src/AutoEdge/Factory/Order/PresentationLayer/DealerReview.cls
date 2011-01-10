/*------------------------------------------------------------------------
    File        : DealerReview
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 07 11:55:28 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
/*routine-level on error undo, throw.*/
  
using AutoEdge.Factory.Order.PresentationLayer.CurrentTask.
using AutoEdge.Factory.Order.PresentationLayer.TagWrapper.
using AutoEdge.Factory.Order.PresentationLayer.ITaskListManager.
using AutoEdge.Factory.Order.PresentationLayer.ServerConnectPanel.
using AutoEdge.Factory.Order.PresentationLayer.CreateProcessInstance.
using AutoEdge.Factory.Order.PresentationLayer.TaskDetailForm.
using AutoEdge.Factory.Order.PresentationLayer.OrderListForm.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkItemStatusEnum.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicAPI.  
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkFlowWebService.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkItem. 
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.ProcessTemplate.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.XML.WebServiceInvocationError.

using Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup.
using Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarItem.
using Infragistics.Win.Appearance.
using Infragistics.Win.UltraWinToolbars.ToolBase.
using Infragistics.Win.UltraWinToolbars.ButtonTool.
using System.Windows.Forms.DialogResult.
using Progress.Windows.Form.

class AutoEdge.Factory.Order.PresentationLayer.DealerReview inherits Form
        implements ITaskListManager: 
	
    define private variable imageListSmall as System.Windows.Forms.ImageList no-undo.
    define private variable imageListLarge as System.Windows.Forms.ImageList no-undo.
    define private variable m_DealerReview_Toolbars_Dock_Area_Top as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea no-undo.
    define private variable m_DealerReview_Toolbars_Dock_Area_Right as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea no-undo.
    define private variable m_DealerReview_Toolbars_Dock_Area_Left as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea no-undo.
    define private variable m_DealerReview_Toolbars_Dock_Area_Bottom as Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea no-undo.
	define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable splitter1 as System.Windows.Forms.Splitter no-undo.
    define private variable ultraTabbedMdiManager1 as Infragistics.Win.UltraWinTabbedMdi.UltraTabbedMdiManager no-undo.
    define private variable ultraToolbarsManager1 as Infragistics.Win.UltraWinToolbars.UltraToolbarsManager no-undo.

    define private variable uxAccordion as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBar no-undo.
    define private variable uxStatus as Infragistics.Win.UltraWinStatusBar.UltraStatusBar no-undo.
    
    define protected property BizLogicService as IBizLogicAPI no-undo get. set.
    define public property SessionId as character no-undo get. protected set.
    
    define public event CurrentTaskUpdated signature void(input piTaskId as int64).
    
	constructor public DealerReview (  ): 
        super().
        
        InitializeComponent().
        
        ServerDisconnect().
        
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
	end constructor.

	method private void DealerReview_FormClosed( input sender as System.Object, input e as System.Windows.Forms.FormClosedEventArgs ):
	    ServerDisconnect().
	end method.

	method private void InitializeComponent(  ):
		
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraToolbar1 as Infragistics.Win.UltraWinToolbars.UltraToolbar no-undo.
        ultraToolbar1 = new Infragistics.Win.UltraWinToolbars.UltraToolbar("UltraToolbar1").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable labelTool1 as Infragistics.Win.UltraWinToolbars.LabelTool no-undo.
        labelTool1 = new Infragistics.Win.UltraWinToolbars.LabelTool("BizLogicServerLabel").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool9 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool9 = new Infragistics.Win.UltraWinToolbars.ButtonTool("ServerConnect").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool5 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool5 = new Infragistics.Win.UltraWinToolbars.ButtonTool("ServerDisconnect").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool4 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool4 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshTasksList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool10 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool10 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshProcessesList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool8 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool8 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Help").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool2 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool2 = new Infragistics.Win.UltraWinToolbars.ButtonTool("Help").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance11 as Infragistics.Win.Appearance no-undo.
        appearance11 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool6 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool6 = new Infragistics.Win.UltraWinToolbars.ButtonTool("ServerConnect").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance21 as Infragistics.Win.Appearance no-undo.
        appearance21 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance16 as Infragistics.Win.Appearance no-undo.
        appearance16 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool3 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool3 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshTasksList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance17 as Infragistics.Win.Appearance no-undo.
        appearance17 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance18 as Infragistics.Win.Appearance no-undo.
        appearance18 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool1 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool1 = new Infragistics.Win.UltraWinToolbars.ButtonTool("ServerDisconnect").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance22 as Infragistics.Win.Appearance no-undo.
        appearance22 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance19 as Infragistics.Win.Appearance no-undo.
        appearance19 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable labelTool2 as Infragistics.Win.UltraWinToolbars.LabelTool no-undo.
        labelTool2 = new Infragistics.Win.UltraWinToolbars.LabelTool("BizLogicServerLabel").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool7 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool7 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshProcessesList").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance14 as Infragistics.Win.Appearance no-undo.
        appearance14 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance15 as Infragistics.Win.Appearance no-undo.
        appearance15 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable buttonTool12 as Infragistics.Win.UltraWinToolbars.ButtonTool no-undo.
        buttonTool12 = new Infragistics.Win.UltraWinToolbars.ButtonTool("RefreshOrders").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance13 as Infragistics.Win.Appearance no-undo.
        appearance13 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance20 as Infragistics.Win.Appearance no-undo.
        appearance20 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("AutoEdge.Factory.Order.PresentationLayer.DealerReview").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel1 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel1 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel2 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel2 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel3 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel3 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel4 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel4 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel5 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel5 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel6 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel6 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraStatusPanel7 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel no-undo.
        ultraStatusPanel7 = new Infragistics.Win.UltraWinStatusBar.UltraStatusPanel().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance1 as Infragistics.Win.Appearance no-undo.
        appearance1 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraExplorerBarGroup4 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup no-undo.
        ultraExplorerBarGroup4 = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraExplorerBarItem1 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarItem no-undo.
        ultraExplorerBarItem1 = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarItem().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance23 as Infragistics.Win.Appearance no-undo.
        appearance23 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance24 as Infragistics.Win.Appearance no-undo.
        appearance24 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraExplorerBarGroup1 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup no-undo.
        ultraExplorerBarGroup1 = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraExplorerBarGroup3 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup no-undo.
        ultraExplorerBarGroup3 = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraExplorerBarGroup2 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup no-undo.
        ultraExplorerBarGroup2 = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup().
        this-object:ultraToolbarsManager1 = new Infragistics.Win.UltraWinToolbars.UltraToolbarsManager(this-object:components).
        this-object:imageListLarge = new System.Windows.Forms.ImageList(this-object:components).
        this-object:imageListSmall = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxStatus = new Infragistics.Win.UltraWinStatusBar.UltraStatusBar().
        this-object:m_DealerReview_Toolbars_Dock_Area_Left = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_DealerReview_Toolbars_Dock_Area_Right = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_DealerReview_Toolbars_Dock_Area_Top = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom = new Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        this-object:ultraTabbedMdiManager1 = new Infragistics.Win.UltraWinTabbedMdi.UltraTabbedMdiManager(this-object:components).
        this-object:uxAccordion = new Infragistics.Win.UltraWinExplorerBar.UltraExplorerBar().
        this-object:splitter1 = new System.Windows.Forms.Splitter().
        cast(this-object:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:ultraTabbedMdiManager1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxAccordion, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* ultraToolbarsManager1 */
        /*  */
        this-object:ultraToolbarsManager1:AlwaysShowMenusExpanded = Infragistics.Win.DefaultableBoolean:True.
        this-object:ultraToolbarsManager1:DesignerFlags = 1.
        this-object:ultraToolbarsManager1:DockWithinContainer = this-object.
        this-object:ultraToolbarsManager1:DockWithinContainerBaseType = Progress.Util.TypeHelper:GetType("Progress.Windows.Form").
        this-object:ultraToolbarsManager1:ImageListLarge = this-object:imageListLarge.
        this-object:ultraToolbarsManager1:ImageListSmall = this-object:imageListSmall.
        this-object:ultraToolbarsManager1:ImageSizeLarge = new System.Drawing.Size(24, 24).
        this-object:ultraToolbarsManager1:ShowFullMenusDelay = 500.
        ultraToolbar1:DockedColumn = 0.
        ultraToolbar1:DockedRow = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as Infragistics.Win.UltraWinToolbars.ToolBase extent 6 no-undo.
        arrayvar0[1] = labelTool1.
        arrayvar0[2] = buttonTool9.
        arrayvar0[3] = buttonTool5.
        arrayvar0[4] = buttonTool4.
        arrayvar0[5] = buttonTool10.
        arrayvar0[6] = buttonTool8.
        ultraToolbar1:NonInheritedTools:AddRange(arrayvar0).
        ultraToolbar1:Settings:AllowCustomize = Infragistics.Win.DefaultableBoolean:False.
        ultraToolbar1:Settings:AllowFloating = Infragistics.Win.DefaultableBoolean:False.
        ultraToolbar1:Settings:FillEntireRow = Infragistics.Win.DefaultableBoolean:True.
        ultraToolbar1:Settings:ToolDisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        ultraToolbar1:Text = "UltraToolbar1".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Infragistics.Win.UltraWinToolbars.UltraToolbar extent 1 no-undo.
        arrayvar1[1] = ultraToolbar1.
        this-object:ultraToolbarsManager1:Toolbars:AddRange(arrayvar1).
        this-object:ultraToolbarsManager1:ToolbarSettings:UseLargeImages = Infragistics.Win.DefaultableBoolean:True.
        appearance11:Image = 8.
        buttonTool2:SharedPropsInternal:AppearancesSmall:Appearance = appearance11.
        buttonTool2:SharedPropsInternal:Caption = "Help".
        buttonTool2:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        appearance21:Image = 7.
        buttonTool6:SharedPropsInternal:AppearancesLarge:Appearance = appearance21.
        appearance16:Image = 5.
        buttonTool6:SharedPropsInternal:AppearancesSmall:Appearance = appearance16.
        buttonTool6:SharedPropsInternal:Caption = "Connect".
        buttonTool6:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        buttonTool6:SharedPropsInternal:Spring = true.
        appearance17:Image = 4.
        buttonTool3:SharedPropsInternal:AppearancesLarge:Appearance = appearance17.
        appearance18:Image = 3.
        buttonTool3:SharedPropsInternal:AppearancesSmall:Appearance = appearance18.
        buttonTool3:SharedPropsInternal:Caption = "Refresh Tasks".
        appearance22:Image = 6.
        buttonTool1:SharedPropsInternal:AppearancesLarge:Appearance = appearance22.
        appearance19:Image = 7.
        buttonTool1:SharedPropsInternal:AppearancesSmall:Appearance = appearance19.
        buttonTool1:SharedPropsInternal:Caption = "Disconnect".
        buttonTool1:SharedPropsInternal:Spring = true.
        labelTool2:SharedPropsInternal:Caption = "BizLogic Server".
        labelTool2:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:TextOnlyAlways.
        labelTool2:SharedPropsInternal:ShowInCustomizer = false.
        appearance14:Image = 3.
        buttonTool7:SharedPropsInternal:AppearancesLarge:Appearance = appearance14.
        appearance15:Image = 4.
        buttonTool7:SharedPropsInternal:AppearancesSmall:Appearance = appearance15.
        buttonTool7:SharedPropsInternal:Caption = "Refresh Processes".
        appearance13:Image = "basket_go_32x32.png".
        buttonTool12:SharedPropsInternal:AppearancesLarge:Appearance = appearance13.
        appearance20:Image = "basket_go_16x16.png".
        buttonTool12:SharedPropsInternal:AppearancesSmall:Appearance = appearance20.
        buttonTool12:SharedPropsInternal:Caption = "Refresh Orders".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Infragistics.Win.UltraWinToolbars.ToolBase extent 7 no-undo.
        arrayvar2[1] = buttonTool2.
        arrayvar2[2] = buttonTool6.
        arrayvar2[3] = buttonTool3.
        arrayvar2[4] = buttonTool1.
        arrayvar2[5] = labelTool2.
        arrayvar2[6] = buttonTool7.
        arrayvar2[7] = buttonTool12.
        this-object:ultraToolbarsManager1:Tools:AddRange(arrayvar2).
        this-object:ultraToolbarsManager1:ToolClick:Subscribe(this-object:ultraToolbarsManager1_ToolClick).
        /*  */
        /* imageListLarge */
        /*  */
        this-object:imageListLarge:ImageStream = cast(resources:GetObject("imageListLarge.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageListLarge:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageListLarge:Images:SetKeyName(0, "date_error_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(1, "date_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(2, "system_emblem_32x29.png").
        this-object:imageListLarge:Images:SetKeyName(3, "cog_go32x32.png").
        this-object:imageListLarge:Images:SetKeyName(4, "date_go_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(5, "connect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(6, "disconnect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(7, "server_connect_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(8, "help_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(9, "exclamation_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(10, "basket_go_32x32.png").
        this-object:imageListLarge:Images:SetKeyName(11, "basket_32x32.png").
        /*  */
        /* imageListSmall */
        /*  */
        this-object:imageListSmall:ImageStream = cast(resources:GetObject("imageListSmall.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageListSmall:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageListSmall:Images:SetKeyName(0, "date_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(1, "date_error_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(2, "system_emblem_16x15.png").
        this-object:imageListSmall:Images:SetKeyName(3, "date_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(4, "cog_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(5, "server_connect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(6, "connect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(7, "disconnect_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(8, "help_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(9, "exclamation_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(10, "basket_go_16x16.png").
        this-object:imageListSmall:Images:SetKeyName(11, "basket_16x16.png").
        /*  */
        /* uxStatus */
        /*  */
        this-object:uxStatus:Location = new System.Drawing.Point(0, 530).
        this-object:uxStatus:Name = "uxStatus".
        ultraStatusPanel1:Enabled = false.
        ultraStatusPanel1:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel1:Text = "Portal User:".
        ultraStatusPanel2:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel2:Text = "<user name>".
        ultraStatusPanel3:Enabled = false.
        ultraStatusPanel3:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel3:Text = "Session Id:".
        ultraStatusPanel4:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Spring.
        ultraStatusPanel4:Text = "<id>".
        ultraStatusPanel5:Enabled = false.
        ultraStatusPanel5:MinWidth = 5.
        ultraStatusPanel5:Style = Infragistics.Win.UltraWinStatusBar.PanelStyle:ControlContainer.
        ultraStatusPanel5:Width = 19.
        ultraStatusPanel6:Style = Infragistics.Win.UltraWinStatusBar.PanelStyle:Date.
        ultraStatusPanel7:SizingMode = Infragistics.Win.UltraWinStatusBar.PanelSizingMode:Automatic.
        ultraStatusPanel7:Style = Infragistics.Win.UltraWinStatusBar.PanelStyle:Time.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as Infragistics.Win.UltraWinStatusBar.UltraStatusPanel extent 7 no-undo.
        arrayvar3[1] = ultraStatusPanel1.
        arrayvar3[2] = ultraStatusPanel2.
        arrayvar3[3] = ultraStatusPanel3.
        arrayvar3[4] = ultraStatusPanel4.
        arrayvar3[5] = ultraStatusPanel5.
        arrayvar3[6] = ultraStatusPanel6.
        arrayvar3[7] = ultraStatusPanel7.
        this-object:uxStatus:Panels:AddRange(arrayvar3).
        this-object:uxStatus:Size = new System.Drawing.Size(974, 23).
        this-object:uxStatus:TabIndex = 0.
        this-object:uxStatus:Text = "ultraStatusBar1".
        /*  */
        /* m_DealerReview_Toolbars_Dock_Area_Left */
        /*  */
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Left.
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:Location = new System.Drawing.Point(0, 35).
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:Name = "m_DealerReview_Toolbars_Dock_Area_Left".
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:Size = new System.Drawing.Size(0, 495).
        this-object:m_DealerReview_Toolbars_Dock_Area_Left:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_DealerReview_Toolbars_Dock_Area_Right */
        /*  */
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Right.
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:Location = new System.Drawing.Point(974, 35).
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:Name = "m_DealerReview_Toolbars_Dock_Area_Right".
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:Size = new System.Drawing.Size(0, 495).
        this-object:m_DealerReview_Toolbars_Dock_Area_Right:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_DealerReview_Toolbars_Dock_Area_Top */
        /*  */
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Top.
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:Location = new System.Drawing.Point(0, 0).
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:Name = "m_DealerReview_Toolbars_Dock_Area_Top".
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:Size = new System.Drawing.Size(974, 35).
        this-object:m_DealerReview_Toolbars_Dock_Area_Top:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* m_DealerReview_Toolbars_Dock_Area_Bottom */
        /*  */
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:BackColor = System.Drawing.SystemColors:Control.
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Bottom.
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:Location = new System.Drawing.Point(0, 530).
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:Name = "m_DealerReview_Toolbars_Dock_Area_Bottom".
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:Size = new System.Drawing.Size(974, 0).
        this-object:m_DealerReview_Toolbars_Dock_Area_Bottom:ToolbarsManager = this-object:ultraToolbarsManager1.
        /*  */
        /* ultraTabbedMdiManager1 */
        /*  */
        this-object:ultraTabbedMdiManager1:AllowMaximize = true.
        this-object:ultraTabbedMdiManager1:MdiParent = this-object.
        /*  */
        /* uxAccordion */
        /*  */
        appearance1:FontData:Name = "Segoe UI".
        appearance1:FontData:SizeInPoints = 12.
        this-object:uxAccordion:Appearance = appearance1.
        this-object:uxAccordion:Dock = System.Windows.Forms.DockStyle:Left.
        ultraExplorerBarItem1:Key = "ListOrders".
        appearance23:Image = "basket_32x32.png".
        ultraExplorerBarItem1:Settings:AppearancesLarge:Appearance = appearance23.
        appearance24:Image = "basket_16x16.png".
        ultraExplorerBarItem1:Settings:AppearancesSmall:Appearance = appearance24.
        ultraExplorerBarItem1:Text = "Show Orders".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarItem extent 1 no-undo.
        arrayvar4[1] = ultraExplorerBarItem1.
        ultraExplorerBarGroup4:Items:AddRange(arrayvar4).
        ultraExplorerBarGroup4:Key = "Orders".
        ultraExplorerBarGroup4:Text = "Orders".
        ultraExplorerBarGroup1:Key = "AssignedTasks".
        ultraExplorerBarGroup1:Text = "My Tasks".
        ultraExplorerBarGroup3:Key = "AvailableTasks".
        ultraExplorerBarGroup3:Text = "Available Tasks".
        ultraExplorerBarGroup2:Key = "SavvionProcesses".
        ultraExplorerBarGroup2:Text = "Savvion Processes".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarGroup extent 4 no-undo.
        arrayvar5[1] = ultraExplorerBarGroup4.
        arrayvar5[2] = ultraExplorerBarGroup1.
        arrayvar5[3] = ultraExplorerBarGroup3.
        arrayvar5[4] = ultraExplorerBarGroup2.
        this-object:uxAccordion:Groups:AddRange(arrayvar5).
        this-object:uxAccordion:GroupSettings:Style = Infragistics.Win.UltraWinExplorerBar.GroupStyle:LargeImagesWithText.
        this-object:uxAccordion:ImageListLarge = this-object:imageListLarge.
        this-object:uxAccordion:ImageListSmall = this-object:imageListSmall.
        this-object:uxAccordion:ItemSettings:Style = Infragistics.Win.UltraWinExplorerBar.ItemStyle:Button.
        this-object:uxAccordion:Location = new System.Drawing.Point(0, 35).
        this-object:uxAccordion:Name = "uxAccordion".
        this-object:uxAccordion:Size = new System.Drawing.Size(261, 495).
        this-object:uxAccordion:Style = Infragistics.Win.UltraWinExplorerBar.UltraExplorerBarStyle:Listbar.
        this-object:uxAccordion:TabIndex = 12.
        this-object:uxAccordion:ItemClick:Subscribe(this-object:ultraExplorerBar1_ItemClick).
        /*  */
        /* splitter1 */
        /*  */
        this-object:splitter1:Location = new System.Drawing.Point(261, 35).
        this-object:splitter1:Name = "splitter1".
        this-object:splitter1:Size = new System.Drawing.Size(10, 495).
        this-object:splitter1:TabIndex = 13.
        this-object:splitter1:TabStop = false.
        /*  */
        /* DealerReview */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(974, 553).
        this-object:Controls:Add(this-object:splitter1).
        this-object:Controls:Add(this-object:uxAccordion).
        this-object:Controls:Add(this-object:m_DealerReview_Toolbars_Dock_Area_Left).
        this-object:Controls:Add(this-object:m_DealerReview_Toolbars_Dock_Area_Right).
        this-object:Controls:Add(this-object:m_DealerReview_Toolbars_Dock_Area_Top).
        this-object:Controls:Add(this-object:m_DealerReview_Toolbars_Dock_Area_Bottom).
        this-object:Controls:Add(this-object:uxStatus).
        this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        this-object:IsMdiContainer = true.
        this-object:Name = "DealerReview".
        this-object:Text = "AutoEdge|TheFactory: Customer Order Review".
        this-object:TransparencyKey = System.Drawing.Color:Fuchsia.
        this-object:FormClosed:Subscribe(this-object:DealerReview_FormClosed).
        cast(this-object:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:ultraTabbedMdiManager1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxAccordion, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
	end method.

    method private void timer1_Tick( input sender as System.Object, input e as System.EventArgs ):
        RefreshTasksList().
    end method.

	method private void ultraExplorerBar1_ItemClick( input sender as System.Object, input e as Infragistics.Win.UltraWinExplorerBar.ItemEventArgs):
        define variable oTags as TagWrapper extent no-undo.
        define variable oTask as CurrentTask no-undo.
        define variable oForm as Form no-undo.
        
        case e:Item:Group:Key:
            when 'AssignedTasks' or when 'AvailableTasks' then
            do:
                oTask = cast(cast(e:Item:Tag, TagWrapper):PABLO, CurrentTask).
                oForm = new TaskDetailForm(this-object, oTask).
            end.
            when 'SavvionProcesses' then
                oForm = new CreateProcessInstance(SessionId,
                                                  BizLogicService,
                                                  cast(cast(e:Item:Tag, TagWrapper):PABLO, ProcessTemplate)).
            otherwise
            do:
                case e:Item:Key:
                    when 'ListOrders' then
                        oForm = new OrderListForm().
                end case.
            end.
        end case.
        
        if valid-object(oForm) then
        do:
            oForm:MdiParent = this-object.
            oForm:Show().
        end.
	end method.
	
	method public void CompleteTask(poTask as CurrentTask):
        BizLogicService:CompleteWorkItemFromWIID(SessionId, poTask:WorkItem:Id, poTask:DataSlots).
        
        TaskCompleted(poTask:WorkItem:Id).
        
        OnCurrentTaskUpdated(poTask:WorkItem:Id).
        
        catch oError as WebServiceInvocationError:
            oError:ShowError().
            oError:LogError().
        end catch.
    end method.
    
    method protected void OnCurrentTaskUpdated(piTaskId as int64):
        this-object:CurrentTaskUpdated:Publish(piTaskId).
    end method.
	
	method public void TaskCompleted(piTaskId as int64):
        define variable oGroup as UltraExplorerBarGroup no-undo.
        define variable oItem as UltraExplorerBarItem no-undo.
        define variable oForm as Form no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oTag as TagWrapper no-undo.
         
        oItem = uxAccordion:Groups:Item['AssignedTasks']:Items:Item[string(piTaskId)].
        oTag = cast(oItem:Tag, TagWrapper).
        
        iMax = MdiChildren:Length - 1.        
        do iLoop = iMax to 0 by -1:
            oForm = cast(MdiChildren:GetValue(iLoop), Form).
            if type-of(oForm, AutoEdge.Factory.Order.PresentationLayer.TaskDetailForm) and
               cast(oForm, AutoEdge.Factory.Order.PresentationLayer.TaskDetailForm):CurrentTask eq cast(oTag:PABLO, AutoEdge.Factory.Order.PresentationLayer.CurrentTask) then
                oForm:Close().
        end.
        
        uxAccordion:Groups:Item['AssignedTasks']:Items:Remove(oItem).
    end method.

    method private void ultraToolbarsManager1_ToolClick( input sender as System.Object, input e as Infragistics.Win.UltraWinToolbars.ToolClickEventArgs ):
        case e:Tool:Key:
            when 'ServerConnect' then ShowServerConnect().
            when 'ServerDisconnect' then ServerDisconnect().
            when 'RefreshTasksList' then RefreshTasksList().
            when 'RefreshProcessesList' then RefreshProcessesList().
            when 'Help' then ShowHelp().
        end case.
    end method.
    
    method protected void ShowHelp():
        message
            'Dealer Salesrep Workbench'
            view-as alert-box info title 'AutoEdge|TheFactory Help'.        
    end method.
    
    method protected void RefreshTasksList():
        session:set-wait-state('general').
        
        ClearTasks('all').
        FillTaskList('all').
        
        finally:
            session:set-wait-state('').
        end finally.
    end method.

    method protected void RefreshProcessesList():
        session:set-wait-state('general').
        
        ClearProcesses().
        FillProcessList().
        
        finally:
            session:set-wait-state('').
        end finally.
    end method.

    method protected void SetToolState(pcTool as character extent, plEnable as logical):
        def var iIndex as integer no-undo.
        def var iLoop as integer no-undo.
        define variable oTool as ToolBase no-undo.
        
        do iLoop = 1 to extent(pcTool):
            iIndex = ultraToolbarsManager1:Tools:IndexOf(pcTool[iLoop]).
            if iIndex ge 0 then
                oTool = cast(ultraToolbarsManager1:Tools:GetItem(iIndex), ButtonTool).
            
            if valid-object(oTool) then
                oTool:SharedProps:Enabled = plEnable.
        end.
    end method.
    
    method public void ServerDisconnect():
        def var cTool as character extent no-undo.
        
        ClearTasks('all').
        ClearProcesses().
        
        if valid-object(BizLogicService) then
            this-object:BizLogicService:Disconnect(SessionId).
        
        BizLogicService = ?.
        SessionId = ''.
        uxStatus:Panels[1]:Text = '<disconnected>'.
        uxStatus:Panels[3]:Text = '<disconnected>'.
        
        extent(cTool) = 3.
        cTool[1] = 'ServerDisconnect'.
        cTool[2] = 'RefreshTasksList'.
        cTool[3] = 'RefreshProcessesList'.
        SetToolState(cTool, false).
        
        extent(cTool) = ?.
        extent(cTool) = 1.
        cTool[1] = 'ServerConnect'.
        SetToolState(cTool, true).
    end method.
    
    method public void ServerConnect(input pcUserName as character,
                                     input pcPassword as character,
                                     input pcPortalURL as character):
        def var cTool as character extent no-undo. 

        session:set-wait-state('general').
        
        BizLogicService = new WorkFlowWebService(pcPortalURL).
        SessionId = BizLogicService:Connect(pcUserName, pcPassword).
        
        extent(cTool) = 3.
        cTool[1] = 'ServerDisconnect'.
        cTool[2] = 'RefreshTasksList'.
        cTool[3] = 'RefreshProcessesList'.
        SetToolState(cTool, true).
        
        extent(cTool) = ?.
        extent(cTool) = 1.
        cTool[1] = 'ServerConnect'.
        SetToolState(cTool, false).
        
        uxStatus:Panels[1]:Text = pcUserName.
        uxStatus:Panels[3]:Text = SessionId.
        
/*        RefreshTasksList().*/
        
        catch oError as Progress.Lang.Error:
            message this-object this-object:GetClass():TypeName program-name(1) program-name(2) skip(2)
            oError:GetMessage(1) skip(2)
            oError:CallStack 
            view-as alert-box error title '[PJ DEBUG]'.
            
            undo, throw oError. 
        end catch.
        finally:
            session:set-wait-state('').
        end finally.
    end method.
    
    method protected void ShowServerConnect():
        def var oFrame as AutoEdge.Factory.Order.PresentationLayer.ServerConnectPanel extent 1 no-undo.
        define variable oServerConnectForm as AutoEdge.Factory.Order.PresentationLayer.LightboxForm no-undo.
        
        oFrame[1] = new ServerConnectPanel(this-object).
        
        /* position where we want it on *this* form */
        oFrame[1]:Location = new System.Drawing.Point(
            int((this-object:Size:Width / 2) - (oFrame[1]:Size:Width / 2 )),
            int((this-object:Size:Height / 2) - (oFrame[1]:Size:Height / 2 ) )).
        
        oServerConnectForm = new AutoEdge.Factory.Order.PresentationLayer.LightboxForm(this-object, oFrame).
        oServerConnectForm:Show().
    end method.
    
    method public void SetTaskDataSlots (poTask as CurrentTask):
        if extent(poTask:DataSlots) eq ? then 
            poTask:DataSlots = BizLogicService:GetWorkItemDataSlotsFromWIID(
                                    SessionId,                                    
                                    poTask:WorkItem:Id).
    end method.    
    
    method protected void FillTaskList(pcListType as character):
        define variable oTaskList as WorkItem extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oGroup as UltraExplorerBarGroup no-undo.
        define variable oItem as UltraExplorerBarItem no-undo.
        define variable oTag as TagWrapper no-undo.
        define variable oAppLarge as Appearance no-undo.
        define variable oAppSmall as Appearance no-undo.
        define variable cLabel as character no-undo.
        
        /* Empty all the existing orders */
        ClearTasks(pcListType).
        
        case pcListType:
            when 'assigned' then 
                assign oGroup = uxAccordion:Groups:Item['AssignedTasks']
                       oTaskList = BizLogicService:GetAssignedWorkItemList(SessionId)
                       no-error.
            when 'available' then 
                assign oGroup = uxAccordion:Groups:Item['AvailableTasks']
                       oTaskList = BizLogicService:GetAvailableWorkItemList(SessionId)
                       no-error.
            when 'all' then
            do:
                FillTaskList('assigned').
                FillTaskList('available').
            end.
        end.
        
        if valid-object(oGroup) and extent(oTaskList) ne ? then
        do:
            iMax = extent(oTaskList).
            do iLoop = 1 to iMax:
                if valid-object(oTaskList[iLoop]) then
                do on error undo, throw:
                    cLabel = oTaskList[iLoop]:ProcessInstanceName.
                    oItem = oGroup:Items:Add(string(oTaskList[iLoop]:Id), cLabel).
                    
                    if ReviewIsOverdue(oTaskList[iLoop]:duedate) then
                        assign oItem:Settings:AppearancesLarge:Appearance:Image = 'date_error_32x32.png'
                               oItem:Settings:AppearancesSmall:Appearance:Image = 'date_error_16x16.png'.
                    else
                        assign oItem:Settings:AppearancesLarge:Appearance:Image = 'date_32x32.png'
                               oItem:Settings:AppearancesSmall:Appearance:Image = 'date_16x16.png'.
                    
                    oTag = new TagWrapper(new AutoEdge.Factory.Order.PresentationLayer.CurrentTask(oTaskList[iLoop])).
                    oItem:Tag = oTag.
                end.
            end.
        end.
    end method.
            
    method public logical ReviewIsOverdue (pcDueDate as datetime-tz):
        return (interval(today, pcDueDate, 'hours') ge 6).
    end method.
    
    method protected void FillProcessList():
        define variable oProcessList as ProcessTemplate extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop2 as integer no-undo.
        define variable iMax2 as integer no-undo.
        define variable oGroup as UltraExplorerBarGroup no-undo.
        define variable oItem as UltraExplorerBarItem no-undo.
        define variable oDataSlotInstances as DataSlotInstance extent no-undo.
        define variable oTag as TagWrapper no-undo.
        define variable cLabel as character no-undo.
        define variable oAppLarge as Appearance no-undo.
        define variable oAppSmall as Appearance no-undo.
        
        oProcessList = BizLogicService:getUserAuthorizedProcessTemplateList(SessionId).
        iMax = extent(oProcessList).
        
        oGroup = uxAccordion:Groups:Item['SavvionProcesses'].
        do iLoop = 1 to iMax:
            if valid-object(oProcessList[iLoop]) and oProcessList[iLoop]:AppName begins 'AE_TF' then
            do:
                assign oItem = oGroup:Items:Add(string(oProcessList[iLoop]:id), oProcessList[iLoop]:AppName )
                       oItem:ToolTipText = oProcessList[iLoop]:name
                       oItem:Settings:AppearancesLarge:Appearance:Image = 'system_emblem_32x29.png'
                       oItem:Settings:AppearancesSmall:Appearance:Image = 'system_emblem_16x15.png'.
                
                oTag = new TagWrapper(oProcessList[iLoop]).
                oItem:Tag = oTag.
            end.
        end.
    end method.
    
    method protected void ClearProcesses():
        define variable oGroup as UltraExplorerBarGroup no-undo.
        define variable oForm as Form no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        oGroup = uxAccordion:Groups:Item['SavvionProcesses'].        
        oGroup:Items:Clear().
        
        iMax = MdiChildren:Length - 1.
        do iLoop = iMax to 0 by -1:
            if type-of(MdiChildren:GetValue(iLoop), AutoEdge.Factory.Order.PresentationLayer.CreateProcessInstance) then
            do:
                oForm = cast(MdiChildren:GetValue(iLoop), Form).
                oForm:Close().
            end.
        end.
    end method.
    
    method protected void ClearTasks(pcListType as character):
        define variable oGroup as UltraExplorerBarGroup no-undo.
        define variable oForm as Form no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        case pcListType:
            when 'assigned' then oGroup = uxAccordion:Groups:Item['AssignedTasks'].
            when 'available' then oGroup = uxAccordion:Groups:Item['AvailableTasks'].
            when 'all' then 
            do:
                ClearTasks('available').
                ClearTasks('assigned').
            end.
        end.
        
        if valid-object(oGroup) then
        do:
            oGroup:Items:Clear().
            iMax = MdiChildren:Length - 1.        
            do iLoop = iMax to 0 by -1:
                if type-of(MdiChildren:GetValue(iLoop), AutoEdge.Factory.Order.PresentationLayer.TaskDetailForm) then
                do:
                    oForm = cast(MdiChildren:GetValue(iLoop), Form).
                    oForm:Close().
                end.
            end.
        end.
    end method.
    
    method public void ReassignTask(poTask as CurrentTask, pcPerformer as character):
        case poTask:WorkItem:Status:
            when WorkItemStatusEnum:Assigned then
                BizLogicService:ReassignWorkItemFromWIID(SessionId, poTask:WorkItem:Id, pcPerformer).
            otherwise
                BizLogicService:AssignWorkItemFromWIID(SessionId, poTask:WorkItem:Id, pcPerformer).
        end case.
        
        OnCurrentTaskUpdated(poTask:WorkItem:id).
        catch oError as WebServiceInvocationError:
            oError:LogError().
        end catch.        
    end method.
    
	destructor public DealerReview ( ):
        ServerDisconnect().
        
		if valid-object(components) then do:
			cast(components, System.IDisposable):Dispose().
		end.
	end destructor.

end class.
        