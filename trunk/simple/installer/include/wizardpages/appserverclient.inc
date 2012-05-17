  [Code]
  var
    lblAppServerName: TLabel;
    lblAppServerHost: TLabel;
    txtAETFASHost: TEdit;
    txtAETFASClientName: TEdit;
  
  procedure AppServerClient_Activate(Page: TWizardPage);
  begin
  end;
  
  function AppServerClient_ShouldSkipPage(Page: TWizardPage): Boolean;
  begin
    Result := False;
  end;
  
  function AppServerClient_BackButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  function AppServerClient_NextButtonClick(Page: TWizardPage): Boolean;
  begin
    Result := True;
  end;
  
  procedure AppServerClient_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
  begin
  end;
  
  function AppServerClient_CreatePage(PreviousPageId: Integer): Integer;
  var
    Page: TWizardPage;
  begin
    Page := CreateCustomPage(
      PreviousPageId,
      ExpandConstant('{cm:AppServerClientCaption}'),
      ExpandConstant('{cm:AppServerClientDescription}')
    );
  
    { lblAppServerName }
    lblAppServerName := TLabel.Create(Page);
    with lblAppServerName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(20);
      Width := ScaleX(81);
      Height := ScaleY(13);
      Caption := 'AppServer Name';
    end;
    
    { lblAppServerHost }
    lblAppServerHost := TLabel.Create(Page);
    with lblAppServerHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(16);
      Top := ScaleY(52);
      Width := ScaleX(76);
      Height := ScaleY(13);
      Caption := 'AppServer Host';
    end;
    
    { txtAETFASHost }
    txtAETFASHost := TEdit.Create(Page);
    with txtAETFASHost do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(48);
      Width := ScaleX(137);
      Height := ScaleY(21);
      TabOrder := 0;
      Text := 'localhost';
    end;
    
    { txtAETFASClientName }
    txtAETFASClientName := TEdit.Create(Page);
    with txtAETFASClientName do
    begin
      Parent := Page.Surface;
      Left := ScaleX(168);
      Top := ScaleY(16);
      Width := ScaleX(137);
      Height := ScaleY(21);
      TabOrder := 1;
      Text := 'asAutoEdgeTheFactory';
    end;
    
  
    with Page do
    begin
      OnActivate := @AppServerClient_Activate;
      OnBackButtonClick := @AppServerClient_BackButtonClick;
      OnNextButtonClick := @AppServerClient_NextButtonClick;
      OnCancelButtonClick := @AppServerClient_CancelButtonClick;
    end;
  
    Result := Page.ID;
  end;
