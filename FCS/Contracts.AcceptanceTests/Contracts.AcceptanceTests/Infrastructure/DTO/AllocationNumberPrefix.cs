namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class AllocationNumberPrefix
    {
        public AllocationNumberPrefix(string prefix, string allocationNumber)
        {
            Prefix = prefix;
            AllocationNumber = allocationNumber;
        }

        public string Prefix { get; }

        /// <summary>
        /// This is the full reference e.g. XXX-1234
        /// </summary>
        public string AllocationNumber { get; }
    }
}
