



/// <summary>
/// Unknown Detailed Calculation Ext (ID 50000) extends Record Detailed Calculation.
/// </summary>
/// 
/// <remarks>
/// 
///  2023.04.13             Jesper Harder                       023     Rapport Detailed Calculation (99000756, Rapportanmodning)
/// 
/// </remarks>
reportextension 50000 "Detailed Calculation Ext" extends "Detailed Calculation"
{

    RDLCLayout = './src/report ext/DetailedCalculationExt.rdl';


    requestpage
    {
        layout
        {
            addlast(content)
            {
                group(scanpan)
                {
                    Caption = 'SCANPAN';

                    field(Scanpan2; Scanpan) { ApplicationArea = Manufacturing; Caption = 'Test field'; }
                }
            }
        }
    }

    var
        Scanpan: Label 'SCANPAN';

    /*
    https://bc.scanpan.dk/BC_DRIFT_UP/?page=9652&company=SCANPAN%20Danmark&dc=0
    
    Build the extension (Ctrl+Shift+B). The MyRDLReport.rdl file will be created in the root of the current project.

    Open the generated report layout file in Microsoft SQL Server Report Builder.

    Edit the layout by inserting a table.

    Add the Name column from the Datasets folder into the table and save the .rdl file.

    Back in Visual Studio Code, press Ctrl+F5 to compile and run the report in Dynamics 365 Business Central.
    */
}
