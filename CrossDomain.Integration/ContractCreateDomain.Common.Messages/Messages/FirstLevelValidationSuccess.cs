namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class FirstLevelValidationSuccess
    {
        public contractRequestType ContractRequest { get; set; }
    }
}
