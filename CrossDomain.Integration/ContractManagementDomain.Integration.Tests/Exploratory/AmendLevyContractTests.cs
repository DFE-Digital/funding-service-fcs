
namespace SFA.FCT.ContractManagementDomain.Integration.Tests.Exploratory
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using AutoMapper;
    using Microsoft.Extensions.Logging;
    using ContractCreateDomain.Implementation;
    using ContractCreateDomain.Implementation.Persistence;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagementService.Common.Commands;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using NServiceBus;
    using UnitTests.Common;



    [TestClass]
    public class AmendLevyContractTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void AmendLevyContract_IncrementVersion_ShouldBeIdempotent()
        {
            // create contract in CRM
            ExtendedContract contract = CreateCorporateContract();

            DeleteMasterAndChildContracts(contract.contractNumber);
            CreateContract(contract);

            ExtendedContractType childContract = contract.contracts.First();
            SetContractState(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber, sfa_contractstatus.Approved, "Approved");

            AddContractorToRoatpIfNotExists(childContract.contractor.ukprn.ToString());
            RemoveFromFeed(contract.contractNumber);

            // send first command to "amend levy contract"
            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation
                {
                    ContractNumber = childContract.contractNumber,
                    ContractStatus = ContractStatus.Approved,
                    ContractSubStatus = ContractSubStatus.Approved,
                    ContractVersionNumber = childContract.contractVersionNumber,
                    MasterContractNumber = contract.contractNumber,
                    SubVersionNumber = childContract.contractSubVersionNumber,
                    Ukprn = childContract.contractor.ukprn.ToString()
                }
            };

            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();

            // poll for result of completion
            CheckResultPoller poller = new CheckResultPoller(
                checkResult: () =>
                {
                    var crmContract = GetContract(childContract.contractNumber, childContract.contractVersionNumber + 1, 0);
                    return crmContract.Count == 1;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            Assert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(), "Amended version was not present");

            // send second command to "amend levy contract"
            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();

            // poll for result, should fail
            CheckResultPoller duplicatePoller = new CheckResultPoller(
                checkResult: () => GetContract(childContract.contractNumber, childContract.contractVersionNumber + 1, 0).Count > 1,
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            Assert.IsFalse(duplicatePoller.CheckResultAndWaitTillCompleteOrOutOfTime(), "Contract was amended twice");
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AmendLevyContract_PreIncrementWithdraw_ShouldBeIdempotent()
        {
            // create contract in CRM
            ExtendedContract contract = CreateCorporateContract();

            DeleteMasterAndChildContracts(contract.contractNumber);
            CreateContract(contract);

            ExtendedContractType childContract = contract.contracts.First();
            SetContractState(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber, sfa_contractstatus.Draft, "Published to Provider");

            AddContractorToRoatpIfNotExists(childContract.contractor.ukprn.ToString());
            RemoveFromFeed(contract.contractNumber);

            // send first command to "amend levy contract"
            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation
                {
                    ContractNumber = childContract.contractNumber,
                    ContractStatus = ContractStatus.Draft,
                    ContractSubStatus = ContractSubStatus.PublishedtoProvider,
                    ContractVersionNumber = childContract.contractVersionNumber,
                    MasterContractNumber = contract.contractNumber,
                    SubVersionNumber = childContract.contractSubVersionNumber,
                    Ukprn = childContract.contractor.ukprn.ToString()
                }
            };

            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();

            // poll for result of completion
            CheckResultPoller poller = new CheckResultPoller(
                checkResult: () =>
                {
                    var crmContract = GetContract(childContract.contractNumber, childContract.contractVersionNumber + 1, 0);
                    return crmContract.Count == 1;
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            Assert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(), "Contract was not amended");

            // send second command to "amend levy contract"
            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();

            // poll for result, should fail
            CheckResultPoller duplicatePoller = new CheckResultPoller(
                checkResult: () => GetContract(childContract.contractNumber, childContract.contractVersionNumber + 1, childContract.contractSubVersionNumber).Count > 1,
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            Assert.IsFalse(duplicatePoller.CheckResultAndWaitTillCompleteOrOutOfTime(), "Contract was amended twice");
        }

        private void RemoveFromFeed(string contractNumber)
        {
            using (var context = new ContractManagementDbContext())
            {
                context.AtomFeedItems.RemoveWhere(i => i.BusinessKey == $"{contractNumber}:1.0");
                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void AmendLevyContract_InitiateWithdraw_ShouldBeIdempotent()
        {
            // create contract in CRM
            ExtendedContract contract = CreateCorporateContract();

            DeleteMasterAndChildContracts(contract.contractNumber);
            CreateContract(contract);

            ExtendedContractType childContract = contract.contracts.First();
            SetContractState(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber, sfa_contractstatus.Draft, "Published to Provider");

            RemoveFromRoatp(childContract.contractor.ukprn.ToString());
            RemoveFromFeed(contract.contractNumber);

            // send first command to "amend levy contract"
            AmendLevyContractCommand command = new AmendLevyContractCommand
            {
                ContractInformation = new ContractInformation
                {
                    ContractNumber = childContract.contractNumber,
                    ContractStatus = ContractStatus.Draft,
                    ContractSubStatus = ContractSubStatus.PublishedtoProvider,
                    ContractVersionNumber = childContract.contractVersionNumber,
                    MasterContractNumber = contract.contractNumber,
                    SubVersionNumber = childContract.contractSubVersionNumber,
                    Ukprn = childContract.contractor.ukprn.ToString()
                }
            };

            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();

            // poll for result of completion
            CheckResultPoller poller = new CheckResultPoller(
                checkResult: () =>
                {
                    var crmContract = GetContractStatusAndSubStatus(childContract.contractNumber, childContract.contractVersionNumber, childContract.contractSubVersionNumber);

                    if (crmContract == null)
                    {
                        return false;
                    }

                    return crmContract.Status == sfa_contractstatus.Withdrawn && crmContract.SubStatus == "Withdrawn By Agency";
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 5);

            Assert.IsTrue(poller.CheckResultAndWaitTillCompleteOrOutOfTime(), "Contract version was not withdrawn");

            // send second command to "amend levy contract"
            CreateSendOnlyEndpoint<AmendLevyContractCommand>()
                .Send("ContractManagementDomain.LevyAmendmentEndpoint", command).Wait();
            // poll for result, should fail - not applicable? Check logs / CRM
        }

        private static void CreateContract(ExtendedContractType contract)
        {
            CreateContractsManager().CreateContract(contract, Guid.NewGuid().ToString());
        }

        private static void DeleteMasterAndChildContracts(string masterContractNumber)
        {
            using (OrganizationService organizationService = new OrganizationService(GetCrmConnection()))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                context.sfa_contractSet
                    .Where(c => c.sfa_number == masterContractNumber)
                    .Select(c => c.Id)
                    .AsEnumerable()
                    .ForEach(masterContractId =>
                    {
                        context.sfa_contractSet
                            .Where(c => c.sfa_ParentContractId.Id == masterContractId)
                            .Select(c => c.Id)
                            .AsEnumerable()
                            .ForEach(contractId => ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", contractId)));

                        ActionRetrier.RetryWhenExceptionThrown(() => organizationService.Delete("sfa_contract", masterContractId));
                    });
            }
        }

        private static List<sfa_contract> GetContract(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (OrganizationService organizationService = new OrganizationService(GetCrmConnection()))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber)
                    .ToList();
            }
        }

        private static ContractStatusSubStatus GetContractStatusAndSubStatus(string contractNumber, int versionNumber, int subVersionNumber)
        {
            using (OrganizationService organizationService = new OrganizationService(GetCrmConnection()))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return (from c in context.sfa_contractSet
                        join s in context.sfa_statusSet
                            on c.sfa_SubStatus.Id equals s.sfa_statusId.Value
                        where c.sfa_number == contractNumber
                              && c.sfa_Version == versionNumber
                              && c.sfa_SubVersion == subVersionNumber
                        select new { Id = c.sfa_contractId, Status = c.sfa_ContractStatus, SubStatus = s.sfa_name })
                    .ToList()
                    .Select(
                        i =>
                            new ContractStatusSubStatus
                            {
                                Id = i.Id.Value,
                                Status = (sfa_contractstatus)i.Status.Value,
                                SubStatus = i.SubStatus
                            })
                    .Single();
            }
        }

        private static void SetContractState(string contractNumber, int versionNumber, int subVersionNumber, sfa_contractstatus status, string subStatusName)
        {
            using (OrganizationService organizationService = new OrganizationService(GetCrmConnection()))
            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                Guid contractId = context.sfa_contractSet
                    .Single(c => c.sfa_number == contractNumber && c.sfa_Version == versionNumber && c.sfa_SubVersion == subVersionNumber).Id;
                Guid subStatus = context.sfa_statusSet.Single(s => s.sfa_name == subStatusName).Id;

                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_ContractStatusEnum = status,
                    sfa_SubStatus = new EntityReference(sfa_status.EntityLogicalName, subStatus),
                    sfa_LastApprovedVersion = true,
                    sfa_LatestVersion = true,
                    sfa_ContractApprovalDate = DateTime.UtcNow,
                    sfa_StatusLastUpdatedDate = DateTime.UtcNow
                });
            }
        }

        private static IContractsManager CreateContractsManager()
        {
            OrganizationService organizationService = new OrganizationService(GetCrmConnection());

            return new ContractsManager
            {
                LookupManager = new LookupManager
                {
                    BatchCacheManager = new BatchCacheManager(),
                    EnduringCacheManager = new EnduringCacheManager(),
                    OrganizationService = organizationService
                },
                OrganizationService = organizationService,
                XrmOrganisationManager = new XrmOrganisationManager
                {
                    OrgService = organizationService
                },
                XrmWorkflowManager = new XrmWorkflowManager
                {
                    OrganizationService = organizationService
                }
            };
        }

        private static ExtendedContract GetCorporateContractFromResource()
        {
            // Build logging
            using ILoggerFactory loggerFactory = LoggerFactory.Create(b => b.AddConsole());

            // Build mapping configuration (AutoMapper v15+: MapperConfiguration requires an ILoggerFactory)
            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<Contract, ExtendedContract>();
                cfg.CreateMap<contractType, ExtendedContractType>();
                cfg.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();
            }, loggerFactory);

            var mapper = config.CreateMapper();

            var source = TestResource.FromXml<Contract>(
                "SFA.FCT.ContractManagementDomain.Integration.Tests.Resources",
                "levyContractForAmendment.xml");

            return mapper.Map<ExtendedContract>(source);
        }

        private static CrmConnection GetCrmConnection()
        {
            return CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);
        }

        private static void AddContractorToRoatpIfNotExists(string ukprn)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                if (dbContext.RoatpProviders.SingleOrDefault(p => p.Ukprn == ukprn) == null)
                {
                    dbContext.RoatpProviders.Add(new RoatpProvider(ukprn));
                    dbContext.SaveChanges();
                }
            }
        }

        private static void RemoveFromRoatp(string ukprn)
        {
            using (ContractManagementDbContext dbContext = new ContractManagementDbContext())
            {
                dbContext.RoatpProviders.RemoveWhere(p => p.Ukprn == ukprn);
                dbContext.SaveChanges();
            }
        }

        /// <summary>
        /// Modern (NServiceBus 8+) send-only endpoint using the current Azure Service Bus transport.
        /// Reads the ASB connection string from either AppSettings["AzureServiceBusConnectionString"]
        /// or a ConnectionStrings entry with the same key.
        /// </summary>
        public static IEndpointInstance CreateSendOnlyEndpoint<TCommand>()
        {
            var endpointConfiguration = new EndpointConfiguration("WebJobs");
            endpointConfiguration.SendOnly();

            // 1) Instantiate the modern ASB transport with topology
            var transport = new AzureServiceBusTransport(
                ConfigurationManager.ConnectionStrings["NServiceBus/Transport"].ConnectionString,
                TopicTopology.Default
            );

            // 2) Register the transport
            endpointConfiguration.UseTransport(transport);
            endpointConfiguration.Conventions()
                .DefiningCommandsAs(t => t == typeof(TCommand));

            // Your existing scanner settings
            var assembliesToExclude = Directory.EnumerateFiles(AppDomain.CurrentDomain.BaseDirectory, "*.dll")
                .Select(Path.GetFileName)
                .ToArray();

            var scanner = endpointConfiguration.AssemblyScanner();
            scanner.ExcludeAssemblies(assembliesToExclude);
            scanner.ThrowExceptions = false;

            endpointConfiguration.UseSerialization<NewtonsoftJsonSerializer>();

            return Endpoint.Start(endpointConfiguration).GetAwaiter().GetResult();
        }

        private ExtendedContract CreateCorporateContract()
        {
            return new ExtendedContract
            {
                contractNumber = "SFA4823",
                contractVersionNumber = 1,
                contractor = new Contractor
                {
                    legalName = "NACRO",
                    ukprn = 40004823,
                    organisationIdentifier = "ORG0004823",
                },
                amendmentType = "None",
                hierarchyType = hierarchyType.MASTERCONTRACT,
                startDate = new DateTime(2017, 5, 1, 12, 0, 0),
                endDate = null,
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContract
                    {
                        contractNumber = "APPLEVY-4823",
                        startDate = new DateTime(2017, 5, 1, 12, 0, 0),
                        endDate = null,
                        contractVersionNumber = 1,
                        contractSubVersionNumber = 0,
                        contractValue = 0,
                        contractType1 = "Contract for Services",
                        period = new Period
                        {
                            period1 = "1799",
                            fundingStreamPeriods = new List<fundingStreamPeriodsFundingStreamPeriod>
                            {
                                new fundingStreamPeriodsFundingStreamPeriod
                                {
                                    fundingStreamPeriodCode = "LEVY1799"
                                }
                            },
                            periodType = new periodTypeType
                            {
                                periodTypeCode = periodTypeCodeType.LEVY,
                                periodTypeName = periodTypeNameType.APPRENTICESHIPLEVY
                            }
                        },
                        contractor = new Contractor
                        {
                            legalName = "NACRO",
                            ukprn = 40004823,
                            organisationIdentifier = "ORG0004823"
                        },
                        fundingType = new fundingType
                        {
                            fundingTypeCode = "LEVY",
                            fundingTypeName = "Apprenticeship Levy"
                        },
                        amendmentType = "None",
                        hierarchyType = hierarchyType.CONTRACT,
                        description = string.Empty,
                        contractAllocations = GetAllocations()
                    }
                },
                fundingType = new fundingType
                {
                    fundingTypeCode = "LEVY",
                    fundingTypeName = "Apprenticeship Levy"
                },
            };
        }

        private List<ExtendedContractAllocation> GetAllocations()
        {
            return new List<ExtendedContractAllocation>
            {
                new ExtendedContractAllocation
                {
                    contractAllocationNumber = "LEVY-34823",
                    startDate = new DateTime(2017, 5, 1, 12, 0, 0),
                    endDate = null,
                    maximumContractValue = 0,
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = "LEVY"
                    },
                    period = new Period
                    {
                        period1 = "1799",
                        fundingStreamPeriods = new List<fundingStreamPeriodsFundingStreamPeriod>
                        {
                            new fundingStreamPeriodsFundingStreamPeriod
                            {
                                fundingStreamPeriodCode = "LEVY1799"
                            }
                        },
                        periodType = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.LEVY,
                            periodTypeName = periodTypeNameType.APPRENTICESHIPLEVY
                        }
                    },
                    fundingStreamPeriodCode = "LEVY1799",
                    contractDeliverables = GetDeliverables()
                }
            };
        }

        private List<contractDeliverablesTypeContractDeliverable> GetDeliverables()
        {
            return new List<contractDeliverablesTypeContractDeliverable>
            {
                new contractDeliverablesTypeContractDeliverable
                {
                    deliverable = new deliverableType
                    {
                        deliverableCode = 7,
                        deliverableName = "Total Adult Levy Apprenticeships"
                    },
                    DisplayOrder = 7,
                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                    {
                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                        {
                            year = 2017,
                            period = 5,
                            periodType = new periodTypeType
                            {
                                periodTypeName = periodTypeNameType.CALENDARMONTH,
                                periodTypeCode = periodTypeCodeType.CM
                            },
                            displayOrder = 201705,
                            periodName = "May-17",
                            plannedVolume = 0,
                            plannedValue = 0,
                            aggregate = false
                        }
                    },
                    plannedValue = 0
                },
                new contractDeliverablesTypeContractDeliverable
                {
                    deliverable = new deliverableType
                    {
                        deliverableCode = 1,
                        deliverableName = "Total 16-18 Apprenticeships"
                    },
                    DisplayOrder = 1,
                    contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                    {
                        new contractDeliverablePeriodsTypeContractDeliverablePeriod
                        {
                            year = 2017,
                            period = 5,
                            periodType = new periodTypeType
                            {
                                periodTypeName = periodTypeNameType.CALENDARMONTH,
                                periodTypeCode = periodTypeCodeType.CM
                            },
                            displayOrder = 201705,
                            periodName = "May-17",
                            plannedVolume = 0,
                            plannedValue = 0,
                            aggregate = false
                        }
                    },
                    plannedValue = 0
                }
            };
        }

        private class ContractStatusSubStatus
        {
            public Guid Id { get; set; }
            public sfa_contractstatus Status { get; set; }
            public string SubStatus { get; set; }
        }
    }
}
