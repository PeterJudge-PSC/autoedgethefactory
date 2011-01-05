/*------------------------------------------------------------------------
    File        : ServerConnectPanel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 09 08:10:42 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw. 

using AutoEdge.Factory.Order.PresentationLayer.ITaskListManager.
using Progress.Windows.Form.
using Progress.Windows.UserControl.


class AutoEdge.Factory.Order.PresentationLayer.ServerConnectPanel inherits UserControl: 
	
	define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable uxInputPanel as Infragistics.Win.Misc.UltraPanel no-undo.
    define private variable uxUser as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.
    define private variable uxPortal as Infragistics.Win.UltraWinEditors.UltraComboEditor no-undo.
    define private variable uxPassword as Infragistics.Win.UltraWinEditors.UltraTextEditor no-undo.
    define private variable uxLogin as Infragistics.Win.Misc.UltraButton no-undo.
    define private variable uxCancel as Infragistics.Win.Misc.UltraButton no-undo.
    define private variable lblUser as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable lblPortal as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable lblPassword as Infragistics.Win.Misc.UltraLabel no-undo.
    define private variable imageList1 as System.Windows.Forms.ImageList no-undo.

    define private variable moTaskListManager as ITaskListManager no-undo.
    
	constructor public ServerConnectPanel(input poParent as ITaskListManager):
        this-object().
        moTaskListManager = poParent.
	end constructor.
	
	constructor public ServerConnectPanel (  ):
        super().
        
        InitializeComponent().
        
        uxPortal:Value = uxPortal:Items[0].
        
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
        define variable appearance6 as Infragistics.Win.Appearance no-undo.
        appearance6 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance5 as Infragistics.Win.Appearance no-undo.
        appearance5 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance2 as Infragistics.Win.Appearance no-undo.
        appearance2 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable resources as Progress.Util.ResourceManager no-undo.
        resources = new Progress.Util.ResourceManager("AutoEdge.Factory.Order.PresentationLayer.ServerConnectPanel").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance3 as Infragistics.Win.Appearance no-undo.
        appearance3 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance9 as Infragistics.Win.Appearance no-undo.
        appearance9 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance4 as Infragistics.Win.Appearance no-undo.
        appearance4 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable valueListItem2 as Infragistics.Win.ValueListItem no-undo.
        valueListItem2 = new Infragistics.Win.ValueListItem().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance1 as Infragistics.Win.Appearance no-undo.
        appearance1 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance8 as Infragistics.Win.Appearance no-undo.
        appearance8 = new Infragistics.Win.Appearance().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable appearance7 as Infragistics.Win.Appearance no-undo.
        appearance7 = new Infragistics.Win.Appearance().
        this-object:lblUser = new Infragistics.Win.Misc.UltraLabel().
        this-object:uxInputPanel = new Infragistics.Win.Misc.UltraPanel().
        this-object:uxLogin = new Infragistics.Win.Misc.UltraButton().
        this-object:imageList1 = new System.Windows.Forms.ImageList(this-object:components).
        this-object:uxCancel = new Infragistics.Win.Misc.UltraButton().
        this-object:uxUser = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:uxPortal = new Infragistics.Win.UltraWinEditors.UltraComboEditor().
        this-object:lblPortal = new Infragistics.Win.Misc.UltraLabel().
        this-object:uxPassword = new Infragistics.Win.UltraWinEditors.UltraTextEditor().
        this-object:lblPassword = new Infragistics.Win.Misc.UltraLabel().
        this-object:uxInputPanel:ClientArea:SuspendLayout().
        this-object:uxInputPanel:SuspendLayout().
        cast(this-object:uxUser, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxPortal, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:uxPassword, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* lblUser */
        /*  */
        appearance6:FontData:Name = "Segoe UI".
        appearance6:FontData:SizeInPoints = 12.
        appearance6:TextVAlignAsString = "Middle".
        this-object:lblUser:Appearance = appearance6.
        this-object:lblUser:Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25).
        this-object:lblUser:Location = new System.Drawing.Point(20, 70).
        this-object:lblUser:Name = "lblUser".
        this-object:lblUser:Size = new System.Drawing.Size(340, 31).
        this-object:lblUser:TabIndex = 18.
        this-object:lblUser:Text = "User Name".
        /*  */
        /* uxInputPanel */
        /*  */
        appearance5:BackColor = System.Drawing.Color:Silver.
        appearance5:BorderColor = System.Drawing.Color:Black.
        appearance5:ImageBackgroundStyle = Infragistics.Win.ImageBackgroundStyle:Stretched.
        this-object:uxInputPanel:Appearance = appearance5.
        this-object:uxInputPanel:AutoSize = true.
        /*  */
        /* uxInputPanel.ClientArea */
        /*  */
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxLogin).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxCancel).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxUser).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxPortal).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblPortal).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblUser).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:uxPassword).
        this-object:uxInputPanel:ClientArea:Controls:Add(this-object:lblPassword).
        this-object:uxInputPanel:Location = new System.Drawing.Point(0, 0).
        this-object:uxInputPanel:Name = "uxInputPanel".
        this-object:uxInputPanel:Size = new System.Drawing.Size(392, 198).
        this-object:uxInputPanel:TabIndex = 21.
        /*  */
        /* uxLogin */
        /*  */
        appearance2:FontData:Name = "Segoe UI".
        appearance2:FontData:SizeInPoints = 12.
        appearance2:Image = "Knob Valid Green.png".
        this-object:uxLogin:Appearance = appearance2.
        this-object:uxLogin:DialogResult = System.Windows.Forms.DialogResult:OK.
        this-object:uxLogin:ImageList = this-object:imageList1.
        this-object:uxLogin:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxLogin:Location = new System.Drawing.Point(117, 144).
        this-object:uxLogin:Name = "uxLogin".
        this-object:uxLogin:Size = new System.Drawing.Size(120, 40).
        this-object:uxLogin:TabIndex = 40.
        this-object:uxLogin:Text = "Login".
        this-object:uxLogin:Click:Subscribe(this-object:uxLogin_Click).
        /*  */
        /* imageList1 */
        /*  */
        this-object:imageList1:ImageStream = cast(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        this-object:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        this-object:imageList1:Images:SetKeyName(0, "Knob Valid Green.png").
        this-object:imageList1:Images:SetKeyName(1, "Knob Snapback.png").
        this-object:imageList1:Images:SetKeyName(2, "portal_silver_icon.png").
        this-object:imageList1:Images:SetKeyName(3, "portal_silver.png").
        this-object:imageList1:Images:SetKeyName(4, "").
        /*  */
        /* uxCancel */
        /*  */
        appearance3:FontData:Name = "Segoe UI".
        appearance3:FontData:SizeInPoints = 12.
        appearance3:Image = "Knob Snapback.png".
        this-object:uxCancel:Appearance = appearance3.
        this-object:uxCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        this-object:uxCancel:ImageList = this-object:imageList1.
        this-object:uxCancel:ImageSize = new System.Drawing.Size(32, 32).
        this-object:uxCancel:Location = new System.Drawing.Point(242, 145).
        this-object:uxCancel:Name = "uxCancel".
        this-object:uxCancel:Size = new System.Drawing.Size(120, 40).
        this-object:uxCancel:TabIndex = 50.
        this-object:uxCancel:Text = "Cancel".
        this-object:uxCancel:Click:Subscribe(this-object:uxCancel_Click).
        /*  */
        /* uxUser */
        /*  */
        appearance9:FontData:Name = "Segoe UI".
        appearance9:FontData:SizeInPoints = 12.
        this-object:uxUser:Appearance = appearance9.
        this-object:uxUser:Location = new System.Drawing.Point(120, 70).
        this-object:uxUser:Name = "uxUser".
        this-object:uxUser:Size = new System.Drawing.Size(242, 31).
        this-object:uxUser:TabIndex = 20.
        this-object:uxUser:Text = "ebms".
        /*  */
        /* uxPortal */
        /*  */
        appearance4:FontData:Name = "Segoe UI".
        appearance4:FontData:SizeInPoints = 12.
        this-object:uxPortal:Appearance = appearance4.
        valueListItem2:DataValue = "172.16.114.240:18793".
        valueListItem2:DisplayText = "OEBPM Training server".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as Infragistics.Win.ValueListItem extent 1 no-undo.
        arrayvar0[1] = valueListItem2.
        this-object:uxPortal:Items:AddRange(arrayvar0).
        this-object:uxPortal:Location = new System.Drawing.Point(120, 32).
        this-object:uxPortal:Name = "uxPortal".
        this-object:uxPortal:Size = new System.Drawing.Size(242, 31).
        this-object:uxPortal:TabIndex = 10.
        /*  */
        /* lblPortal */
        /*  */
        appearance1:FontData:Name = "Segoe UI".
        appearance1:FontData:SizeInPoints = 12.
        appearance1:TextVAlignAsString = "Middle".
        this-object:lblPortal:Appearance = appearance1.
        this-object:lblPortal:Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25).
        this-object:lblPortal:Location = new System.Drawing.Point(20, 32).
        this-object:lblPortal:Name = "lblPortal".
        this-object:lblPortal:Size = new System.Drawing.Size(340, 31).
        this-object:lblPortal:TabIndex = 0.
        this-object:lblPortal:Text = "BPM Portal".
        /*  */
        /* uxPassword */
        /*  */
        appearance8:FontData:Name = "Segoe UI".
        appearance8:FontData:SizeInPoints = 12.
        this-object:uxPassword:Appearance = appearance8.
        this-object:uxPassword:Location = new System.Drawing.Point(120, 110).
        this-object:uxPassword:Name = "uxPassword".
        this-object:uxPassword:PasswordChar = '*'.
        this-object:uxPassword:Size = new System.Drawing.Size(242, 31).
        this-object:uxPassword:TabIndex = 30.
        this-object:uxPassword:Text = "ebms".
        /*  */
        /* lblPassword */
        /*  */
        appearance7:FontData:Name = "Segoe UI".
        appearance7:FontData:SizeInPoints = 12.
        appearance7:TextVAlignAsString = "Middle".
        this-object:lblPassword:Appearance = appearance7.
        this-object:lblPassword:Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25).
        this-object:lblPassword:Location = new System.Drawing.Point(20, 110).
        this-object:lblPassword:Name = "lblPassword".
        this-object:lblPassword:Size = new System.Drawing.Size(340, 31).
        this-object:lblPassword:TabIndex = 17.
        this-object:lblPassword:Text = "Password".
        /*  */
        /* ServerConnectPanel */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(6, 13).
        this-object:AutoSize = true.
        this-object:AutoSizeMode = System.Windows.Forms.AutoSizeMode:GrowAndShrink.
        this-object:BackColor = System.Drawing.Color:Transparent.
        this-object:Controls:Add(this-object:uxInputPanel).
        this-object:Name = "ServerConnectPanel".
        this-object:Size = new System.Drawing.Size(395, 201).
        this-object:uxInputPanel:ClientArea:ResumeLayout(false).
        this-object:uxInputPanel:ClientArea:PerformLayout().
        this-object:uxInputPanel:ResumeLayout(false).
        this-object:uxInputPanel:PerformLayout().
        cast(this-object:uxUser, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxPortal, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:uxPassword, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        this-object:PerformLayout().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
	end method.

    method override protected void OnLoad(input e as System.EventArgs ):
        super:OnLoad(input e).
        this-object:ActiveControl  = uxUser.
    end method.

	method private void uxCancel_Click( input sender as System.Object, input e as System.EventArgs ):
        cast(this-object:Parent, Form):Close().
	end method.
	
	method private void uxLogin_Click( input sender as System.Object, input e as System.EventArgs ):
        moTaskListManager:ServerConnect(uxUser:Text, uxPassword:Text, uxPortal:Value:ToString()).
        
        /* do this here in case of error */
        cast(this-object:Parent, Form):Close().
	end method.
	
	destructor public ServerConnectPanel ( ):
		if valid-object(components) then do:
			cast(components, System.IDisposable):Dispose().
		end.
	end destructor.

end class.