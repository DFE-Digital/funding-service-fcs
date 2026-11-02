namespace ContractRequestDomain.Cfs.Commands
{
    using ContractRequestDomain.Cfs.Common.Dtos;

    public class EnrichAllocationCommand
    {
        public Allocation Allocation { get; set; }

        public override string ToString()
        {
            return Allocation.ToString();
        }
    }
}
