namespace PaymentManagement.Calculation.Tests.Services
{
    using Calculation.Behaviours;
    using Calculation.Dtos;
    using Calculation.Repositories;
    using Calculation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class BehaviourFactoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetAllocationDurationDeliverableLineBehaviour_WhenFSP_IsESF()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());
                
                // act
                var behaviour = factory.GetBehaviour("ESF1420", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(AllocationDurationDeliverableLineBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetAllocationDurationAllocationLevelBehaviour_WhenFSP_IsAEB_AS1920_And_Period_202010()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("AEB-AS1920", 202010, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b =>
                    {
                        Assert.IsTrue(
                            b.GetTypeOfCappingClass == typeof(AllocationDurationAllocationLevelBehaviour));
                    },
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldReturnCorrectBehaviourFor_16_18TRN1920()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("16-18TRN1920", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(FinancialYearAllocationLevelBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldReturnCorrectBehaviourFor16_18NLAP2018()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("16-18NLAP2018", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(FinancialYearAllocationLevelWithPrioritisedApportionmentBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldReturnCorrectBehaviourFor16_APPS1920()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("APPS1920", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(AllocationDurationAllocationLevelWithPrioritisedApportionmentBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldReturnCorrectBehaviourFor16_AEBC_ASCL1920()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("AEBC-ASCL1920", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(PayOnProfileBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldReturnCorrectBehaviourFor_ALLF1920()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("ALLF1920", 202002, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(PaidExternallyBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void BehaviourFactory_ShouldGetBehaviour_ShouldGetFinancialYearDeliverableGroupBehaviourFor_STFI2021()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                // arrange
                var factory = new BehaviourFactory(new PolicyFundingStreamPeriodRepository());

                // act
                var behaviour = factory.GetBehaviour("STFI2021", 202008, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                behaviour.Match(some: b => Assert.IsTrue(b.GetTypeOfCappingClass == typeof(FinancialYearDeliverableGroupBehaviour)),
                    none: () => Assert.Fail("We should support FSP with the new calculator"));
            }
        }
    }
}
