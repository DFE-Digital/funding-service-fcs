namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporateContract;

    public class ContractNotificationPublishedToProviderEvent
    {
        public contract CorporateContract { get; set; }
    }
}
