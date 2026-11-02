namespace FundingAllocation.DataStore.Model
{
    using System;
    using System.Collections.Generic;

    public enum RelationshipToFundingAllocationEnum
    {
        Created,
        Queued
    }

    public class Contract
    {
        private Contract()
        {
        }

        public Contract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber)
        {
            ContractNumber = contractNumber;
            ContractVersionNumber = contractVersionNumber;
            ContractSubVersionNumber = contractSubVersionNumber;
        }

        public int Id { get; private set; }

        public string ContractNumber { get; private set; }

        public int ContractVersionNumber { get; private set; }

        public int ContractSubVersionNumber { get; private set; }

        public bool IsCreatedInCrm { get; set; }

        public string RelationshipToFundingAllocation { get; private set; }

        public RelationshipToFundingAllocationEnum RelationshipToFundingAllocationEnum
        {
            get => (RelationshipToFundingAllocationEnum)Enum.Parse(typeof(RelationshipToFundingAllocationEnum), RelationshipToFundingAllocation);
            set => RelationshipToFundingAllocation = value.ToString();
        }

        public List<FundingAllocation> FundingAllocations { get; private set; }
    }
}