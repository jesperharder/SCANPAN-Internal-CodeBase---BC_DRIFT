



/// <summary>
/// Query Addresses (ID 50005).
/// </summary>
/// <remarks>
/// 2023.08             Jesper Harder       046         Addresses Customer and Vendor
/// </remarks> 
query 50005 "AddressesVendor"
{

    Caption = 'Displays all Vendor addresses.';
    QueryType = Normal;
    Permissions =
        tabledata Vendor = R;

    elements
    {
        dataitem(Vendor; Vendor)
        {
            column("VendorNo"; "No.")
            {
                Caption = 'Vendo No.';
            }
            column("VendorName"; Name)
            {
                Caption = 'Vendor Name';
            }
        }
    }
}