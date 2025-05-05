



/// <summary>
/// 2024.06.13JH        Fix from ExtionsionIT, better handling for Shipmondo PackageType on Tasklet
/// </summary>
//Mobil-pakkeopsætning
pageextension 50116 MOBMobileWMSPackageSetup extends "MOB Mobile WMS Package Setup"
{
    layout
    {
        addafter("Shipping Agent")
        {
            //Shipping Agent Service Code (5, Code, PK)
            field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
            {
                ApplicationArea = All;
                ToolTip = 'Shipping Agent Service Code';
            }
        }
    }
}
