table 50001 "SalespriceListTMP"
{
    Caption = 'SCANPANTemptableSalespriceList';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; LineNo; Integer)
        {
            Caption = 'LineNo';
            DataClassification = ToBeClassified;
        }
        field(10; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
        field(11; ItemImage; MediaSet)
        {
            Caption = 'ItemImage';
            DataClassification = ToBeClassified;
        }
        field(20; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(30; Colli; Integer)
        {
            Caption = 'Colli';
            DataClassification = ToBeClassified;
        }
        field(31; ColliCode; code[20])
        {
            Caption = 'ColliCode';
            DataClassification = ToBeClassified;
        }
        field(32; ItemUnitCode; code[20])
        {
            Caption = 'Item Unit Code';
        }
        field(33; ItemUnitQuantity; Integer)
        {
            Caption = 'ItemUnitQuantity';
            BlankZero = true;
        }

        field(40; NetPrice; Decimal)
        {
            Caption = 'NetPrice';
            DataClassification = ToBeClassified;
        }
        field(50; GrossPrice; Decimal)
        {
            Caption = 'GrossPrice';
            DataClassification = ToBeClassified;
        }
        field(60; BarCode; Code[20])
        {
            Caption = 'BarCode';
            DataClassification = ToBeClassified;
        }
        field(70; SourceNo; Code[20])
        {
            Caption = 'SourceNo';
            DataClassification = ToBeClassified;
        }
        field(80; CustomerNo; Code[20])
        {
            Caption = 'CustomerNo';
            DataClassification = ToBeClassified;
        }
        field(90; CustomerItemNo; Code[20])
        {
            Caption = 'CustomerItemNo';
            DataClassification = ToBeClassified;
        }
        field(100; VatPct; integer)
        {
            Caption = 'VatPct';
            DataClassification = ToBeClassified;
        }
        field(110; LanguageCode; code[20])
        {
            Caption = 'LanguageCode';
            DataClassification = ToBeClassified;
        }
        field(120; CustomerPriceGroup; Code[20])
        {
            Caption = 'CustomerPriceGroup';
            DataClassification = ToBeClassified;
        }
        field(130; GenProdPostingGroup; Code[20])
        {
            Caption = 'GenProdPostingGroup';
            DataClassification = ToBeClassified;
        }
        field(140; ItemProductLineCode; Code[20])
        {
            Caption = 'ItemProductLineCode';
            DataClassification = ToBeClassified;
        }
        field(150; ItemCategoryCode; Code[20])
        {
            Caption = 'ItemCategoryCode';
            DataClassification = ToBeClassified;
        }
        field(160; NetWeightItemCard; decimal)
        {
            Caption = 'NetWeightItemCard';
            DataClassification = ToBeClassified;
        }
        field(170; GrossWeightItemCard; decimal)
        {
            Caption = 'GrossWeightItemCard';
            DataClassification = ToBeClassified;
        }
        field(180; GrossWeightUnitMeasure; decimal)
        {
            Caption = 'NetWeightUnitMeasure';
            DataClassification = ToBeClassified;
        }
        field(190; ItemUnitOfMeasure; Code[20])
        {
            Caption = 'ItemUnitOfMeasure';
            DataClassification = ToBeClassified;
        }
        field(200; PricelistCode; Code[20])
        {
            Caption = 'PricelistCode';
            DataClassification = ToBeClassified;
        }



    }
    keys
    {
        key(PK; LineNo)
        {
            Clustered = true;
        }
        key(AttributeSort; GenProdPostingGroup, ItemProductLineCode, ItemNo)
        {
            Clustered = false;
        }

    }
    fieldgroups
    {
        fieldgroup(Brick; ItemNo, ItemImage, Description)
        {

        }
    }
}
