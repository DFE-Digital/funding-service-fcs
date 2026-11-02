namespace ContractCreateDomain.Endpoint.XrmService.DTOs
{
    public class CrmAllocationInfo
    {
        public CrmAllocationInfo(string number)
        {
            Number = number;
        }

        public string Number { get; }
    }
}
