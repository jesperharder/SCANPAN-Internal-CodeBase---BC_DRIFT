

/// <summary>
/// PageExtension ItemPictureExtSC (ID 50025) extends Record Item Picture.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50025 "ItemPictureExtSC" extends "Item Picture"
{
    //https://yzhums.com/17574/
    actions
    {
        addafter(ImportPicture)
        {
            action(ImportPictureFromURL)
            {
                ApplicationArea = all;
                Caption = 'Import from URL';
                Image = Import;
                ToolTip = 'Import a picture file from URL.';

                trigger OnAction()
                var
                    PictureURLDialog: Page "Picture URL Dialog";
                begin
                    PictureURLDialog.SetItemInfo(Rec."No.", Rec.Description);
                    if PictureURLDialog.RunModal() = Action::OK then
                        PictureURLDialog.GetItemImages();
                end;
            }
        }
    }
}
