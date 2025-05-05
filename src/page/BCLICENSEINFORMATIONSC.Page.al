


/// <summary>
/// Page "SCANPAN_BC_LICENSE_INFORMATION" (ID 50002).
/// </summary>
/// 
/// <remarks>
/// 
/// – 
/// – TaLicense Permissionble Information
/// – Active Sessions
/// – Database locks
/// – Events
/// – Installed apps
/// 
/// </remarks>
page 50002 "BC_LICENSE_INFORMATION_SC"
{
    AdditionalSearchTerms = 'Scanpan';
    ApplicationArea = All;
    Caption = 'SCANPAN_BC_LICENSE_INFORMATION';
    PageType = List;
    SourceTable = "License Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Text"; Rec."Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Text field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }

            }
        }
    }
}
