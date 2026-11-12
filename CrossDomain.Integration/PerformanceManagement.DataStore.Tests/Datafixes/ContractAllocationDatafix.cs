namespace PerformanceManagement.DataStore.Tests.Datafixes
{
    using System.Collections.Generic;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;

    [TestClass]
    public class ContractAllocationDatafix
    {
        const string ConnnectionString =
               "";

        [TestMethod, TestCategory("DataFix_R10a")]
        public void ContractAllocation_ShouldSeedContractAllocationTableFromAtomTable()
        {
            //"Data Source = acx03vg6p0.database.windows.net; Initial Catalog = fct-database-dci; Persist Security Info = True; User ID = fctsa; Password =";
            IReadOnlyCollection<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract> contracts = null;
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ConnectionString = ConnnectionString;
                DbRawSqlQuery<string> xmlContracts = context.Database.SqlQuery<string>(@"select AtomFeedItemXml
                  from
                  (select distinct[ContractNumber], [ContractVersionNumber] from
                   [MonitoringDeliverables].[AllocationDeliverablePeriod]
                   where[FundingStreamPeriodCode] in ('ASC1516', 'CL1516', '24+ALLBC1516', 'DLS1516')) ctrct,
                   (SELECT[BusinessKey]
                     ,substring(BusinessKey, 1, (charindex(':', BusinessKey) - 1)) as contract_number
	                 ,substring(BusinessKey, (charindex(':', BusinessKey) + 1), 1) as version
	                ,[AtomFeedItemXml]
                        FROM[ContractManagement].[AtomFeedItem]
                        where[ItemType] = 0) atom
                        where atom.contract_number = ctrct.[ContractNumber]
                        and atom.version = ctrct.[ContractVersionNumber] ");

                contracts = xmlContracts.Select(xml => xml.DeserializeXml<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract>()).ToList();
            }

            Assert.IsTrue(contracts.Any());
            Assert.IsTrue(contracts.First().contracts.Any());

            // now populate the table
            contracts.SelectMany(CreateContractAllocationFromCorpContract).ForEach(WriteContractAllocationToDb);
        }

        private void WriteContractAllocationToDb(ContractAllocation contractAllocation)
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.Database.Connection.ConnectionString = ConnnectionString;
                context.ContractAllocations.Add(contractAllocation);
                context.SaveChanges();
            }
        }

        private IEnumerable<ContractAllocation> CreateContractAllocationFromCorpContract(SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.Contract contract)
        {
            contractType childContract = contract.contracts.First();

            return childContract.contractAllocations.Select(ca => TransformToContractAllocation(ca, childContract));
        }

        private ContractAllocation TransformToContractAllocation(contractAllocationsContractAllocation corpSchemaAllocation, contractType childContract)
        {
            return new ContractAllocation(corpSchemaAllocation.contractAllocationNumber, corpSchemaAllocation.startDate,
                corpSchemaAllocation.endDate)
            {
                Contract = new SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Contract
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
                Period = new SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation.Period
                {
                    PeriodTypeName = childContract.period.periodType.periodTypeName.ToString()
                }
            };
        }
    }
}
