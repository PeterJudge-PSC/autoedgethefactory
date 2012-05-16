  
  [Code]
  var
    lblOpenEdgeServerPort: TLabel;
    lblOEServerHost: TLabel;
    txtBpmServerPort: TEdit;
    txtOEServerHost: TEdit;
    txtOEAdapter: TNewStaticText;
  
  procedure BpmModelSettings_Activate(Page: TWizardPage);
  begin
  end;
  
  function BpmModelSettings_ShouldSkipPage(Page: TWizardPage): Boolean;
  begin
    Result := False;
  end;
  
  function BpmModelSettings_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  function BpmModelSettings_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  procedure BpmModelSettings_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;
  
  function BpmModelSettings_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:BpmModelSettingsCaption}'),
      ExpandConstant('{cm:BpmModelSettingsDescription}')
    );
  
    { lblOpenEdgeServerPort }
    lblOpenEdgeServerPort := TLabel.Create(Page);
    with lblOpenEdgeServerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(51);
      Top := ScaleY(68);
      Width := ScaleX(108);
      Height := ScaleY(13);
      Caption := 'OpenEdge Server Port';
    end;
    
    { lblOEServerHost }
    lblOEServerHost := TLabel.Create(Page);
    with lblOEServerHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(51);
      Top := ScaleY(44);
      Width := ScaleX(110);
      Height := ScaleY(13);
      Caption := 'OpenEdge Server Host';
    end;
    
    { txtBpmServerPort }
    txtBpmServerPort := TEdit.Create(Page);
    with txtBpmServerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(64);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 0;
      Text := '8080';
    end;
    
    { txtOEServerHost }
    txtOEServerHost := TEdit.Create(Page);
    with txtOEServerHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(40);
      Width := ScaleX(145);
      Height := ScaleY(21);
      TabOrder := 1;
      Text := 'localhost';
    end;
    
    { txtOEAdapter }
    txtOEAdapter := TNewStaticText.Create(Page);
    with txtOEAdapter do
    begin
      Parent := Page.Surface;
      Left := ScaleX(24);
      Top := ScaleY(16);
      Width := ScaleX(156);
      Height := ScaleY(14);
      Caption := 'OpenEdge Adapter Settings';
      Font.Color := -16777208;
      Font.Height := ScaleY(-11);
      Font.Name := 'Tahoma';
      Font.Style := [fsBold];
      ParentFont := False;
      TabOrder := 2;
    end;
    
  
    with Page do
    begin
      OnActivate := @BpmModelSettings_Activate;
      OnShouldSkipPage := @BpmModelSettings_ShouldSkipPage;
      OnBackButtonClick := @BpmModelSettings_BackButtonClick;
      OnNextButtonClick := @BpmModelSettings_NextButtonClick;
      OnCancelButtonClick := @BpmModelSettings_CancelButtonClick;
    end;
  
    Result := Page.ID;
  end;
  
  procedure InitializeWizard();
  begin
    BpmModelSettings_CreatePage(wpWelcome);
  end;
