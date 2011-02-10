[CustomMessages]
DBBrokerPortsCaption=Progress Database Brokers Setup
DBBrokerPortsDescription=Please provide the database broker ports (TCP) to use

[Code]
var
	lblDBAutoEdgeFactory		: TLabel;
	txtDBAutoEdgeFactory		: TEdit;

{ We will validate whether a port has been filled out and if it has 4 or more digits	}
{ no real port check is done here now, which we could add later if required.			}
	
function DBBrokerPorts_NextButtonClick(Page: TWizardPage): Boolean;
begin
	if ( Length( txtDBAutoEdgeFactory.Text ) < 4 ) then
	begin
		MsgBox( 'Database Broker Port for AutoEdge|TheFactory needs to be 1000+!', mbError, MB_OK );
		Result := false;
	end
	else
	begin
		Result := True;
	end;
end;

function DBBrokerPorts_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
begin
	Page := CreateCustomPage( PreviousPageId,
							  ExpandConstant( '{cm:DBBrokerPortsCaption}' ),
							  ExpandConstant( '{cm:DBBrokerPortsDescription}' ));

  { lblDBAutoEdgeFactory }
  lblDBAutoEdgeFactory := TLabel.Create(Page);
  with lblDBAutoEdgeFactory do
  begin
    Parent := Page.Surface;
    Left := ScaleX(35);
    Top := ScaleY(28);
    Width := ScaleX(106);
    Height := ScaleY(13);
    Caption := 'AutoEdge|TheFactory';
  end;
  
  { txtDBAutoEdgeFactory }
  txtDBAutoEdgeFactory := TEdit.Create(Page);
  with txtDBAutoEdgeFactory do
  begin
    Parent := Page.Surface;
    Left := ScaleX(176);
    Top := ScaleY(24);
    Width := ScaleX(65);
    Height := ScaleY(21);
    TabOrder := 0;
    Text := '7010';
  end;
	
	with Page do
	begin
		OnNextButtonClick := @DBBrokerPorts_NextButtonClick;
	end;
	
	Result := Page.ID;
end;
