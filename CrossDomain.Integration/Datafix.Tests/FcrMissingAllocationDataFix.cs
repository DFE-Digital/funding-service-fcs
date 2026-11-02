namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using UnitTests.Common;

    [TestClass]
    public class FcrMissingAllocationDataFix
    {
        private static readonly string[] PayOnProfileFsps =
        {
            "1619LR1718", "AAC1617", "AEBC1617", "AEBC1718", "AEB-CL1718",
            "AEB-LS1718", "AEBTO-CL1617", "AEBTO-CL1718", "AEBTO-LS1617", "AEBTO-LS1718", "ALLBC1617", "ALLBC1718",
            "NCS-I1718", "NCS-IC1718", "NMF1718", "OLASS1617", "SSF1718"
        };

        [TestMethod, TestCategory("DataFix_R33")]
        public void ShouldAddMissingAllocationsAndDeliverablePeriods()
        {
            CleardownAllocationsAndDeliverables();

            IReadOnlyCollection<contract> contracts;

            string fspsFormattedForSql = string.Join(",", PayOnProfileFsps.Select(fsp => $"'{fsp}'"));

            using (var context = new PerformanceManagementDbContext())
            { 
                DbRawSqlQuery<string> xmlContracts = context.Database.SqlQuery<string>(
                    $@"WITH ContractNumberCTE (ContractNumber, ContractVersionNumber) AS
                    (
	                    SELECT DISTINCT ContractNumber,ContractVersionNumber
	                    FROM [MonitoringDeliverables].[AllocationDeliverablePeriod]
	                    WHERE [FundingStreamPeriodCode] IN ({fspsFormattedForSql})
                    )
                    SELECT atom.[AtomFeedItemXml]
                    FROM [ContractManagement].[AtomFeedItem] atom
                    JOIN ContractNumberCTE cn 
	                    ON substring(atom.BusinessKey, 1, (charindex(':', atom.BusinessKey) - 1)) = cn.ContractNumber
	                    AND substring(atom.BusinessKey, (charindex(':', atom.BusinessKey) + 1), 1) = cn.ContractVersionNumber
                    WHERE [ItemType] = 0
                    ORDER BY cn.ContractNumber,cn.ContractVersionNumber");

                contracts = xmlContracts.Select(xml => xml.DeserializeXml<contract>()).ToList();
            }

            Assert.IsTrue(contracts.Any());
            Assert.IsTrue(contracts.First().contracts.Any());

            contracts.SelectMany(MapToChildContractContractAllocationPair)
                .Select(CreateContractAllocationFromCorpContract)
                .ForEach(WriteContractAllocationToDb);
        }

        private void WriteContractAllocationToDb(ContractAllocationWithDeliverables contractAllocationWithDeliverables)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                UpsertAllocation(context, contractAllocationWithDeliverables.ContractAllocation);

                contractAllocationWithDeliverables.Deliverables.ForEach(d => UpsertContractAllocationDeliverable(context, d));
                
                context.SaveChanges();
            }
        }

        private void UpsertAllocation(PerformanceManagementDbContext context, ContractAllocation contractAllocation)
        {
            var allocationInDb = context.ContractAllocations.Find(contractAllocation.AllocationNumber);
            if (allocationInDb == null)
            {
                context.ContractAllocations.Add(contractAllocation);
            }
            else
            {
                allocationInDb.Contract.ApprovalDate =
                    contractAllocation.Contract.ApprovalDate;
                allocationInDb.Contract.ContractNumber =
                    contractAllocation.Contract.ContractNumber;
                allocationInDb.Contract.SubVersionNumber = contractAllocation.Contract.SubVersionNumber;
                allocationInDb.Contract.VersionNumber =
                    contractAllocation.Contract.VersionNumber;

                allocationInDb.Contractor.LegalName =
                    contractAllocation.Contractor.LegalName;
                allocationInDb.Contractor.OrganisationIdentifier =
                    contractAllocation.Contractor.OrganisationIdentifier;
                allocationInDb.Contractor.UKPRN =
                    contractAllocation.Contractor.UKPRN;

                allocationInDb.StartDate = contractAllocation.StartDate;
                allocationInDb.EndDate = contractAllocation.EndDate;

                allocationInDb.FundingType.FundingTypeCode =
                    contractAllocation.FundingType.FundingTypeCode;
                allocationInDb.FundingType.FundingTypeName =
                    contractAllocation.FundingType.FundingTypeName;

                allocationInDb.Period.PeriodTypeName =
                    contractAllocation.Period.PeriodTypeName;
                allocationInDb.LastModifiedDate = DateTime.UtcNow;
            }
        }

        private void UpsertContractAllocationDeliverable(PerformanceManagementDbContext context, ContractAllocationDeliverable contractAllocationDeliverable)
        {
            var contractAllocationDeliverableInDb = context.ContractAllocationDeliverables.Find(contractAllocationDeliverable.ContractAllocationNumber,
                contractAllocationDeliverable.DeliverableCode);

            if (contractAllocationDeliverableInDb == null)
            {
                context.ContractAllocationDeliverables.Add(contractAllocationDeliverable);
            }
            else
            {
                contractAllocationDeliverableInDb.PlannedValue = contractAllocationDeliverable.PlannedValue;
            }
        }

        private ContractAllocationWithDeliverables CreateContractAllocationFromCorpContract(ChildContractContractAllocationPair childContractContractAllocationPair)
        {
            return ToContractAllocationWithDeliverables(childContractContractAllocationPair.Allocation, childContractContractAllocationPair.ChildContract);
        }

        private IEnumerable<ChildContractContractAllocationPair> MapToChildContractContractAllocationPair(contract contract)
        {
            contractType childContract = contract.contracts.First();

            return contract.contracts.SelectMany(c => c.contractAllocations)
                           .Where(a => PayOnProfileFsps.Contains(a.fundingStreamPeriodCode))
                           .Select(a => new ChildContractContractAllocationPair(childContract, a));
        }

        private ContractAllocationWithDeliverables ToContractAllocationWithDeliverables(contractAllocationsContractAllocation corpSchemaAllocation, contractType childContract)
        {
            var flattenedDeliverables = FlattenDeliverables(corpSchemaAllocation.contractDeliverables);
            IEnumerable<ContractAllocationDeliverable> deliverablesWithSummedPlannedValue =
                flattenedDeliverables.Select(d => ToContractAllocationDeliverable(d, corpSchemaAllocation.contractAllocationNumber));
            ContractAllocation contractAllocation = new ContractAllocation(corpSchemaAllocation.contractAllocationNumber, corpSchemaAllocation.startDate,
                corpSchemaAllocation.endDate)
            {
                Contract = new Contract
                {
                    ApprovalDate = childContract.ContractApprovalDate.Value,
                    ContractNumber = childContract.contractNumber,
                    SubVersionNumber = childContract.contractSubVersionNumber,
                    VersionNumber = childContract.contractVersionNumber
                },
                Contractor = new Contractor
                {
                    LegalName = childContract.contractor.legalName,
                    OrganisationIdentifier = childContract.contractor.organisationIdentifier,
                    UKPRN = childContract.contractor.ukprn
                },
                FundingType = new FundingType
                {
                    FundingTypeName = childContract.fundingType.fundingTypeName,
                    FundingTypeCode = childContract.fundingType.fundingTypeCode
                },
                Period = new Period
                {
                    PeriodTypeName = childContract.period.periodType.periodTypeName.ToString()
                }
            };

            return new ContractAllocationWithDeliverables(contractAllocation, deliverablesWithSummedPlannedValue);
        }

        public static List<contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
          List<contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList,
          List<contractDeliverablesTypeContractDeliverable> flattenedList = null)
        { 
            flattenedList = flattenedList ?? new List<contractDeliverablesTypeContractDeliverable>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList);
            }

            return flattenedList;
        }

        private ContractAllocationDeliverable ToContractAllocationDeliverable(contractDeliverablesTypeContractDeliverable deliverable, string allocationNumber)
        {
            return new ContractAllocationDeliverable(
                allocationNumber,
                deliverable.deliverable.deliverableCode,
                deliverable.contractDeliverablePeriods.Sum(dp => dp.plannedValue));
        }

        private void CleardownAllocationsAndDeliverables()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ContractAllocations.RemoveAll();
                context.ContractAllocationDeliverables.RemoveAll();

                context.SaveChanges();
            }
        }

        private class ContractAllocationWithDeliverables
        {
            public ContractAllocationWithDeliverables(ContractAllocation contractAllocation, IEnumerable<ContractAllocationDeliverable> deliverables)
            {
                Deliverables = deliverables;
                ContractAllocation = contractAllocation;
            }

            public ContractAllocation ContractAllocation { get; }

            public IEnumerable<ContractAllocationDeliverable> Deliverables { get; }
        }

        private class ChildContractContractAllocationPair
        {
            public ChildContractContractAllocationPair(contractType childContract, contractAllocationsContractAllocation allocation)
            {
                ChildContract = childContract;
                Allocation = allocation;
            }

            public contractType ChildContract { get; }

            public contractAllocationsContractAllocation Allocation { get; }
        }
    }
}
