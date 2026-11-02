namespace FCT.Operations.PaymentSummary.Extensions
{
    using Aspose.Cells;
    using System.Drawing;

    public static class AsposeCellExtensions
    {
        public static void SetPaymentValueDefaultStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Right;
            style.Custom = "#,##0.00";
            style.Font.Color = Color.Black;
            if (cell.GetValue() < 0)
            {
                style.Font.Color = Color.Red;
            }
            SetFontNameAndSizeAndUnbold(style);

            cell.SetStyle(style);
        }

        public static void Set1619PaymentValueDefaultStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Right;
            style.Custom = "#,##0.00";
            style.Font.Color = Color.Black;
            if (cell.GetValue() < 0)
            {
                style.Font.Color = Color.Red;
            }
            SetFontNameAndSizeAndUnbold(style);

            cell.SetStyle(style);
            style.Font.IsBold= true;
        }

        public static void SetProviderCellFormatAndStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Left;
            style.ForegroundColor = Color.White;
            SetFontNameAndSizeAndUnbold(style);
            style.IsTextWrapped = false;
            cell.SetStyle(style);

            cell.SetTopBottomBorderThin();
        }

        public static void SetProviderCellFormatAndStyle1619(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Right;
            style.ForegroundColor = Color.White;
            SetFontNameAndSizeAndUnbold(style);
            style.IsTextWrapped = false;
            cell.SetStyle(style);
            style.Font.IsBold= true;
            cell.SetTopBottomBorderThin();
        }

        public static void SetFspHeaderStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Center;
            style.ForegroundColor = Color.FromArgb(255, 255, 204);
            style.Pattern = BackgroundType.Solid;
            style.IsTextWrapped = true;
            cell.SetStyle(style);
        }

        public static decimal GetValue(this Cell cell)
        {
            cell.Calculate(true, null);
            decimal.TryParse(cell.Value?.ToString(), out var val);

            return val;
        }

        public static void CenterHorizontalAlignment(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Right;
            cell.SetStyle(style);
        }

        public static void SetDataRowFormatAndStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.ForegroundColor = Color.White;
            cell.SetStyle(style);
            cell.SetTopBottomBorderThin();
        }
        public static void SetDataRowFormatAndStyle1619(this Cell cell)
        {
            var style = cell.GetStyle();
            style.ForegroundColor = Color.White;
            cell.SetStyle(style);
            //cell.SetTopBottomBorderThin();
            style.Font.IsBold = true;
        }


        public static void SetBold(this Cell cell)
        {
            var style = cell.GetStyle();
            style.Font.IsBold = true;
            cell.SetStyle(style);
        }

        public static void SetTopBottomBorderThin(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.TopBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Thin, Color.Black);
            cell.SetStyle(style);
        }

        public static void SetBottomBorderMedium(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);
            
        }

        private static void SetFontNameAndSizeAndUnbold(Style style)
        {
            style.Font.Size = 11;
            style.Font.Name = "Calibri";
            style.Font.IsBold = true;
        }
    }
}
