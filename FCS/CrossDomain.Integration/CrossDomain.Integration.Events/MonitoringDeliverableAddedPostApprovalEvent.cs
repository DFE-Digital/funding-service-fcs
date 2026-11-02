namespace SFA.FCT.CrossDomain.Integration.Events
{
    // this is a class (not an interface) because it is passed between NSB5 and 6
    public class MonitoringDeliverableAddedPostApprovalEvent
    {
        public string AllocationNumber { get; set; }

        public int DeliverableCode { get; set; }

        public int ContractVersionNumber { get; set; }

        public int ContractSubVersionNumber { get; set; }

        /// <summary>
        /// These periods look like this 201808
        /// </summary>
        public string[] Periods { get; set; }

        public override string ToString()
        {
            return $"AllocationNumber: {AllocationNumber}, ContractVersionNumber: {ContractVersionNumber}, ContractSubVersionNumber: {ContractSubVersionNumber}, DeliverableCode: {DeliverableCode}";
        }
    }
}
