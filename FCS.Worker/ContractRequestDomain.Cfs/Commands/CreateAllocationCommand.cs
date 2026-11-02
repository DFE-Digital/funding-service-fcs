namespace ContractRequestDomain.Cfs.Commands
{
    using ContractRequestDomain.Cfs.Common.Dtos;

    public class CreateAllocationCommand
    {
        public Allocation Allocation { get; set; }

        public override string ToString()
        {
            return Allocation.ToString();
        }
    }
}
