namespace SFA.FCT.Contracts.AcceptanceTests.Pages.DTO
{
    using System;
    using AllocationDelivery.DataStore.Model;
    using CrossDomain.Integration.Entities;

    public class SimpleContractAllocation
    {
        public string AllocationNumber { get; private set; }

        public int ContractVersionNumber { get; private set; }

        public AllocationDeliveryEntryCategory AllocationDeliveryEntryCategory { get; private set; }

        public AllocationDeliveryPerformance AllocationDeliveryPerformanceItem { get; set; }

        public SimpleContractAllocation(
            string allocationNumber, int contractVersionNumber, AllocationDeliveryEntryCategory allocationDeliveryEntryCategory)
        {
            AllocationNumber = allocationNumber;
            ContractVersionNumber = contractVersionNumber;
            AllocationDeliveryEntryCategory = allocationDeliveryEntryCategory;

            if (string.IsNullOrEmpty(AllocationNumber) || ContractVersionNumber == 0)
            {
                throw new ArgumentException("The allocationNumber must be set and the contractVersionNumber must be greater than zero");
            }
            
        }
        public SimpleContractAllocation(
            AllocationDeliveryEntryCategory allocationDeliveryEntryCategory, AllocationDeliveryPerformance allocationDelPerfItem)
        {
            AllocationNumber = allocationDelPerfItem.contractAllocationNumber;
            ContractVersionNumber = allocationDelPerfItem.Contract.contractVersionNumber;
            AllocationDeliveryEntryCategory = allocationDeliveryEntryCategory;

            if (string.IsNullOrEmpty(AllocationNumber) || ContractVersionNumber == 0)
            {
                throw new ArgumentException("The allocationNumber must be set and the contractVersionNumber must be greater than zero");
            }
            AllocationDeliveryPerformanceItem = allocationDelPerfItem;
        }

        public SimpleContractAllocation(string AllocationReferenceNumber)
        {
            AllocationNumber = AllocationReferenceNumber;

        }

        public override bool Equals(object obj)
        {
            SimpleContractAllocation other = obj as SimpleContractAllocation;

            if (other != null)
            {
                return AllocationNumber == other.AllocationNumber
                    && ContractVersionNumber == other.ContractVersionNumber
                    && AllocationDeliveryEntryCategory == other.AllocationDeliveryEntryCategory;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return AllocationNumber.GetHashCode() ^ ContractVersionNumber.GetHashCode() ^ AllocationDeliveryEntryCategory.GetHashCode();
        }

        //                                   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |

        public string ContractNumber { get; set; }
        public string FundingStreamCode { get; set; }
        public DateTime AllocationStartDate { get; set; }
        public DateTime AllocationEndDate { get; set; }
        public decimal AllocationValue { get; set; }
        public string UoPName { get; set; }
        public string UoPCode { get; set; }
        public string AllocationDescription { get; set; }
        public string LEPCode { get; set; }
        public string LEPName { get; set; }
        public string TenderSpecificationReference { get; set; }
        public string LotReference { get; set; }
        public string TenderAwardReference { get; set; }
        public string InvestmentPriority { get; set; }
        public string AgreementNumber { get; set; }
        public string ActivityDescription { get; set; }
        public string SpecificationTitle { get; set; }
        public string RegionType { get; set; }
    }
}
