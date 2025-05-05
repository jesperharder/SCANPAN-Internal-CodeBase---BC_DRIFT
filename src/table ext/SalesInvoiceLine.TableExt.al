/// <summary>
/// TableExtension SalesInvoiceLine (ID 50011) extends Record Sales Invoice Line.
/// </summary>
/// <remarks>
/// 2023.05.12                                  Jesper Harder                          031     Added CountryRegion FlowField to Posted Invoices
/// </remarks>

tableextension 50011 "SalesInvoiceLine" extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Country/Region of Origin Code"; Code[20])
        {
            Caption = 'Country/Region of Origin Code';
            FieldClass = FlowField;
            CalcFormula = lookup(
                Item."Country/Region of Origin Code" where("No." = field("No.")));
        }
    }
}
