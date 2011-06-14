  
    [Code]
  var
    lblAETFASBrokerPort: TLabel;
    lblAETFASMinPort: TLabel;
    lblAETFASMaxPort: TLabel;
    lblAETFAppserverName: TLabel;
    txtAETFASBrokerPort: TEdit;
    txtAETFASMinPort: TEdit;
    txtAETFASMaxPort: TEdit;
    txtAEFAppserverName: TEdit;
  
  procedure ASBrokerPorts_Activate(Page: TWizardPage);
  begin
  end;
  
  function ASBrokerPorts_ShouldSkipPage(Page: TWizardPage): Boolean;
  begin
    Result := False;
  end;
  
  function ASBrokerPorts_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  function ASBrokerPorts_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  procedure ASBrokerPorts_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;
  
  function ASBrokerPorts_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:ASBrokerPortsCaption}'),
      ExpandConstant('{cm:ASBrokerPortsDescription}')
    );
  
    { lblAETFASBrokerPort }
    lblAETFASBrokerPort := TLabel.Create(Page);
    with lblAETFASBrokerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(52);
      Width := ScaleX(54);
      Height := ScaleY(13);
      Caption := 'Broker Port';
    end;
    
    { lblAETFASMinPort }
    lblAETFASMinPort := TLabel.Create(Page);
    with lblAETFASMinPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(84);
      Width := ScaleX(76);
      Height := ScaleY(13);
      Caption := 'Agents Min Port';
    end;
    
    { lblAETFASMaxPort }
    lblAETFASMaxPort := TLabel.Create(Page);
    with lblAETFASMaxPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(116);
      Width := ScaleX(80);
      Height := ScaleY(13);
      Caption := 'Agents Max Port';
    end;
    
    { lblAETFAppserverName }
    lblAETFAppserverName := TLabel.Create(Page);
    with lblAETFAppserverName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(20);
      Width := ScaleX(81);
      Height := ScaleY(13);
      Caption := 'AppServer Name';
    end;
    
    { txtAETFASBrokerPort }
    txtAETFASBrokerPort := TEdit.Create(Page);
    with txtAETFASBrokerPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(48);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 0;
      Text := '7101';
    end;
    
    { txtAETFASMinPort }
    txtAETFASMinPort := TEdit.Create(Page);
    with txtAETFASMinPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(80);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 1;
      Text := '2200';
    end;
    
    { txtAETFASMaxPort }
    txtAETFASMaxPort := TEdit.Create(Page);
    with txtAETFASMaxPort do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(112);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 2;
      Text := '2400';
    end;
    
    { txtAEFAppserverName }
    txtAEFAppserverName := TEdit.Create(Page);
    with txtAEFAppserverName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(16);
      Width := ScaleX(137);
      Height := ScaleY(21);
      TabOrder := 3;
      Text := 'asAutoEdgeTheFactory';
    end;
    
  
    with Page do
    begin
      OnActivate := @ASBrokerPorts_Activate;
      OnShouldSkipPage := @ASBrokerPorts_ShouldSkipPage;
      OnBackButtonClick := @ASBrokerPorts_BackButtonClick;
      OnNextButtonClick := @ASBrokerPorts_NextButtonClick;
      OnCancelButtonClick := @ASBrokerPorts_CancelButtonClick;
    end;
  
    Result := Page.ID;
  end;
