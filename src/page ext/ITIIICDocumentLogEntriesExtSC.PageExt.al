
/// <summary>
/// PageExtension ITIIICDocumentLogEntriesExtSC (ID 50014) extends Record ITI IIC Document Log Entries.
/// </summary>
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 
/// </remarks>

pageextension 50014 "ITIIICDocumentLogEntriesExtSC" extends "ITI IIC Document Log Entries"
{
    layout
    {
        addafter("IIC Endpoint No.")
        {
            field("IIC Send To Endpoint No.38060"; Rec."IIC Send To Endpoint No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IIC Send To Endpoint No. field.';
            }
            field("Document ID18268"; Rec."Document ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document ID field.';
            }
        }
    }
}
