namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class AddMissingDeliverablePeriodCommand
    {
        public string AllocationNumber { get; set; }

        public int VersionNumber { get; set; }

        public int DeliverableCode { get; set; }

        public string Period { get; set; }

        public override string ToString()
        {
            return
                $"AllocationNumber: {AllocationNumber}, VersionNumber: {VersionNumber}, DeliverableCode: {DeliverableCode}, Period: {Period}";
        }
    }
}
