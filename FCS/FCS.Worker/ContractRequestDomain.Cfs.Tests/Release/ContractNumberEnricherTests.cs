namespace ContractRequestDomain.Cfs.Tests.Release
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Cfs.Release.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ContractNumberEnricherTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractNumberEnricher_ShouldEnrich()
        {
            // arrange
            ContractNumberEnricher contractNumberEnricher = new ContractNumberEnricher(
                new XrmNumberRequestManager(
                    new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                    new SequenceRepository())
                );

            const periodTypeCodeType periodTypeCode = periodTypeCodeType.CM;
            const periodTypeNameType periodTypeName = periodTypeNameType.CALENDARMONTH;

            ExtendedContractType extendedContractType = new ExtendedContractType
            {
                hierarchyType = hierarchyType.MASTERCONTRACT,
                fundingType = new fundingType
                {
                    fundingTypeCode = "LOANS"
                },
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType
                    {
                        hierarchyType = hierarchyType.CONTRACT,
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "LOANS"
                        },
                        contractAllocations = new List<ExtendedContractAllocation>
                        {
                            new ExtendedContractAllocation
                            {
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "ALLF"
                                },
                                fundingStreamPeriodCode = "ALLF1819"
                            }
                        },
                        period = new period
                        {
                            period1 = "1819",
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCode,
                                periodTypeName = periodTypeName
                            }
                        },
                    }
                }
            };

            ConnectionInfo connectionInfo = new ConnectionInfo(
                null,
                new SqlConnection(ConfigurationManager.ConnectionStrings["ContractRequestDbContext"].ConnectionString));

            // act
            contractNumberEnricher.EnrichWithContractAndAllocationNumbers(extendedContractType, connectionInfo);

            // assert
            Assert.IsFalse(string.IsNullOrEmpty(extendedContractType.contractNumber), "The master contract number is not set");

            var childContract = extendedContractType.contracts.First();
            Assert.IsFalse(string.IsNullOrEmpty(childContract.contractNumber), "The child contract number is not set");

            var allocation = childContract.contractAllocations.First();
            Assert.IsFalse(string.IsNullOrEmpty(allocation.contractAllocationNumber), "The allocation number is not set");
        }
    }
}
