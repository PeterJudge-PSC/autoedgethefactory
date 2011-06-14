[Code]
var
	lblAdminServerPort: TLabel;
	lblNSPort:			TLabel;
	txtAdminServerPort: TEdit;
	txtNSPort:			TEdit;


procedure AdminPort_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
end;

function AdminPort_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
begin
	Page := CreateCustomPage( PreviousPageId,
							  ExpandConstant( '{cm:AdminPortCaption}' ),
							  ExpandConstant( '{cm:AdminPortDescription}' ));

	{ lblAdminServerPort }
	lblAdminServerPort := TLabel.Create(Page);
	with lblAdminServerPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(11);
		Top := ScaleY(43);
		Width := ScaleX(166);
		Height := ScaleY(13);
		Caption := 'Progress AdminServer PortNumber';
	end;
	
	{ lblNSPort }
	lblNSPort := TLabel.Create(Page);
	with lblNSPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(12);
		Top := ScaleY(68);
		Width := ScaleX(164);
		Height := ScaleY(13);
		Caption := 'Progress NameServer PortNumber';
	end;
	
	{ txtAdminServerPort }
	txtAdminServerPort := TEdit.Create(Page);
	with txtAdminServerPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(208);
		Top := ScaleY(40);
		Width := ScaleX(65);
		Height := ScaleY(21);
		TabOrder := 0;
		Text := '20931';
	end;
	
	{ txtNSPort }
	txtNSPort := TEdit.Create(Page);
	with txtNSPort do
	begin
		Parent := Page.Surface;
		Left := ScaleX(208);
		Top := ScaleY(64);
		Width := ScaleX(65);
		Height := ScaleY(21);
		TabOrder := 1;
		Text := '5162';
	end;
  
	
	Result := Page.ID;
end;
