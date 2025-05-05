




/// <summary>
/// PageExtension ShopCalendarHolidays (ID 50060) extends Record Shop Calendar Holidays //(99000753, List).
/// </summary>
pageextension 50060 "ShopCalendarHolidays" extends "Shop Calendar Holidays" //(99000753, List)
{

    layout
    {
        addfirst(Control1)
        {
            field("Shop Calendar Code"; Rec."Shop Calendar Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
                ToolTip = 'Specifies the value of the Shop Calendar Code field.';
            }
        }
    }

}