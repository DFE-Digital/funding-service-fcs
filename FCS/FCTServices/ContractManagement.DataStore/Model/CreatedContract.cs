namespace ContractManagement.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class CreatedContract
    {
        private CreatedContract()
        {
        }

        public CreatedContract(string contractNumber, int contractVersionNumber, int contractSubVersionNumber, AmendmentType? amendmentType, int? totalAllocationCount = 0)
        {
            ContractNumber = contractNumber;
            ContractVersionNumber = contractVersionNumber;
            ContractSubVersionNumber = contractSubVersionNumber;
            AmendmentType = amendmentType;
            TotalAllocationCount = totalAllocationCount;

        }

        [StringLength(50)]
        [Key, Column(Order = 0)]
        public string ContractNumber { get; private set; }

        [Key, Column(Order = 1)]
        public int ContractVersionNumber { get; private set; }

        [Key, Column(Order = 2)]
        public int ContractSubVersionNumber { get; private set; }

        public AmendmentType? AmendmentType { get; private set; }
        public int? TotalAllocationCount { get; set; }

        public static AmendmentType? ToAmendmentType(string amendmentTypeString)
        {
            if (Enum.TryParse(amendmentTypeString, true, result: out AmendmentType result))
            {
                return result;
            }

            return null;
        }
    }

    public enum AmendmentType
    {
        Notification,
        Variation
    }
}
