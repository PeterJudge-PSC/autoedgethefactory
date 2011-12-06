[CustomMessages]
HostnameCaption=Web Application Client Setup
HostnameDescription=Please specify the hostname of the web application server

[Code]
var
	lblHostname: TLabel;
	lblWebServerPort: TLabel;
	txtHostname: TEdit;
	btnPing: TButton;
	txtWebServerPort: TEdit;

procedure Ping_OnClick(Button: TObject);
var
	ret	:integer;
begin
	if ( Length( txtHostname.Text ) > 0 ) then
	begin
		if not Exec( 'ping.exe' , txtHostname.Text, ExpandConstant( '{sys}' ), SW_SHOW, ewWaitUntilTerminated, ret ) then
		begin
			MsgBox( 'PING failed: ' + SysErrorMessage( ret ), mbError, MB_OK );
		end
	end;
end;

function Hostname_NextButtonClick(Page: TWizardPage): Boolean;
begin
	if ( Length( txtHostname.Text ) = 0 ) then
	begin
		MsgBox( 'Please specify a valid hostname!', mbError, MB_OK );
		Result := false;
	end
	else if ( Length( txtWebServerPort.Text ) = 0 ) then
	begin
		MsgBox( 'Please specify a valid web server port number!', mbError, MB_OK );
		Result := false;
	end
	else
	begin
		Result := True;
	end;
end;

function Hostname_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
begin
	Page := CreateCustomPage( PreviousPageId,
							  ExpandConstant( '{cm:HostnameCaption}' ),
							  ExpandConstant( '{cm:HostnameDescription}' ));
	
	{ lblHostname }
	lblHostname := TLabel.Create(Page);
	with lblHostname do
	begin
		Parent := Page.Surface;
		Left := ScaleX(11);
		Top := ScaleY(32);
		Width := ScaleX(48);
		Height := ScaleY(13);
		Caption := 'Hostname';
	end;
	
	{ lblWebServerPort }
	lblWebServerPort := TLabel.Create(Page);
	with lblWebServerPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(11);
		Top := ScaleY(60);
		Width := ScaleX(80);
		Height := ScaleY(13);
		Caption := 'Web Server Port';
	end;
	
	{ txtHostname }
	txtHostname := TEdit.Create(Page);
	with txtHostname do
	begin
		Parent := Page.Surface;
		Left := ScaleX(103);
		Top := ScaleY(29);
		Width := ScaleX(217);
		Height := ScaleY(21);
		TabOrder := 0;
		Text := 'localhost';
	end;
	
	{ btnPing }
	btnPing := TButton.Create(Page);
	with btnPing do
	begin
		Parent := Page.Surface;
		Left := ScaleX(328);
		Top := ScaleY(28);
		Width := ScaleX(75);
		Height := ScaleY(23);
		Caption := 'Ping';
		TabOrder := 1;
	end;
	
	{ txtWebServerPort }
	txtWebServerPort := TEdit.Create(Page);
	with txtWebServerPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(104);
		Top := ScaleY(56);
		Width := ScaleX(57);
		Height := ScaleY(21);
		TabOrder := 2;
		Text := '80';
	end;
  
	with Page do
	begin
		OnNextButtonClick := @Hostname_NextButtonClick;
	end;
	
	Result := Page.ID;
end;
