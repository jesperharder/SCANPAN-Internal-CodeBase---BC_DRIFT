pageextension 50091 "CommentSheet" extends "Comment Sheet"
{
    Caption = 'Comment Sheet Ext';
    AdditionalSearchTerms = 'Scanpan, CommentSheetExt,Comment Sheet Ext, CommentSheet';

    layout
    {
        addlast(Control1)
        {
            field("Name"; GetRelatedName())
            {
                ApplicationArea = All;
                Caption = 'Name';
                ToolTip = 'Shows the related name/description for the selected table and No.';
                Editable = false;
            }
            field("Table Name"; Rec."Table Name")
            {
                ApplicationArea = All;
                Caption = 'Table Name';
                ToolTip = 'Specifies the table to which the comment line is related.';
                Editable = false;
            }
        }
        addafter("Usage Code NOTO")
        {
            field("Usage Code Description"; UsageCodeDescription())
            {
                ApplicationArea = All;
                Caption = 'Usage Code Description';
                ToolTip = 'Displays the description of the selected usage code.';
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            group("SPN Filters")
            {
                Caption = 'SPN Filters';
                action(SPNIgnoreContextFilters)
                {
                    ApplicationArea = All;
                    Caption = 'Ignore context filters';
                    Image = ClearFilter;
                    ToolTip = 'Temporarily ignore the standard page context filters (RunPageLink & other system filter groups). Security filters are not affected.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        ClearContextFilters();
                        CurrPage.Update(false);
                    end;
                }
                action(SPNRestoreContextFilters)
                {
                    ApplicationArea = All;
                    Caption = 'Restore context filters';
                    Image = Filter;
                    ToolTip = 'Reapply the original context filters that were active when the page opened.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        RestoreContextFilters();
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Take a snapshot of all relevant filter groups so we can restore later.
        SnapshotViews();
    end;

    var
        BankAccount: Record "Bank Account";

        // Lookups used by GetRelatedName()
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
        Vendor: Record Vendor;
        UnknownLbl: Label 'Unknown', Locked = true, MaxLength = 2048;
        // Snapshots of GetView() per filter group
        SavedView0: Text;
        SavedView1: Text;
        SavedView2: Text;
        SavedView3: Text;
        SavedView7: Text;

    local procedure SnapshotViews()
    begin
        // Default
        Rec.FilterGroup(0);
        SavedView0 := Rec.GetView();
        // Global / other platform-applied filters
        Rec.FilterGroup(1);
        SavedView1 := Rec.GetView();
        Rec.FilterGroup(2);
        SavedView2 := Rec.GetView();
        Rec.FilterGroup(3);
        SavedView3 := Rec.GetView();
        // Context / RunPageLink (commonly ends up here)
        Rec.FilterGroup(7);
        SavedView7 := Rec.GetView();

        Rec.FilterGroup(0);
    end;

    local procedure ClearContextFilters()
    begin
        // Clear filters in commonly used groups. We explicitly skip group 4 (security filters).
        Rec.FilterGroup(0);
        Rec.SetView('');
        Rec.FilterGroup(1);
        Rec.SetView('');
        Rec.FilterGroup(2);
        Rec.SetView('');
        Rec.FilterGroup(3);
        Rec.SetView('');
        Rec.FilterGroup(7);
        Rec.SetView('');
        Rec.FilterGroup(0);
    end;

    local procedure RestoreContextFilters()
    begin
        // Restore previously captured views (if any)
        Rec.FilterGroup(0);
        if SavedView0 <> '' then Rec.SetView(SavedView0) else Rec.SetView('');
        Rec.FilterGroup(1);
        if SavedView1 <> '' then Rec.SetView(SavedView1) else Rec.SetView('');
        Rec.FilterGroup(2);
        if SavedView2 <> '' then Rec.SetView(SavedView2) else Rec.SetView('');
        Rec.FilterGroup(3);
        if SavedView3 <> '' then Rec.SetView(SavedView3) else Rec.SetView('');
        Rec.FilterGroup(7);
        if SavedView7 <> '' then Rec.SetView(SavedView7) else Rec.SetView('');
        Rec.FilterGroup(0);
    end;

    local procedure GetRelatedName(): Text[2048]
    var
        TableName: Enum "Comment Line Table Name";
        Result: Text[2048];
    begin
        if Rec."No." = '' then
            exit('');

        TableName := Rec."Table Name";

        case TableName of
            TableName::Customer:
                if Customer.Get(Rec."No.") then
                    Result := Customer.Name;
            TableName::Vendor:
                if Vendor.Get(Rec."No.") then
                    Result := Vendor.Name;
            TableName::Item:
                if Item.Get(Rec."No.") then
                    Result := Item.Description;
            TableName::Resource:
                if Resource.Get(Rec."No.") then
                    Result := Resource.Name;
            TableName::"G/L Account":
                if GLAccount.Get(Rec."No.") then
                    Result := GLAccount.Name;
            TableName::"Bank Account":
                if BankAccount.Get(Rec."No.") then
                    Result := BankAccount.Name;
            else
                Result := UnknownLbl;
        end;

        if Result = '' then
            exit(Rec."No.");
        exit(Result);
    end;

    local procedure UsageCodeDescription(): Text[160]
    var
        NOTOCommentUsage: Record "NOTO Comment Usage";
    begin
        if NOTOCommentUsage.Get(Rec."Usage Code NOTO") then
            exit(NOTOCommentUsage.Description);
        exit('');
    end;
}
