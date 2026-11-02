namespace SFA.FCT.ContractCreateDomain.Common.Events
{
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class AddContractNumbersResponseEvent : IEvent
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
