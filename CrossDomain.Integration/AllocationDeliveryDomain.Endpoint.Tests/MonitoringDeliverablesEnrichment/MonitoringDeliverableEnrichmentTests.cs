namespace AllocationDeliveryDomain.Endpoint.Tests.MonitoringDeliverablesEnrichment
{
    using AllocationDeliveryDomain.Endpoint.Tests.Integration;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Castle.Components.DictionaryAdapter;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class MonitoringDeliverableEnrichmentTests : MDEnrichEndpointIntegrationTestBase
    {
        private IMonitoringDeliverableEnrichment _enrichment;

        [TestInitialize]
        public void TestInitialize()
        {
        }

       [TestMethod, TestCategory("UnitTest")]
        public void AllocationDelivery_ShouldEnrichAllocationTypeWithMonitoringDeliverables()
        {
            // arrange
            Mock<IMonitoringDeliverablesDbContext> mockDb = new Mock<IMonitoringDeliverablesDbContext>();
            const string fundingStreamPeriodCode = "TT";
            mockDb.Setup(x => x.FundingStreamPeriodDeliverables).Returns(GetFundingStreamPeriodDeliverables(fundingStreamPeriodCode));
            _enrichment = new MonitoringDeliverableEnrichment(mockDb.Object);
            allocationType allocation = CreateAllocationType(fundingStreamPeriodCode);

            // act
            _enrichment.Enrich(allocation);

            // assert
            List<contractDeliverableType> allDeliverablesIncludingMonitoring = GetDeliverablesFromAllocation(allocation);
            Assert.IsTrue(allDeliverablesIncludingMonitoring.Count == 5, "the total number of deliverables is not correct");
            var monitoringDeliverables = allDeliverablesIncludingMonitoring.Where(d => d.deliverable.isMonitoring);
            Assert.IsTrue(monitoringDeliverables.Count() == 4, "the total number of monitoring deliverables is not correct");
            Assert.IsTrue(monitoringDeliverables.First().contractDeliverablePeriods.Count == 12, "the number of periods is incorrect");
            var group = monitoringDeliverables.GroupBy(d => d.contractDeliverablePeriods.Count);
            Assert.IsTrue(group.Count() == 1, "some of the periods do not have the right number");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AllocationDelivery_ShouldSetIsMonitoringFlagAndDisplayOrderOnExistingDeliverablesWithWhenEnrichingWhereAppropriate()
        {
            // arrange
            Mock<IMonitoringDeliverablesDbContext> mockDb = new Mock<IMonitoringDeliverablesDbContext>();
            const string fundingStreamPeriodCode = "TT";
            mockDb.Setup(x => x.FundingStreamPeriodDeliverables).Returns(GetFundingStreamPeriodDeliverables(fundingStreamPeriodCode));
            _enrichment = new MonitoringDeliverableEnrichment(mockDb.Object);
            allocationType allocation = CreateAllocationType(fundingStreamPeriodCode);

            // act
            _enrichment.Enrich(allocation);

            // assert
            List<contractDeliverableType> allDeliverables = GetDeliverablesFromAllocation(allocation);
            var monitoringDeleiverable = allDeliverables.First(d => d.deliverable.deliverableCode == 1);
            Assert.IsTrue(monitoringDeleiverable.deliverable.isMonitoring);
            Assert.IsTrue(monitoringDeleiverable.deliverable.DisplayOrder == 1, "The display order expected is 1");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void AllocationDelivery_ShouldEnrichAllocationTypeWithMonitoringDeliverablesIntegration()
        {
            // arrange
            IMonitoringDeliverablesDbContext dbContext = Container.Resolve<IMonitoringDeliverablesDbContext>();
            _enrichment = new MonitoringDeliverableEnrichment(dbContext);
            allocationType allocation = CreateTwentyFourPlusBAllocationType();

            // act
            _enrichment.Enrich(allocation);

            // assert
            List<contractDeliverableType> allDeliverables = GetDeliverablesFromAllocation(allocation);
            var numMonitoringDeliverables = allDeliverables.Count(d => d.deliverable.isMonitoring);
            Assert.AreEqual(3, numMonitoringDeliverables);
            var childDeliverablesOnDeliverableCodeOne =
                allocation.contractDeliverables.First(d => d.deliverable.deliverableCode == 1)
                    .contractDeliverables;
            Assert.AreEqual(childDeliverablesOnDeliverableCodeOne.Count, 3, "There are not the required number of child deliverables on the deliverable with code 1");
            Assert.AreEqual(childDeliverablesOnDeliverableCodeOne.Count(d => d.deliverable.isMonitoring), 3, "There are not the required number of monitoring deliverables on the deliverable with code 1");
        }

        private List<contractDeliverableType> GetDeliverablesFromAllocation(allocationType allocation)
        {
            List<contractDeliverableType> deliverables = new List<contractDeliverableType>();

            allocation.contractDeliverables.ForEach(d => AddDeliverableToList(d, deliverables));

            return deliverables;
        }

        private void AddDeliverableToList(contractDeliverableType contractDeliverable, List<contractDeliverableType> deliverables)
        {
            contractDeliverable.contractDeliverables.ForEach(d=> AddDeliverableToList(d, deliverables));

            deliverables.Add(contractDeliverable);
        }

        private DbSet<FundingStreamPeriodDeliverable> GetFundingStreamPeriodDeliverables(string fundingStreamPeriodCode)
        {
            var deliverables = EfHelper.GetQueryableMockDbSet(
            new FundingStreamPeriodDeliverable
            {
                AllowActuals = true,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableCode = 1,
                DisplayOrder = 1
            },
            new FundingStreamPeriodDeliverable
            {
                AllowActuals = true,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableCode = 3,
                ParentDeliverableCode = 2,
                DisplayOrder = 2
            },
           new FundingStreamPeriodDeliverable
            {
                AllowActuals = true,
                FundingStreamPeriodCode = fundingStreamPeriodCode,
                DeliverableCode = 4,
                ParentDeliverableCode = 2,
               DisplayOrder = 3
           },
            new FundingStreamPeriodDeliverable
             {
                 AllowActuals = true,
                 FundingStreamPeriodCode = fundingStreamPeriodCode,
                 DeliverableCode = 5,
                 ParentDeliverableCode = 4,
                DisplayOrder = 4
            },
             new FundingStreamPeriodDeliverable
             {
                 AllowActuals = true,
                 FundingStreamPeriodCode = "Some Other One",
                 DeliverableCode = 5,
                 ParentDeliverableCode = 4,
                 DisplayOrder = 5
             });

            return deliverables;
        }

        private allocationType CreateTwentyFourPlusBAllocationType()
        {
            allocationType allocation = new allocationType
            {
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod()
                {
                    fundingStreamPeriodCode = "24+ALLB1516"

                },
            };

            allocation.contractDeliverables.Add(new contractDeliverableType
            {
                deliverable = new deliverableType
                {
                    deliverableCode = 1
                },
                contractDeliverablePeriods = CreateContractDeliverablePeriods()
            });

            return allocation;
        }

        private allocationType CreateAllocationType(string fundingStreamPeriodCode)
        {
            allocationType allocation = new allocationType
            {
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod()
                {
                    fundingStreamPeriodCode = fundingStreamPeriodCode
                },
            };

            allocation.contractDeliverables.Add(new contractDeliverableType
            {
                deliverable = new deliverableType
                {
                    deliverableCode = 1
                },
                contractDeliverablePeriods = CreateContractDeliverablePeriods()
            });

            allocation.contractDeliverables.Add(new contractDeliverableType
            {
                contractDeliverables = new List<contractDeliverableType>
                {
                    new contractDeliverableType
                    {
                        deliverable = new deliverableType
                        {
                            deliverableCode = 3
                        },
                        contractDeliverablePeriods = CreateContractDeliverablePeriods()
                    },
                    new contractDeliverableType
                    {
                        contractDeliverables = new List<contractDeliverableType>
                        {
                            new contractDeliverableType
                            {
                                deliverable = new deliverableType
                                {
                                    deliverableCode = 5
                                },
                                contractDeliverablePeriods = CreateContractDeliverablePeriods()
                            }
                        },
                        deliverable = new deliverableType
                        {
                            deliverableCode = 4
                        },
                        contractDeliverablePeriods = CreateContractDeliverablePeriods()
                    }
                },
                deliverable = new deliverableType
                {
                    deliverableCode = 2
                },
                contractDeliverablePeriods = CreateContractDeliverablePeriods()
            });

            return allocation;
        }

        private List<contractDeliverablePeriodsTypeContractDeliverablePeriod> CreateContractDeliverablePeriods()
        {
            List<contractDeliverablePeriodsTypeContractDeliverablePeriod> periods = new EditableList<contractDeliverablePeriodsTypeContractDeliverablePeriod>();
            for (int i = 0; i < 12; i++)
            {
                periods.Add(new contractDeliverablePeriodsTypeContractDeliverablePeriod());    
            }

            return periods;
        }
    }
}
