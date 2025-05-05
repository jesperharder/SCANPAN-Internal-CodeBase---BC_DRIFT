



tableextension 50019 "Warehouse Employee" extends "Warehouse Employee"
{
    /// <summary>
    /// TableExtension Warehouse Employee (ID 50019) extends Record Warehouse Employee.
    /// </summary>
    /// <remarks>
    /// 2023.09             Jesper Harder       049         Restrict changes to Warehouse Source Filter (5771)
    /// </remarks>

    fields
    {
        field(50000; "Permit Change Warehouse Filter"; Boolean)
        {
            Caption = 'Permit Change Warehouse Source Filter';
        }
    }

}