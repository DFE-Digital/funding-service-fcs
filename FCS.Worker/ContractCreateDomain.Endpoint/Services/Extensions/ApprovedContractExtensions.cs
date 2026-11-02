namespace ContractCreateDomain.Endpoint.Services.Extensions
{
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ApprovedContractExtensions
    {
        public static ApprovedContractInfo ToApprovedContractInfo(this ApprovedContract approvedContract)
        {
            return new ApprovedContractInfo
            {
                ContractNumber = approvedContract.ContractNumber,
                MasterContractNumber = approvedContract.MasterContractNumber,
                StartDate = approvedContract.StartDate.Value,
                EndDate = approvedContract.EndDate,
                FundingPeriod = approvedContract.FundingPeriod,
                FundingType = approvedContract.FundingType,
                Allocations = approvedContract.ApprovedContractAllocations
                    .Select(a => new ApprovedContractAllocationInfo
                    {
                        ContractAllocationNumber = a.ContractAllocationNumber,
                        FundingStreamPeriodCode = a.FundingStreamPeriodCode,
                        PlannedValueEnvelope1 = a.PlannedValueEnvelope1.Value,
                        PlannedValueEnvelope2 = a.PlannedValueEnvelope2.Value,
                        TotalPlannedValue = a.TotalPlannedValue,
                        Deliverables = a.ApprovedContractDeliverables
                            .Select(d => new ApprovedContractDeliverableInfo
                            {
                                DeliverableCode = d.DeliverableCode,
                                PlannedValueEnvelope1 = d.PlannedValueEnvelope1,
                                PlannedValueEnvelope2 = d.PlannedValueEnvelope2,
                                TotalPlannedValue = d.TotalPlannedValue
                            })
                            .ToList()
                    })
                    .ToList()
            };
        }
    }
}
