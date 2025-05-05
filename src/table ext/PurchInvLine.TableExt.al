



/// <summary>
/// TableExtension PurchInvLine (ID 50024) extends Record Purch. Inv. Line.
/// </summary>
/// <remarks>
/// 2023.10             Jesper Harder       044         LTS Drop Shipment exclude from Exports
/// </remarks>
tableextension 50024 "PurchInvLine" extends "Purch. Inv. Line"
{

    fields
    {
        /// <remarks>
        /// Using Base Application field no. to facilitate automatic transfer of fieldvalue when purchase order is invoiced.
        /// </remarks> 
        field(73; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = false;
        }
    }

}