/// <summary>
/// Page Picture URL Dialog (ID 50001).
/// </summary>
/// <remarks>
///
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2022.12.25          Jesper Harder       0193        SOAP Workings by Magnus Harder, great code understanding and icebraker..
///
/// </remarks>
page 50001 "Picture URL Dialog"
{
    AdditionalSearchTerms = 'Scanpan';
    Caption = 'Picture URL Dialog';
    //https://yzhums.com/17574/
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            label("Single Item Image update")
            {
                ApplicationArea = All;
                Caption = 'Single Item Image update';
            }
            field(ItemNo; ItemNo)
            {
                ApplicationArea = All;
                Caption = 'Item No.';
                Editable = false;
                ToolTip = 'Specifies the value of the Item No. field.';
            }
            field(ItemDesc; ItemDesc)
            {
                ApplicationArea = All;
                Caption = 'Item Description';
                Editable = false;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
            field(PictureURL; PictureURL)
            {
                ApplicationArea = All;
                Caption = 'Picture URL';
                ExtendedDatatype = URL;
                ToolTip = 'Specifies the value of the Picture URL field.';
            }
            label("spacer2")
            {
                ApplicationArea = Basic, Suite;
                Caption = '', Locked = true;
            }
            label("Multiple Item Image update")
            {
                ApplicationArea = All;
                Caption = 'Multiple Item Image update';
            }
            field(OverwriteExistingImage; OverwriteExistingImage)
            {
                ApplicationArea = All;
                Caption = 'Overwrite existing Item Picture';
                ToolTip = 'Specifies the value of the Overwrite existing Item Picture field.';
            }
            field(ItemPostingGroup; InventoryPostinGroup)
            {
                ApplicationArea = All;
                Caption = 'Filter on Inventory Posting Group';
                TableRelation = "Inventory Posting Group";
                ToolTip = 'Specifies the value of the Filter on Inventory Posting Group field.';
            }
        }
    }

    var
        PIMimages: Codeunit "PIMimages";
        OverwriteExistingImage: Boolean;
        InventoryPostinGroup: Code[20];
        ItemNo: Code[20];
        PictureURL: Text;
        ItemDesc: Text[100];

    /// <summary>
    /// GetItemImages.
    /// </summary>
    procedure GetItemImages()
    var
    begin
        if PictureURL <> '' then PIMimages.ImportItemPictureFromURL(ItemNo, PictureURL);
        if InventoryPostinGroup <> '' then PIMimages.GetItemImagesFromFilter(InventoryPostinGroup, OverwriteExistingImage);
    end;

    /// <summary>
    /// SetItemInfo.
    /// </summary>
    /// <param name="NewItemNo">Code[20].</param>
    /// <param name="NewItemDesc">Text[100].</param>
    procedure SetItemInfo(NewItemNo: Code[20]; NewItemDesc: Text[100])
    begin
        ItemNo := NewItemNo;
        ItemDesc := NewItemDesc;
    end;
}