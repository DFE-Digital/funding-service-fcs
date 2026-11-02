namespace FundingAllocation.Dto
{
    using System.Collections.Generic;
    using System.Linq;

    public class ContractAllocationInfo
    {
        public ContractAllocationInfo(
            string fundingStreamPeriodCode,
            string fundingStreamCode,
            string allocationReferencePrefix,
            int deliveryUkprn,
            IReadOnlyCollection<ContractDeliverableInfo> deliverables,
            int numAllocationsOnContract)
        {
            FundingStreamPeriodCode = fundingStreamPeriodCode;
            FundingStreamCode = fundingStreamCode;
            AllocationReferencePrefix = allocationReferencePrefix;
            Deliverables = deliverables;
            NumAllocationsOnContract = numAllocationsOnContract;
            DeliveryUkprn = deliveryUkprn;
        }

        public string FundingStreamPeriodCode { get; }

        public string FundingStreamCode { get; }

        public string AllocationReferencePrefix { get; }

        public int DeliveryUkprn { get; }
        public int NumAllocationsOnContract { get; }

        public IReadOnlyCollection<ContractDeliverableInfo> Deliverables { get; }

        public decimal GetTotalPlannedValue() => Deliverables.Sum(d => d.GetTotalPlannedValue());

        public string GetDeliveryUkprnIfDifferentToContracting(int contractingUkprn)
        {
            if (NumAllocationsOnContract == 1 && DeliveryUkprn == contractingUkprn)
            {
                return string.Empty;
            }

            return DeliveryUkprn.ToString();
        }
    }
}
