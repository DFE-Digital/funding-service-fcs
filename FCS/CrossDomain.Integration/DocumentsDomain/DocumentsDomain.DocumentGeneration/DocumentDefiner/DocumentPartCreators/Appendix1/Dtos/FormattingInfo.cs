namespace SFA.FCT.DocumentsDomain.DocumentGeneration.DocumentDefiner.DocumentPartCreators.Appendix1.Dtos
{
    public class FormattingInfo
    {
        public FormattingInfo(bool isFundingStreamNameRow)
        {
            IsFundingStreamNameRow = isFundingStreamNameRow;
        }

        public bool IsFundingStreamNameRow { get; }
    }
}
