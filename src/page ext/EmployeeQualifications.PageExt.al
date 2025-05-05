






pageextension 50083 "EmployeeQualifications" extends "Employee Qualifications"
{


    layout
    {

        addfirst(Control1)
        {
            field("Employee No."; Rec."Employee No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a number for the employee.';
                Visible = true;
            }
        }
    }


}