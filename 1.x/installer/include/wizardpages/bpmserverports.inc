  
  [Code]
  var
    lblBpmServerPort: TLabel;
    lblBpmServerHost: TLabel;
    txtBpmServerPort: TEdit;
    txtBpmServerHost: TEdit;
  
  procedure BpmServer_Activate(Page: TWizardPage);
  begin
  end;
  
  function BpmServer_ShouldSkipPage(Page: TWizardPage): Boolean;
  begin
    Result := False;
  end;
  
  function BpmServer_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  function BpmServer_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  procedure BpmServer_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;
  
  function BpmServer_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:BpmServerCaption}'),
      ExpandConstant('{cm:BpmServerDescription}')
    );
  
    { lblBpmServerPort }
    lblBpmServerPort := TLabel.Create(Page);
    with lblBpmServerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(59);
      Top := ScaleY(76);
      Width := ScaleX(20);
      Height := ScaleY(13);
      Caption := 'Port';
    end;
    
    { lblBpmServerHost }
    lblBpmServerHost := TLabel.Create(Page);
    with lblBpmServerHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(27);
      Top := ScaleY(44);
      Width := ScaleX(55);
      Height := ScaleY(13);
      Caption := 'BPM Server';
    end;
    
    { txtBpmServerPort }
    txtBpmServerPort := TEdit.Create(Page);
    with txtBpmServerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(112);
      Top := ScaleY(72);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 0;
      Text := '18793';
    end;
    
    { txtBpmServerHost }
    txtBpmServerHost := TEdit.Create(Page);
    with txtBpmServerHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(112);
      Top := ScaleY(40);
      Width := ScaleX(145);
      Height := ScaleY(21);
      TabOrder := 1;
      Text := 'localhost';
    end;
    
  
    with Page do
    begin
      OnActivate := @BpmServer_Activate;
      OnBackButtonClick := @BpmServer_BackButtonClick;
      OnNextButtonClick := @BpmServer_NextButtonClick;
      OnCancelButtonClick := @BpmServer_CancelButtonClick;
    end;
  
    Result := Page.ID;
  end;
