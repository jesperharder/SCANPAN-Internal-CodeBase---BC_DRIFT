


///<summary>
/// 50037 "ProdOrderRoutingExtSC" extends "Prod. Order Routing"
/// </summary>
pageextension 50037 ProdOrderRouting extends "Prod. Order Routing"
{
    layout
    {
        addafter("Run Time")
        {
            field("Expected Capacity Need1"; Rec."Expected Capacity Need")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expected Capacity Need field.';
            }
        }
        modify("Expected Capacity Need")
        {
            Visible = true;
        }
        moveafter("Move Time"; "Expected Capacity Need")

        addafter("Run Time")
        {
            field("Setup Time Unit of Meas."; Rec."Setup Time Unit of Meas. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the setup time unit of measure.';
            }
            field("Run Time Unit of Meas."; Rec."Run Time Unit of Meas. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the run time unit of measure.';
            }
            field("Wait Time Unit of Meas."; Rec."Wait Time Unit of Meas. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the wait time unit of measure.';
            }
            field("Move Time Unit of Meas."; Rec."Move Time Unit of Meas. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the move time unit of measure.';
            }
        }
        addafter("Wait Time Unit of Meas.")
        {
            field("Maximum Process Time75344"; Rec."Maximum Process Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Maximum Process Time field.';
            }
            field("Concurrent Capacities06516"; Rec."Concurrent Capacities")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the con capacity of the operation.';
            }
        }
        addafter("Move Time Unit of Meas.")
        {
            field("Send-Ahead Quantity75969"; Rec."Send-Ahead Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the send-ahead quantity of the operation.';
            }
        }

    }
}
