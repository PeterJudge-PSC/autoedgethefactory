[CustomMessages]
OpenEdgeReleaseCaption=OpenEdge Release Selection
OpenEdgeReleaseDescription=Please select the OpenEdge Release to be used for the installation.

[Code]
var
	lblOpenEdgeRelease: TLabel;
	cbOpenEdgeRelease: TComboBox;
	OpenEdgeVersion : string;

function GetOpenEdgeVersion() : string;
begin
	Result := OpenEdgeVersion;
end;

procedure OpenEdgeRelease_Activate(Page: TWizardPage);
var
	OpenEdgeReleases : TArrayOfString;
	S : string;
	I : integer;
	startPos : integer;
  strMajorVer, strMinorVer : string;
  intPos, intMajorVer : integer; 
begin

	OpenEdgeVersion := '';
	
	{	We will read all subkeys underneath HKLM/PSC/PROGRESS to see what	}
	{	versions of Progress are installed. This list will then be			}
	{	presented to the user to select the version to use for the			}
	{	installation using the OpenEdgeRelease wizard page.					}

	cbOpenEdgeRelease.Items.Clear();

	if RegGetSubkeyNames( HKEY_LOCAL_MACHINE, 'SOFTWARE\PSC\PROGRESS', OpenEdgeReleases ) then
	begin
		for I := 0 to ( GetArrayLength( OpenEdgeReleases ) - 1 ) do
		begin
			S := OpenEdgeReleases[ I ];
      intPos := Pos('.', S);
      strMajorVer := Copy(S, 1, intPos-1);
      try
        intMajorVer := StrToInt(strMajorVer);
      except
        intMajorVer := 0; 
      end;
      
      // Only allow versions of OpenEdge > 10.2B
      if ( ( intMajorVer = 10 ) and
           ( Copy(S, intPos+1, 2) = '2B' ) ) or  
      // anything from 11 onwards works
           ( intMajorVer >= 10 ) then 
			begin
				cbOpenEdgeRelease.Items.Add( S );
			end;
		end;

    // select first item 
    if ( cbOpenEdgeRelease.Items.Count > 0 ) then
      cbOpenEdgeRelease.ItemIndex := 0;
	end
	else
	begin
		MsgBox( 'Unable to retrieve information on installed OpenEdge Releases!', mbError, MB_OK );
		Abort();
	end;
end;

function OpenEdgeRelease_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
	Result := False;
end;

function OpenEdgeRelease_NextButtonClick(Page: TWizardPage): Boolean;
begin

	OpenEdgeVersion := cbOpenEdgeRelease.Text;

	{	Selection has to be made and has to fit '10.xx' at least	}
	{	so this is four chars minimum.								}

	if ( length( OpenEdgeVersion ) < 5 ) then
		Result := false
	else
		Result := True;

end;

function OpenEdgeRelease_CreatePage(PreviousPageId: Integer): Integer;
var
	Page: TWizardPage;
begin
	Page := CreateCustomPage(
		PreviousPageId,
		ExpandConstant('{cm:OpenEdgeReleaseCaption}'),
		ExpandConstant('{cm:OpenEdgeReleaseDescription}')
	);

	{ lblOpenEdgeRelease }
	lblOpenEdgeRelease := TLabel.Create(Page);
	with lblOpenEdgeRelease do
	begin
		Parent := Page.Surface;
		Left := ScaleX(18);
		Top := ScaleY(27);
		Width := ScaleX(91);
		Height := ScaleY(13);
		Caption := 'OpenEdge Release';
	end;

	{ cbOpenEdgeRelease }
	cbOpenEdgeRelease := TComboBox.Create(Page);
	with cbOpenEdgeRelease do
	begin
		Parent := Page.Surface;
		Left := ScaleX(128);
		Top := ScaleY(24);
		Width := ScaleX(249);
		Height := ScaleY(21);
		TabOrder := 0;
	end;


	with Page do
	begin
		OnActivate := @OpenEdgeRelease_Activate;
		OnShouldSkipPage := @OpenEdgeRelease_ShouldSkipPage;
		OnNextButtonClick := @OpenEdgeRelease_NextButtonClick;
	end;

	Result := Page.ID;
end;


