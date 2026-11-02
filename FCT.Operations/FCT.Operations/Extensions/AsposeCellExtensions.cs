namespace FCT.Operations.Extensions
{
    using System.Drawing;
    using Aspose.Cells;

    public static class AsposeCellExtensions
    {
        public static Cell SetCellFormatAndStyle(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Left;
            style.ForegroundColor = Color.White;
            style.IsTextWrapped = false;
            SetFontNameAndSizeAndUnbold(style);
            SetAllBorderThin(style);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetCellFormatAndStyle(this Cell cell, TextAlignmentType alignment)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = alignment;
            style.VerticalAlignment = alignment;
            style.ForegroundColor = Color.White;
            style.IsTextWrapped = false;
            SetFontNameAndSizeAndUnbold(style);
            SetAllBorderThin(style);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetCellFormatAndStyleNotBorder(this Cell cell, TextAlignmentType alignment)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = alignment;
            style.VerticalAlignment = alignment;
            style.ForegroundColor = Color.White;
            style.IsTextWrapped = false;
            cell.SetStyle(style);

            return cell;
        }

        public static void CenterHorizontalAlignment(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Center;
            cell.SetStyle(style);
        }

        public static void RightHorizontalAlignment(this Cell cell)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = TextAlignmentType.Right;
            cell.SetStyle(style);
        }

        public static Cell SetWrap(this Cell cell)
        {
            var style = cell.GetStyle();
            style.IsTextWrapped = true;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetBackgroundColour(this Cell cell, Color color)
        {
            var style = cell.GetStyle();
            style.BackgroundColor = color;
            style.Pattern = BackgroundType.Solid;
            style.ForegroundColor = color;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithForegroundColour(this Cell cell, Color color)
        {
            var style = cell.GetStyle();
            style.Font.Color = color;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithVerticalAlignment(this Cell cell, TextAlignmentType textAlignment)
        {
            var style = cell.GetStyle();
            style.VerticalAlignment = textAlignment;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetBold(this Cell cell)
        {
            var style = cell.GetStyle();
            style.Font.IsBold = true;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithAlignment(this Cell cell, TextAlignmentType horizontalAlignment = TextAlignmentType.Center, TextAlignmentType verticalAlignmentType = TextAlignmentType.Center)
        {
            var style = cell.GetStyle();
            style.HorizontalAlignment = horizontalAlignment;
            style.VerticalAlignment = verticalAlignmentType;
            cell.SetStyle(style);

            return cell;
        }


        private static void SetFontNameAndSizeAndUnbold(Style style)
        {
            style.Font.Size = 11;
            style.Font.Name = "Calibri";
            style.Font.IsBold = false;
        }

        public static Cell WithFont(this Cell cell, string fontName, int size, bool isBold = false)
        {
            var style = cell.GetStyle();
            style.Font.Name = fontName;
            style.Font.Size = size;
            style.Font.IsBold = isBold;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithNumberFormat(this Cell cell)
        {
            var style = cell.GetStyle();
            style.Number = 1;
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithVerticalMediumBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Medium, Color.Black);
            style.SetBorder(BorderType.RightBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithTopAndLeftThinBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.TopBorder, CellBorderType.Thin, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithTopThinMediumLeftBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.TopBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Medium, Color.Black);

            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithThinBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.TopBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.RightBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Thin, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithLeftAndBottomMediumBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Medium, Color.Black);
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithLeftMediumBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell WithRightMediumBorder(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.RightBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetBottomBorderMedium(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetRightBorderMedium(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.RightBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static Cell SetTopBorderMedium(this Cell cell)
        {
            var style = cell.GetStyle();
            style.SetBorder(BorderType.TopBorder, CellBorderType.Medium, Color.Black);
            cell.SetStyle(style);

            return cell;
        }

        public static void SetAllBorderThin(this Style style)
        {
            style.SetBorder(BorderType.TopBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.BottomBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.LeftBorder, CellBorderType.Thin, Color.Black);
            style.SetBorder(BorderType.RightBorder, CellBorderType.Thin, Color.Black);
        }
    }
}