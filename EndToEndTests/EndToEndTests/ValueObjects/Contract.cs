namespace EndToEndTests.ValueObjects
{
    public class Contract
    {
        public string ContractId { get; set; }
        public int Version { get; set; }
        public string Status { get; set; }

        public Contract Clone()
        {
            return new Contract
            {
                ContractId = ContractId,
                Version = Version,
                Status = Status
            };
        }

    }
}
