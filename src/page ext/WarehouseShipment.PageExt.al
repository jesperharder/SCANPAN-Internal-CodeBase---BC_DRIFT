

pageextension 50045 WarehouseShipment extends "Warehouse Shipment"
{
    /// <summary>
    /// PageExtension "WarehouseShipmentExtSC" (ID 50045) extends Record Warehouse Shipment.
    /// </summary>
    /// 
    /// <remarks>
    /// 
    /// 2023.03.08         Jesper Harder       0193        Added description field
    /// 2023.07.14         Jesper Harder        035        Post TransportOrderID through
    /// 2024.10             Jesper Harder       088        CountryCode Editable in WarehouseShipment
    /// </remarks>
    /// 

    layout
    {
        addlast(General)
        {
            field(Description; Rec.Description)
            {
                ToolTip = 'Short description here.';
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
            /*field("Transport Order No."; Rec."Transport Order No.")
            {
                ToolTip = 'Transport Order No.';
                ApplicationArea = Basic, Suite;
                Visible = true;
                Editable = false;
                TableRelation = "IDYS Transport Order Header"."No.";
            }*/
        }

        // 088  
        modify(CountryCodeNOTO)
        {
            Editable = true;
        }
    }

}
