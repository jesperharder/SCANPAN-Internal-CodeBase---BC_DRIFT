



///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>

enum 50014 DSVShipmentState
{ 
    value(0; "Booked") { caption = 'Booked'; }
    value(1; "PendingConsolidation") { caption = 'PendingConsolidation'; }
    value(2; "Consolidated") { caption = 'Consolidated'; }
    value(3; "PendingCollection") { caption = 'PendingCollection'; }
    value(4; "Collected") { caption = 'Collected'; }
    value(5; "OnHand") { caption = 'OnHand'; }
    value(6; "DepartedOriginCFS") { caption = 'DepartedOriginCFS'; }
    value(7; "Shipped") { caption = 'Shipped'; }
    value(8; "Arrived") { caption = 'Arrived'; }
    value(9; "CustomsCommenced") { caption = 'CustomsCommenced'; }
    value(10; "CustomsCleared") { caption = 'CustomsCleared'; }
    value(11; "AvailableDestinationCFS") { caption = 'AvailableDestinationCFS'; }
    value(12; "PendingDelivery") { caption = 'PendingDelivery'; }
    value(13; "DepartedDestinationCFS") { caption = 'DepartedDestinationCFS'; }
    value(14; "Handover") { caption = 'Handover'; }
    value(15; "Delivered") { caption = 'Delivered'; }
    value(16; "Cancelled") { caption = 'Cancelled'; }


}