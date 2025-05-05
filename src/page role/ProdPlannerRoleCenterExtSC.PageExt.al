


/// <summary>
/// PageExtension ProdPlannerRoleCenterExtSC (ID 50028) extends Record Production Planner Role Center.
/// </summary>
/// 
/// <remarks>
/// 
/// Version list
/// 2022.12             Jesper Harder       0193        Added modifications
/// 2024.11             Jesper Harder       097         Monitor select JobQueue from role center
/// </remarks>

pageextension 50028 "ProdPlannerRoleCenterExtSC" extends "Production Planner Role Center"
{
    layout
    {
        addafter(Control45)
        {
            // 097
            part(ScanpanProcessesCardPart; ScanpanCardPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Scanpan Process status';
            }
        }

    }

    actions
    {
        addlast(sections)
        {
            group("SCANPAN")
            {
                Caption = 'SCANPAN';
                Image = "List";
                ToolTip = 'Shortcuts SCANPAN';
                group("Warehouse Reports")
                {
                    Caption = 'Production Reports';
                    ToolTip = 'Collection of Production related reports.';
                    action("ReportAddress Label")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Pallet label';
                        Image = Report;
                        RunObject = Report "Scanpan Pallelabel";
                        ToolTip = 'Prints Labels used on wrapped pallets.';
                    }
                    action("ReportProdControllingRoutingLine")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Production Routing Priority';
                        ToolTip = 'Prints a production priority list.';
                        Image = Report;
                        RunObject = Report ProductionControllingPriority;
                    }
                }
                group("Controlling Pages")
                {
                    Caption = 'Production Controlling';
                    ToolTip = 'Tools collection for controlling the production.';

                    action("ProdControllingRoutingLine ")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'SCANPAN Production Controlling Routing List';
                        ToolTip = 'Executes the SCANPAN Production Controlling Routing List action.';
                        Image = ListPage;
                        RunObject = page ProdControllingRoutingLine;
                    }
                }
            }
        }
    }
}

