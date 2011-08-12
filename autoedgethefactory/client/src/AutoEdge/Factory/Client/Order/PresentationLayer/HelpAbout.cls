/** ------------------------------------------------------------------------
    File        : HelpAbout
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Fri Jun 03 14:18:58 EDT 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Infragistics.Win.UltraWinTabControl.UltraTab.
using Progress.Windows.Form.

using OpenEdge.CommonInfrastructure.Common.Connection.IServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.BpmServerConnection.
using OpenEdge.CommonInfrastructure.Common.Connection.ConnectionTypeEnum.

using OpenEdge.CommonInfrastructure.Client.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IConnectionManager.
using OpenEdge.CommonInfrastructure.Common.ConnectionManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.IApplicationStart.

using OpenEdge.Core.System.UnhandledError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.XML.WebServiceInvocationError.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.BPM.Task.
using OpenEdge.Lang.BPM.IBizLogicAPI.
using OpenEdge.Lang.BPM.WorkItemStatusEnum.
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.ProcessTemplate.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class AutoEdge.Factory.Client.Order.PresentationLayer.HelpAbout inherits Form:

    define private temp-table mSettingData no-undo
        field SettingGroup as character
        field Order as integer
        field Key as character
        field SettingValue as character
        index idx1 as primary SettingGroup Key
        index idx2 SettingGroup Order.
    define private query mQrySettings for mSettingData scrolling.

    define variable mcDocURL as character no-undo.

    define private variable bsSettings as Progress.Data.BindingSource no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable imageList1 as System.Windows.Forms.ImageList no-undo.
    define private variable ultraPanel1 as Infragistics.Win.Misc.UltraPanel no-undo.
    define private variable ultraTabPageControl3 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable ultraTabPageControl2 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable ultraTabPageControl5 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable ultraTabSharedControlsPage1 as Infragistics.Win.UltraWinTabControl.UltraTabSharedControlsPage no-undo.
    define private variable ultraTabPageControl1 as Infragistics.Win.UltraWinTabControl.UltraTabPageControl no-undo.
    define private variable uxDetail as Infragistics.Win.UltraWinGrid.UltraGrid no-undo.
    define private variable uxLogo as Infragistics.Win.UltraWinEditors.UltraPictureBox no-undo.
    define private variable uxSettingsGroup as Infragistics.Win.UltraWinTabControl.UltraTabControl no-undo.
    define private variable uxVersionInfo as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.
    define private variable uxWebBrowser as System.Windows.Forms.WebBrowser no-undo.
    define private variable uxWebBrowserPanel as Infragistics.Win.Misc.UltraPanel no-undo.

    define public property ServiceManager as IServiceManager no-undo
        get():
            if not valid-object(ServiceManager) then
                ServiceManager = cast(ABLSession:Instance:SessionProperties:Get(OpenEdge.CommonInfrastructure.Common.ServiceManager:IServiceManagerType), IServiceManager).
            return ServiceManager.
        end get.
        private set.

    define protected property SecMgr as ISecurityManager no-undo
        get():
            if not valid-object(SecMgr) then
                SecMgr = cast(ServiceManager:GetService(SecurityManager:ISecurityManagerType), ISecurityManager).
            return SecMgr.
        end get.
        private set.

    define protected property ConMgr as IConnectionManager no-undo
        get():
            if not valid-object(ConMgr) then
                ConMgr = cast(ServiceManager:GetService(ConnectionManager:IConnectionManagerType), IConnectionManager).
            return ConMgr.
        end get.
        private set.

    define protected property BizLogicService as IBizLogicAPI no-undo
        get():
            define variable oServerConnection as IServerConnection no-undo.
            if not valid-object(BizLogicService) then
            do:
                oServerConnection = ConMgr:GetServerConnection(ConnectionTypeEnum:BpmServer, 'bpmAutoEdgeTheFactory').
                if valid-object(oServerConnection) then
                do:
                    if not oServerConnection:IsConnected then
                        oServerConnection:Connect().
                    BizLogicService = cast(oServerConnection:Server, IBizLogicAPI).
                end.
            end.
            return BizLogicService.
        end get.
        set.

    /** Shows help about a class.

        @param Class The caller of this dialog */
    constructor public HelpAbout(input poCaller as class Class):
        define variable oTab as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.

        this-object().

        mcDocURL = BuildAutoDoxURL(poCaller).
        oTab = uxSettingsGroup:Tabs['uxCodeDoc'].
        oTab:Enabled = true.
    end constructor.

    constructor public HelpAbout():
        super().

        InitializeComponent().

        InitData().

        /* default to not show any code documentation */
        uxSettingsGroup:Tabs['uxCodeDoc']:Enabled = false.

        ShowHelp().

        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

    method protected void ShowHelp():
        define variable cVersion as character no-undo.

        input from 'version.txt'.
            import unformatted cVersion.
        input close.

        uxVersionInfo:Text = cVersion.

    end method.

    method protected void InitData():
        define variable cBpmSessionId as character no-undo.
        define variable cBpmServerHost as character no-undo.
        define variable lBpmServerConnected as logical no-undo.
        define variable cAppServerHost as character no-undo.
        define variable lAppServerConnected as logical no-undo.
        define variable cUserName as character no-undo.
        define variable cUserDomain as character no-undo.
        define variable cTenantName as character no-undo.
        define variable oPropertyValue  as String no-undo.
        define variable oUC as IUserContext no-undo.
        define variable oServerConnection as IServerConnection no-undo.
        define variable cUnknownString as character no-undo.
        define variable iLoop as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oKey as Object no-undo.

        cUnknownString = '<unknown>'.

        /* servers */
        oServerConnection = ConMgr:GetServerConnection(ConnectionTypeEnum:BpmServer, 'bpmAutoEdgeTheFactory').
        if valid-object(oServerConnection) then
            assign cBpmServerHost = string(oServerConnection:ConnectionParameters:GetConnectionString())
                   lBpmServerConnected = oServerConnection:IsConnected.
        else
            assign cBpmServerHost = cUnknownString
                   lBpmServerConnected = false.

        create mSettingData.
        assign mSettingData.SettingGroup = 'BPM'
               mSettingData.Order = 1
               mSettingData.Key = 'Bpm Server Name'
               mSettingData.SettingValue = 'bpmAutoEdgeTheFactory'.

        create mSettingData.
        assign mSettingData.SettingGroup = 'BPM'
               mSettingData.Order = 2
               mSettingData.Key = 'Bpm Server Host'
               mSettingData.SettingValue = cBpmServerHost.

        create mSettingData.
        assign mSettingData.SettingGroup = 'BPM'
               mSettingData.Order = 3
               mSettingData.Key = 'IsConnected'
               mSettingData.SettingValue = string(lBpmServerConnected).

        oServerConnection = ConMgr:GetServerConnection(ConnectionTypeEnum:AppServer, 'asAutoEdgeTheFactory').
        if valid-object(oServerConnection) then
            assign cAppServerHost = string(oServerConnection:ConnectionParameters:GetConnectionString())
                   lAppServerConnected = oServerConnection:IsConnected.
        else
            assign cAppServerHost = cUnknownString
                   lAppServerConnected = false.

        create mSettingData.
        assign mSettingData.SettingGroup = 'OPENEDGE'
               mSettingData.Order = 1
               mSettingData.Key = 'AppServer Name'
               mSettingData.SettingValue = 'asAutoEdgeTheFactory'.

        create mSettingData.
        assign mSettingData.SettingGroup = 'OPENEDGE'
               mSettingData.Order = 2
               mSettingData.Key = 'AppServer Host'
               mSettingData.SettingValue = cAppServerHost.

        create mSettingData.
        assign mSettingData.SettingGroup = 'OPENEDGE'
               mSettingData.Order = 3
               mSettingData.Key = 'IsConnected'
               mSettingData.SettingValue = string(lAppServerConnected).

        oUC = cast(SecMgr, OpenEdge.CommonInfrastructure.Common.ISecurityManager):CurrentUserContext.
        if valid-object(oUC) then
        do:
            assign cUserName = oUC:UserName
                   cUserDomain = oUC:UserDomain
                   cTenantName = oUC:TenantName.
            iLoop = 4.
            oIterator = oUC:UserProperties:KeySet:Iterator().
            do while oIterator:HasNext():
                oKey = oIterator:Next().

                create mSettingData.
                assign mSettingData.SettingGroup = 'USER'
                       mSettingData.Order = iLoop
                       iLoop = iLoop + 1
                       mSettingData.Key = oKey:ToString()
                       mSettingData.SettingValue = oUC:UserProperties:Get(oKey):ToString().
            end.
        end.
        else
            assign cUserName = cUnknownString
                   cUserDomain = cUnknownString
                   cTenantName = cUnknownString.

        create mSettingData.
        assign mSettingData.SettingGroup = 'USER'
               mSettingData.Order = 1
               mSettingData.Key = 'Login Name'
               mSettingData.SettingValue = cUserName.

        create mSettingData.
        assign mSettingData.SettingGroup = 'USER'
               mSettingData.Order = 2
               mSettingData.Key = 'Login Domain'
               mSettingData.SettingValue = cUserDomain.

        create mSettingData.
        assign mSettingData.SettingGroup = 'USER'
               mSettingData.Order = 3
               mSettingData.Key = 'Tenant Name'
               mSettingData.SettingValue = cTenantName.

    end method.

    method private void InitializeComponent(  ):

        /* NOTE: The following method is automatically generated.

        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.

        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance81 as Infragistics.Win.Appearance no-undo.
        appearance81 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridBand1 as Infragistics.Win.UltraWinGrid.UltraGridBand no-undo.
        ultraGridBand1 = new Infragistics.Win.UltraWinGrid.UltraGridBand("mSettingData", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn3 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn3 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("Key").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraGridColumn4 as Infragistics.Win.UltraWinGrid.UltraGridColumn no-undo.
        ultraGridColumn4 = new Infragistics.Win.UltraWinGrid.UltraGridColumn("SettingValue").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance82 as Infragistics.Win.Appearance no-undo.
        appearance82 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance83 as Infragistics.Win.Appearance no-undo.
        appearance83 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance84 as Infragistics.Win.Appearance no-undo.
        appearance84 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance85 as Infragistics.Win.Appearance no-undo.
        appearance85 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance86 as Infragistics.Win.Appearance no-undo.
        appearance86 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance87 as Infragistics.Win.Appearance no-undo.
        appearance87 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance88 as Infragistics.Win.Appearance no-undo.
        appearance88 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance89 as Infragistics.Win.Appearance no-undo.
        appearance89 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance90 as Infragistics.Win.Appearance no-undo.
        appearance90 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance91 as Infragistics.Win.Appearance no-undo.
        appearance91 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance92 as Infragistics.Win.Appearance no-undo.
        appearance92 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance93 as Infragistics.Win.Appearance no-undo.
        appearance93 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance94 as Infragistics.Win.Appearance no-undo.
        appearance94 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("mSettingData").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("AutoEdge.Factory.Client.Order.PresentationLayer.HelpAbout").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance1 as Infragistics.Win.Appearance no-undo.
        appearance1 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab3 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab3 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance6 as Infragistics.Win.Appearance no-undo.
        appearance6 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab1 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab1 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance4 as Infragistics.Win.Appearance no-undo.
        appearance4 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab2 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab2 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance5 as Infragistics.Win.Appearance no-undo.
        appearance5 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable ultraTab5 as Infragistics.Win.UltraWinTabControl.UltraTab no-undo.
        ultraTab5 = new Infragistics.Win.UltraWinTabControl.UltraTab().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance3 as Infragistics.Win.Appearance no-undo.
        appearance3 = new Infragistics.Win.Appearance().
        this-object:uxWebBrowserPanel = new Infragistics.Win.Misc.UltraPanel().
        this-object:uxWebBrowser = new System.Windows.Forms.WebBrowser().
        this-object:ultraTabPageControl1 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:ultraTabPageControl2 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:ultraTabPageControl3 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:uxDetail = new Infragistics.Win.UltraWinGrid.UltraGrid().
        this-object:bsSettings = new Progress.Data.BindingSource(this-object:components).
        this-object:ultraTabPageControl5 = new Infragistics.Win.UltraWinTabControl.UltraTabPageControl().
        this-object:ultraPanel1 = new Infragistics.Win.Misc.UltraPanel().
        this-object:uxLogo = new Infragistics.Win.UltraWinEditors.UltraPictureBox().
        this-object:uxVersionInfo = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:imageList1 = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxSettingsGroup = new Infragistics.Win.UltraWinTabControl.UltraTabControl().
        this-object:ultraTabSharedControlsPage1 = new Infragistics.Win.UltraWinTabControl.UltraTabSharedControlsPage().
        this-object:uxWebBrowserPanel:ClientArea:SuspendLayout().
        this-object:uxWebBrowserPanel:SuspendLayout().
        this-object:ultraTabPageControl1:SuspendLayout().
        cast(this-object:uxDetail, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bsSettings, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:ultraPanel1:ClientArea:SuspendLayout().
        this-object:ultraPanel1:SuspendLayout().
        cast(this-object:uxVersionInfo, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxSettingsGroup, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:uxSettingsGroup:SuspendLayout().
        this-object:ultraTabSharedControlsPage1:SuspendLayout().
        this-object:SuspendLayout().
        /*  */
        /* uxWebBrowserPanel */
        /*  */
        /*  */
        /* uxWebBrowserPanel.ClientArea */
        /*  */
        this-object:uxWebBrowserPanel:ClientArea:Controls:Add(this-object:uxWebBrowser).
        this-object:uxWebBrowserPanel:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxWebBrowserPanel:Location = new System.Drawing.Point(0, 0).
        this-object:uxWebBrowserPanel:Name = "uxWebBrowserPanel".
        this-object:uxWebBrowserPanel:Size = new System.Drawing.Size(452, 248).
        this-object:uxWebBrowserPanel:TabIndex = 2.
        /*  */
        /* uxWebBrowser */
        /*  */
        this-object:uxWebBrowser:AllowNavigation = false.
        this-object:uxWebBrowser:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxWebBrowser:Location = new System.Drawing.Point(0, 0).
        this-object:uxWebBrowser:MinimumSize = new System.Drawing.Size(20, 20).
        this-object:uxWebBrowser:Name = "uxWebBrowser".
        this-object:uxWebBrowser:ScriptErrorsSuppressed = true.
        this-object:uxWebBrowser:Size = new System.Drawing.Size(452, 248).
        this-object:uxWebBrowser:TabIndex = 0.
        /*  */
        /* ultraTabPageControl1 */
        /*  */
        this-object:ultraTabPageControl1:Controls:Add(this-object:uxDetail).
        this-object:ultraTabPageControl1:Location = new System.Drawing.Point(38, 1).
        this-object:ultraTabPageControl1:Name = "ultraTabPageControl1".
        this-object:ultraTabPageControl1:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* ultraTabPageControl2 */
        /*  */
        this-object:ultraTabPageControl2:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabPageControl2:Name = "ultraTabPageControl2".
        this-object:ultraTabPageControl2:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* ultraTabPageControl3 */
        /*  */
        this-object:ultraTabPageControl3:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabPageControl3:Name = "ultraTabPageControl3".
        this-object:ultraTabPageControl3:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* uxDetail */
        /*  */
        this-object:uxDetail:DataSource = this-object:bsSettings.
        appearance81:BackColor = System.Drawing.SystemColors:Window.
        appearance81:BorderColor = System.Drawing.SystemColors:InactiveCaption.
        this-object:uxDetail:DisplayLayout:Appearance = appearance81.
        this-object:uxDetail:DisplayLayout:AutoFitStyle = Infragistics.Win.UltraWinGrid.AutoFitStyle:ResizeAllColumns.
        ultraGridBand1:ColHeadersVisible = false.
        ultraGridColumn3:CellActivation = Infragistics.Win.UltraWinGrid.Activation:NoEdit.
        ultraGridColumn3:Header:Fixed = true.
        ultraGridColumn3:Header:VisiblePosition = 0.
        ultraGridColumn3:Width = 201.
        ultraGridColumn4:AllowGroupBy = Infragistics.Win.DefaultableBoolean:False.
        ultraGridColumn4:CellActivation = Infragistics.Win.UltraWinGrid.Activation:NoEdit.
        ultraGridColumn4:Header:Fixed = true.
        ultraGridColumn4:Header:VisiblePosition = 1.
        ultraGridColumn4:Width = 249.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Object extent 2 no-undo.
        arrayvar0[1] = ultraGridColumn3.
        arrayvar0[2] = ultraGridColumn4.
        ultraGridBand1:Columns:AddRange(arrayvar0).
        ultraGridBand1:Override:CellDisplayStyle = Infragistics.Win.UltraWinGrid.CellDisplayStyle:PlainText.
        this-object:uxDetail:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
        this-object:uxDetail:DisplayLayout:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        appearance82:FontData:Name = "Segoe UI".
        appearance82:ForeColor = System.Drawing.SystemColors:InactiveCaptionText.
        appearance82:TextHAlignAsString = "Center".
        this-object:uxDetail:DisplayLayout:CaptionAppearance = appearance82.
        this-object:uxDetail:DisplayLayout:CaptionVisible = Infragistics.Win.DefaultableBoolean:True.
        appearance83:BackColor = System.Drawing.SystemColors:ActiveBorder.
        appearance83:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance83:BackGradientStyle = Infragistics.Win.GradientStyle:Vertical.
        appearance83:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:GroupByBox:Appearance = appearance83.
        appearance84:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxDetail:DisplayLayout:GroupByBox:BandLabelAppearance = appearance84.
        this-object:uxDetail:DisplayLayout:GroupByBox:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        this-object:uxDetail:DisplayLayout:GroupByBox:Hidden = true.
        appearance85:BackColor = System.Drawing.SystemColors:ControlLightLight.
        appearance85:BackColor2 = System.Drawing.SystemColors:Control.
        appearance85:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance85:ForeColor = System.Drawing.SystemColors:GrayText.
        this-object:uxDetail:DisplayLayout:GroupByBox:PromptAppearance = appearance85.
        this-object:uxDetail:DisplayLayout:MaxColScrollRegions = 1.
        this-object:uxDetail:DisplayLayout:MaxRowScrollRegions = 1.
        appearance86:BackColor = System.Drawing.SystemColors:Window.
        appearance86:ForeColor = System.Drawing.SystemColors:ControlText.
        this-object:uxDetail:DisplayLayout:Override:ActiveCellAppearance = appearance86.
        appearance87:BackColor = System.Drawing.SystemColors:Highlight.
        appearance87:ForeColor = System.Drawing.SystemColors:HighlightText.
        this-object:uxDetail:DisplayLayout:Override:ActiveRowAppearance = appearance87.
        this-object:uxDetail:DisplayLayout:Override:AllowAddNew = Infragistics.Win.UltraWinGrid.AllowAddNew:No.
        this-object:uxDetail:DisplayLayout:Override:AllowDelete = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxDetail:DisplayLayout:Override:AllowUpdate = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxDetail:DisplayLayout:Override:BorderStyleCell = Infragistics.Win.UIElementBorderStyle:None.
        this-object:uxDetail:DisplayLayout:Override:BorderStyleRow = Infragistics.Win.UIElementBorderStyle:None.
        appearance88:BackColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:Override:CardAreaAppearance = appearance88.
        appearance89:BorderColor = System.Drawing.Color:Silver.
        appearance89:TextTrimming = Infragistics.Win.TextTrimming:EllipsisCharacter.
        this-object:uxDetail:DisplayLayout:Override:CellAppearance = appearance89.
        this-object:uxDetail:DisplayLayout:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:EditAndSelectText.
        this-object:uxDetail:DisplayLayout:Override:CellPadding = 0.
        appearance90:BackColor = System.Drawing.SystemColors:Control.
        appearance90:BackColor2 = System.Drawing.SystemColors:ControlDark.
        appearance90:BackGradientAlignment = Infragistics.Win.GradientAlignment:Element.
        appearance90:BackGradientStyle = Infragistics.Win.GradientStyle:Horizontal.
        appearance90:BorderColor = System.Drawing.SystemColors:Window.
        this-object:uxDetail:DisplayLayout:Override:GroupByRowAppearance = appearance90.
        appearance91:TextHAlignAsString = "Left".
        this-object:uxDetail:DisplayLayout:Override:HeaderAppearance = appearance91.
        this-object:uxDetail:DisplayLayout:Override:HeaderStyle = Infragistics.Win.HeaderStyle:WindowsXPCommand.
        appearance92:BackColor = System.Drawing.SystemColors:GradientInactiveCaption.
        this-object:uxDetail:DisplayLayout:Override:RowAlternateAppearance = appearance92.
        appearance93:BackColor = System.Drawing.SystemColors:Window.
        appearance93:BorderColor = System.Drawing.Color:Silver.
        this-object:uxDetail:DisplayLayout:Override:RowAppearance = appearance93.
        this-object:uxDetail:DisplayLayout:Override:RowSelectors = Infragistics.Win.DefaultableBoolean:False.
        appearance94:BackColor = System.Drawing.SystemColors:ControlLight.
        this-object:uxDetail:DisplayLayout:Override:TemplateAddRowAppearance = appearance94.
        this-object:uxDetail:DisplayLayout:RowConnectorStyle = Infragistics.Win.UltraWinGrid.RowConnectorStyle:None.
        this-object:uxDetail:DisplayLayout:ScrollBounds = Infragistics.Win.UltraWinGrid.ScrollBounds:ScrollToFill.
        this-object:uxDetail:DisplayLayout:ScrollStyle = Infragistics.Win.UltraWinGrid.ScrollStyle:Immediate.
        this-object:uxDetail:DisplayLayout:ViewStyle = Infragistics.Win.UltraWinGrid.ViewStyle:SingleBand.
        this-object:uxDetail:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxDetail:Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25, System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(0)).
        this-object:uxDetail:Location = new System.Drawing.Point(0, 0).
        this-object:uxDetail:Name = "uxDetail".
        this-object:uxDetail:Size = new System.Drawing.Size(452, 248).
        this-object:uxDetail:TabIndex = 1.
        this-object:uxDetail:Text = "User Detail".
        /*  */
        /* bsSettings */
        /*  */
        this-object:bsSettings:MaxDataGuess = 0.
        this-object:bsSettings:NoLOBs = false.
        this-object:bsSettings:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("Key", "Key", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = new Progress.Data.ColumnPropDesc("SettingValue", "Value", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar2.
        this-object:bsSettings:TableSchema = tableDesc1.
        /*  */
        /* ultraTabPageControl5 */
        /*  */
        this-object:ultraTabPageControl5:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabPageControl5:Name = "ultraTabPageControl5".
        this-object:ultraTabPageControl5:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* ultraPanel1 */
        /*  */
        /*  */
        /* ultraPanel1.ClientArea */
        /*  */
        this-object:ultraPanel1:ClientArea:Controls:Add(this-object:uxLogo).
        this-object:ultraPanel1:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:ultraPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:ultraPanel1:Name = "ultraPanel1".
        this-object:ultraPanel1:Size = new System.Drawing.Size(491, 55).
        this-object:ultraPanel1:TabIndex = 0.
        /*  */
        /* uxLogo */
        /*  */
        this-object:uxLogo:BorderShadowColor = System.Drawing.Color:Empty.
        this-object:uxLogo:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:uxLogo:Image = cast(resources:GetObject("uxLogo.Image"), System.Object).
        this-object:uxLogo:Location = new System.Drawing.Point(0, 0).
        this-object:uxLogo:Name = "uxLogo".
        this-object:uxLogo:Size = new System.Drawing.Size(491, 50).
        this-object:uxLogo:TabIndex = 1.
        /*  */
        /* uxVersionInfo */
        /*  */
        appearance1:BackColor = System.Drawing.Color:White.
        appearance1:BackColorDisabled = System.Drawing.Color:White.
        appearance1:ForeColorDisabled = System.Drawing.SystemColors:ControlText.
        appearance1:TextHAlignAsString = "Center".
        this-object:uxVersionInfo:Appearance = appearance1.
        this-object:uxVersionInfo:BackColor = System.Drawing.Color:White.
        this-object:uxVersionInfo:Dock = System.Windows.Forms.DockStyle:Top.
        this-object:uxVersionInfo:Enabled = false.
        this-object:uxVersionInfo:Location = new System.Drawing.Point(0, 55).
        this-object:uxVersionInfo:Multiline = true.
        this-object:uxVersionInfo:Name = "uxVersionInfo".
        this-object:uxVersionInfo:ShowOverflowIndicator = true.
        this-object:uxVersionInfo:Size = new System.Drawing.Size(491, 32).
        this-object:uxVersionInfo:TabIndex = 0.
        this-object:uxVersionInfo:TabStop = false.
        /*  */
        /* imageList1 */
        /*  */
        this-object:imageList1:ImageStream = cast(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageList1:Images:SetKeyName(0, "aetf.ico").
        this-object:imageList1:Images:SetKeyName(1, "progress.ico").
        this-object:imageList1:Images:SetKeyName(2, "aetf_logo.png").
        this-object:imageList1:Images:SetKeyName(3, "source_p_32x32.png").
        this-object:imageList1:Images:SetKeyName(4, "services_32x32.png").
        this-object:imageList1:Images:SetKeyName(5, "bpmstudio_32x32.ico").
        this-object:imageList1:Images:SetKeyName(6, "user_32x32.png").
        /*  */
        /* uxSettingsGroup */
        /*  */
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabSharedControlsPage1).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl1).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl2).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl3).
        this-object:uxSettingsGroup:Controls:Add(this-object:ultraTabPageControl5).
        this-object:uxSettingsGroup:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:uxSettingsGroup:ImageList = this-object:imageList1.
        this-object:uxSettingsGroup:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxSettingsGroup:Location = new System.Drawing.Point(0, 87).
        this-object:uxSettingsGroup:Name = "uxSettingsGroup".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as System.Windows.Forms.Control extent 2 no-undo.
        arrayvar3[1] = this-object:uxDetail.
        arrayvar3[2] = this-object:uxWebBrowserPanel.
        this-object:uxSettingsGroup:SharedControls:AddRange(arrayvar3).
        this-object:uxSettingsGroup:SharedControlsPage = this-object:ultraTabSharedControlsPage1.
        this-object:uxSettingsGroup:Size = new System.Drawing.Size(491, 250).
        this-object:uxSettingsGroup:TabButtonStyle = Infragistics.Win.UIElementButtonStyle:Borderless.
        this-object:uxSettingsGroup:TabIndex = 1.
        this-object:uxSettingsGroup:TabOrientation = Infragistics.Win.UltraWinTabs.TabOrientation:LeftTop.
        appearance6:Image = "user_32x32.png".
        appearance6:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance6:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab3:Appearance = appearance6.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as System.Windows.Forms.Control extent 1 no-undo.
        arrayvar4[1] = this-object:uxWebBrowserPanel.
        ultraTab3:ExcludedSharedControls:AddRange(arrayvar4).
        ultraTab3:Key = "uxAETFGroup".
        ultraTab3:TabPage = this-object:ultraTabPageControl1.
        ultraTab3:Text = "".
        ultraTab3:ToolTipText = "Application settings".
        appearance4:Image = "bpmstudio_32x32.ico".
        appearance4:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance4:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab1:Appearance = appearance4.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as System.Windows.Forms.Control extent 1 no-undo.
        arrayvar5[1] = this-object:uxWebBrowserPanel.
        ultraTab1:ExcludedSharedControls:AddRange(arrayvar5).
        ultraTab1:Key = "uxBpmGroup".
        ultraTab1:TabPage = this-object:ultraTabPageControl2.
        ultraTab1:Text = "".
        ultraTab1:ToolTipText = "BPM server settings ".
        appearance5:Image = "services_32x32.png".
        appearance5:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance5:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab2:Appearance = appearance5.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar6 as System.Windows.Forms.Control extent 1 no-undo.
        arrayvar6[1] = this-object:uxWebBrowserPanel.
        ultraTab2:ExcludedSharedControls:AddRange(arrayvar6).
        ultraTab2:Key = "uxOEGroup".
        ultraTab2:TabPage = this-object:ultraTabPageControl3.
        ultraTab2:Text = "".
        ultraTab2:ToolTipText = "AppServer settings".
        appearance3:Image = "source_p_32x32.png".
        appearance3:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance3:ImageVAlign = Infragistics.Win.VAlign:Middle.
        ultraTab5:Appearance = appearance3.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar7 as System.Windows.Forms.Control extent 1 no-undo.
        arrayvar7[1] = this-object:uxDetail.
        ultraTab5:ExcludedSharedControls:AddRange(arrayvar7).
        ultraTab5:Key = "uxCodeDoc".
        ultraTab5:TabPage = this-object:ultraTabPageControl5.
        ultraTab5:Text = "".
        ultraTab5:ToolTipText = "AutoDox2 code documentation".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar8 as Infragistics.Win.UltraWinTabControl.UltraTab extent 4 no-undo.
        arrayvar8[1] = ultraTab3.
        arrayvar8[2] = ultraTab1.
        arrayvar8[3] = ultraTab2.
        arrayvar8[4] = ultraTab5.
        this-object:uxSettingsGroup:Tabs:AddRange(arrayvar8).
        this-object:uxSettingsGroup:UseFlatMode = Infragistics.Win.DefaultableBoolean:False.
        this-object:uxSettingsGroup:ViewStyle = Infragistics.Win.UltraWinTabControl.ViewStyle:Office2007.
        this-object:uxSettingsGroup:ActiveTabChanging:Subscribe(this-object:uxSettingsGroup_ActiveTabChanging).
        /*  */
        /* ultraTabSharedControlsPage1 */
        /*  */
        this-object:ultraTabSharedControlsPage1:Controls:Add(this-object:uxDetail).
        this-object:ultraTabSharedControlsPage1:Controls:Add(this-object:uxWebBrowserPanel).
        this-object:ultraTabSharedControlsPage1:Location = new System.Drawing.Point(-10000, -10000).
        this-object:ultraTabSharedControlsPage1:Name = "ultraTabSharedControlsPage1".
        this-object:ultraTabSharedControlsPage1:Size = new System.Drawing.Size(452, 248).
        /*  */
        /* HelpAbout */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(491, 337).
        this-object:Controls:Add(this-object:uxSettingsGroup).
        this-object:Controls:Add(this-object:uxVersionInfo).
        this-object:Controls:Add(this-object:ultraPanel1).
        this-object:Icon = cast(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        this-object:MinimumSize = new System.Drawing.Size(370, 325).
        this-object:Name = "HelpAbout".
        this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
        this-object:Text = "About".
        this-object:uxWebBrowserPanel:ClientArea:ResumeLayout(false).
        this-object:uxWebBrowserPanel:ResumeLayout(false).
        this-object:ultraTabPageControl1:ResumeLayout(false).
        cast(this-object:uxDetail, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bsSettings, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ultraPanel1:ClientArea:ResumeLayout(false).
        this-object:ultraPanel1:ResumeLayout(false).
        cast(this-object:uxVersionInfo, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxSettingsGroup, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:uxSettingsGroup:ResumeLayout(false).
        this-object:ultraTabSharedControlsPage1:ResumeLayout(false).
        this-object:ResumeLayout(false).
        this-object:PerformLayout().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    /*------------------------------------------------------------------------------
            Purpose:
            Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void uxSettingsGroup_ActiveTabChanging( input sender as System.Object, input e as Infragistics.Win.UltraWinTabControl.ActiveTabChangingEventArgs ):
        case string(e:Tab:Key):
            when 'uxAETFGroup' then ShowDetailGrid('USER', 'User Detail').
            when 'uxBpmGroup' then ShowDetailGrid('BPM', 'BPM Server Detail').
            when 'uxOEGroup' then ShowDetailGrid('OPENEDGE', 'AppServer Detail').
            when 'uxCodeDoc' then ShowUrl(mcDocURL).
        end case.
    end method.

    method private character BuildAutoDoxURL(input poCaller as class Class):
        define variable cFullPath as character no-undo.

        cFullPath = search('autodox2/' + replace(poCaller:TypeName, '.', '~/') + '.cls.html').
        if cFullPath eq ? then
            cFullPath = search('autodox2/index.html').

        Assert:ArgumentNotNullOrEmpty(cFullPath, 'Top-level AutoDox index page').
        file-info:file-name = cFullPath.
        cFullPath = file-info:full-pathname.

        return 'file:///' + replace(cFullPath, '~\', '~/').
    end method.

    method private void ShowURL(input pcURL as character):
        uxWebBrowser:Url = new System.Uri(pcURL).
    end method.

    method private void ShowDetailGrid(input pcGroup as character,
                                       input pcCaption as character):

        open query mQrySettings preselect each mSettingData where mSettingData.SettingGroup eq pcGroup by mSettingData.Order.
        bsSettings:Handle = query mQrySettings:handle.

        uxDetail:Text = pcCaption.
    end method.

    destructor public HelpAbout ( ):
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.
    end destructor.

end class.