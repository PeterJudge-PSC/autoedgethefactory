  [Code]
  var
    lblAETFDBService: TLabel;
    lblAETFDBHost: TLabel;
    lblAETFDBName: TLabel;
    txtAETFDBService: TEdit;
    txtAETFDBHost: TEdit;
    txtAETFDBName: TEdit;
  
  procedure DBBrokerPorts_Activate(Page: TWizardPage);
  begin
  end;
   
  function DBBrokerPorts_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  function DBBrokerPorts_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  procedure DBBrokerPorts_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;
  
  function DBBrokerPorts_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:DBBrokerPortsCaption}'),
      ExpandConstant('{cm:DBBrokerPortsDescription}')
    );
  
    { lblAETFDBService }
    lblAETFDBService := TLabel.Create(Page);
    with lblAETFDBService do
    begin
      Parent := Page.Surface;
      Left := ScaleX(83);
      Top := ScaleY(68);
      Width := ScaleX(65);
      Height := ScaleY(13);
      Caption := 'Port / Service';
    end;
    
    { lblAETFDBHost }
    lblAETFDBHost := TLabel.Create(Page);
    with lblAETFDBHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(83);
      Top := ScaleY(44);
      Width := ScaleX(22);
      Height := ScaleY(13);
      Caption := 'Host';
    end;
    
    { lblAETFDBName }
    lblAETFDBName := TLabel.Create(Page);
    with lblAETFDBName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(83);
      Top := ScaleY(20);
      Width := ScaleX(27);
      Height := ScaleY(13);
      Caption := 'Name';
    end;
    
    { txtAETFDBService }
    txtAETFDBService := TEdit.Create(Page);
    with txtAETFDBService do
    begin
      Parent := Page.Surface;
      Left := ScaleX(176);
      Top := ScaleY(64);
      Width := ScaleX(65);
      Height := ScaleY(21);
      TabOrder := 0;
      Text := '7010';
    end;
    
    { txtAETFDBHost }
    txtAETFDBHost := TEdit.Create(Page);
    with txtAETFDBHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(176);
      Top := ScaleY(40);
      Width := ScaleX(129);
      Height := ScaleY(21);
      TabOrder := 1;
      Text := 'localhost';
    end;
    
    { txtAETFDBName }
    txtAETFDBName := TEdit.Create(Page);
    with txtAETFDBName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(176);
      Top := ScaleY(16);
      Width := ScaleX(129);
      Height := ScaleY(21);
      TabOrder := 2;
      Text := 'dbAutoEdgeTheFactory';
    end;
    
  
    with Page do
    begin
      OnActivate := @DBBrokerPorts_Activate;
      OnBackButtonClick := @DBBrokerPorts_BackButtonClick;
      OnNextButtonClick := @DBBrokerPorts_NextButtonClick;
      OnCancelButtonClick := @DBBrokerPorts_CancelButtonClick;
    end;
  
    Result := Page.ID;
  end;
