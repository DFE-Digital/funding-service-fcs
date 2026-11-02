namespace SFA.FCT.ContractCreateDomain.Common.Messages.Messages
{
    using CrossDomain.Integration.Entities.ContractRequest;

    public class UpdateDraftContractUnsuccessful
    {
        public contractRequestType ContractRequest { get; set; }

        public errorInfoType Error { get; set; }
    }
}
