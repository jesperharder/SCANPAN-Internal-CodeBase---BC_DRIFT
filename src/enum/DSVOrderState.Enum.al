

///<remarks>
/// 2023.09             Jesper Harder       048         API stack for DSV API
/// </remarks>

enum 50013 DSVOrderState
{

    value(0; "Provisional")
    {
        caption = 'Provisional';
    }

    value(1; "Open") { caption = 'Open'; }
    value(2; "Confirmed") { caption = 'Confirmed'; }
    value(3; "OnHand") { caption = 'OnHand'; }
    value(4; "BookingProvisional") { caption = 'BookingProvisional'; }
    value(5; "BookingBooked") { caption = 'BookingBooked'; }
    value(6; "BookingRejected") { caption = 'BookingRejected'; }
    value(7; "BookingApproved") { caption = 'BookingApproved'; }
    value(8; "BookingConfirmed") { caption = 'BookingConfirmed'; }
    value(9; "BookingParked") { caption = 'BookingParked'; }
    value(10; "PendingConsolidation") { caption = 'PendingConsolidation'; }
    value(11; "Consolidated") { caption = 'Consolidated'; }
    value(12; "PendingCollection") { caption = 'PendingCollection'; }
    value(13; "Collected") { caption = 'Collected'; }
    value(14; "BookingOnHand") { caption = 'BookingOnHand'; }
    value(15; "DepartedOriginCFS") { caption = 'DepartedOriginCFS'; }
    value(16; "Shipped") { caption = 'Shipped'; }
    value(17; "Arrived") { caption = 'Arrived'; }
    value(18; "CustomsCommenced") { caption = 'CustomsCommenced'; }
    value(19; "CustomsCleared") { caption = 'CustomsCleared'; }
    value(20; "AvailableDestinationCFS") { caption = 'AvailableDestinationCFS'; }
    value(21; "PendingDelivery") { caption = 'PendingDelivery'; }
    value(22; "DepartedDestinationCFS") { caption = 'DepartedDestinationCFS'; }
    value(23; "Handover") { caption = 'Handover'; }
    value(24; "Delivered") { caption = 'Delivered'; }
    value(25; "Fulfilled") { caption = 'Fulfilled'; }
    value(26; "Cancelled") { caption = 'Cancelled'; }


}
