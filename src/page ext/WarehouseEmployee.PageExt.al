





pageextension 50084 "Warehouse Employee" extends "Warehouse Employees"
{
    ///<summary>
    /// 2023.09             Jesper Harder       049         Restrict changes to Warehouse Source Filter (5771)
    ///</summary>

    layout
    {
        addlast(Control1)
        {
            field("Permit Change Warehouse Filter"; Rec."Permit Change Warehouse Filter")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Enabled permits Changes to Warehouse Source Filter field.';
            }
        }
    }

}