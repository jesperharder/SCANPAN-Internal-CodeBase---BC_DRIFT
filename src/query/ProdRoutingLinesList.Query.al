


/// <summary>
/// Query ProdRoutingLines (ID 50003).
/// </summary>
/// <remarks>
/// 2023.05.11                      Jesper Harder                           030     List All Routing Lines
/// 2023.10                         Jesper Harder                           001     Production Controlling, RoutingLines Priority, Short Comments
/// </remarks>
query 50003 "ProdRoutingLinesList"
{
    Caption = 'Scanpan Production Order Routinglines';
    QueryType = Normal;
    Permissions =
        tabledata "Routing Header" = R,
        tabledata "Routing Line" = R;

    elements
    {
        dataitem(RoutingHeader; "Routing Header")
        {
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column("Type"; "Type")
            {
            }
            column(Status; Status)
            {
            }
            column(LastDateModified; "Last Date Modified")
            {
            }
            column(Comment; Comment)
            {
            }
            dataitem(RoutingLine; "Routing Line")
            {
                DataItemLink = "Routing No." = RoutingHeader."No.";

                column(OperationNo; "Operation No.")
                {
                }
                column("Line_Type"; "Type")
                {
                }
                column(Line_No; "No.")
                {
                }
                column(Line_Description; Description)
                {
                }
                column(RoutingLinkCode; "Routing Link Code")
                {
                }
                column(SetupTime; "Setup Time")
                {
                }
                column(RunTime; "Run Time")
                {
                }
                column(RunTimeUnitofMeasCode; "Run Time Unit of Meas. Code")
                {
                }
                column(WaitTime; "Wait Time")
                {
                }
                column(MoveTime; "Move Time")
                {
                }
                column(FixedScrapQuantity; "Fixed Scrap Quantity")
                {
                }
                column(ScrapFactor; "Scrap Factor %")
                {
                }
                column(ConcurrentCapacities; "Concurrent Capacities")
                {
                }
                column(SendAheadQuantity; "Send-Ahead Quantity")
                {
                }
                column(UnitCostper; "Unit Cost per")
                {
                }
                column(RoutingPriority; "Routing Priority")
                {
                }

            }
        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
