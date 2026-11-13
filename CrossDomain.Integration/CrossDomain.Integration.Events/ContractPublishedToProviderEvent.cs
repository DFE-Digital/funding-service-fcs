namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporateContract;

    public class ContractNotificationPublishedToProviderEvent
    {
        public Contract CorporateContract { get; set; }
    }
}
