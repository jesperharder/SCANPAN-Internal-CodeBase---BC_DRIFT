




/// <summary>
/// Codeunit SCANPAN_CodeBase (ID 50000).
/// </summary>
/// 
/// <remarks>
/// Version list
/// 2022.12             Jesper Harder       0193        Base Scanpan Codeunit
/// 2022.12             Jesper Harder       0193        Implements Item.Picture
/// </remarks>
codeunit 50000 "PIMimages" 
{
    Access = Public;
    Subtype = Normal;

    trigger OnRun()
    begin

    end;

    ///
    /// 
    /// Implements Item.Picture
    /// 


    #region formatGUIDtoURL
    /// <summary>
    /// formatGUIDtoURL.
    /// </summary>
    /// <param name="GuidStr">Text.</param>
    /// <param name="Width">Integer.</param>
    /// <param name="Height">Integer.</param>
    /// <returns>Return variable ImageURL of type Text.</returns>
    procedure formatGUIDtoURL(GuidStr: Text; Width: Integer; Height: Integer) ImageURL: Text
    var
        baseUrl: Text;
        endPoint: Text;
        id: Text;
        size: Text;
    begin
        //https://cdn.scanpan.dk/perfion/image.aspx?ID=3ca1d013-3701-49d9-8420-e8d56f5e8399&size=237x160
        baseUrl := 'https://cdn.scanpan.dk';
        endPoint := '/perfion/image.aspx';
        id := '?ID=' + GuidStr;
        size := '&size=' + format(Width) + 'x' + format(Height);
        ImageURL := baseUrl + endPoint + id + size;
    end;
    #endregion

    #region GetImageURL
    /// <summary>
    /// GetImageURL.
    /// </summary>
    /// <param name="ItemNo">code[20].</param>
    /// <param name="Width">Integer.</param>
    /// <param name="Height">Integer.</param>
    /// <returns>Return variable ImageURL of type Text.</returns>
    procedure GetImageURL(ItemNo: code[20]; Width: Integer; Height: Integer) ImageURL: Text
    var
        Length: Integer;
        StartIndex: Integer;
        ContentToSend: Text;
        GuidStr: Text;
        Result: Text;
    begin
        ContentToSend := '<Query>';
        ContentToSend += '    <Select languages="EN" options="IncludeFeatureViewOrder">';
        ContentToSend += '        <Feature id="Produktbillede" />';
        ContentToSend += '    </Select>';
        ContentToSend += '    <From id ="Product"/>';
        ContentToSend += '    <Where>';
        ContentToSend += '        <Clause id="Varenummer" operator="Match" value="' + ItemNo + '"/>';
        ContentToSend += '    </Where>';
        ContentToSend += '</Query>';

        Result := MakeRequest('http://cdn.scanpan.dk/Perfion/GetData.asmx', ContentToSend);

        Length := 36;
        StartIndex := Text.StrPos(Result, '&lt;/Produktbillede&gt;') - Length;
        if StartIndex < 0 then exit;

        GuidStr := Text.CopyStr(Result, StartIndex, Length);
        ImageURL := formatGUIDtoURL(GuidStr, Width, Height);
    end;
    #endregion

    #region GetItemImagesFromFilter
    /// <summary>
    /// GetItemImagesFromFilter.
    /// </summary>
    /// <param name="ItemInventoryGroupFilter">Text.</param>
    /// <param name="OverwriteExistingImage">Boolean.</param>
    procedure GetItemImagesFromFilter(ItemInventoryGroupFilter: Text; OverwriteExistingImage: Boolean)
    var
        Items: Record Item;
        HttpClient: HttpClient;

        HttpResponseMessage: HttpResponseMessage;
        InStream: InStream;
        PictureURL: Text;
        WindowDialog: Dialog;
        ItemSetCounter: Integer;
        TotalSetCounter: Integer;
        RunCode: Boolean;

        Text001Lbl: Label 'Updating Item ';
        Text002Lbl: Label 'Inventory Posting Group filter: ';
    begin
        Items.SetFilter("Inventory Posting Group", ItemInventoryGroupFilter);
        if Items.FindSet() then begin
            WindowDialog.OPEN(Text001Lbl + '@1@@@@@@@@@@@@@@@ \' + Text002Lbl + ' ' + ItemInventoryGroupFilter);
            TotalSetCounter := Items.Count;
            RunCode := false;
            if (OverwriteExistingImage = false) and (Items.Picture.Count = 0) then
                RunCode := true;
            if OverwriteExistingImage = true then
                RunCode := true;
            repeat
                if RunCode = true then begin
                    PictureURL := (GetImageURL(Items."No.", 150, 150));
                    if PictureURL = '' then //Not found - use default SCANPAN image logo
                        PictureURL := 'https://cdn.scanpan.dk/perfion/image.aspx?ID=ce38aebe-312f-4c06-8840-55c12b80d9e9&size=75x75';
                    HttpClient.Get(PictureURL, HttpResponseMessage);
                    HttpResponseMessage.Content.ReadAs(InStream);
                    Clear(Items.Picture);
                    Items.Picture.ImportStream(InStream, 'Product Image ' + Format(Items."No."));
                    ItemSetCounter += 1;
                    WindowDialog.Update(1, ROUND(ItemSetCounter / TotalSetCounter * 10000, 1));

                    Items.Modify(true);
                end;
            until Items.NEXT() = 0;
            WindowDialog.Close();
        end;
    end;
    #endregion

    #region ImportItemPictureFromURL
    /// <summary>
    /// ImportItemPictureFromURL.
    /// </summary>
    /// <param name="ItemNo">code[20].</param>
    /// <param name="PictureURL">Text.</param>
    procedure ImportItemPictureFromURL(ItemNo: code[20]; PictureURL: Text)
    var
        Item: Record Item;
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        InStream: InStream;
    begin
        HttpClient.Get(PictureURL, HttpResponseMessage);
        HttpResponseMessage.Content.ReadAs(InStream);
        if Item.Get(ItemNo) then begin
            Clear(Item.Picture);
            Item.Picture.ImportStream(InStream, 'Demo picture for item ' + Format(Item."No."));
            Item.Modify(true);
        end;
    end;
    #endregion

    #region MakeRequest
    /// <summary>
    /// MakeRequest.
    /// </summary>
    /// <param name="uri">Text.</param>
    /// <param name="payload">Text.</param>
    /// <returns>Return variable responseText of type Text.</returns>
    procedure MakeRequest(uri: Text; payload: Text) responseText: Text;
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        contentHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        contentToSend: Text;
    begin

        ContentToSend := '<?xml version="1.0" encoding="utf-8"?>';
        ContentToSend += '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        ContentToSend += '<soap12:Body>';
        ContentToSend += '    <ExecuteQuery xmlns="http://perfion.com/">';
        ContentToSend += '        <query>';
        ContentToSend += '        <![CDATA[';
        contentToSend += payload;
        ContentToSend += '        ]]>';
        ContentToSend += '        </query>';
        ContentToSend += '    </ExecuteQuery>';
        ContentToSend += '</soap12:Body>';
        ContentToSend += '</soap12:Envelope>';



        // Add the payload to the content
        HttpContent.WriteFrom(contentToSend);

        // Retrieve the contentHeaders associated with the content
        HttpContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/soap+xml; charset=utf-8');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message
        HttpRequestMessage.Content := HttpContent;

        HttpRequestMessage.SetRequestUri(uri);
        HttpRequestMessage.Method := 'POST';

        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        // Read the response content as json.
        HttpResponseMessage.Content().ReadAs(responseText);
    end;
    #endregion
}
