namespace ContractCreateDomain.Tests.Integration_Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using UnitTests.Common;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;
    using Microsoft.Xrm.Sdk;
    using System.Threading.Tasks;

    [TestClass]
    public class DasTests
    {

        [TestMethod]
        [TestCategory("TechnicalExploration_Das")]
        public async System.Threading.Tasks.Task ContractCreate_ShouldLoadContractInCrmWhenValidContractRequestObjectIsSentIn()
        {
            // arrange
            RemoveExistingContractsWithForThisUkprn(
                10033670,
                sfa_contracthierarchytype.Contract);

            RemoveExistingContractsWithForThisUkprn(
                10033670,
                sfa_contracthierarchytype.Master);

            contractRequestType contract =
                GetJsonResourceContractRequest();

            // act
            var endpoint = await CreateMessageSession();

            await endpoint.Send(
                new NewContractRequestCommand
                {
                    ContractRequest = contract
                });

            await endpoint.Stop();
        }




        [TestMethod]
        [TestCategory("TechnicalExploration_Das")]
        public async System.Threading.Tasks.Task ContractCreate_ShouldLoadContractInCrmWhenOpenEndedContractRequestObjectIsSentIn()
        {
            // arrange
            RemoveExistingContractsWithForThisUkprn(
                10017281,
                sfa_contracthierarchytype.Contract);

            RemoveExistingContractsWithForThisUkprn(
                10017281,
                sfa_contracthierarchytype.Master);

            contractRequestType contract =
                GetObjectInitializedContractRequestType();

            // act
            var endpoint = await CreateMessageSession();

            await endpoint.Send(
                new NewContractRequestCommand
                {
                    ContractRequest = contract
                });

            await endpoint.Stop();
        }


        private static void RemoveExistingContractsWithForThisUkprn(int ukprn, sfa_contracthierarchytype hierarchyType)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var contracts = crmContext.sfa_contractSet
                    .Where(c => c.sfa_UKPRN == ukprn.ToString() && (sfa_contracthierarchytype)c.sfa_HierarchyType.Value == hierarchyType)
                    .ToList();

                contracts.ForEach(crmContext.DeleteObject);

                crmContext.SaveChanges();
            }
        }

        private static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static contractRequestType GetJsonResourceContractRequest()
        {
            using (var resource = new TestResource("ContractCreateDomain.Tests", @"Resources.contract_request_das.json"))
            {
                return
                    (contractRequestType)
                        new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(contractRequestType));
            }
        }

        private static contractRequestType GetObjectInitializedContractRequestType()
        {
            return new contractRequestType
            {
                contract = new contractType
                {
                    contractor = new Contractor
                    {
                        ukprn = 10017281,
                        legalName = "Levy 281 Co Ltd",
                        organisationIdentifier = "ORG0017281"
                    },
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractDeliverables = new List<contractDeliverable>
                                    {
                                        new contractDeliverable
                                        {
                                            contractDeliverablePeriods = new List<contractDeliverablePeriodType>
                                            {
                                                new contractDeliverablePeriodType
                                                {
                                                    correlationId = Guid.NewGuid().ToString("D"),
                                                    year = 2017,
                                                    period = 05,
                                                    plannedValue = 0m
                                                }
                                            },
                                            correlationId = Guid.NewGuid().ToString("D"),
                                            CRMIntent = Intent.New,
                                            deliverable = new deliverableType
                                            {
                                                deliverableCode = 1,
                                                fundingStreamCode = "LEVY"
                                            },
                                            deliverableDescription = "Placeholder"
                                        }
                                    },
                                    correlationId = Guid.NewGuid().ToString("D"),
                                    CRMIntent = Intent.New,
                                    endDate = null,
                                    fundingStreamCode = "LEVY",
                                    fundingStreamPeriodCode = "LEVY1799",
                                    period = new periodType
                                    {
                                        period = "1799",
                                        periodType1 = new periodTypeType
                                        {
                                            periodTypeCode = "LEVY"
                                        }
                                    },
                                    startDate = new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc),
                                    ukprn = 10017281,
                                }
                            },
                            contractor = new Contractor
                            {
                                ukprn = 10017281,
                                legalName = "Levy 281 Co Ltd",
                                organisationIdentifier = "ORG0017281"
                            },
                            contractType1 = "Contract for Services",
                            contractVersionNumber = 1,
                            correlationId = Guid.NewGuid().ToString("D"),
                            CRMIntent = Intent.New,
                            endDate = null,
                            fundingTypeCode = "LEVY",
                            hierarchyType = hierarchyType.CONTRACT,
                            period = new periodType
                            {
                                periodType1 = new periodTypeType
                                {
                                    periodTypeCode = "LEVY"
                                },
                                period = "1799"
                            },
                            startDate = new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc),
                        }
                    },
                    correlationId = Guid.NewGuid().ToString("D"),
                    endDate = null,
                    fundingTypeCode = "LEVY",
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    period = new periodType
                    {
                        period = "1799",
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = "LEVY"
                        }
                    },
                    startDate = new DateTime(2017, 05, 01, 0, 0, 0, DateTimeKind.Utc)
                },
                correlationInfo = new correlationInfoType
                {
                    batchId = Guid.NewGuid().ToString("D"),
                    correlationId = Guid.NewGuid().ToString("D")
                },
                FundingConfiguration = new List<FundingConfigurationDataType>
                {
                    new FundingConfigurationDataType
                    {
                        FundingPeriodEndDate = new DateTime(2099, 12, 31, 0, 0, 0, DateTimeKind.Utc),
                        FundingPeriodStartDate = new DateTime(2017, 04, 06, 0, 0, 0, DateTimeKind.Utc),
                        FundingStreamCode = "LEVY",
                        FundingStreamName = "Apprenticeship Levy",
                        FundingStreamPeriodCode = "LEVY1799",
                        FundingTypeCode = "LEVY",
                        Period = "1799",
                        PeriodTypeCode = "LEVY",
                        PeriodTypeName = "Contract Duration"
                    }
                }
            };
        }

        private static async System.Threading.Tasks.Task<IEndpointInstance> CreateMessageSession()
        {
            var endpointConfiguration =
                new EndpointConfiguration("ContractCreateDomain.Tests");

            endpointConfiguration.SendOnly();

            endpointConfiguration.UseSerialization<SystemJsonSerializer>();

            endpointConfiguration.UseTransport<LearningTransport>();

            endpointConfiguration.UsePersistence<LearningPersistence>();

            return await Endpoint.Start(endpointConfiguration);
        }

    }
}
