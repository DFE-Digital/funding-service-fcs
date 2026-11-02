namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class UploadPaymentSummaryReportToSharePointCommand
    {
        public string Filename { get; set; }

        public override string ToString() => Filename;
    }
}
