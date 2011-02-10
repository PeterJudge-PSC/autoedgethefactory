[CustomMessages]
ASBrokerPortsCaption=Progress AppServer Brokers Setup
ASBrokerPortsDescription=Please specify the AppServer broker ports (TCP) to use

[Code]
var
	lblASAutoEdgeFactory		: TLabel;
  lblMinPort			: TLabel;
  lblMaxPort			: TLabel;
	txtASAutoEdgeFactory		: TEdit;
  txtMinPort			: TEdit;
  txtMaxPort			: TEdit;

function ASBrokerPorts_NextButtonClick(Page: TWizardPage): Boolean;
begin
	Result := True;
end;

function ASBrokerPorts_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
begin
	Page := CreateCustomPage( PreviousPageId,
							  ExpandConstant( '{cm:ASBrokerPortsCaption}' ),
							  ExpandConstant( '{cm:ASBrokerPortsDescription}' ));

  { lblASAutoEdgeFactory }
  lblASAutoEdgeFactory := TLabel.Create(Page);
  with lblASAutoEdgeFactory do
  begin
    Parent := Page.Surface;
    Left := ScaleX(16);
    Top := ScaleY(28);
    Width := ScaleX(106);
    Height := ScaleY(13);
    Caption := 'AutoEdge|TheFactory';
  end;
  
  { lblMinPort }
  lblMinPort := TLabel.Create(Page);
  with lblMinPort do
  begin
    Parent := Page.Surface;
    Left := ScaleX(16);
    Top := ScaleY(60);
    Width := ScaleX(76);
    Height := ScaleY(13);
    Caption := 'Agents Min Port';
  end;
  
  { lblMaxPort }
  lblMaxPort := TLabel.Create(Page);
  with lblMaxPort do
  begin
    Parent := Page.Surface;
    Left := ScaleX(16);
    Top := ScaleY(92);
    Width := ScaleX(80);
    Height := ScaleY(13);
    Caption := 'Agents Max Port';
  end;
  
  { txtASAutoEdgeFactory }
  txtASAutoEdgeFactory := TEdit.Create(Page);
  with txtASAutoEdgeFactory do
  begin
    Parent := Page.Surface;
    Left := ScaleX(168);
    Top := ScaleY(24);
    Width := ScaleX(65);
    Height := ScaleY(21);
    TabOrder := 0;
    Text := '7101';
  end;
  
  { txtMinPort }
  txtMinPort := TEdit.Create(Page);
  with txtMinPort do
  begin
    Parent := Page.Surface;
    Left := ScaleX(168);
    Top := ScaleY(56);
    Width := ScaleX(65);
    Height := ScaleY(21);
    TabOrder := 1;
    Text := '2200';
  end;
  
  { txtMaxPort }
  txtMaxPort := TEdit.Create(Page);
  with txtMaxPort do
  begin
    Parent := Page.Surface;
    Left := ScaleX(168);
    Top := ScaleY(88);
    Width := ScaleX(65);
    Height := ScaleY(21);
    TabOrder := 2;
    Text := '2400';
  end;
  	
	with Page do
	begin
		OnNextButtonClick := @ASBrokerPorts_NextButtonClick;
	end;
	
	Result := Page.ID;
end;
