namespace PaymentManagement.Calculation.Tests.Extensions
{
    using System.Collections.Generic;
    using Calculation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentManagement.Calculation.Dtos;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class contractDeliverableTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_CappingApportionmentPriorityOrder_ShouldReturnNull()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType(){deliverable = new deliverableType(){deliverableCode = 1}};

            // act
            var result = contractDeliverableTypeExtensions.CappingApportionmentPriorityOrder(fspDeliverableInfos);

            // assert
            Assert.IsNull(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_CappingApportionmentPriorityOrder_ShouldReturnCorrectValue()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType() { deliverable = new deliverableType() { deliverableCode = 5 } };

            // act
            var result = contractDeliverableTypeExtensions.CappingApportionmentPriorityOrder(fspDeliverableInfos);

            // assert
            Assert.AreEqual(3, result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_AllowProfile_ShouldReturnFalse()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType() { deliverable = new deliverableType() { deliverableCode = 2 } };

            // act
            var result = contractDeliverableTypeExtensions.IsAllowProfile(fspDeliverableInfos);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_AllowProfile_ShouldReturnTrue()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType() { deliverable = new deliverableType() { deliverableCode = 1 } };

            // act
            var result = contractDeliverableTypeExtensions.IsAllowProfile(fspDeliverableInfos);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_IsAllowPayment_ShouldReturnTrueWhenDeliverableHasAllowPaymentTrue()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1, allowPayment:true),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType() { deliverable = new deliverableType() { deliverableCode = 3 } };

            // act
            var result = contractDeliverableTypeExtensions.IsAllowPayment(fspDeliverableInfos);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void contractDeliverableTypeExtensions_IsAllowPayment_ShouldReturnFalseWhenDeliverableDoesNotAllowPayment()
        {
            IReadOnlyCollection<FspDeliverableInfo> fspDeliverableInfos = new List<FspDeliverableInfo>
            {
                new FspDeliverableInfo(1,  true, null, -1),
                new FspDeliverableInfo(2,  false, 1, -1),
                new FspDeliverableInfo(3,  false, 1, -1),
                new FspDeliverableInfo(4,  false, 2, -1),
                new FspDeliverableInfo(5,  false, 3, -1)
            };

            var contractDeliverableTypeExtensions = new contractDeliverableType() { deliverable = new deliverableType() { deliverableCode = 3 } };

            // act
            var result = contractDeliverableTypeExtensions.IsAllowPayment(fspDeliverableInfos);

            // assert
            Assert.IsFalse(result);
        }
    }
}