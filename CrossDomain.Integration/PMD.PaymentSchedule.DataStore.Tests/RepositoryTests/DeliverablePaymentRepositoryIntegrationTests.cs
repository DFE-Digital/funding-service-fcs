namespace PMD.PaymentSchedule.DataStore.Tests.RepositoryTests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using UnitTests.Common;
    using System.Linq;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    [TestClass]
    public class DeliverablePaymentRepositoryIntegrationTests
    {
        private readonly List<string> _allocNumbers = new List<string>();

        [TestCleanup]
        public void Cleanup()
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                _allocNumbers.ForEach(an => context.DeliverablePayments.RemoveWhere(dp => dp.AllocationNumber == an));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetDeliverablePaymentsForAllocation_ShouldReturnAllDeliverablePayments_ForAllocation()
        {
            var delPaymentRepo = new DeliverablePaymentRepository();

            SetupDeliverablePayments("CL-880", 3);

            string allocationNumberToTest = "CL-8801";
            IReadOnlyCollection<DeliverablePayment> testResults = delPaymentRepo.GetDeliverablePaymentsForAllocation(allocationNumberToTest, 1,
                ConnectionInfo.CreateFrom(new PaymentSchedulePolicyContext().Database.Connection));

            Assert.AreEqual(12, testResults.Count);
            Assert.AreEqual(1, testResults.Last().DeliverableCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetDeliverablePeriodActualVolumesForAllocation_ShouldGetVolumes()
        {
            // arrange
            const string allocationNumber = "123";
            const int version = 1;

            RemoveDeliverablePayments(allocationNumber, version);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = version,
                    Period = "201801",
                    DeliverableCode = 1,
                    ActualVolume = 10,
                });
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = allocationNumber,
                    VersionNumber = version,
                    Period = "201802",
                    DeliverableCode = 1,
                    ActualVolume = 20
                });

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                var repository = new DeliverablePaymentRepository();
  
                // act 
                var volumes = repository.GetDeliverablePeriodActualVolumesForAllocation(allocationNumber, version,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, volumes.Count, "The number of rows returned is incorrect");
                Assert.AreEqual(20, volumes.Single(v => v.DeliverableCode == 1 && v.Period == "201802").Volume, "The volume value is incorrect");
            }    
        }

        private void RemoveDeliverablePayments(string allocationNumber, int version)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == version)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_ShouldUpdateAnExistingDeliverablePayment()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const int testDeliverableCode = 1;
            const string testPeriod = "Test_Period";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == testAllocationNumber)
                   .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod
                });

                context.SaveChanges();
            }

            const decimal testBalancingPayment = 10;
            const decimal testReconciliationPaymentAmount = 11;
            const decimal testProfilePaymentAmount = 12;
            const decimal testCappedPaymentAmount = 13;
            const decimal testNetPaymentAmount = 14;

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                repository.AddOrUpdate(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod,
                    BalancingPaymentAmount = testBalancingPayment,
                    ReconciliationPaymentAmount = testReconciliationPaymentAmount,
                    ProfilePaymentAmount = testProfilePaymentAmount,
                    CappedPaymentAmount = testCappedPaymentAmount,
                    NetPaymentAmount = testNetPaymentAmount
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingDeliverablePayment = context.DeliverablePayments.Find(testAllocationNumber, testVersionNumber, testDeliverableCode, testPeriod);

                Assert.AreEqual(testBalancingPayment, matchingDeliverablePayment.BalancingPaymentAmount, "The BalancingPaymentAmount is not correct");
                Assert.AreEqual(testReconciliationPaymentAmount, matchingDeliverablePayment.ReconciliationPaymentAmount, "The ReconciliationPaymentAmount is not correct");
                Assert.AreEqual(testProfilePaymentAmount, matchingDeliverablePayment.ProfilePaymentAmount, "The ProfilePaymentAmount is not correct");
                Assert.AreEqual(testCappedPaymentAmount, matchingDeliverablePayment.CappedPaymentAmount, "The CappedPaymentAmount is not correct");
                Assert.AreEqual(testNetPaymentAmount, matchingDeliverablePayment.NetPaymentAmount, "The NetPaymentAmount is not correct");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_ShouldInsertWhenThereIsNoExistingDeliverablePayment()
        {
            // arrange
            const string testAllocationNumber = "Alloc_Test";
            const int testVersionNumber = 1;
            const int testDeliverableCode = 1;
            const string testPeriod = "Test_Period";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == testAllocationNumber)
                   .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }

            const decimal testBalancingPayment = 10;

            // act
            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                repository.AddOrUpdate(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = testVersionNumber,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod,
                    BalancingPaymentAmount = testBalancingPayment
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var matchingDeliverablePayment = context.DeliverablePayments.Find(testAllocationNumber, testVersionNumber, testDeliverableCode, testPeriod);

                Assert.AreEqual(testBalancingPayment, matchingDeliverablePayment.BalancingPaymentAmount);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetLatestVersion_ShouldReturnLatestVersionNumber()
        {
            // arrange
            const string testAllocationNumber = "TESTALLOC-9";
            int[] testVersionNumbers = {1, 2, 3};
            const int testDeliverableCode = 1;
            const string testPeriod = "TESTPERIOD";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == testAllocationNumber)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();

                testVersionNumbers.Select(vn => new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = vn,
                    Period = testPeriod,
                    DeliverableCode = testDeliverableCode
                }).ForEach(dp => context.DeliverablePayments.Add(dp));

                context.SaveChanges();
            }

            // act
            int? latestVersion;

            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();
                latestVersion = repository.GetLatestVersion(testAllocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            Assert.AreEqual(testVersionNumbers.Max(), latestVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetLatestVersion_ShouldReturnNullIfNoAllocationExists()
        {
            // arrange
            const string testAllocationNumber = "TESTALLOC-8";

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == testAllocationNumber)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }

            // act
            int? latestVersion;

            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();
                latestVersion = repository.GetLatestVersion(testAllocationNumber, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            Assert.AreEqual(default(int?), latestVersion);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_CreateDeliverablePaymentCopy_ShouldCopyAndRemovePlannedValueIfRequested()
        {
            // arrange
            IReadOnlyCollection<DeliverablePayment> originalDeliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    ActualVolume = 10,
                    ActualValue = 11,
                    AllocationNumber = "A",
                    BalancingPaymentAmount = 12,
                    CappedPaymentAmount = 13,
                    PlannedValue = 100,
                    DeliverableCode = 1,
                    Period = "201712"
                },
                 new DeliverablePayment
                {
                    ActualVolume = 10,
                    ActualValue = 11,
                    AllocationNumber = "A",
                    BalancingPaymentAmount = 12,
                    CappedPaymentAmount = 13,
                    PlannedValue = 110,
                    DeliverableCode = 2,
                    Period = "201712"
                }
            };

            DeliverablePaymentRepository repository;
            using (var context = new PaymentSchedulePolicyContext())
            {
                repository = new DeliverablePaymentRepository();
            }
                
            IReadOnlyCollection<int> deliverableCodes = new List<int> {1};

            // act
            IReadOnlyCollection<DeliverablePayment> copiedDeliverablePayments = repository.CopyDeliverablePaymentsWithoutPlannedValueOnCertainDeliverableCodes(originalDeliverablePayments,
                deliverableCodes);

            // assert
            var dp1 = copiedDeliverablePayments.Single(dp => dp.DeliverableCode == 1);
            Assert.AreEqual(0, dp1.PlannedValue.Value, "The planned value has not been removed");

            var dp2 = copiedDeliverablePayments.Single(dp => dp.DeliverableCode == 2);
            Assert.AreEqual(110, dp2.PlannedValue, "The planned value has been removed");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_ShouldAddOrUpdateDeliverablePaymentsForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;
            const int testDeliverableCode = 1;
            const string testPeriod1 = "201801";
            const string testPeriod2 = "201802";

            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod1,
                    PeriodTypeCode = PeriodTypeCode.AY
                });

                context.SaveChanges();
            }

            List<DeliverablePayment> newDeliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod1,
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualValue = 1,
                    ActualVolume = 2,
                    BalancingPaymentAmount = 3,
                    CappedPaymentAmount = 4,
                    PlannedValue = 5,
                    PlannedVolume = 6,
                    ProfilePaymentAmount = 7,
                    ReconciliationPaymentAmount = 8,
                    NetPaymentAmount = 9
                },
                new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod2,
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualValue = 10,
                    ActualVolume = 20,
                    BalancingPaymentAmount = 30,
                    CappedPaymentAmount = 40,
                    PlannedValue = 50,
                    PlannedVolume = 60,
                    ProfilePaymentAmount = 70,
                    ReconciliationPaymentAmount = 80,
                    NetPaymentAmount = 90
                }
            };



            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository paymentScheduleService = new DeliverablePaymentRepository();

                // act
                paymentScheduleService.AddOrUpdateDeliverablePaymentsForAllocation(newDeliverablePayments, testAllocationNumber, textContractVersion,
                    ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentSchedulePolicyContext())
            {
                var dps =
                    context.DeliverablePayments.Where(
                        dp => dp.AllocationNumber == testAllocationNumber && dp.VersionNumber == textContractVersion)
                        .ToList();

                Assert.AreEqual(2, dps.Count, "There are not the correct number of deliverable payments");
                var dpForPeriod1 = dps.Single(dp => dp.Period == testPeriod1);
                var dpForPeriod2 = dps.Single(dp => dp.Period == testPeriod2);
                var expectedDpForPeriod1 = newDeliverablePayments.Single(dp => dp.Period == testPeriod1);
                var expectedDpForPeriod2 = newDeliverablePayments.Single(dp => dp.Period == testPeriod2);
                Assert.AreEqual(expectedDpForPeriod1.ActualValue, dpForPeriod1.ActualValue, "The actual value for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.ActualVolume, dpForPeriod1.ActualVolume, "The actual volume for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.BalancingPaymentAmount, dpForPeriod1.BalancingPaymentAmount, "The BalancingPaymentAmount for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.CappedPaymentAmount, dpForPeriod1.CappedPaymentAmount, "The CappedPaymentAmount for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.NetPaymentAmount, dpForPeriod1.NetPaymentAmount, "The NetPaymentAmount for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.ProfilePaymentAmount, dpForPeriod1.ProfilePaymentAmount, "The ProfilePaymentAmount for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.ReconciliationPaymentAmount,
                    dpForPeriod1.ReconciliationPaymentAmount,
                    "The ReconciliationPaymentAmount for period 1 is incorrect");

                Assert.AreEqual(expectedDpForPeriod2.ActualValue, dpForPeriod2.ActualValue, "The actual value for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.ActualVolume, dpForPeriod2.ActualVolume, "The actual volume for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.BalancingPaymentAmount, dpForPeriod2.BalancingPaymentAmount, "The BalancingPaymentAmount for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.CappedPaymentAmount, dpForPeriod2.CappedPaymentAmount, "The CappedPaymentAmount for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.NetPaymentAmount, dpForPeriod2.NetPaymentAmount, "The NetPaymentAmount for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.ProfilePaymentAmount, dpForPeriod2.ProfilePaymentAmount, "The ProfilePaymentAmount for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.ReconciliationPaymentAmount, dpForPeriod2.ReconciliationPaymentAmount, "The ReconciliationPaymentAmount for period 2 is incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_UpdateActualValuesAndVolumes_ShouldUpdateActualValuesAndVolumesForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;
            const int testDeliverableCode = 1;
            const string testPeriod1 = "201801";
            const string testPeriod2 = "201802";

            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod1,
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualValue = null,
                    ActualVolume = null
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod2,
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualValue = null,
                    ActualVolume = null
                });

                context.SaveChanges();
            }

            List<DeliverablePayment> updateDeliverablePayments = new List<DeliverablePayment>
            {
                new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod1,
                    ActualValue = 1,
                    ActualVolume = 2
                },
                new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = testDeliverableCode,
                    Period = testPeriod2,
                    ActualValue = 10,
                    ActualVolume = 20
                }
            };

            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository paymentScheduleService = new DeliverablePaymentRepository();

                // act
                paymentScheduleService.UpdateActualValuesAndVolumes(updateDeliverablePayments, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (PaymentSchedulePolicyContext context = new PaymentSchedulePolicyContext())
            {
                List<DeliverablePayment> dps = context.DeliverablePayments
                    .Where(dp => dp.AllocationNumber == testAllocationNumber && dp.VersionNumber == textContractVersion)
                    .ToList();

                Assert.AreEqual(2, dps.Count, "There are not the correct number of deliverable payments");
                DeliverablePayment dpForPeriod1 = dps.Single(dp => dp.Period == testPeriod1);
                DeliverablePayment dpForPeriod2 = dps.Single(dp => dp.Period == testPeriod2);
                DeliverablePayment expectedDpForPeriod1 = updateDeliverablePayments.Single(dp => dp.Period == testPeriod1);
                DeliverablePayment expectedDpForPeriod2 = updateDeliverablePayments.Single(dp => dp.Period == testPeriod2);

                Assert.AreEqual(expectedDpForPeriod1.ActualValue, dpForPeriod1.ActualValue, "The actual value for period 1 is incorrect");
                Assert.AreEqual(expectedDpForPeriod1.ActualVolume, dpForPeriod1.ActualVolume, "The actual volume for period 1 is incorrect");

                Assert.AreEqual(expectedDpForPeriod2.ActualValue, dpForPeriod2.ActualValue, "The actual value for period 2 is incorrect");
                Assert.AreEqual(expectedDpForPeriod2.ActualVolume, dpForPeriod2.ActualVolume, "The actual volume for period 2 is incorrect");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetSummedActualsByDeliverableForAllocation_ShouldGetSummedNonZeroActualsByDeliverableForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;
  
            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 1,
                    ActualValue = 2
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201802",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 5,
                    ActualValue = 6
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201803",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 11,
                    ActualValue = 12
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 3,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 14,
                    ActualValue = 15
                });

                context.SaveChanges();
            }
        
            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                // act
                IReadOnlyCollection<DeliverableActual> deliverableActuals = repository.GetSummedActualsByDeliverableForAllocation(allocationNumber: testAllocationNumber,
                    versionNumber: textContractVersion, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, deliverableActuals.Count, "The number of deliverables is incorrect");
                Assert.AreEqual(20, deliverableActuals.Single(d => d.DeliverableCode == 1).Value, "The actual value is incorrect for deliverable 1");
                Assert.AreEqual(17, deliverableActuals.Single(d => d.DeliverableCode == 1).Volume, "The actual volume is incorrect for deliverable 1");
                Assert.AreEqual(15, deliverableActuals.Single(d => d.DeliverableCode == 3).Value, "The actual value is incorrect for deliverable 3");
                Assert.AreEqual(14, deliverableActuals.Single(d => d.DeliverableCode == 3).Volume, "The actual volume is incorrect for deliverable 3");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetSummedActualsByDeliverableForAllocation_ShouldGetSummedNullActualVolumesByDeliverableForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;

            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 2
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201802",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 6
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201803",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 12
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 3,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 15
                });

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                // act
                IReadOnlyCollection<DeliverableActual> deliverableActuals = repository.GetSummedActualsByDeliverableForAllocation(allocationNumber: testAllocationNumber,
                    versionNumber: textContractVersion, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, deliverableActuals.Count, "The number of deliverables is incorrect");
                Assert.IsNull(deliverableActuals.Single(d => d.DeliverableCode == 1).Volume, "The actual volume is not null for deliverable 1");
                Assert.IsNull(deliverableActuals.Single(d => d.DeliverableCode == 3).Volume, "The actual volume is not null for deliverable 3");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetSummedActualsByDeliverableForAllocation_ShouldGetSummedZeroActualVolumesByDeliverableForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;

            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 0,
                    ActualValue = 2
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201802",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 0,
                    ActualValue = 6
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201803",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 0,
                    ActualValue = 12
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 3,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 0,
                    ActualValue = 15
                });

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                // act
                IReadOnlyCollection<DeliverableActual> deliverableActuals = repository.GetSummedActualsByDeliverableForAllocation(allocationNumber: testAllocationNumber,
                    versionNumber: textContractVersion, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, deliverableActuals.Count, "The number of deliverables is incorrect");
                Assert.AreEqual(0, deliverableActuals.Single(d => d.DeliverableCode == 1).Volume, "The actual volume is not zero for deliverable 1");
                Assert.AreEqual(0, deliverableActuals.Single(d => d.DeliverableCode == 3).Volume, "The actual volume is not zero for deliverable 3");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DeliverablePaymentRepository_GetSummedActualsByDeliverableForAllocation_ShouldGetSummedZeroAndNullActualVolumesByDeliverableForAllocation()
        {
            // arrange
            const string testAllocationNumber = "Test Alloc";
            const int textContractVersion = 1;

            ClearDeliverablePaymentTable(testAllocationNumber, textContractVersion);

            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201801",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = 0,
                    ActualValue = 2
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201802",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 6
                });

                context.DeliverablePayments.Add(new DeliverablePayment
                {
                    AllocationNumber = testAllocationNumber,
                    VersionNumber = textContractVersion,
                    DeliverableCode = 1,
                    Period = "201803",
                    PeriodTypeCode = PeriodTypeCode.AY,
                    ActualVolume = null,
                    ActualValue = 12
                });

                context.SaveChanges();
            }

            using (var context = new PaymentSchedulePolicyContext())
            {
                DeliverablePaymentRepository repository = new DeliverablePaymentRepository();

                // act
                IReadOnlyCollection<DeliverableActual> deliverableActuals = repository.GetSummedActualsByDeliverableForAllocation(allocationNumber: testAllocationNumber,
                    versionNumber: textContractVersion, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(1, deliverableActuals.Count, "The number of deliverables is incorrect");
                Assert.AreEqual(0, deliverableActuals.Single(d => d.DeliverableCode == 1).Volume, "The actual volume is not zero for deliverable 1");
            }
        }

        private void ClearDeliverablePaymentTable(string allocationNumber, int version)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                context.DeliverablePayments.Where(dp => dp.AllocationNumber == allocationNumber && dp.VersionNumber == version)
                    .ForEach(dp => context.DeliverablePayments.Remove(dp));

                context.SaveChanges();
            }
        }

        private void SetupDeliverablePayments(string startAllocNumber, int amountToCreate)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                for (int i = 0; i < amountToCreate; i++)
                {
                    string allocNumber = startAllocNumber + i;
                    _allocNumbers.Add(allocNumber);

                    for (int j = 1; j <= 12; j++)
                    {
                        context.DeliverablePayments.Add(new DeliverablePayment
                        {
                            AllocationNumber = allocNumber,
                            DeliverableCode = 1,
                            VersionNumber = 1,
                            Period = j.ToString()
                        });
                    }
                }

                context.SaveChanges();
            }
        }
    }
}
