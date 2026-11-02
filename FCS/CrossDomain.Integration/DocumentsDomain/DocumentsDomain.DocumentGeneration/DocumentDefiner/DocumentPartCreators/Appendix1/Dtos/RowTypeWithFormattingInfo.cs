namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1.Dtos
{
    using Common.Models;

    public class RowTypeWithFormattingInfo : RowType
    {
        public RowTypeWithFormattingInfo(bool isFundingStreamNameRow, bool isOfWhichRow)
        {
            FormattingInfo = new FormattingInfo(isFundingStreamNameRow);
            IsOfWhichRow = isOfWhichRow;
        }

        public FormattingInfo FormattingInfo { get; set; }

        public decimal Total { get; set; }

        public bool IsOfWhichRow { get; }
    }
}
