namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.PaymentAggregated.Services
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using AutoMapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.DTOs;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Repositories;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic.Services;
    using UnitTests.Common;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class ContractDeliverablePeriodPresenceCheckerTests
    {
        private ContractDeliverablePeriodRepository _contractDeliverablePeriodRepository;
        private ContractDeliverablePeriodPresenceChecker _contractDeliverablePeriodPresenceChecker;

        [TestInitialize]
        public void TestInitialize()
        {
            TestCleanup();

            ExtendedContract masterContract = GetMasterContractFromResource();
            CreateContract(masterContract);
            SetContractAsLastApprovedVersion("24Loans-1049");

            _contractDeliverablePeriodRepository = new ContractDeliverablePeriodRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService());
            _contractDeliverablePeriodPresenceChecker = new ContractDeliverablePeriodPresenceChecker();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            DeleteAllocations("ALLB-665");
            DeleteContracts("24Loans-1049");
            DeleteContracts("SFA-6442");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllRequiredContractDeliverablePeriodsPresent_ShouldReturnTrueWhenAllContractDeliverablePeriodsArePresent()
        {
            // arrange
            Allocation allocation = new Allocation
            {
                AllocationNumber = "ALLB-665",
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Period = "201508",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail {DeliverableCode = 1}
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        Period = "201509",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail {DeliverableCode = 1}
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        Period = "201510",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail {DeliverableCode = 1}
                                }
                            }
                        }
                    }
                }
            };

            IReadOnlyCollection<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods =
                _contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation("ALLB-665");

            // act
            bool areAllRequiredContractDeliverablePeriodsPresent =
                _contractDeliverablePeriodPresenceChecker.AreAllRequiredContractDeliverablePeriodsPresent(allocation, existingContractDeliverablePeriods);

            // assert
            Assert.IsTrue(areAllRequiredContractDeliverablePeriodsPresent, "Incorrectly determined not all contract deliverable periods were present.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllRequiredContractDeliverablePeriodsPresent_ShouldReturnFalseWhenContractDeliverablePeriodsAreNotPresentForASpecificDeliverable()
        {
            // arrange
            Allocation allocation = new Allocation
            {
                AllocationNumber = "ALLB-665",
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Period = "201508",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail { DeliverableCode = 1 }
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        Period = "201509",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail { DeliverableCode = 1 },
                                    new DeliverableDetail { DeliverableCode = 2 }
                                }
                            }
                        }
                    }
                }
            };

            IReadOnlyCollection<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods =
                _contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation("ALLB-665");

            // act
            bool areAllRequiredContractDeliverablePeriodsPresent =
                _contractDeliverablePeriodPresenceChecker.AreAllRequiredContractDeliverablePeriodsPresent(allocation, existingContractDeliverablePeriods);

            // assert
            Assert.IsFalse(areAllRequiredContractDeliverablePeriodsPresent, "Incorrectly determined all contract deliverable periods were present.");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractDeliverablePeriodPresenceChecker_AreAllRequiredContractDeliverablePeriodsPresent_ShouldReturnFalseWhenContractDeliverablePeriodsAreNotPresentForASpecificPeriod()
        {
            // arrange
            Allocation allocation = new Allocation
            {
                AllocationNumber = "ALLB-665",
                AllocationPeriods = new List<AllocationPeriod>
                {
                    new AllocationPeriod
                    {
                        Period = "201508",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail { DeliverableCode = 1 }
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        Period = "201509",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail { DeliverableCode = 1 },
                                }
                            }
                        }
                    },
                    new AllocationPeriod
                    {
                        Period = "201608",
                        Aggregations = new List<Aggregation>
                        {
                            new Aggregation
                            {
                                DeliverableDetails = new List<DeliverableDetail>
                                {
                                    new DeliverableDetail { DeliverableCode = 1 },
                                }
                            }
                        }
                    }
                }
            };

            IReadOnlyCollection<ContractDeliverablePeriodInfo> existingContractDeliverablePeriods =
                _contractDeliverablePeriodRepository.GetContractDeliverablePeriodsForAllocation("ALLB-665");

            // act
            bool areAllRequiredContractDeliverablePeriodsPresent =
                _contractDeliverablePeriodPresenceChecker.AreAllRequiredContractDeliverablePeriodsPresent(allocation, existingContractDeliverablePeriods);

            // assert
            Assert.IsFalse(areAllRequiredContractDeliverablePeriodsPresent, "Incorrectly determined all contract deliverable periods were present.");
        }

        private static ExtendedContract GetMasterContractFromResource()
        {
            Contract corporateContract =
                TestResource.FromXml<Contract>(
                    "PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Resources",
                    "masterContract.xml");

            var config = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<Contract, ExtendedContract>();
                cfg.CreateMap<contractType, ExtendedContractType>();
                cfg.CreateMap<contractAllocationsContractAllocation, ExtendedContractAllocation>();
            },null);

            IMapper mapper = config.CreateMapper();

            return mapper.Map<ExtendedContract>(corporateContract);
        }

        private static void CreateContract(ExtendedContractType masterContract)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            var contractsManager = new ContractsManager
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
                }
            };

            contractsManager.CreateContract(masterContract, Guid.NewGuid().ToString());
        }

        private static void SetContractAsLastApprovedVersion(string contractNumber)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                sfa_contract contract = xrmContext.sfa_contractSet.Single(c => c.sfa_number == contractNumber);
                contract.sfa_LastApprovedVersion = true;
                xrmContext.UpdateObject(contract);
                xrmContext.SaveChanges();
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractSet
                    .Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.Id)
                    .ToList()
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown<FaultException>(() => organizationService.Delete("sfa_contract", id)));
            }
        }

        private static void DeleteAllocations(string allocationNumber)
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                xrmContext.sfa_contractallocationSet
                    .Where(a => a.sfa_contractallocationnumber == allocationNumber)
                    .Select(a => a.Id)
                    .ToList()
                    .ForEach(id => ActionRetrier.RetryWhenExceptionThrown<FaultException>(() => organizationService.Delete("sfa_contractallocation", id)));
            }
        }
    }
}