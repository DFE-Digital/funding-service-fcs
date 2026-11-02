namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Events
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class AddContractNumbersResponseEvent
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
