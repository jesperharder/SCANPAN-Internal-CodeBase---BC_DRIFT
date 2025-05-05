


/// <summary>
/// Page DSVAPI (ID 50007).
/// </summary>
/// ///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>
page 50007 DSVAPI
{

    AdditionalSearchTerms = 'Scanpan, DSV, API, DSVAPI, CONTAINER, SHIPMENT, SEA, TRANSPORT';
    UsageCategory = Lists;
    PageType = List;
    ApplicationArea = Basic, Suite;
    Caption = 'DSV API';


    layout
    {

    }

    actions
    {
        area(Processing)
        {
            action("TEST")
            {
                Image = Troubleshoot;
                Caption = 'API Test';
                ToolTip = 'Testing the API.';
                trigger OnAction()
                var
                begin
                    DSVAPI.DSVCreateOrder(0, 'K101118', false);
                end;

            }
        }
    }

    var
        DSVAPI: Codeunit DSVAPI;
}